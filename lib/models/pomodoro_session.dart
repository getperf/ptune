import 'package:ptune/models/pomodoro_log.dart';
import 'package:ptune/models/session_type.dart';
import 'package:ptune/models/timer_phase.dart';
import 'package:ptune/models/pomodoro_log_analyzer.dart';
import 'package:ptune/utils/logger.dart'; // ← 追加

class PomodoroSession {
  int pomodoroUnitSec = 1500; // default fallback
  String? taskId;
  TimerPhase phase = TimerPhase.ready;
  SessionType sessionType = SessionType.work;
  final List<PomodoroLog> logs = [];

  @override
  String toString() {
    final logStr = logs.map((l) => l.toString()).join(', ');
    final task = taskId ?? "None";
    return 'Session(${sessionType.label}:${phase.label}, task=$task, logs=[$logStr])';
  }

  void record({TimerPhase? phase, String? taskId, DateTime? timestamp}) {
    if (phase != null) this.phase = phase;
    if (taskId != null) this.taskId = taskId;

    final log = PomodoroLog(
      this.phase,
      taskId: this.taskId,
      timestamp: timestamp,
    );
    logs.add(log);

    logger.d("[PomodoroSession] recorded: $log");
  }

  int get elapsedSeconds {
    if (logs.isEmpty) return 0;
    final start = logs.first.timestamp;
    final end = DateTime.now();
    return end.difference(start).inSeconds;
  }

  // 🔽 追加: すでに中間コミットされた時間（taskIdごと）
  final Map<String, double> _committedSeconds = {};

  /// 作業時間を秒で差分集計し、ポモドーロ単位に変換して返す
  Map<String, double> getPartialSummary() {
    if (sessionType != SessionType.work) {
      logger.i("[PomodoroSession] skipped partial summary (non-work)");
      return {};
    }

    final analyzer = PomodoroLogAnalyzer(logs);
    final rawSummary = analyzer.summarize(); // 全ログを集計

    logger.d("[PomodoroSession] rawSummary: $rawSummary");
    logger.d("[PomodoroSession] committedSeconds: $_committedSeconds");

    final deltaSummary = _buildDeltaSummary(rawSummary);
    logger.d("[PomodoroSession] deltaSummary: $deltaSummary");

    // コミット済みに追加
    for (final entry in deltaSummary.entries) {
      _committedSeconds.update(
        entry.key,
        (v) => v + entry.value,
        ifAbsent: () => entry.value,
      );
    }
    logger.d("[PomodoroSession] updated committed: $_committedSeconds");

    final result = _convertToPomodoroUnits(deltaSummary, pomodoroUnitSec);
    logger.d("[PomodoroSession] partial summary: $result");
    return result;
  }

  /// セッション終了時にログ全体を集計してポモドーロ換算し、記録後にクリア
  Map<String, double> getSummaryAndCommit() {
    if (sessionType != SessionType.work) {
      logger.i(
        "[PomodoroSession] sessionType=$sessionType → summary skipped, logs cleared",
      );
      logs.clear();
      _committedSeconds.clear();
      return {};
    }

    final analyzer = PomodoroLogAnalyzer(logs);
    final summary = analyzer.summarize();
    final deltaSummary = _buildDeltaSummary(summary);

    logger.i("[PomodoroSession] summary computed for task=$taskId: $summary");
    logger.i("[PomodoroSession] final delta summary: $deltaSummary");

    final pomodoroCounts = _convertToPomodoroUnits(deltaSummary, pomodoroUnitSec);
    logger.i("[PomodoroSession] pomodoro counts: $pomodoroCounts");

    logs.clear();
    _committedSeconds.clear();
    return pomodoroCounts;
  }

  /// セッション全体を初期状態に戻す
  void clear() {
    logs.clear();
    _committedSeconds.clear();
    taskId = null;
    phase = TimerPhase.ready;
    sessionType = SessionType.work;
    pomodoroUnitSec = 1500;
    logger.i("[PomodoroSession] cleared → reset to initial state");
  }

  Map<String, double> _buildDeltaSummary(Map<String, double> rawSummary) {
    final Map<String, double> deltaSummary = {};

    for (final entry in rawSummary.entries) {
      final already = _committedSeconds[entry.key] ?? 0;
      final diff = entry.value - already;
      if (diff > 0) {
        deltaSummary[entry.key] = diff;
      }
    }

    return deltaSummary;
  }

  Map<String, double> _convertToPomodoroUnits(
    Map<String, double> secondsMap,
    int pomodoroUnitSec,
  ) {
    final Map<String, double> result = {};
    for (final entry in secondsMap.entries) {
      final unitCount = (entry.value / pomodoroUnitSec);
      result[entry.key] = unitCount;
    }
    return result;
  }
}
