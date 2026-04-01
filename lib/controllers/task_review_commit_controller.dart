import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptune/models/my_task.dart';
import 'package:ptune/providers/task_review/task_review_provider.dart';
import 'package:ptune/providers/task_review/task_review_state.dart';
import 'package:ptune/providers/timer_completed_task_provider.dart';
import 'package:ptune/providers/task_provider.dart';
import 'package:ptune/services/task_review/task_review_commit_decider.dart';
import 'package:ptune/utils/logger.dart';

class TaskReviewCommitController {
  final WidgetRef ref;
  bool _committing = false;

  TaskReviewCommitController(this.ref);

  /// Home に戻る直前に必ず呼ぶ
  Future<void> onExitToHome() async {
    if (_committing) return;
    _committing = true;

    try {
      final completedTask = ref.read(completedTimerTaskProvider);
      if (completedTask == null) return;

      final taskId = completedTask.id;
      final reviewState = ref.read(taskReviewProvider(taskId));

      if (!shouldCommitTaskReview(
        completedTask: completedTask,
        review: reviewState,
      )) {
        logger.i('[TaskReviewCommit] skip commit');
        _clearStates(completedTask);
        return;
      }

      final updated = _applyReview(completedTask, reviewState);

      await ref.read(tasksProvider.notifier).updateTask(updated, commit: true);

      logger.i('[TaskReviewCommit] committed review flags + goal');

      _clearStates(completedTask);
    } catch (e, st) {
      logger.e('[TaskReviewCommit] commit failed: $e, $st');
    } finally {
      _committing = false;
    }
  }

  MyTask _applyReview(MyTask task, TaskReviewState reviewState) {
    return task.copyWith(
      reviewFlags: reviewState.selected.toList(),
      goal: reviewState.goal,
    );
  }

  void _clearStates(MyTask completedTask) {
    ref.read(taskReviewProvider(completedTask.id).notifier).clear();
    ref.read(completedTimerTaskProvider.notifier).state = null;
  }
}
