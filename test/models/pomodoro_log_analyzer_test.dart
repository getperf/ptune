import 'package:flutter_test/flutter_test.dart';
import 'package:ptune/models/pomodoro_log.dart';
import 'package:ptune/models/pomodoro_log_analyzer.dart';
import 'package:ptune/models/timer_phase.dart';

void main() {
  group('PomodoroLogAnalyzer', () {
    test('summarize calculates total time per task', () {
      final logs = [
        PomodoroLog(
          TimerPhase.running,
          taskId: 'taskA',
          timestamp: DateTime.utc(2025, 1, 1, 9, 0, 0),
        ),
        PomodoroLog(
          TimerPhase.paused,
          taskId: 'taskA',
          timestamp: DateTime.utc(2025, 1, 1, 9, 10, 0),
        ),
        PomodoroLog(
          TimerPhase.running,
          taskId: 'taskA',
          timestamp: DateTime.utc(2025, 1, 1, 9, 15, 0),
        ),
        PomodoroLog(
          TimerPhase.end,
          taskId: 'taskA',
          timestamp: DateTime.utc(2025, 1, 1, 9, 30, 0),
        ),
      ];

      final analyzer = PomodoroLogAnalyzer(logs);
      final result = analyzer.summarize();

      expect(result['taskA'], 10 * 60 + 15 * 60 + 2); // 1500秒
    });

    test('summarize ignores mismatched task_ids or missing timestamps', () {
      final logs = [
        PomodoroLog(TimerPhase.running, taskId: 'taskX'),
        PomodoroLog(TimerPhase.paused, taskId: 'taskY'),
      ];

      final analyzer = PomodoroLogAnalyzer(logs);
      final result = analyzer.summarize();

      expect(result, isEmpty);
    });
  });
}
