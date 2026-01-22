// lib/providers/task_review/task_review_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptune/models/my_task.dart';
import 'package:ptune/models/review_flag.dart';

import 'task_review_state.dart';

class TaskReviewNotifier extends StateNotifier<TaskReviewState> {
  TaskReviewNotifier() : super(TaskReviewState.initial());

  void toggle(ReviewFlag flag) {
    final next = Set<ReviewFlag>.from(state.selected);
    if (!next.add(flag)) {
      next.remove(flag);
    }
    state = state.copyWith(selected: next);
  }

  void clear() {
    state = TaskReviewState.initial();
  }

  /// タスク完了時にレビュー結果を反映
  MyTask applyTo(MyTask task) {
    return task.copyWith(reviewFlags: state.selected.toList());
  }
}
