import 'package:ptune/controllers/timer_controller.dart';
import 'package:ptune/models/my_task.dart';
import 'package:ptune/states/auto_mode_state.dart';
import 'package:ptune/utils/logger.dart';

/// AutoSafeGuard:
/// 自動モード（AutoMode）でのポモドーロタイマー動作中に、
/// 作業時間のやりすぎ（プラン超過）を防ぐための安全装置クラス。
///
/// タイマーのセッション終了時に `evaluateAfterSession()` を呼び出し、
/// 過剰作業を検知した場合は自動モードを解除して手動モードに切り替える。
///
/// 使用例:
/// ```dart
/// final guard = AutoSafeGuard(
///   controller: this,
///   autoMode: ref.read(autoModeProvider),
///   task: ref.read(selectedTimerTaskProvider),
/// );
/// await guard.evaluateAfterSession();
/// ```
///
/// このガードは `autoMode.safeMode` が有効かつ、
/// 実績(actual) が計画(planned) より4セッション以上超えている場合に発動する。

class AutoSafeGuard {
  final TimerController controller;
  final AutoMode autoMode;
  final MyTask? task;

  AutoSafeGuard({
    required this.controller,
    required this.autoMode,
    required this.task,
  });

  /// セッション終了後に呼び出し、作業オーバーを検出した場合に
  /// 自動モードを解除してタイマーを停止する
  Future<bool> evaluateAfterSession() async {
    if (!autoMode.isSafeEnabled || !_isOverPlanned(task)) return true;

    controller.stop();

    logger.i(
      "[AutoSafeGuard] Stopped due to exceeding limit",
    );
    return false;
  }

  /// 計画(planned)より実績(actual)が4セッション以上超えていたら true を返す
  bool _isOverPlanned(MyTask? task) {
    final planned = task?.pomodoro?.planned ?? 0;
    final actual = task?.pomodoro?.actual ?? 0;
    return actual > planned + 4;
  }
}
