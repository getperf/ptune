import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptune/providers/auth_state_provider.dart';
import 'package:ptune/providers/task_list_check_provider.dart';
import 'package:ptune/utils/snackbar_service.dart';

class GoRouterRefreshNotifier extends ChangeNotifier {
  late final ProviderSubscription _authSub;
  late final ProviderSubscription _taskListSub;

  GoRouterRefreshNotifier(Ref ref) {
    _authSub = ref.listen<AuthStatus>(
      authStateProvider,
      (prev, next) {
        notifyListeners();

        if (prev == next) return;

        switch (next) {
          case AuthStatus.unauthenticated:
            if (prev != AuthStatus.unknown) {
              showGlobalSnackBar("ログインが必要です");
            }
            break;
          case AuthStatus.expired:
            if (prev == AuthStatus.authenticated) {
              showGlobalSnackBar("セッションの有効期限が切れました。再認証してください");
            }
            break;
          case AuthStatus.error:
            if (prev == AuthStatus.authenticating) {
              showGlobalSnackBar("認証処理でエラーが発生しました");
            }
            break;
          default:
            break;
        }
      },
      fireImmediately: true,
    );

    _taskListSub = ref.listen<AsyncValue<bool>>(
      taskListCheckProvider,
      (prev, next) {
        notifyListeners();
        next.whenOrNull(
          error: (err, stack) {
            showGlobalSnackBar("タスクリストの取得に失敗しました");
          },
        );
      },
      fireImmediately: true,
    );
  }

  @override
  void dispose() {
    _authSub.close();
    _taskListSub.close();
    super.dispose();
  }
}

final authListenerProvider = Provider<GoRouterRefreshNotifier>((ref) {
  return GoRouterRefreshNotifier(ref);
});
