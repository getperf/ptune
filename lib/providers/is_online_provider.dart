import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptune/providers/google_auth_client_provider.dart';

final isOnlineProvider = FutureProvider<bool>((ref) async {
  final client = ref.watch(googleAuthClientProvider);

  final uri = Uri.parse(
      'https://tasks.googleapis.com/tasks/v1/users/@me/lists?maxResults=1');
  try {
    final res = await client.get(uri).timeout(const Duration(seconds: 5));
    return res.statusCode == 200;
  } catch (_) {
    return false;
  }
});
