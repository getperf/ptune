import 'package:ptune/models/pomodoro_log.dart';
import 'package:ptune/models/timer_phase.dart';
import 'package:ptune/utils/logger.dart'; // ← 追加

class PomodoroLogAnalyzer {
  final List<PomodoroLog> logs;

  PomodoroLogAnalyzer(this.logs);

  /// 各 taskId ごとにセッション時間（秒）を集計して返す
  Map<String, double> summarize() {
    final Map<String, double> summary = {};
    PomodoroLog? lastRunning;

    for (final log in logs) {
      logger.d(
        "[Analyzer] phase=${log.phase}, task=${log.taskId}, time=${log.timestamp}",
      );

      double delta = 0;
      if (lastRunning != null) {
        delta = log.timestamp
                .difference(lastRunning.timestamp)
                .inSeconds
                .toDouble() +
            1;
      }

      switch (log.phase) {
        case TimerPhase.ready:
          lastRunning = null;
          logger.d("[Analyzer] TimerPhase.ready → lastRunning reset");
          break;

        case TimerPhase.running:
          if (lastRunning?.taskId != null && delta > 0) {
            _addToSummary(summary, lastRunning!.taskId!, delta);
          }
          lastRunning = log;
          logger.d("[Analyzer] running started for ${log.taskId}");
          break;

        case TimerPhase.paused:
        case TimerPhase.end:
          if (lastRunning?.timestamp != null &&
              log.taskId == lastRunning?.taskId &&
              delta > 0) {
            _addToSummary(summary, log.taskId!, delta);
          } else {
            logger.w("[Analyzer] invalid segment at end");
          }
          lastRunning = null;
          break;
      }
    }

    // 🔽 最後が running のままなら now までの経過を追加
    if (lastRunning != null && lastRunning.taskId != null) {
      final now = DateTime.now();
      final delta =
          now.difference(lastRunning.timestamp).inSeconds.toDouble() + 1;

      if (delta > 0) {
        _addToSummary(summary, lastRunning.taskId!, delta);
        logger
            .d("[Analyzer] ⏱️ running継続 → +${delta}s to ${lastRunning.taskId}");
      }
    }

    logger.d("[Analyzer] summary complete: $summary");
    return summary;
  }

  // Map<String, double> summarize() {
  //   final Map<String, double> summary = {};
  //   PomodoroLog? lastRunning;

  //   for (final log in logs) {
  //     logger.d(
  //       "[Analyzer] phase=${log.phase}, task=${log.taskId}, time=${log.timestamp}",
  //     );

  //     double delta = 0;
  //     if (lastRunning != null) {
  //       delta =
  //           log.timestamp
  //               .difference(lastRunning.timestamp)
  //               .inSeconds
  //               .toDouble() +
  //           1;
  //     }

  //     switch (log.phase) {
  //       case TimerPhase.ready:
  //         lastRunning = null;
  //         logger.d("[Analyzer] TimerPhase.ready → lastRunning reset");
  //         break;

  //       case TimerPhase.running:
  //         if (lastRunning?.taskId != null) {
  //           if (delta > 0) {
  //             _addToSummary(summary, lastRunning!.taskId!, delta);
  //           }
  //         }
  //         lastRunning = log;
  //         logger.d("[Analyzer] running started for ${log.taskId}");
  //         break;

  //       case TimerPhase.paused:
  //       case TimerPhase.end:
  //         if (lastRunning?.timestamp != null &&
  //             log.taskId == lastRunning?.taskId) {
  //           if (delta > 0) {
  //             _addToSummary(summary, log.taskId!, delta);
  //           }
  //         } else {
  //           logger.w("[Analyzer] invalid segment at end");
  //         }
  //         lastRunning = null;
  //         break;
  //     }
  //   }

  //   logger.d("[Analyzer] summary complete: $summary");
  //   return summary;
  // }

  void _addToSummary(Map<String, double> summary, String taskId, double delta) {
    summary.update(taskId, (value) => value + delta, ifAbsent: () => delta);
    logger.i("[Analyzer] task=$taskId +${delta}s (total=${summary[taskId]})");
  }
}
