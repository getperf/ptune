import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptune/services/task_list_initializer.dart';
import 'package:ptune/providers/task_list_service_provider.dart';

final taskListInitializerProvider = Provider<TaskListInitializer>((ref) {
  final service = ref.watch(taskListServiceProvider);
  return TaskListInitializer(ref, service);
});
