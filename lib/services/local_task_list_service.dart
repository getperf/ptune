import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:ptune/models/my_task_list.dart';
import 'package:ptune/services/task_list_service_interface.dart';
import 'package:ptune/utils/logger.dart';

class LocalTaskListService implements TaskListServiceInterface {
  static const _fileName = 'tasklists.json';

  Future<File> _getFile() async {
    final dir = await getApplicationSupportDirectory();
    return File('${dir.path}/$_fileName');
  }

  @override
  Future<void> clearCache() async {
    final file = await _getFile();
    if (await file.exists()) {
      await file.delete();
      logger.i('[LocalTaskListService] tasklists.json deleted');
    }
  }

  @override
  Future<List<MyTaskList>> loadTaskLists() async {
    try {
      final file = await _getFile();
      logger.i('[LocalTaskListService] tasklists path = ${file.path}');
      if (!await file.exists()) {
        logger.w('[LocalTaskListService] No local file found.');
        return [];
      }

      final content = await file.readAsString();
      final map = jsonDecode(content) as Map<String, dynamic>;
      return map.values
          .map((e) => MyTaskList.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      logger.e('[LocalTaskListService] Failed to load: $e');
      return [];
    }
  }

  @override
  Future<void> saveTaskLists(List<MyTaskList> lists) async {
    final map = {for (var list in lists) list.id: list.toJson()};

    final file = await _getFile();
    await file.writeAsString(jsonEncode(map));
    logger.i('[LocalTaskListService] Saved ${lists.length} tasklists.');
  }

  // 不要なメソッドは未実装でOK
  @override
  Future<MyTaskList> createTaskList(String title) async =>
      throw UnimplementedError();

  @override
  Future<void> deleteTaskList(String id) async => throw UnimplementedError();

  @override
  Future<List<MyTaskList>> fetchTaskLists() async => throw UnimplementedError();
}
