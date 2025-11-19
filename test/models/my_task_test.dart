import 'package:flutter_test/flutter_test.dart';
import 'package:ptune/models/my_task.dart';
import 'package:ptune/models/pomodoro_info.dart';
import 'package:ptune/models/my_task_ext.dart';

void main() {
  group('MyTask', () {
    test('toDisplayString without pomodoro', () {
      final task = MyTask(id: '1', title: 'Write Code');
      expect(task.toDisplayString(), '[ ] Write Code');
    });

    test('toDisplayString with pomodoro', () {
      final task = MyTask(
        id: '1',
        title: 'Task A',
        pomodoro: PomodoroInfo(planned: 2, actual: 1.0),
      );
      expect(task.toDisplayString(), '[ ] Task A 🍅x2 ✅x1.0');
    });

    test('markStarted sets started if null', () {
      final task = MyTask(id: '1', title: 'StartMe');
      final marked = task.markStarted();
      expect(marked.started, isNotNull);
    });

    test('markCompleted sets completed and status', () {
      final task = MyTask(id: '1', title: 'FinishMe');
      final completed = task.markCompleted();
      expect(completed.status, 'completed');
      expect(completed.completed, isNotNull);
    });

    // test('toApiData produces correct map', () {
    //   final task = MyTask(
    //     id: '42',
    //     title: 'API Task',
    //     note: 'Test Note',
    //     parent: 'parent123',
    //     due: DateTime.utc(2025, 7, 30),
    //     pomodoro: PomodoroInfo(planned: 2, actual: 1),
    //   ).markStarted();

    //   final api = task.toApiData();
    //   expect(api['title'], 'API Task');
    //   expect(api['status'], 'needsAction');
    //   expect(api['notes'], contains('🍅x2✅x1.0'));
    //   expect(api['notes'], contains('started='));
    //   expect(api['due'], '2025-07-30T00:00:00.000Z');
    //   expect(api['parent'], 'parent123');
    // });

    test('JSON serialization/deserialization', () {
      final task = MyTask(id: '1', title: 'SerializeTest');
      final json = task.toJson();
      final restored = MyTask.fromJson(json);
      expect(restored, task);
    });

    test('subTasks list works recursively', () {
      final sub = MyTask(id: 'sub1', title: 'Sub Task');
      final parent = MyTask(id: 'main', title: 'Main', subTasks: [sub]);
      expect(parent.subTasks.length, 1);
      expect(parent.subTasks.first.title, 'Sub Task');
    });
  });
}
