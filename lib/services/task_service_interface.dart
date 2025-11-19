import '../models/my_task.dart';

abstract class TaskServiceInterface {
  Future<List<MyTask>> fetchTasks();
  Future<void> saveTasks(List<MyTask> tasks);
  Future<void> saveTask(MyTask task);
  Future<MyTask> addTask(MyTask task);
  Future<void> deleteTask(String id);
  Future<void> moveTask(
    String taskId, {
    String? parentId,
    String? previousId,
  });
}
