import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptune/services/auth/firebase_auth/firebase_auth_gateway.dart';
import 'package:ptune/services/auth/google_auth_client.dart';
import 'package:ptune/services/auth/auth_gateway.dart';
import 'package:ptune/services/auth/google_api_auth/google_apis_auth_gateway.dart';
import 'package:ptune/utils/env_config.dart';

final authGatewayProvider = Provider<AuthGateway>((ref) {
  final method = EnvConfig.authProvider;

  switch (method) {
    case 'firebase':
      return FirebaseAuthGateway(); // Firebase用AuthService内包
    case 'google':
    default:
      return GoogleApisAuthGateway(); // 状態管理も含む
  }
});

final googleAuthClientProvider = Provider<GoogleAuthClient>((ref) {
  final gateway = ref.watch(authGatewayProvider);
  return GoogleAuthClient(gateway);
});
