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

    test('final summary should only include uncommitted remainder after partial commits', () {
      final start = DateTime.utc(2025, 1, 1, 9, 0, 0);
      final partialEnd = DateTime.utc(2025, 1, 1, 9, 15, 0);
      final resume = DateTime.utc(2025, 1, 1, 9, 15, 1);
      final end = DateTime.utc(2025, 1, 1, 9, 25, 0);

      session.sessionType = SessionType.work;
      session.record(
        phase: TimerPhase.running,
        taskId: 'taskA',
        timestamp: start,
      );
      session.record(
        phase: TimerPhase.paused,
        taskId: 'taskA',
        timestamp: partialEnd,
      );

      final partial = session.getPartialSummary();
      expect(partial['taskA'], closeTo(901 / 1500, 0.01));

      session.record(
        phase: TimerPhase.running,
        taskId: 'taskA',
        timestamp: resume,
      );
      session.record(
        phase: TimerPhase.end,
        taskId: 'taskA',
        timestamp: end,
      );

      final finalSummary = session.getSummaryAndCommit();
      expect(finalSummary['taskA'], closeTo(600 / 1500, 0.01));
    });

    test('final summary should not re-add a task already flushed on task switch', () {
      final firstStart = DateTime.utc(2025, 1, 1, 9, 0, 0);
      final firstPause = DateTime.utc(2025, 1, 1, 9, 5, 0);
      final secondStart = DateTime.utc(2025, 1, 1, 9, 5, 1);
      final secondEnd = DateTime.utc(2025, 1, 1, 9, 25, 0);

      session.sessionType = SessionType.work;
      session.record(
        phase: TimerPhase.running,
        taskId: 'taskA',
        timestamp: firstStart,
      );
      session.record(
        phase: TimerPhase.paused,
        taskId: 'taskA',
        timestamp: firstPause,
      );

      final partial = session.getPartialSummary();
      expect(partial['taskA'], closeTo(301 / 1500, 0.01));

      session.record(
        phase: TimerPhase.running,
        taskId: 'taskB',
        timestamp: secondStart,
      );
      session.record(
        phase: TimerPhase.end,
        taskId: 'taskB',
        timestamp: secondEnd,
      );

      final finalSummary = session.getSummaryAndCommit();
      expect(finalSummary.containsKey('taskA'), isFalse);
      expect(finalSummary['taskB'], closeTo(1200 / 1500, 0.01));
    });

    test('single pomodoro with multiple task switches should aggregate each task once', () {
      final aStart = DateTime.utc(2025, 1, 1, 9, 0, 0);
      final aPause = DateTime.utc(2025, 1, 1, 9, 5, 0);
      final bStart = DateTime.utc(2025, 1, 1, 9, 5, 1);
      final bPause = DateTime.utc(2025, 1, 1, 9, 10, 0);
      final cStart = DateTime.utc(2025, 1, 1, 9, 10, 1);
      final cEnd = DateTime.utc(2025, 1, 1, 9, 25, 0);

      session.sessionType = SessionType.work;
      session.record(
        phase: TimerPhase.running,
        taskId: 'taskA',
        timestamp: aStart,
      );
      session.record(
        phase: TimerPhase.paused,
        taskId: 'taskA',
        timestamp: aPause,
      );

      final firstPartial = session.getPartialSummary();
      expect(firstPartial['taskA'], closeTo(301 / 1500, 0.01));

      session.record(
        phase: TimerPhase.running,
        taskId: 'taskB',
        timestamp: bStart,
      );
      session.record(
        phase: TimerPhase.paused,
        taskId: 'taskB',
        timestamp: bPause,
      );

      final secondPartial = session.getPartialSummary();
      expect(secondPartial.containsKey('taskA'), isFalse);
      expect(secondPartial['taskB'], closeTo(300 / 1500, 0.01));

      session.record(
        phase: TimerPhase.running,
        taskId: 'taskC',
        timestamp: cStart,
      );
      session.record(
        phase: TimerPhase.end,
        taskId: 'taskC',
        timestamp: cEnd,
      );

      final finalSummary = session.getSummaryAndCommit();
      expect(finalSummary.containsKey('taskA'), isFalse);
      expect(finalSummary.containsKey('taskB'), isFalse);
      expect(finalSummary['taskC'], closeTo(900 / 1500, 0.01));
    });
  });
}
