import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptune/providers/local_task_service_provider.dart';
import 'package:ptune/providers/remote_task_service_provider.dart';
import 'package:ptune/services/task_exporter.dart';

final taskExporterProvider = Provider<TaskExporter>((ref) {
  final local = ref.watch(localTaskServiceProvider);
  final remote = ref.watch(remoteTaskServiceProvider);
  return TaskExporter(remote, local);
});
