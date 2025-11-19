import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ptune/controllers/auth_controller_provider.dart';
import 'package:ptune/providers/auth_state_provider.dart';
import 'package:ptune/utils/logger.dart';

class AuthView extends ConsumerWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(authStateProvider);
    final uri = GoRouterState.of(context).uri;
    final mode = uri.queryParameters['mode'] ?? 'default';
    final returnTo = uri.queryParameters['returnTo'] ?? '/home';

    final controller = ref.read(authControllerProvider);

    /// ✅ 初回自動実行: 未認証で busy でない場合、認証を試行
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (status == AuthStatus.unauthenticated && mode != 'signin') {
        logger.i('[AuthView] auto sign-in triggered');
        await controller.signIn(context, returnTo: returnTo);
      }
    });
    final isBusy = status == AuthStatus.authenticating;
    final isAuthed = status == AuthStatus.authenticated;
    final title = '認証: ${isBusy ? '処理中' : status.label}';

    if (status == AuthStatus.expired) {
      return Scaffold(
        appBar: AppBar(title: const Text('再認証が必要です')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('セッションが期限切れになりました。再認証してください。'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref
                    .read(authControllerProvider)
                    .signIn(context, returnTo: returnTo),
                child: const Text('再認証'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isAuthed || mode == 'signin') ...[
              ElevatedButton(
                onPressed: isBusy
                    ? null
                    : () async {
                        logger.i('[AuthView] Sign in button pressed');
                        await controller.signIn(context, returnTo: returnTo);
                      },
                child: isBusy
                    ? const CircularProgressIndicator()
                    : const Text('Google にサインイン'),
              ),
            ] else ...[
              ElevatedButton(
                onPressed: isBusy
                    ? null
                    : () async {
                        logger.i('[AuthView] Sign out button pressed');
                        await controller.signOut(
                          context,
                          returnTo: '/auth?mode=signin&returnTo=$returnTo',
                        );
                      },
                child: const Text('サインアウト'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: isBusy
                    ? null
                    : () async {
                        logger.i('[AuthView] Re-authenticate button pressed');
                        await controller.reauthenticate(
                          context,
                          returnTo: returnTo,
                        );
                      },
                child: const Text('再認証'),
              ),
              // const SizedBox(height: 12),
              // OutlinedButton(
              //   onPressed: () {
              //     logger.i('[AuthView] Back button pressed');
              //     context.go(returnTo);
              //   },
              //   child: const Text('Back'),
              // ),
            ],
          ],
        ),
      ),
    );
  }
}
