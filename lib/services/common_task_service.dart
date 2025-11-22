import 'dart:async';

import 'package:ptune/models/my_task.dart';
import 'package:ptune/services/local_task_service.dart';
import 'package:ptune/services/remote_task_service.dart';
import 'package:ptune/services/task_service_interface.dart';
import 'package:ptune/utils/logger.dart';

class UnSyncedTaskLog {
  final Set<String> unsyncedTaskIds = {};

  void markUnsynced(String taskId) {
    unsyncedTaskIds.add(taskId);
  }

  void clear() {
    unsyncedTaskIds.clear();
  }

  bool get hasUnSynced => unsyncedTaskIds.isNotEmpty;
}

class CommonTaskService implements TaskServiceInterface {
  final LocalTaskService local;
  final RemoteTaskService remote;
  final UnSyncedTaskLog unsyncedLog = UnSyncedTaskLog();
  bool _nextFetchForceRemote = false;

  CommonTaskService({required this.local, required this.remote});

  void forceRemoteNextFetch() {
    _nextFetchForceRemote = true;
  }

  @override
  Future<List<MyTask>> fetchTasks() async {
    if (!_nextFetchForceRemote) {
      final localTasks = await local.fetchTasks();
      if (localTasks.isNotEmpty) return localTasks;
    }

    _nextFetchForceRemote = false;

    try {
      final remoteTasks = await remote.fetchTasks();
      await local.saveTasks(remoteTasks);
      return remoteTasks;
    } catch (e) {
      logger.w('[CommonTaskService] remote fetch failed: $e');
      return [];
    }
  }

  @override
  Future<void> saveTasks(List<MyTask> tasks) async {
    // 1. まずはローカルに全件保存（従来通り）
    await local.saveTasks(tasks);
    logger.i('[CommonTaskService] local saveTasks: ${tasks.length} tasks');

    // 2. リモートに送る対象を絞り込む
    //    - 完了タスクは Google Tasks 側で更新制限に引っかかりやすいので除外
    final List<MyTask> remoteTargets =
        tasks.where((t) => t.status != 'completed').toList(growable: false);

    if (remoteTargets.isEmpty) {
      logger.i(
        '[CommonTaskService] skip remote saveTasks: no updatable tasks (all completed)',
      );
      return;
    }

    logger.i(
      '[CommonTaskService] remote saveTasks: '
      '${remoteTargets.length}/${tasks.length} tasks (skip completed)',
    );

    // 3. リモートは非同期実行（従来通り）＋失敗時は unsynced に記録
    unawaited(remote.saveTasks(remoteTargets).catchError((e) {
      logger.w('[CommonTaskService] remote saveTasks failed: $e');
      for (final task in remoteTargets) {
        unsyncedLog.markUnsynced(task.id);
      }
    }));
  }

  @override
  Future<void> saveTask(MyTask task) async {
    await local.saveTask(task);
    logger.i('[CommonTaskService] local saveTask: ${task.id}');

    unawaited(remote.saveTask(task).catchError((e) {
      logger.w('[CommonTaskService] remote saveTask failed: $e');
      unsyncedLog.markUnsynced(task.id);
    }));
  }

  @override
  Future<MyTask> addTask(MyTask task) async {
    final localTask = await local.addTask(task);

    try {
      final remoteTask = await remote.createTask(localTask);
      if (remoteTask.id != localTask.id) {
        await local.updateTaskId(localTask.id, remoteTask.id);
      }
      return remoteTask;
    } catch (e) {
      logger.w('[CommonTaskService] Remote add failed: $e');
      unsyncedLog.markUnsynced(localTask.id);
      return localTask;
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    await local.deleteTask(id);
    logger.i('[CommonTaskService] local deleteTask: $id');

    unawaited(remote.deleteTask(id).catchError((e) {
      logger.w('[CommonTaskService] remote deleteTask failed: $e');
      unsyncedLog.markUnsynced(id);
    }));
  }

  @override
  Future<void> moveTask(
    String taskId, {
    String? parentId,
    String? previousId,
  }) async {
    await remote.moveTask(
      taskId,
      parent: parentId,
      previous: previousId,
    );
  }

  Future<void> flushUnsynced() async {
    final tasksList = await local.fetchTasks();
    final tasks = {for (var t in tasksList) t.id: t};
    for (final id in unsyncedLog.unsyncedTaskIds) {
      final task = tasks[id];
      if (task != null) {
        try {
          await remote.saveTask(task);
        } catch (e) {
          logger.w('[flushUnsynced] failed for $id: $e');
        }
      }
    }
    unsyncedLog.clear();
  }

  bool hasUnSyncedLogs() => unsyncedLog.hasUnSynced;

  void resetUnsyncedLog() {
    unsyncedLog.clear();
  }
}
