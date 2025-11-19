import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptune/providers/local_task_service_provider.dart';
import 'package:ptune/providers/remote_task_service_provider.dart';
import 'package:ptune/services/task_importer.dart';

final taskImporterProvider = Provider<TaskImporter>((ref) {
  final local = ref.watch(localTaskServiceProvider);
  final remote = ref.watch(remoteTaskServiceProvider);
  return TaskImporter(remote, local);
});
