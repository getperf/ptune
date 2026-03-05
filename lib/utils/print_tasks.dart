import 'package:ptune/models/my_task.dart';
import 'package:ptune/utils/logger.dart';

import 'package:ptune/services/task_order_service.dart';

void printTasks(List<MyTask> tasks) {
  final sorted = TaskOrderService.normalizeForUi(tasks);

  logger.i('=== Task List ===');

  for (final task in sorted) {
    if (task.parent == null) {
      logger.i('[${task.id}] ${task.title} (pos:${task.position})');

      final children = TaskOrderService.siblings(tasks, task.id);

      for (final sub in children) {
        logger.i('  └─ ${sub.title}');
      }
    }
  }
}
