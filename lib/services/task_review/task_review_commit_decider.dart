import 'package:ptune/models/my_task.dart';
import 'package:ptune/providers/task_review/task_review_state.dart';

bool shouldCommitTaskReview({
  required MyTask? completedTask,
  required TaskReviewState review,
}) {
  if (completedTask == null) return false;
  if (completedTask.status != 'completed') return false;
  if (review.selected.isEmpty && review.goal == null) return false;
  return true;
}
