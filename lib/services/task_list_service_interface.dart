import 'package:ptune/models/my_task_list.dart';

abstract class TaskListServiceInterface {
  Future<List<MyTaskList>> fetchTaskLists();
  Future<MyTaskList> createTaskList(String title);
  Future<void> deleteTaskList(String id);
  Future<void> saveTaskLists(List<MyTaskList> lists);
  Future<List<MyTaskList>> loadTaskLists();
  Future<void> clearCache();
}
