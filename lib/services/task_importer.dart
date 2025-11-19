import 'package:ptune/models/my_task.dart';
import 'package:ptune/services/local_task_service.dart';
import 'package:ptune/services/remote_task_service.dart';

class TaskImporter {
  final RemoteTaskService remoteService;
  final LocalTaskService localService;

  TaskImporter(this.remoteService, this.localService);

  Future<List<MyTask>> importTasks() async {
    final tasks = await remoteService.fetchTasks();
    await localService.saveTasks(tasks);
    return tasks;
  }
}
