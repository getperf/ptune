import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:ptune/models/my_task_list.dart';
import 'package:ptune/services/task_list_service_interface.dart';
import 'package:ptune/utils/logger.dart'; // ✅ 追加

class DemoTaskListService implements TaskListServiceInterface {
  final String jsonAssetPath;

  DemoTaskListService({required this.jsonAssetPath});

  @override
  Future<List<MyTaskList>> fetchTaskLists() async {
    logger.d('[DemoTasklistService] Loading tasklists from $jsonAssetPath');

    final raw = await rootBundle.loadString(jsonAssetPath);
    final json = jsonDecode(raw) as Map<String, dynamic>;

    final lists = json.entries.map((e) {
      final data = Map<String, dynamic>.from(e.value);
      return MyTaskList.fromJson(data);
    }).toList();

    logger.i('[DemoTasklistService] Loaded ${lists.length} tasklists');
    return lists;
  }

  @override
  Future<MyTaskList> createTaskList(String title) async {
    final id = "demo-${DateTime.now().millisecondsSinceEpoch}";
    final list = MyTaskList(
      id: id,
      title: title,
      description: "Created in demo mode",
    );
    logger.i('[DemoTasklistService] Created tasklist: id=$id, title=$title');
    return list;
  }

  @override
  Future<void> deleteTaskList(String id) async {
    logger.w('[DemoTasklistService] deleteTasklist is not implemented: id=$id');
  }

  @override
  Future<void> saveTaskLists(List<MyTaskList> lists) async {
    logger.w('[DemoTasklistService] saveTasklists is not implemented');
  }

  @override
  Future<List<MyTaskList>> loadTaskLists() async {
    logger.d(
      '[DemoTasklistService] Calling loadTasklists() → fetchTasklists()',
    );
    return await fetchTaskLists();
  }

  @override
  Future<void> clearCache() async {
    logger.w('[DemoTasklistService] clearCache is not implemented');
  }
}
