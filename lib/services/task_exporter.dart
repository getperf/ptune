import 'package:ptune/models/my_task.dart';
import 'package:ptune/services/local_task_service.dart';
import 'package:ptune/services/remote_task_service.dart';
import 'package:ptune/utils/logger.dart';

class TaskExporter {
  final RemoteTaskService remoteService;
  final LocalTaskService localService;

  TaskExporter(this.remoteService, this.localService);

  Future<void> exportTasks() async {
    final localTasks = await localService.fetchTasks();
    final remoteTasks = await remoteService.fetchTasks();

    await _syncTasks(localTasks, remoteTasks);
    _logRemoteOnlyTasks(localTasks, remoteTasks);
  }

  Future<void> _syncTasks(
    List<MyTask> localTasks,
    List<MyTask> remoteTasks,
  ) async {
    final localTasks = await localService.fetchTasks();
    final remoteTasks = await remoteService.fetchTasks();
    final remoteMap = {for (var t in remoteTasks) t.id: t};

    int created = 0;
    int updated = 0;

    for (final task in localTasks) {
      try {
        if (task.id.isNotEmpty && remoteMap.containsKey(task.id)) {
          await remoteService.saveTask(task);
          logger.i('[TaskExporter] Updated: ${task.title}');
          updated++;
        } else {
          final netTask = await remoteService.createTask(task);
          logger.i('[TaskExporter] Created: ${netTask.title}');
          created++;
        }
      } catch (e, stack) {
        logger.e("[TaskExporter] Failed to export task: ${task.title}");
        logger.d(stack.toString());
      }
    }

    logger.i(
      "[TaskExporter] Export completed: $created created, $updated updated",
    );
  }

  void _logRemoteOnlyTasks(List<MyTask> localTasks, List<MyTask> remoteTasks) {
    final localIds = localTasks.map((t) => t.id).toSet();
    for (final task in remoteTasks) {
      if (!localIds.contains(task.id)) {
        logger.w(
          "[TaskExporter] Orphan remote task (not in local): ${task.title}",
        );
      }
    }
  }
}
