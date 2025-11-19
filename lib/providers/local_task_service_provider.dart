import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptune/services/local_task_service.dart';

final localTaskServiceProvider = Provider<LocalTaskService>((ref) {
  return LocalTaskService();
});
