import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ptune/models/my_task.dart';
import 'package:ptune/models/pomodoro_info.dart';
import 'package:ptune/models/timer_phase.dart';
import 'package:ptune/providers/is_online_provider.dart';
import 'package:ptune/providers/task_factory_provider.dart';
import 'package:ptune/providers/task_list_provider.dart';
import 'package:ptune/providers/timer_controller_provider.dart';
import 'package:ptune/services/common_task_service.dart';
import 'package:ptune/states/timer_phase_state.dart';
import 'package:ptune/utils/print_tasks.dart';
import 'package:ptune/utils/task_hierarchy.dart';
import 'package:ptune/views/edit_task_view.dart';
import 'package:ptune/providers/task_provider.dart';
import 'package:ptune/utils/logger.dart';

final isFormVisibleProvider = StateProvider<bool>((ref) => false);

class HomeController {
  final Ref ref;
  final BuildContext context;

  HomeController(this.ref, this.context);

  Future<bool> toggleTaskForm() async {
    final isOnline = await ref.read(isOnlineProvider.future);
    if (!isOnline) return false;
    final current = ref.read(isFormVisibleProvider);
    ref.read(isFormVisibleProvider.notifier).state = !current;
    logger.d("[HomeController] toggleTaskForm: ${!current}");
    return true;
  }

  void closeTaskForm() {
    ref.read(isFormVisibleProvider.notifier).state = false;
    logger.d("[HomeController] closeTaskForm");
  }

  void toggleTask(String id) {
    final notifier = ref.read(tasksProvider.notifier);
    notifier.toggleComplete(id);
    logger.i("[HomeController] toggleTask: $id");
  }

  void onTaskTapped(MyTask task) {
    ref.read(selectedEditTaskProvider.notifier).state = task;
    logger.i("[HomeController] onTaskTapped: ${task.id} (${task.title})");

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EditTaskView()),
    );
  }

  void startTimer(MyTask task) {
    // 1. 切替対象タスクを明示
    ref.read(selectedTimerTaskProvider.notifier).state = task;
    logger.i("[HomeController] startTimer: ${task.id} (${task.title})");

    // 2. 現在のフェーズで分岐
    final phase = ref.read(timerPhaseProvider);

    if (phase == TimerPhase.paused || phase == TimerPhase.running) {
      logger.i("[HomeController] switchTask");
      ref.read(timerControllerProvider).switchTask();
    } else {
      ref.read(timerPhaseProvider.notifier).state = TimerPhase.ready;
      ref.read(timerControllerProvider).start();
    }

    // 3. タイマー画面へ遷移
    context.push('/timer');
  }

  int _extractPlanned(String label) {
    final match = RegExp(r'🍅x(\d+)').firstMatch(label);
    return match != null ? int.parse(match.group(1)!) : 0;
  }

  Future<void> submitTask(String title, String label) async {
    final list = ref.read(selectedTaskListProvider);
    if (list == null || list.id.isEmpty) {
      _notifyUser('タスクリストが未選択です');
      return;
    }

    final planned = _extractPlanned(label);
    final isBlocked = label.contains('🚫');
    final finalTitle = isBlocked ? '$title🚫' : title;

    final task = MyTask(
      id: '',
      title: finalTitle,
      tasklistId: list.id,
      status: 'needsAction',
      pomodoro: PomodoroInfo(planned: planned),
    );

    final taskService = ref.read(taskServiceProvider);
    final asyncTasks = ref.read(tasksProvider);
    final tasks = asyncTasks.value ?? [];

    try {
      // ① 追加位置を決定
      final plan = planInsertLast(tasks);

      // ② create（position は null）
      final newTask = await taskService.addTask(task);

      // ③ ★必須★ move で position を確定
      await moveTaskApi(
        newTask.id,
        parentId: plan.parent,
        previousId: plan.previousId,
      );

      ref.invalidate(tasksProvider);
    } catch (e, st) {
      logger.e('[HomeController] submitTask failed', error: e, stackTrace: st);
      if (context.mounted) handleTaskError(context, e);
    }
  }

  Future<void> deleteCompletedTasks() async {
    final asyncTasks = ref.read(tasksProvider);
    final tasks = asyncTasks.value ?? [];
    final completed = tasks.where((t) => t.status == 'completed');
    final taskService = ref.read(taskServiceProvider);

    try {
      for (final task in completed) {
        await taskService.deleteTask(task.id);
      }
      ref.invalidate(tasksProvider);
      logger.i("[HomeController] deleteCompletedTasks");
    } catch (e, st) {
      logger.e(
        '[HomeController] deleteCompletedTasks failed',
        error: e,
        stackTrace: st,
      );
      if (context.mounted) handleTaskError(context, e);
    }
  }

  Future<void> moveTask(MyTask task, MyTask? previous, bool asChild) async {
    final asyncTasks = ref.read(tasksProvider);
    final tasks = asyncTasks.value ?? [];

    logger.i(
      "[moveTask] move ${task.id}, previous: ${previous?.id}, asChild: $asChild",
    );

    final plan = planMove(tasks, task, previous, asChild);

    if (plan.kind == MovePlanKind.error) {
      _notifyUser(plan.reason);
      return;
    }

    try {
      await moveTaskApi(
        task.id,
        previousId: plan.previousId,
        parentId: plan.parent,
      );
      printTasks(tasks);
    } catch (e, st) {
      logger.e('[HomeController] moveTask failed', error: e, stackTrace: st);
      if (context.mounted) handleTaskError(context, e);
    }
  }

  Future<void> moveTaskApi(
    String taskId, {
    required String? parentId,
    required String? previousId,
  }) async {
    final taskService = ref.read(taskServiceProvider);
    try {
      await taskService.moveTask(
        taskId,
        parentId: parentId,
        previousId: previousId,
      );
      if (taskService is CommonTaskService) {
        taskService.forceRemoteNextFetch();
      }
      ref.invalidate(tasksProvider);
    } catch (e, st) {
      logger.e('[HomeController] moveTaskApi failed', error: e, stackTrace: st);
      if (context.mounted) handleTaskError(context, e);
    }
  }

  Future<void> toggleSubtask(MyTask task) async {
    final asyncTasks = ref.read(tasksProvider);
    final tasks = asyncTasks.value ?? [];

    final plan = planToggleMove(tasks, task);

    if (plan.kind == MovePlanKind.error) {
      _notifyUser(plan.reason);
      return;
    }

    try {
      await moveTaskApi(
        task.id,
        parentId: plan.parent,
        previousId: plan.previousId,
      );
      printTasks(tasks);
    } catch (e, st) {
      logger.e(
        '[HomeController] toggleSubtask failed',
        error: e,
        stackTrace: st,
      );
      if (context.mounted) handleTaskError(context, e);
    }
  }

  void _notifyUser(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }
}
