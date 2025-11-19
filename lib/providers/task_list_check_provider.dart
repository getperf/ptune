import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptune/providers/task_list_service_provider.dart';
import 'package:ptune/services/task_list_initializer.dart';
import 'package:ptune/utils/logger.dart';

final taskListCheckProvider =
    NotifierProvider<TaskListCheckNotifier, AsyncValue<bool>>(
        TaskListCheckNotifier.new);

class TaskListCheckNotifier extends Notifier<AsyncValue<bool>> {
  @override
  AsyncValue<bool> build() {
    _init();
    return const AsyncValue.loading(); // 初期状態
  }

  void _init() {
    Future.microtask(() => check());
  }

  Future<void> check() async {
    logger.d('[TaskListCheckNotifier] check() called');
    try {
      final service = ref.read(taskListServiceProvider);
      final initializer = TaskListInitializer(ref, service);
      final result = await initializer.checkAndSelectToday();
      logger.d('[TaskListCheckNotifier] result: $result');
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
