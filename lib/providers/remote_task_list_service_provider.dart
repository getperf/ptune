import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptune/providers/google_auth_client_provider.dart';
import 'package:ptune/services/remote_task_list_service.dart';

final remoteTaskListServiceProvider = Provider<RemoteTaskListService>((ref) {
  final authClient = ref.watch(googleAuthClientProvider);
  return RemoteTaskListService(authClient);
});
