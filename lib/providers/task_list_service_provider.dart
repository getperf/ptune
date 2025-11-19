import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptune/providers/google_auth_client_provider.dart';
import 'package:ptune/services/common_task_list_service.dart';
import 'package:ptune/services/local_task_list_service.dart';
import 'package:ptune/services/remote_task_list_service.dart';
import 'package:ptune/services/task_list_service_interface.dart';
import 'package:ptune/services/demo_task_list_service.dart';
import 'package:ptune/utils/env_config.dart';
// import 'package:ptune/services/production_task_list_service.dart';

final localTaskListServiceProvider = Provider((ref) => LocalTaskListService());

final taskListServiceProvider = Provider<TaskListServiceInterface>((ref) {
  final isDemo = EnvConfig.isDemo;
  if (isDemo) {
    return DemoTaskListService(jsonAssetPath: 'assets/tasklists.json');
  } else {
    final authClient = ref.watch(googleAuthClientProvider);
    final remote = RemoteTaskListService(authClient);
    final local = ref.watch(localTaskListServiceProvider);
    return CommonTaskListService(local: local, remote: remote);
    // final authClient = ref.watch(googleAuthClientProvider);
    // return ProductionTaskListService(authClient);
  }
});
