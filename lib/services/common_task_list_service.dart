import 'package:ptune/models/my_task_list.dart';
import 'package:ptune/services/task_list_service_interface.dart';
import 'package:ptune/services/local_task_list_service.dart';
import 'package:ptune/services/remote_task_list_service.dart';
import 'package:ptune/utils/logger.dart';

class CommonTaskListService implements TaskListServiceInterface {
  final LocalTaskListService local;
  final RemoteTaskListService remote;

  CommonTaskListService({required this.local, required this.remote});

  @override
  Future<void> clearCache() async {
    await local.clearCache();
  }

  @override
  Future<List<MyTaskList>> fetchTaskLists() async {
    final cached = await local.loadTaskLists();
    if (cached.isNotEmpty) {
      logger.i('[CommonTaskListService] Loaded from local cache.');
      return cached;
    }

    try {
      final fetched = await remote.fetchTaskLists();
      await local.saveTaskLists(fetched);
      return fetched;
    } catch (e) {
      logger.w('[CommonTaskListService] Remote fetch failed: $e');
      return [];
    }
  }

  @override
  Future<MyTaskList> createTaskList(String title) async {
    final created = await remote.createTaskList(title);
    final current = await local.loadTaskLists();
    final updated = [...current, created];
    await local.saveTaskLists(updated);
    return created;
  }

  @override
  Future<void> deleteTaskList(String id) async {
    await remote.deleteTaskList(id);
    final current = await local.loadTaskLists();
    final updated = current.where((t) => t.id != id).toList();
    await local.saveTaskLists(updated);
  }

  @override
  Future<void> saveTaskLists(List<MyTaskList> lists) {
    return local.saveTaskLists(lists);
  }

  @override
  Future<List<MyTaskList>> loadTaskLists() {
    return local.loadTaskLists();
  }
}
