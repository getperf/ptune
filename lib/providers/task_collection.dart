import '../models/my_task.dart';

class TaskCollection {
  final List<MyTask> _tasks;
  final Map<String, MyTask> _taskMap;

  TaskCollection(this._tasks) : _taskMap = {for (var t in _tasks) t.id: t};

  List<MyTask> get all => _tasks;

  MyTask? findById(String id) => _taskMap[id];

  MyTask? findParent(MyTask task) =>
      task.parent != null ? _taskMap[task.parent!] : null;

  List<MyTask> findChildren(String parentId) =>
      _tasks.where((t) => t.parent == parentId).toList();

  List<MyTask> updateTask(MyTask updated) =>
      _tasks.map((t) => t.id == updated.id ? updated : t).toList();
}
