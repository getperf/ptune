import 'package:ptune/models/my_task.dart';
import 'package:ptune/models/task_row.dart';

class TaskRowsBuilder {
  static List<TaskRow> build(List<MyTask> tasks) {
    final rows = <TaskRow>[];

    final Map<String?, List<MyTask>> children = {};

    for (final task in tasks) {
      children.putIfAbsent(task.parent, () => []).add(task);
    }

    final parents = children[null] ?? [];

    for (final parent in parents) {
      rows.add(TaskRow(parent, 0));

      final childs = children[parent.id];
      if (childs != null) {
        for (final c in childs) {
          rows.add(TaskRow(c, 1));
        }
      }
    }

    return rows;
  }
}
