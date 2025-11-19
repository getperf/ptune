import 'package:flutter_test/flutter_test.dart';
import 'package:ptune/models/pomodoro_info.dart';

void main() {
  group('PomodoroInfo', () {
    test('default actual is null', () {
      final info = PomodoroInfo(planned: 3);
      expect(info.planned, 3);
      expect(info.actual, isNull);
    });

    test('planned and actual are preserved', () {
      final info = PomodoroInfo(planned: 4, actual: 2.5);
      expect(info.planned, 4);
      expect(info.actual, 2.5);
    });

    test('JSON serialization/deserialization', () {
      final info = PomodoroInfo(planned: 2, actual: 1.5);
      final json = info.toJson();
      final fromJson = PomodoroInfo.fromJson(json);
      expect(fromJson, info);
    });
  });
}
