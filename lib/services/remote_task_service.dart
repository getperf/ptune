import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ptune/exceptions/api_exeption.dart';
import 'package:ptune/exceptions/task_service_exception.dart';
import 'package:ptune/models/my_task.dart';
import 'package:ptune/models/my_task_notes_encoder.dart';
import 'package:ptune/providers/task_list_provider.dart';
import 'package:ptune/services/auth/google_auth_client.dart';
import 'package:ptune/factories/task_factory.dart';
import 'package:ptune/utils/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RemoteTaskService {
  final Ref ref;
  final GoogleAuthClient authClient;
  final TaskFactory taskFactory = TaskFactory();

  RemoteTaskService(this.ref, this.authClient);

  static const _baseUrl = 'https://tasks.googleapis.com/tasks/v1';

  Future<String> _getTaskListId() async {
    final list = ref.read(selectedTaskListProvider);
    if (list == null || list.id.isEmpty) {
      throw NotFoundException('タスクリストが未選択です');
    }
    return list.id;
  }

  // =========================
  // 取得
  // =========================
  Future<List<MyTask>> fetchTasks() async {
    final taskListId = await _getTaskListId();
    final url = Uri.parse(
      '$_baseUrl/lists/$taskListId/tasks?showCompleted=true&showHidden=true',
    );

    final response = await authClient.get(url);

    if (response.statusCode >= 400) {
      _handleErrorResponse(response);
    }

    final data = jsonDecode(response.body);
    final tasks = (data['items'] as List<dynamic>? ?? [])
        .map((json) => taskFactory.fromApiData(json, taskListId: taskListId))
        .toList();

    logger.i('[RemoteTaskService] fetchTasks: ${tasks.length} 件');
    return sortTasksHierarchically(tasks);
  }

  List<MyTask> sortTasksHierarchically(List<MyTask> tasks) {
    final roots = tasks.where((t) => t.parent == null).toList()
      ..sort((a, b) => (b.position ?? '').compareTo(a.position ?? ''));

    final childrenMap = <String, List<MyTask>>{};
    for (final t in tasks.where((t) => t.parent != null)) {
      childrenMap.putIfAbsent(t.parent!, () => []).add(t);
    }

    for (final list in childrenMap.values) {
      list.sort((a, b) => (b.position ?? '').compareTo(a.position ?? ''));
    }

    final result = <MyTask>[];
    for (final root in roots) {
      result.add(root);
      result.addAll(childrenMap[root.id] ?? []);
    }

    return result;
  }

  // =========================
  // 更新
  // =========================
  Future<void> saveTask(MyTask task) async {
    final taskListId = await _getTaskListId();

    final body = taskFactory.toApiData(task, forUpdate: true);

    // ★ 新フォーマットで notes 生成
    body['notes'] = MyTaskNotesEncoder.encode(task);

    final url = Uri.parse('$_baseUrl/lists/$taskListId/tasks/${task.id}');
    final request = http.Request('PATCH', url);
    request.headers['Content-Type'] = 'application/json';
    request.body = jsonEncode(body);

    final response = await authClient.send(request);

    if (response.statusCode != 200) {
      final responseBody = await response.stream.bytesToString();
      throw ApiException(
        response.statusCode,
        'Failed to update task',
        body: responseBody,
      );
    }

    logger.i('[RemoteTaskService] saveTask: ${task.id}');
  }

  // =========================
  // 作成
  // =========================
  Future<MyTask> createTask(MyTask task) async {
    final taskListId = await _getTaskListId();
    final url = Uri.parse('$_baseUrl/lists/$taskListId/tasks');

    final body = taskFactory.toApiData(task, forUpdate: false);

    // ★ 新フォーマットで notes 生成
    body['notes'] = MyTaskNotesEncoder.encode(task);

    final response = await authClient.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode >= 400) {
      _handleErrorResponse(response);
    }

    final data = jsonDecode(response.body);

    final created = taskFactory.fromApiData(data, taskListId: taskListId);

    logger.i('[RemoteTaskService] createTask: ${created.id}:${created.title}');
    return created;
  }

  // =========================
  // 一括保存
  // =========================
  Future<void> saveTasks(List<MyTask> tasks) async {
    for (final task in tasks) {
      await saveTask(task);
    }
  }

  // =========================
  // 移動
  // =========================
  Future<void> moveTask(
    String taskId, {
    String? parent,
    String? previous,
  }) async {
    final queryParams = <String, String>{};
    if (parent != null) queryParams['parent'] = parent;
    if (previous != null) queryParams['previous'] = previous;

    final taskListId = await _getTaskListId();
    final uri = Uri.parse(
      '$_baseUrl/lists/$taskListId/tasks/$taskId/move',
    ).replace(queryParameters: queryParams);

    final response = await authClient.post(uri);

    if (response.statusCode != 200) {
      _handleErrorResponse(response);
    }
  }

  // =========================
  // 削除
  // =========================
  Future<void> deleteTask(String id) async {
    final taskListId = await _getTaskListId();
    final url = Uri.parse('$_baseUrl/lists/$taskListId/tasks/$id');

    final response = await authClient.delete(url);

    if (response.statusCode >= 400) {
      _handleErrorResponse(response);
    }

    logger.i('[RemoteTaskService] deleteTask: $id');
  }

  // =========================
  // エラー処理
  // =========================
  void _handleErrorResponse(http.Response response) {
    String message = 'Unknown error';

    try {
      final data = jsonDecode(response.body);
      message = data['error']?['message'] ?? message;
    } catch (_) {
      message = response.body;
    }

    switch (response.statusCode) {
      case 403:
        throw ForbiddenException(message, body: response.body);
      case 404:
        throw NotFoundException(message, body: response.body);
      case 500:
        throw ServerErrorException(message, body: response.body);
      default:
        throw ApiException(
          response.statusCode,
          message,
          body: response.body,
          notifyUser: false,
        );
    }
  }
}
