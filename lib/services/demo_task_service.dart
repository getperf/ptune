import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

import '../models/my_task.dart';
import '../providers/task_collection.dart';
import 'task_service_interface.dart';
import '../utils/logger.dart'; // ← logger 追加

class DemoTaskService implements TaskServiceInterface {
  final String jsonAssetPath;
  TaskCollection _collection = TaskCollection([]);

  DemoTaskService({this.jsonAssetPath = 'assets/tasks.json'});

  @override
  Future<List<MyTask>> fetchTasks() async {
    final jsonStr = await rootBundle.loadString(jsonAssetPath);
    final Map<String, dynamic> data = json.decode(jsonStr);

    final tasks = data.values
        .map<MyTask>((json) => MyTask.fromJson(json as Map<String, dynamic>))
        .toList();

    _collection = TaskCollection(tasks);
    logger.i(
      "[DemoTaskService] loaded ${tasks.length} tasks from $jsonAssetPath",
    );
    return _collection.all;
  }

  @override
  Future<void> saveTask(MyTask task) async {
    _collection = TaskCollection(_collection.updateTask(task));
    logger.d("[DemoTaskService] saveTask: ${task.id} → ${task.title}");
    await _saveToFile();
  }

  @override
  Future<void> saveTasks(List<MyTask> tasks) async {
    _collection = TaskCollection(tasks);
    logger.i("[DemoTaskService] saveTasks: ${tasks.length} tasks");
    await _saveToFile();
  }

  @override
  Future<MyTask> addTask(MyTask task) async {
    final id = task.id.isEmpty ? _generateTempId() : task.id;
    final newTask = task.copyWith(id: id);

    final updated = [..._collection.all, newTask];
    _collection = TaskCollection(updated);

    logger.i("[DemoTaskService] addTask: $id → ${newTask.title}");
    await _saveToFile();

    return newTask;
  }

  String _generateTempId() {
    return 'tmp-${DateTime.now().millisecondsSinceEpoch}';
  }

  @override
  Future<void> deleteTask(String taskId) async {
    _collection = TaskCollection(
      _collection.all.where((task) => task.id != taskId).toList(),
    );
    logger.d("[DemoTaskService] deleteTask: $taskId");
    await _saveToFile();
  }

  Future<void> _saveToFile() async {
    final dir = await getApplicationSupportDirectory();
    final file = File('${dir.path}/tasks_demo.json');

    final Map<String, dynamic> jsonMap = {
      for (final task in _collection.all) task.id: task.toJson(),
    };

    await file.writeAsString(json.encode(jsonMap));
    logger.d("[DemoTaskService] saved to ${file.path}");
  }

  @override
  Future<void> moveTask(String taskId,
      {String? parentId, String? previousId}) async {
    throw UnimplementedError();
  }
}
