import 'package:flutter_test/flutter_test.dart';
import 'package:ptune/models/pomodoro_scheduler.dart';
import 'package:ptune/models/session_type.dart';

void main() {
  group('PomodoroScheduler', () {
    late PomodoroScheduler scheduler;

    setUp(() {
      scheduler = PomodoroScheduler(longBreakInterval: 4, isDemo: true);
    });

    test('Initial state is work session', () {
      expect(scheduler.currentType, SessionType.work);
      expect(scheduler.workCount, 0);
    });

    test('After one work session, next is short break', () {
      expect(scheduler.startNext(), SessionType.shortBreak);
      expect(scheduler.workCount, 1);
      expect(scheduler.getNextSessionType(), SessionType.work);
    });

    test('After 4th work session, next is long break', () {
      for (int i = 0; i < 3; i++) {
        scheduler.startNext(); // short
        scheduler.startNext(); // work
      }
      final result = scheduler.startNext(); // long break
      expect(result, SessionType.longBreak);
      expect(scheduler.workCount, 4);
    });

    test('getDuration with no argument uses currentType', () {
      scheduler.currentType = SessionType.longBreak;
      expect(scheduler.getDuration(), 5);
    });
  });
}
