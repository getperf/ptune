// lib/providers/task_review/task_review_state.dart
import 'package:ptune/models/review_flag.dart';

class TaskReviewState {
  final Set<ReviewFlag> selected;

  const TaskReviewState({required this.selected});

  factory TaskReviewState.initial() {
    return const TaskReviewState(selected: {});
  }

  TaskReviewState copyWith({Set<ReviewFlag>? selected}) {
    return TaskReviewState(selected: selected ?? this.selected);
  }

  @override
  String toString() {
    return 'TaskReviewState(selected=$selected)';
  }
}
