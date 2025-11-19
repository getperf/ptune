import 'dart:convert';
import 'package:ptune/models/my_task_list.dart';
import 'package:ptune/services/task_list_service_interface.dart';
import 'package:ptune/services/auth/google_auth_client.dart';
import 'package:ptune/utils/logger.dart'; // ✅ ロガー追加

class RemoteTaskListService implements TaskListServiceInterface {
  final GoogleAuthClient authClient;

  RemoteTaskListService(this.authClient);

  static const _baseUrl = 'https://tasks.googleapis.com/tasks/v1';

  @override
  Future<List<MyTaskList>> fetchTaskLists() async {
    final url = Uri.parse('$_baseUrl/users/@me/lists');
    logger.d('[RemoteTaskListService] GET $url');

    final response = await authClient.get(url);

    logger.d('[RemoteTaskListService] status=${response.statusCode}');
    if (response.statusCode != 200) {
      logger.e(
        '[RemoteTaskListService] Failed to fetch tasklists: ${response.body}',
      );
      throw Exception('Failed to fetch tasklists: ${response.body}');
    }

    final data = jsonDecode(response.body);
    final items = data['items'] as List<dynamic>? ?? [];

    logger.i('[RemoteTaskListService] ${items.length} tasklists fetched');
    return items.map((item) => MyTaskList.fromJson(item)).toList();
  }

  @override
  Future<MyTaskList> createTaskList(String title) async {
    final url = Uri.parse('$_baseUrl/users/@me/lists');
    logger.d('[RemoteTaskListService] POST $url title=$title');

    final response = await authClient.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'title': title}),
    );

    logger.d('[RemoteTaskListService] status=${response.statusCode}');
    if (response.statusCode != 200) {
      logger.e(
        '[RemoteTaskListService] Failed to create tasklist: ${response.body}',
      );
      throw Exception('Failed to create tasklist: ${response.body}');
    }

    final json = jsonDecode(response.body);
    final list = MyTaskList.fromJson(json);
    logger.i(
      '[RemoteTaskListService] Created tasklist: id=${list.id}, title=${list.title}',
    );
    return list;
  }

  @override
  Future<void> deleteTaskList(String id) async {
    final url = Uri.parse('$_baseUrl/users/@me/lists/$id');
    logger.d('[RemoteTaskListService] DELETE $url');

    final response = await authClient.delete(url);
    logger.d('[RemoteTaskListService] status=${response.statusCode}');

    if (response.statusCode != 204) {
      logger.e(
        '[RemoteTaskListService] Failed to delete tasklist: ${response.body}',
      );
      throw Exception('Failed to delete tasklist: ${response.body}');
    }

    logger.i('[RemoteTaskListService] Deleted tasklist: id=$id');
  }

  @override
  Future<void> saveTaskLists(List<MyTaskList> lists) async {
    logger.w('[RemoteTaskListService] saveTasklists() is not implemented');
  }

  @override
  Future<List<MyTaskList>> loadTaskLists() async {
    logger.d(
      '[RemoteTaskListService] Calling loadTasklists() → fetchTasklists()',
    );
    return fetchTaskLists();
  }

  @override
  Future<void> clearCache() async {}
}
