import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:ptune/models/my_task_list.dart';
import 'package:ptune/providers/task_list_provider.dart';
import 'package:ptune/services/remote_task_service.dart';
import 'package:ptune/utils/logger.dart';

void main() {
  setUpAll(initLoggerForTest);

  test('fetchTasks follows nextPageToken and returns every page', () async {
    final requestedUris = <Uri>[];
    final client = MockClient((request) async {
      requestedUris.add(request.url);
      if (request.url.queryParameters['pageToken'] == null) {
        return http.Response(
          jsonEncode({
            'items': [
              {'id': 'first', 'title': 'first'},
            ],
            'nextPageToken': 'next-page',
          }),
          200,
        );
      }
      return http.Response(
        jsonEncode({
          'items': [
            {'id': 'second', 'title': 'second'},
          ],
        }),
        200,
      );
    });
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.read(selectedTaskListProvider.notifier).state =
        const MyTaskList(id: 'list-id', title: 'Today');

    final serviceProvider = Provider<RemoteTaskService>(
      (ref) => RemoteTaskService(ref, client),
    );
    final service = container.read(serviceProvider);
    final tasks = await service.fetchTasks();

    expect(tasks.map((task) => task.id), ['first', 'second']);
    expect(requestedUris, hasLength(2));
    expect(requestedUris.first.queryParameters['maxResults'], '100');
    expect(requestedUris.last.queryParameters['pageToken'], 'next-page');
  });
}
