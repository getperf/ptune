import 'package:ptune/models/my_task.dart';
import 'package:ptune/models/task_row.dart';

class TaskRowsBuilder {
  static List<TaskRow> build(
    List<MyTask> tasks, {
    List<MyTask>? parentLookupTasks,
  }) {
    final rows = <TaskRow>[];
    final visibleIds = tasks.map((task) => task.id).toSet();
    final parentLookup = {
      for (final task in parentLookupTasks ?? tasks) task.id: task,
    };

    final Map<String?, List<MyTask>> children = {};

    for (final task in tasks) {
      children.putIfAbsent(task.parent, () => []).add(task);
    }

    final parents = tasks.where((task) {
      final parent = task.parent;
      return parent == null || parent.isEmpty || !visibleIds.contains(parent);
    });

    for (final parent in parents) {
      final parentId = parent.parent;
      final hasHiddenParent =
          parentId != null &&
          parentId.isNotEmpty &&
          !visibleIds.contains(parentId);
      final parentTitle = hasHiddenParent
          ? parentLookup[parentId]?.title
          : null;

      rows.add(TaskRow(parent, 0, parentTitle: parentTitle));

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
