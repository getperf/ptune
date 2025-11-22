import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/my_task.dart';
import '../services/task_service_interface.dart';
import '../utils/logger.dart';

class LocalTaskService implements TaskServiceInterface {
  static final LocalTaskService _instance = LocalTaskService._internal();
  factory LocalTaskService() => _instance;

  LocalTaskService._internal();

  final Map<String, MyTask> _taskMap = {};
  bool _loaded = false;
  late File _file;

  Future<void> _ensureInitialized() async {
    if (_loaded) return;

    final dir = await getApplicationSupportDirectory();
    _file = File('${dir.path}/tasks.json');

    if (!_file.existsSync()) {
      await _file.writeAsString(json.encode({}));
    }

    final content = await _file.readAsString();
    final raw = json.decode(content) as Map<String, dynamic>;
    raw.forEach((key, value) {
      _taskMap[key] = MyTask.fromJson(value);
    });

    _loaded = true;
    logger.i(
      "[LocalTaskService] loaded ${_taskMap.length} tasks from ${_file.path}",
    );
  }

  @override
  Future<List<MyTask>> fetchTasks() async {
    await _ensureInitialized();
    return _taskMap.values.toList();
  }

  @override
  Future<void> saveTasks(List<MyTask> tasks) async {
    await _ensureInitialized();
    _taskMap.clear();
    for (final t in tasks) {
      _taskMap[t.id] = t;
    }
    await _saveToFile();
  }

  @override
  Future<void> saveTask(MyTask task) async {
    await _ensureInitialized();
    _taskMap[task.id] = task;
    await _saveToFile();
  }

  @override
  Future<MyTask> addTask(MyTask task) async {
    final id = (task.id.isNotEmpty) ? task.id : _generateTempId();
    logger.i("[DEBUG] $id");
    final newTask = task.copyWith(id: id);
    await saveTask(newTask);
    return newTask;
  }

  String _generateTempId() {
    return 'tmp-${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<void> updateTaskId(String oldId, String newId) async {
    if (oldId == newId) return;
    final task = _taskMap.remove(oldId);
    if (task == null) {
      logger.w('[LocalTaskService] タスクが見つかりません: $oldId');
      return;
    }
    final newTask = task.copyWith(id: newId);
    await saveTask(newTask);
  }

  @override
  Future<void> deleteTask(String id) async {
    await _ensureInitialized();
    _taskMap.remove(id);
    await _saveToFile();
  }

  void reload() {
    _loaded = false;
  }

  Future<void> _saveToFile() async {
    final data = {for (final t in _taskMap.values) t.id: t.toJson()};
    await _file.writeAsString(json.encode(data));
    logger.i(
      "[LocalTaskService] saved ${_taskMap.length} tasks to ${_file.path}",
    );
  }

  @override
  Future<void> moveTask(String taskId,
      {String? parentId, String? previousId}) async {
    logger.i(
        "[LocalTaskService] moveTask: Offline operation is not supported, so nothing will be done.");
  }
}
