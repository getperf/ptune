import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ptune/models/review_flag.dart';
import 'package:ptune/providers/task_review/task_review_provider.dart';

void main() {
  group('TaskReviewNotifier.ensureSelected', () {
    test('adds a flag without toggling an existing selection off', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(taskReviewProvider('task-a').notifier);

      notifier.ensureSelected(ReviewFlag.operationMiss);
      notifier.ensureSelected(ReviewFlag.operationMiss);

      expect(container.read(taskReviewProvider('task-a')).selected, {
        ReviewFlag.operationMiss,
      });
    });
  });
}
