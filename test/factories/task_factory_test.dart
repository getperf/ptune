import 'package:flutter_test/flutter_test.dart';
import 'package:ptune/factories/task_factory.dart';
import 'package:ptune/factories/task_factory_ext.dart';
import 'package:ptune/models/my_task.dart';
import 'package:ptune/models/pomodoro_info.dart';

void main() {
  test('fromApiData should parse notes and pomodoro correctly', () {
    final factory = TaskFactory();
    final task = factory.fromApiData({
      'id': 'abc',
      'title': 'Test Task',
      'notes': '🍅x3 ✅x2 started=2025-08-10T09:00:00Z',
      'status': 'needsAction',
    });

    expect(task.id, 'abc');
    expect(task.title, 'Test Task');
    expect(task.pomodoro?.planned, 3);
    expect(task.pomodoro?.actual, 2);
    expect(task.started?.year, 2025);
  });

  test('toApiData converts task correctly', () {
    final task = MyTask(
      id: '123',
      title: 'Test Task',
      note: 'Do something important',
      pomodoro: PomodoroInfo(planned: 3, actual: 2.5),
      status: 'needsAction',
    );

    final factory = TaskFactory();
    final apiData = factory.toApiData(task);

    expect(apiData['title'], 'Test Task');
    expect(apiData['status'], 'needsAction');
    expect(apiData['notes'], contains('🍅x3'));
    expect(apiData['notes'], contains('✅x2.5'));
    expect(apiData['notes'], contains('Do something important'));
  });
}
