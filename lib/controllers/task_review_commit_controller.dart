import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptune/models/my_task.dart';
import 'package:ptune/providers/task_review/task_review_provider.dart';
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
      final reviewState = ref.read(taskReviewProvider);

      if (!shouldCommitTaskReview(
        completedTask: completedTask,
        review: reviewState,
      )) {
        logger.i('[TaskReviewCommit] skip commit');
        _clearStates();
        return;
      }

      // レビューをタスクに反映
      final updated = _applyReview(completedTask!, reviewState);

      // Remote 保存（commit=true）
      await ref.read(tasksProvider.notifier).updateTask(updated, commit: true);

      logger.i('[TaskReviewCommit] committed review flags');

      _clearStates();
    } catch (e, st) {
      // 失敗時は状態を保持（再度 Home 戻りで再試行可）
      logger.e('[TaskReviewCommit] signIn failed: $e, $st');
    } finally {
      _committing = false;
    }
  }

  MyTask _applyReview(MyTask task, reviewState) {
    return task.copyWith(reviewFlags: reviewState.selected.toList());
  }

  void _clearStates() {
    ref.read(taskReviewProvider.notifier).clear();
    ref.read(completedTimerTaskProvider.notifier).state = null;
  }
}
