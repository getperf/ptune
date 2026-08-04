import 'package:flutter_test/flutter_test.dart';
import 'package:ptune/models/my_task.dart';
import 'package:ptune/services/task_order_service.dart';
import 'package:ptune/utils/logger.dart';

void main() {
  setUpAll(initLoggerForTest);

  test('normalizeForUi keeps a child whose parent is absent', () {
    final tasks = [
      const MyTask(id: 'root', title: 'root', position: '02'),
      const MyTask(
        id: 'orphan',
        title: 'orphan',
        parent: 'missing-parent',
        position: '01',
      ),
    ];

    final normalized = TaskOrderService.normalizeForUi(tasks);

    expect(normalized.map((task) => task.id), ['orphan', 'root']);
  });
}
