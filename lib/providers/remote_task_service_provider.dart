import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptune/providers/google_auth_client_provider.dart';
import 'package:ptune/services/remote_task_service.dart';

final remoteTaskServiceProvider = Provider<RemoteTaskService>((ref) {
  final authClient = ref.watch(googleAuthClientProvider);
  return RemoteTaskService(ref, authClient);
});
