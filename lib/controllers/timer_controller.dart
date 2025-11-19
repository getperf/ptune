import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptune/providers/timer_event_provider.dart';
import 'package:ptune/states/blink_notifier.dart';
import 'package:ptune/states/over_limit_state.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:ptune/controllers/auto_safe_guard.dart';
import 'package:ptune/controllers/ticking_timer.dart';
import 'package:ptune/models/my_task_ext.dart';
import 'package:ptune/models/pomodoro_scheduler.dart';
import 'package:ptune/models/pomodoro_session.dart';
import 'package:ptune/models/session_type.dart';
import 'package:ptune/providers/pomodoro_scheduler_provider.dart';
import 'package:ptune/providers/pomodoro_summary_provider.dart';
import 'package:ptune/providers/task_provider.dart';
import 'package:ptune/states/auto_mode_state.dart';
import 'package:ptune/states/remaining_time_state.dart';
import 'package:ptune/states/timer_phase_state.dart';
import 'package:ptune/models/timer_phase.dart';
import 'package:ptune/utils/logger.dart';

/// TimerController:
/// Pomodoroセッションの制御ロジック全体を担うコントローラ。
/// タイマーの起動・一時停止・再開・停止・リセット処理、
/// セッションログ記録や自動モード判定を行う。

class TimerController {
  final Ref ref;

  /// 1秒単位でtickを通知するタイマー
  late final TickingTimer _timer;

  /// セッションスケジューラ（作業→休憩→作業...）
  final PomodoroScheduler scheduler;

  /// セッション中のログを蓄積・記録する
  final PomodoroSession _session = PomodoroSession();

  /// コミット通知アラーム検知用の経過時間
  int _lastCommitSecond = 0;

  /// 終了前のアラーム検知フラグ
  bool _hasWarnedAlmostFinished = false;

  TimerController(this.ref, this.scheduler) {
    logger.i("[TimerController] initialized");
    _timer = TickingTimer(onTick: _tick);
  }

  /// 毎秒呼ばれるtick処理
  /// - 残り時間を減少させ、0になったらセッションを終了
  /// - セッション状態をログ出力
  Future<void> _tick() async {
    final sw = Stopwatch()..start();
    final phase = ref.read(timerPhaseProvider);
    final remainingTime = ref.read(remainingTimeProvider.notifier);
    remainingTime.tick();

    final timerState = ref.read(remainingTimeProvider);
    final elapsed = _session.elapsedSeconds;

    if (timerState.remaining >= timerState.total - 1 ||
        timerState.remaining == 30) {
      ref.read(blinkStateProvider.notifier).startBlink(times: 3);
    }

    if (timerState.remaining == 30 &&
        phase == TimerPhase.running &&
        !_hasWarnedAlmostFinished) {
      _hasWarnedAlmostFinished = true;
      ref.read(timerEventProvider.notifier).notify("almost_finished");
    }

    if (elapsed - _lastCommitSecond >= 150) {
      await _commitIntermediateProgress();
      _lastCommitSecond = elapsed;
    }

    // debugレベル出力をinfoから分離（tick量削減）
    logger.d("[tick] remaining: $timerState $_session");

    if (timerState.remaining <= 0) {
      await _onSessionComplete();
    }
    sw.stop();
    logger.d("[tick] duration=${sw.elapsedMicroseconds}µs");
  }

  Future<void> _commitIntermediateProgress() async {
    final summary = _session.getPartialSummary();
    if (summary.isEmpty) {
      logger.i("[TimerController] No differences, skipping apply");
      return;
    }

    logger.i("[TimerController] partial summary to apply: $summary");
    final applier = ref.read(pomodoroSummaryApplierProvider);
    await applier.apply(ref, summary);

    final tasks = ref.read(tasksProvider).value ?? [];
    await ref.read(tasksProvider.notifier).updateTasks(tasks);
  }

  /// セッション終了時の集計とリモート保存
  Future<void> _finalizeSessionAndApply({bool skipUpdateTasks = false}) async {
    final task = ref.read(selectedTimerTaskProvider);
    _session.record(phase: TimerPhase.end, taskId: task?.id);
    final summary = _session.getPartialSummary();
    final applier = ref.read(pomodoroSummaryApplierProvider);
    await applier.apply(ref, summary);

    if (!skipUpdateTasks) {
      final tasks = ref.read(tasksProvider).value ?? [];
      await ref.read(tasksProvider.notifier).updateTasks(tasks);
    }
  }

  /// 次のセッションへ遷移（自動／手動切り替え付き）
  Future<void> _proceedToNextSession({
    required bool skipBreak,
    required bool autoStart,
  }) async {
    _resetSessionState();
    SessionType nextType = scheduler.startNext();
    if (skipBreak && nextType != SessionType.work) {
      nextType = scheduler.startNext();
    }

    final durationSec = scheduler.getDuration(nextType);
    _session.pomodoroUnitSec = durationSec;

    ref.read(sessionTypeProvider.notifier).state = nextType;
    ref.read(remainingTimeProvider.notifier).start(durationSec);
    logger.i("[TimerController] transitioned to $nextType ($durationSec sec)");

    ref.read(timerPhaseProvider.notifier).state = TimerPhase.ready;
    if (autoStart) {
      start(); // 自動開始
    } else {
      stop(); // 手動待機
    }
  }

  void _resetSessionState() {
    _lastCommitSecond = 0;
    _hasWarnedAlmostFinished = false;
  }

  /// セッション完了時に呼ばれる処理
  /// - 集計処理
  /// - AutoSafeGuardで自動モードの停止判定
  /// - 次セッションへの遷移
  Future<void> _onSessionComplete() async {
    _finalizeSessionAndApply();

    final guard = AutoSafeGuard(
      controller: this,
      autoMode: ref.read(autoModeProvider),
      task: ref.read(selectedTimerTaskProvider),
    );

    final canProceed = await guard.evaluateAfterSession();

    if (!canProceed) {
      ref.read(overLimitProvider.notifier).state = true;

      await _proceedToNextSession(
        skipBreak: true,
        autoStart: false,
      );
      return;
    }

    final isAuto = ref.read(autoModeProvider).isAutoEnabled;
    await _proceedToNextSession(
      skipBreak: false,
      autoStart: isAuto,
    );
  }

  /// タイマー開始（初回時にtick即時実行）
  void start() {
    final task = ref.read(selectedTimerTaskProvider.notifier).state;
    logger.i("[TimerController] start() task: ${task?.title ?? 'タスクなし'}");

    final phase = ref.read(timerPhaseProvider);
    final type = ref.read(sessionTypeProvider);
    final durationSec = scheduler.getDuration(type);
    if (phase == TimerPhase.ready) {
      _session.pomodoroUnitSec = durationSec;
      ref.read(remainingTimeProvider.notifier).start(durationSec);
      ref.read(timerPhaseProvider.notifier).state = TimerPhase.running;
    }
    if (task != null) {
      logger.d("[TimerController] mark stated : $task");
      final updated = task.markStarted();
      final notifier = ref.read(tasksProvider.notifier);
      notifier.updateTask(updated, commit: false);
      logger.d("[TimerController] append log : $type $task");
      _session.sessionType = ref.read(sessionTypeProvider);
      _session.record(phase: TimerPhase.running, taskId: task.id);
    }

    if (!_timer.isRunning) {
      _timer.start();
    }
    _tick(); // 即時tick実行で反応を早く
    WakelockPlus.enable();
    logger.i("[TimerController] timer started: $type ($durationSec sec)");
  }

  /// タスク切替時にセッションログを追記
  void switchTask() {
    final task = ref.read(selectedTimerTaskProvider.notifier).state;
    if (task != null) {
      logger.d("[TimerController] append log : $task");
      final timerPhase = ref.read(timerPhaseProvider);
      _session.record(phase: timerPhase, taskId: task.id);
      logger.d("[DEBUG] switchTask: phase=$timerPhase");
      if (timerPhase == TimerPhase.paused) {
        resume();
      }
    }
    logger.i("[TimerController] switch task");
  }

  /// タイマーを一時停止
  void pause() {
    if (!_timer.isRunning) {
      logger.w("[TimerController] pause() ignored: not running");
      return;
    }

    ref.read(remainingTimeProvider.notifier).pause();
    _timer.stop();
    ref.read(timerPhaseProvider.notifier).state = TimerPhase.paused;

    final task = ref.read(selectedTimerTaskProvider);
    _session.record(phase: TimerPhase.paused, taskId: task?.id);
    WakelockPlus.disable();
    logger.i("[TimerController] paused");
  }

  /// タイマーを再開
  void resume() {
    if (_timer.isRunning) {
      logger.w("[TimerController] resume() ignored: already running");
      return;
    }

    ref.read(remainingTimeProvider.notifier).resume();
    ref.read(timerPhaseProvider.notifier).state = TimerPhase.running;
    _timer.start();
    _tick(); // 再開直後に即tick

    final task = ref.read(selectedTimerTaskProvider);
    _session.record(phase: TimerPhase.running, taskId: task?.id);
    WakelockPlus.enable(); // ←追加
    logger.i("[TimerController] resumed");
  }

  /// タイマー完全停止、状態リセット
  void stop() {
    if (_timer.isRunning) {
      _timer.stop();
      logger.i("[TimerController] _timer stopped");
    }

    ref.read(remainingTimeProvider.notifier).stop();
    ref.read(timerPhaseProvider.notifier).state = TimerPhase.ready;
    WakelockPlus.disable(); // ←追加

    logger.i("[TimerController] stopped and state is ready");
  }

  /// 現在のセッションをスキップ(停止)してリセット
  Future<void> reset() async {
    await _finalizeSessionAndApply();
    final isAuto = ref.read(autoModeProvider).isAutoEnabled;
    await _proceedToNextSession(skipBreak: true, autoStart: isAuto);

    logger.i("[TimerController] session resetted");
  }

  // タイマーとスケジューラのリセット
  Future<void> resetTimerState() async {
    // タイマー完全停止
    if (_timer.isRunning) _timer.stop();
    ref.read(remainingTimeProvider.notifier).stop();
    WakelockPlus.disable();

    // Pomodoroセッション初期化
    scheduler.reset();
    _resetSessionState();
    _session.clear(); // ←PomodoroSessionにclear()を追加

    // 状態リセット
    ref.read(timerPhaseProvider.notifier).state = TimerPhase.ready;
    ref.read(sessionTypeProvider.notifier).state = SessionType.work;
    ref.read(selectedTimerTaskProvider.notifier).state = null;

    // 残り時間をゼロ化
    ref.read(remainingTimeProvider.notifier).resetToZero();

    logger.i(
        "[TimerController] resetAllForImport(): session cleared, ready state");
  }

  /// 指定タスクを完了／未完了に切り替え、選択中であれば解除
  Future<void> toggleTask(String id) async {
    // セッション集計は行うが、完了トグル時は updateTasks をスキップ
    await _finalizeSessionAndApply(skipUpdateTasks: true);

    final tasksNotifier = ref.read(tasksProvider.notifier);
    await tasksNotifier.toggleComplete(id);

    // タスクが完了になったら選択解除＋一時停止
    final task = ref.read(selectedTimerTaskProvider);
    if (task?.id == id && task?.status == "needsAction") {
      ref.read(selectedTimerTaskProvider.notifier).state = null;
      pause();
    }

    logger.i("[TimerController] complete toggle changed (skip updateTasks)");
  }

  /// リソース解放（タイマー停止）
  void dispose() {
    logger.i("[TimerController] dispose() called");
    _timer.stop();
  }
}
