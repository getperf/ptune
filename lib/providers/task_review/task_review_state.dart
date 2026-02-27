import 'package:ptune/models/review_flag.dart';

class TaskReviewState {
  final Set<ReviewFlag> selected;
  final String? goal;

  const TaskReviewState({required this.selected, this.goal});

  factory TaskReviewState.initial() {
    return const TaskReviewState(selected: {}, goal: null);
  }

  TaskReviewState copyWith({Set<ReviewFlag>? selected, String? goal}) {
    return TaskReviewState(
      selected: selected ?? this.selected,
      goal: goal ?? this.goal,
    );
  }

  @override
  String toString() {
    return 'TaskReviewState(selected=$selected, goal=$goal)';
  }
}
