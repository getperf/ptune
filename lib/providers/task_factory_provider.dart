import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptune/factories/task_factory.dart';

final taskFactoryProvider = Provider<TaskFactory>((ref) {
  return TaskFactory();
});
