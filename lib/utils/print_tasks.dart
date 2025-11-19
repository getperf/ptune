import 'package:ptune/models/my_task.dart';
import 'package:ptune/utils/logger.dart';

void printTasks(List<MyTask> tasks) {
  // マップ化：親ID → サブタスク一覧
  final Map<String, List<MyTask>> subtasksMap = {};
  for (final t in tasks) {
    if (t.parent != null) {
      subtasksMap.putIfAbsent(t.parent!, () => []).add(t);
    }
  }

  // トップレベルタスクを position順にソート
  final topLevelTasks = tasks.where((t) => t.parent == null).toList()
    ..sort((a, b) => (a.position ?? '').compareTo(b.position ?? ''));

  logger.i('=== Task List (position sorted) ===');

  for (final task in topLevelTasks) {
    logger.i('[${task.id}] ${task.title} (pos: ${task.position})');

    // サブタスクがあれば表示
    final subs = subtasksMap[task.id];
    if (subs != null && subs.isNotEmpty) {
      subs.sort((a, b) => (a.position ?? '').compareTo(b.position ?? ''));
      for (final sub in subs) {
        logger.i('  └─ [${sub.id}] ${sub.title} (pos: ${sub.position})');
      }
    }
  }

  logger.i('=== End of Task List ===');
}
