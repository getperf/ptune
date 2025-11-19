import 'package:ptune/models/task_row.dart';
import '../models/my_task.dart';

List<TaskRow> flattenTasksHierarchically(List<MyTask> tasks) {
  final List<TaskRow> result = [];

  void visit(MyTask task, int depth) {
    result.add(TaskRow(task, depth));

    final children = tasks.where((t) => t.parent == task.id).toList()
      ..sort((a, b) => (a.position ?? '').compareTo(b.position ?? ''));

    for (final child in children) {
      visit(child, depth + 1);
    }
  }

  final roots = tasks.where((t) => t.parent == null).toList()
    ..sort((a, b) => (a.position ?? '').compareTo(b.position ?? ''));

  for (final root in roots) {
    visit(root, 0);
  }

  return result;
}
