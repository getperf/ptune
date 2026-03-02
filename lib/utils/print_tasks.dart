import 'package:ptune/models/my_task.dart';
import 'package:ptune/utils/logger.dart';
import 'package:ptune/utils/task_hierarchy.dart';

void printTasks(List<MyTask> tasks) {
  final sorted = sortByHierarchyPosition(tasks);

  logger.i('=== Task List (position sorted ASC) ===');

  for (final task in sorted) {
    if (task.parent == null) {
      logger.i('[${task.id}] ${task.title} (pos: ${task.position})');

      final children = sorted.where((t) => t.parent == task.id).toList();

      for (final sub in children) {
        logger.i('  └─ [${sub.id}] ${sub.title} (pos: ${sub.position})');
      }
    }
  }

  logger.i('=== End of Task List ===');
}
