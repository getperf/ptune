import 'package:flutter_test/flutter_test.dart';
import 'package:ptune/models/my_task.dart';
import 'package:ptune/models/my_task_notes_encoder.dart';
import 'package:ptune/models/pomodoro_info.dart';

void main() {
  test('planned appears in first line', () {
    final task = MyTask(
      id: '1',
      title: 'Test',
      pomodoro: PomodoroInfo(planned: 2),
      goal: 'Finish',
      tags: ['分類/修正'],
    );

    final notes = MyTaskNotesEncoder.encode(task)!;
    final firstLine = notes.split('\n').first;

    expect(firstLine, '🍅planned=2');
  });
}
