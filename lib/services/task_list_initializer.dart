import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptune/models/my_task_list.dart';
import 'package:ptune/providers/task_list_provider.dart';
import 'package:ptune/services/task_list_service_interface.dart';
import 'package:ptune/utils/logger.dart'; // ✅ ロガー追加

const defaultTaskListTitle = 'Today';

class TaskListInitializer {
  final Ref ref;
  final TaskListServiceInterface service;

  TaskListInitializer(this.ref, this.service);

  Future<void> clearCache() async {
    await service.clearCache();
  }

  /// Todayリストが存在する場合、それを選択する
  Future<bool> checkAndSelectToday() async {
    logger.d('[TasklistInitializer] Fetching tasklists...');
    final lists = await service.fetchTaskLists();

    final map = {for (final list in lists) list.id: list};
    ref.read(taskListsProvider.notifier).setAll(map);
    logger.i(
      '[TasklistInitializer] ${lists.length} tasklists fetched and registered',
    );

    final today = lists.firstWhereOrNull(
      (l) => l.title == defaultTaskListTitle,
    );
    if (today != null) {
      ref.read(selectedTaskListProvider.notifier).state = today;
      logger.i('[TasklistInitializer] Selected Today tasklist: id=${today.id}');
      return true;
    } else {
      logger.w('[TasklistInitializer] Today tasklist not found');
      return false;
    }
  }

  /// Todayリストを新規作成し、選択状態にする
  Future<MyTaskList> createTodayTasklist() async {
    logger.d('[TasklistInitializer] Creating Today tasklist...');
    final list = await service.createTaskList("Today");

    ref.read(taskListsProvider.notifier).add(list);
    ref.read(selectedTaskListProvider.notifier).state = list;

    logger.i(
      '[TasklistInitializer] Created and selected Today tasklist: id=${list.id}',
    );
    return list;
  }
}
