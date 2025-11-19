import 'package:flutter_test/flutter_test.dart';
import 'package:ptune/models/pomodoro_session.dart';
import 'package:ptune/models/session_type.dart';
import 'package:ptune/models/timer_phase.dart';

void main() {
  group('PomodoroSession', () {
    late PomodoroSession session;

    setUp(() {
      session = PomodoroSession();
    });

    test('record() should update phase and taskId', () {
      session.record(
        phase: TimerPhase.running,
        taskId: 'task123',
        timestamp: DateTime.utc(2025, 1, 1, 9, 0, 0),
      );

      expect(session.phase, TimerPhase.running);
      expect(session.taskId, 'task123');
      expect(session.logs.length, 1);
    });

    test('getSummaryAndCommit should clear logs after commit', () {
      final start = DateTime.utc(2025, 1, 1, 9, 0, 0);
      final end = DateTime.utc(2025, 1, 1, 9, 25, 0);

      session.sessionType = SessionType.work;

      session.record(
        phase: TimerPhase.running,
        taskId: 'task123',
        timestamp: start,
      );
      session.record(
        phase: TimerPhase.paused,
        taskId: 'task123',
        timestamp: end,
      );

      final summary = session.getSummaryAndCommit();

      expect(summary['task123'], closeTo(1, 0.01));
      // expect(summary['task123'], 1500); // 25分 = 1500秒
      expect(session.logs, isEmpty);
    });

    test('getSummaryAndCommit should skip if sessionType is break', () {
      session.sessionType = SessionType.shortBreak;

      session.record(phase: TimerPhase.running, taskId: 'taskX');
      session.record(phase: TimerPhase.end, taskId: 'taskX');

      final result = session.getSummaryAndCommit();
      expect(result, isEmpty);
    });
  });
}
