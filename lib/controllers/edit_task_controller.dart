import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptune/models/pomodoro_info.dart';
import '../models/my_task.dart';
import '../models/my_task_ext.dart';
import '../providers/task_provider.dart';
import '../utils/logger.dart';

class EditTaskController {
  final WidgetRef ref;
  String? _tempTitle;
  int? _tempPlanned;

  EditTaskController(this.ref);

  MyTask? get selectedTask => ref.read(selectedEditTaskProvider);

  void setTempTitle(String newTitle) {
    _tempTitle = newTitle;
  }

  Future<void> saveAll({required String title, required int planned}) async {
    final task = selectedTask;
    if (task == null) return;

    final pomodoro = (task.pomodoro ?? PomodoroInfo(planned: 0, actual: 0))
        .copyWith(planned: planned);
    final updated = task.copyWith(
      title: title,
      pomodoro: pomodoro,
    );

    await _updateTask(updated);

    logger.i("[EditTaskController] saveAll: $title, 🍅x$planned");
  }

  Future<void> saveTitle() async {
    final task = selectedTask;
    if (task == null || _tempTitle == null) return;

    final updated = task.copyWith(title: _tempTitle!.trim());
    await _updateTask(updated);
    _tempTitle = null;
    logger.i("[EditTaskController] title saved: ${updated.title}");
  }

  void updateCompleted(bool isCompleted) {
    final task = selectedTask;
    if (task == null) {
      logger.w(
        "[EditTaskController] updateCompleted() called but no task selected",
      );
      return;
    }

    final updated = isCompleted ? task.markCompleted() : task.markUncompleted();
    _updateTask(updated);
    logger.i(
      "[EditTaskController] task ${updated.id} marked as ${isCompleted ? 'completed' : 'not completed'}",
    );
  }

  void setTempPlanned(int value) {
    _tempPlanned = value;
  }

  int? getTempPlanned() {
    return _tempPlanned;
  }

  Future<void> savePlanned(int planned) async {
    final task = selectedTask;
    if (task == null) return;

    final updatedPomodoro =
        (task.pomodoro ?? PomodoroInfo(planned: 0, actual: 0))
            .copyWith(planned: planned);
    final updated = task.copyWith(pomodoro: updatedPomodoro);
    await _updateTask(updated);

    logger.i("[EditTaskController] planned saved: $planned");
  }

  Future<void> _updateTask(MyTask updated) async {
    final tasksNotifier = ref.read(tasksProvider.notifier);
    // final editTaskNotifier = ref.read(selectedEditTaskProvider.notifier);

    await tasksNotifier.updateTask(updated);

    logger.d("[EditTaskController] task ${updated.id} updated");
  }

  void dispose() {
    logger.d("[EditTaskController] debounce timer disposed");
  }
}
