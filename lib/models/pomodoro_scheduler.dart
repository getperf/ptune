import 'session_type.dart';
import 'package:ptune/utils/logger.dart'; // ← ロガー追加

class PomodoroScheduler {
  SessionType currentType = SessionType.work;
  int workCount = 0;
  final int longBreakInterval;
  final bool isDemo;

  PomodoroScheduler({this.longBreakInterval = 4, this.isDemo = true});

  SessionType getNextSessionType() {
    if (currentType == SessionType.work) {
      int nextWorkCount = workCount + 1;
      final next = (nextWorkCount % longBreakInterval == 0)
          ? SessionType.longBreak
          : SessionType.shortBreak;
      logger.d(
        "[Scheduler] next session = $next (after workCount=$nextWorkCount)",
      );
      return next;
    } else {
      logger.d("[Scheduler] next session = work");
      return SessionType.work;
    }
  }

  SessionType startNext() {
    if (currentType == SessionType.work) {
      workCount++;
      currentType = (workCount % longBreakInterval == 0)
          ? SessionType.longBreak
          : SessionType.shortBreak;
    } else {
      currentType = SessionType.work;
    }
    logger.i(
      "[Scheduler] started session: $currentType (workCount=$workCount)",
    );
    return currentType;
  }

  int getDuration([SessionType? type]) {
    final t = type ?? currentType;
    final duration = isDemo ? _getDemoDuration(t) : _getProductionDuration(t);
    logger.d("[Scheduler] getDuration($t) = $duration sec (isDemo=$isDemo)");
    return duration;
  }

  void reset() {
    currentType = SessionType.work;
    workCount = 0;
    logger.i("[Scheduler] reset: workCount=0, type=work");
  }

  int _getDemoDuration(SessionType t) {
    switch (t) {
      case SessionType.work:
        return 60;
      case SessionType.shortBreak:
        return 10;
      case SessionType.longBreak:
        return 20;
    }
  }

  int _getProductionDuration(SessionType t) {
    switch (t) {
      case SessionType.work:
        return 25 * 60;
      case SessionType.shortBreak:
        return 5 * 60;
      case SessionType.longBreak:
        return 15 * 60;
    }
  }
}
