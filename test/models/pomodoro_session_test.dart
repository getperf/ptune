import 'package:flutter_test/flutter_test.dart';
import 'package:ptune/models/pomodoro_session.dart';
import 'package:ptune/models/session_type.dart';
import 'package:ptune/models/timer_phase.dart';
import 'package:ptune/utils/logger.dart';

void main() {
  setUpAll(() {
    initLoggerForTest();
  });

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

    test('getSummaryAndCommit should prevent previous task carry-over', () {
      final firstStart = DateTime.utc(2025, 1, 1, 9, 0, 0);
      final firstEnd = DateTime.utc(2025, 1, 1, 9, 25, 0);
      final secondStart = DateTime.utc(2025, 1, 1, 9, 30, 0);
      final secondMid = DateTime.utc(2025, 1, 1, 9, 32, 30);

      session.sessionType = SessionType.work;
      session.record(
        phase: TimerPhase.running,
        taskId: 'taskA',
        timestamp: firstStart,
      );
      session.record(
        phase: TimerPhase.end,
        taskId: 'taskA',
        timestamp: firstEnd,
      );

      final firstSummary = session.getSummaryAndCommit();
      expect(firstSummary['taskA'], closeTo(1, 0.01));
      expect(session.logs, isEmpty);

      session.record(
        phase: TimerPhase.running,
        taskId: 'taskB',
        timestamp: secondStart,
      );
      session.record(
        phase: TimerPhase.paused,
        taskId: 'taskB',
        timestamp: secondMid,
      );

      final secondSummary = session.getPartialSummary();
      expect(secondSummary.containsKey('taskA'), isFalse);
      expect(secondSummary.containsKey('taskB'), isTrue);
    });
  });
}
