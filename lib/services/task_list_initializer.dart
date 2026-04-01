import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptune/models/my_task_list.dart';
import 'package:ptune/providers/task_list_provider.dart';
import 'package:ptune/services/task_list_service_interface.dart';
import 'package:ptune/utils/logger.dart';
import 'package:ptune/utils/env_config.dart';

class TaskListInitializer {
  final Ref ref;
  final TaskListServiceInterface service;

  TaskListInitializer(this.ref, this.service);

  Future<void> clearCache() async {
    await service.clearCache();
  }

  Future<bool> checkAndSelectConfiguredTasklist() async {
    logger.d('[TasklistInitializer] Fetching tasklists...');
    final lists = await service.fetchTaskLists();

    final map = {for (final list in lists) list.id: list};
    ref.read(taskListsProvider.notifier).setAll(map);

    final today = lists.firstWhereOrNull(
      (l) => l.title == EnvConfig.taskListTitle,
    );

    if (today != null) {
      ref.read(selectedTaskListProvider.notifier).state = today;
      return true;
    }

    return false;
  }

  Future<MyTaskList> createConfiguredTasklist() async {
    final list = await service.createTaskList(EnvConfig.taskListTitle);

    ref.read(taskListsProvider.notifier).add(list);
    ref.read(selectedTaskListProvider.notifier).state = list;

    return list;
  }
}
