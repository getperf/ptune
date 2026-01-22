// lib/providers/task_review/task_review_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'task_review_notifier.dart';
import 'task_review_state.dart';

final taskReviewProvider =
    StateNotifierProvider<TaskReviewNotifier, TaskReviewState>(
      (ref) => TaskReviewNotifier(),
    );
