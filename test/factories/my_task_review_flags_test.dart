import 'package:flutter_test/flutter_test.dart';
import 'package:ptune/models/my_task.dart';
import 'package:ptune/models/review_flag.dart';
import 'package:ptune/utils/logger.dart';

void main() {
  setUpAll(() {
    initLoggerForTest();
  });

  test('MyTask holds reviewFlags', () {
    final task = MyTask(
      id: '1',
      title: 'Test',
      reviewFlags: [ReviewFlag.scopeExpanded, ReviewFlag.unresolved],
    );

    expect(task.reviewFlags.length, 2);
    expect(task.reviewFlags.contains(ReviewFlag.unresolved), true);
  });
}
