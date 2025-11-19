import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthStatus {
  unknown,
  unauthenticated,
  authenticating,
  authenticated,
  expired,
  error,
}

extension AuthStatusExtension on AuthStatus {
  String get label {
    switch (this) {
      case AuthStatus.unknown:
        return 'ログイン不明';
      case AuthStatus.unauthenticated:
        return '未ログイン';
      case AuthStatus.authenticating:
        return 'ログイン中';
      case AuthStatus.authenticated:
        return 'ログイン済み';
      case AuthStatus.expired:
        return '認証期限切れ';
      case AuthStatus.error:
        return 'ログインエラー';
    }
  }
}

class AuthState extends StateNotifier<AuthStatus> {
  AuthState() : super(AuthStatus.unknown);
  void set(AuthStatus s) => state = s;
}

final authStateProvider = StateNotifierProvider<AuthState, AuthStatus>(
  (ref) => AuthState(),
);
