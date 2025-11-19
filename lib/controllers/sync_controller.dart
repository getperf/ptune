import 'dart:io';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ptune/controllers/timer_controller.dart';
import 'package:ptune/exceptions/api_exeption.dart';
import 'package:ptune/providers/pomodoro_scheduler_provider.dart';
import 'package:ptune/providers/remote_task_list_service_provider.dart';
import 'package:ptune/providers/task_export_provider.dart';
import 'package:ptune/providers/task_importer_provider.dart';
import 'package:ptune/providers/task_list_check_provider.dart';
import 'package:ptune/providers/task_list_provider.dart';
import 'package:ptune/providers/task_list_service_provider.dart';
import 'package:ptune/providers/task_provider.dart';
import 'package:ptune/routes/app_router.dart';
import 'package:ptune/services/common_task_service.dart';
import 'package:ptune/services/local_task_list_service.dart';
import 'package:ptune/services/remote_task_list_service.dart';
import 'package:ptune/services/task_exporter.dart';
import 'package:ptune/services/task_importer.dart';
import 'package:ptune/services/task_list_initializer.dart';
import 'package:ptune/utils/logger.dart';
// handleTaskError

final syncControllerProvider = ChangeNotifierProvider<SyncController>((ref) {
  final remote = ref.watch(remoteTaskListServiceProvider);
  final local = ref.watch(localTaskListServiceProvider);
  final taskImporter = ref.watch(taskImporterProvider);
  final taskExporter = ref.watch(taskExporterProvider);
  return SyncController(
    ref: ref,
    remote: remote,
    local: local,
    taskImporter: taskImporter,
    taskExporter: taskExporter,
  );
});

class SyncController extends ChangeNotifier {
  final RemoteTaskListService remote;
  final LocalTaskListService local;
  final TaskImporter taskImporter;
  final TaskExporter taskExporter;
  final Ref ref;

  bool isLoadingInit = false;
  bool isLoadingImport = false;
  bool isLoadingExport = false;

  SyncController({
    required this.ref,
    required this.remote,
    required this.local,
    required this.taskImporter,
    required this.taskExporter,
  });

  Future<void> initializeToday(BuildContext context) async {
    await _withLoading(context, () async {
      await local.clearCache();
      final lists = await remote.fetchTaskLists();
      final today =
          lists.firstWhereOrNull((l) => l.title == defaultTaskListTitle) ??
              await remote.createTaskList(defaultTaskListTitle);

      ref
          .read(taskListsProvider.notifier)
          .setAll({for (final l in lists) l.id: l});
      ref.read(selectedTaskListProvider.notifier).state = today;
      await ref.read(taskListCheckProvider.notifier).check();

      logger.i('[SyncController] Today tasklist ensured: id=${today.id}');

      if (context.mounted) context.go(RoutePaths.home);
    }, loadingSetter: (v) => isLoadingInit = v);
  }

  Future<void> importTasks(BuildContext context) async {
    await _withLoading(context, () async {
      final tasks = await taskImporter.importTasks();
      ref.read(tasksProvider.notifier).replaceAll(tasks);

      // --- 追加: インポート完了後にタイマー状態をリセット ---
      final scheduler = ref.read(pomodoroSchedulerProvider);
      final timerController = TimerController(ref, scheduler);
      await timerController.resetTimerState();
      logger.i("[SyncController] import completed → timer reset done");

      if (context.mounted) context.go(RoutePaths.home);
    }, loadingSetter: (v) => isLoadingImport = v);
  }

  Future<void> exportTasks(BuildContext context) async {
    await _withLoading(context, () async {
      await taskExporter.exportTasks();
      final taskService = ref.read(taskServiceProvider);
      if (taskService is CommonTaskService) {
        taskService.resetUnsyncedLog();
      }
      if (context.mounted) context.go(RoutePaths.home);
    }, loadingSetter: (v) => isLoadingExport = v);
  }

  Future<void> _withLoading(
    BuildContext context,
    Future<void> Function() action, {
    required void Function(bool) loadingSetter,
  }) async {
    try {
      loadingSetter(true);
      notifyListeners();
      await action();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("完了しました")),
        );
      }
    } on ApiException catch (e) {
      logger.w("[SyncController] ApiException: $e");
      if (context.mounted) {
        // ApiException 系は handleTaskError で日本語通知
        handleTaskError(context, e);
      }
    } on SocketException catch (_) {
      logger.w("[SyncController] Network error (offline)");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("ネットワークに接続できません")),
        );
      }
    } catch (e, stack) {
      logger.e("[SyncController] Unexpected error: $e");
      logger.d(stack.toString());
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("サーバーエラーが発生しました")),
        );
      }
    } finally {
      loadingSetter(false);
      notifyListeners();
    }
  }
}
