import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptune/exceptions/api_exeption.dart';
import 'package:ptune/exceptions/task_service_exception.dart';
import 'package:ptune/exceptions/unauthorized_exception.dart';
import 'package:ptune/providers/local_task_service_provider.dart';
import 'package:ptune/providers/remote_task_service_provider.dart';
import 'package:ptune/providers/task_collection.dart';
import 'package:ptune/services/common_task_service.dart';
import 'package:ptune/utils/env_config.dart';
import '../models/my_task.dart';
import '../models/my_task_ext.dart';
import '../services/task_service_interface.dart';
import '../services/demo_task_service.dart';
import '../utils/logger.dart'; // ← 追加

/// TaskService の DI（Provider）
final taskServiceProvider = Provider<TaskServiceInterface>((ref) {
  final isDemo = EnvConfig.isDemo;
  if (isDemo) {
    return DemoTaskService(jsonAssetPath: 'assets/tasks.json');
  }
  logger.i("[Provider] TaskService = ${isDemo ? 'Demo' : 'Production'}");

  final local = ref.watch(localTaskServiceProvider);
  final remote = ref.watch(remoteTaskServiceProvider);

  return CommonTaskService(local: local, remote: remote);
});

/// 選択中タスクの状態（null許容）
final selectedEditTaskProvider = StateProvider<MyTask?>((ref) => null);
final selectedTimerTaskProvider = StateProvider<MyTask?>((ref) => null);

/// Notifier Provider
final tasksProvider =
    StateNotifierProvider<TasksNotifier, AsyncValue<List<MyTask>>>((ref) {
  final service = ref.watch(taskServiceProvider);
  return TasksNotifier(service);
});

/// タスク一覧の管理
class TasksNotifier extends StateNotifier<AsyncValue<List<MyTask>>> {
  final TaskServiceInterface taskService;

  TasksNotifier(this.taskService) : super(const AsyncValue.loading()) {
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    try {
      final tasks = await taskService.fetchTasks();
      state = AsyncValue.data(tasks);
      logger.i("[TaskListNotifier] loaded ${tasks.length} tasks");
    } on ApiException catch (e, st) {
      // ApiExceptionはAsyncErrorに流す
      state = AsyncValue.error(e, st);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateTask(MyTask updated, {bool commit = true}) async {
    final current = state.value ?? [];
    final collection = TaskCollection(current);
    final updatedList = collection.updateTask(updated);
    state = AsyncValue.data(updatedList);

    // commit=false の場合は保存スキップ
    if (commit) {
      await taskService.saveTask(updated);
    }
    logger.d(
        "[TaskListNotifier] updateTask: ${updated.id} → ${updated.title}, commit=$commit");
  }

  Future<void> updateTasks(List<MyTask> tasks) async {
    try {
      state = AsyncValue.data(tasks);
      await taskService.saveTasks(tasks);
      logger.i("[TasksNotifier] updateTasks: ${tasks.length} tasks");
    } on ApiException catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void replaceAll(List<MyTask> tasks) {
    state = AsyncValue.data(tasks);
    logger.i("[TasksNotifier] replaceAll: ${tasks.length} tasks");
  }

  MyTask? findById(String id) {
    final current = state.value ?? [];
    final task = TaskCollection(current).findById(id);
    logger
        .d("[TaskListNotifier] findById: $id → ${task?.title ?? 'not found'}");
    return task;
  }

  Future<void> toggleComplete(String id) async {
    final current = state.value ?? [];
    final index = current.indexWhere((task) => task.id == id);
    if (index == -1) return;

    final task = current[index];
    final updated = task.status == "completed"
        ? task.copyWith(status: "needsAction", completed: null)
        : task.markCompleted();

    logger.i("[TaskListNotifier] toggleComplete: $id → ${updated.status}");

    final updatedList = [...current];
    updatedList[index] = updated;
    state = AsyncValue.data(updatedList);

    try {
      await taskService.saveTask(updated);
    } on ApiException catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

/// UI 側で使うエラーハンドラ
void handleTaskError(BuildContext context, Object error) {
  if (error is ApiException) {
    if (error.notifyUser) {
      String message;
      if (error is UnauthorizedException) {
        message = "認証が切れました。再ログインしてください。";
      } else if (error is NotFoundException) {
        message = "タスクリストが見つかりません。タスクリストを初期化してください。";
      } else if (error is ForbiddenException) {
        message = "アクセス権限がありません。アカウントを確認してください。";
      } else {
        // その他の通知対象エラー
        message = "エラーが発生しました (${error.statusCode}): ${error.message}";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } else {
      // 通知不要（オフライン/サーバ障害など）
      logger.w("Suppressed error: $error");
    }
  } else {
    logger.e("Unexpected error: $error");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("不明なエラーが発生しました。")),
    );
  }
}
