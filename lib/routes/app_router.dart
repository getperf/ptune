import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ptune/providers/auth_state_provider.dart';
import 'package:ptune/providers/task_list_check_provider.dart';
import 'package:ptune/routes/auth_listener.dart';
import 'package:ptune/utils/env_config.dart';
import 'package:ptune/utils/logger.dart';
import 'package:ptune/views/auth_view.dart';
import 'package:ptune/views/home_view.dart';
import 'package:ptune/views/sync_view.dart';
import 'package:ptune/views/timer_view.dart';
import 'package:ptune/views/settings_view.dart';

class RoutePaths {
  static const splash = '/splash';
  static const auth = '/auth';
  static const home = '/home';
  static const sync = '/sync';
  static const timer = '/timer';
  static const settings = '/settings';
}

class AppRouter {
  static GoRouter createRouter(WidgetRef ref, BuildContext context) {
    final authStatus = ref.watch(authStateProvider);
    final taskListCheck = authStatus == AuthStatus.authenticated
        ? ref.watch(taskListCheckProvider)
        : const AsyncData<bool>(false);
    final notifier = ref.watch(authListenerProvider);

    final isDemo = EnvConfig.isDemo;

    return GoRouter(
      initialLocation: RoutePaths.home,
      refreshListenable: notifier,
      redirect: (context, state) {
        logger.d("[Router] state.fullPath=${state.fullPath}, "
            "authStatus=$authStatus, taskListCheck=$taskListCheck, isDemo=$isDemo");

        final loggingIn = state.fullPath == RoutePaths.auth;

        // ✅ デモモード
        if (isDemo) {
          if (state.fullPath == RoutePaths.splash) {
            return RoutePaths.home;
          }
          return null;
        }

        // ✅ 認証状態による遷移
        if (authStatus == AuthStatus.unknown ||
            authStatus == AuthStatus.authenticating) {
          return RoutePaths.splash;
        }
        if (authStatus == AuthStatus.unauthenticated) {
          return loggingIn ? null : RoutePaths.auth;
        }
        if (authStatus == AuthStatus.error &&
            state.fullPath == RoutePaths.splash) {
          return RoutePaths.home;
        }

        // ✅ 認証済み → タスクリスト確認
        if (authStatus == AuthStatus.authenticated) {
          if (state.fullPath == RoutePaths.auth) return null;

          if (taskListCheck is AsyncLoading) {
            return RoutePaths.splash;
          }
          if (taskListCheck is AsyncData && taskListCheck.value == false) {
            if (state.fullPath != RoutePaths.sync) {
              return RoutePaths.sync;
            }
          }
          if (state.fullPath == RoutePaths.splash ||
              state.fullPath == RoutePaths.auth) {
            return RoutePaths.home;
          }
          return null;
        }

        return null;
      },
      routes: [
        GoRoute(
          path: RoutePaths.splash,
          builder: (context, state) => const _SplashView(),
        ),
        GoRoute(
          path: RoutePaths.auth,
          builder: (context, state) => const AuthView(),
        ),
        GoRoute(
          path: RoutePaths.home,
          builder: (context, state) => const HomeView(),
        ),
        GoRoute(
          path: RoutePaths.sync,
          builder: (context, state) => const SyncView(),
        ),
        GoRoute(
          path: RoutePaths.timer,
          builder: (context, state) => const TimerView(),
        ),
        GoRoute(
          path: RoutePaths.settings,
          builder: (context, state) => const SettingsView(),
        ),
      ],
    );
  }
}

class _SplashView extends StatelessWidget {
  const _SplashView();
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: CircularProgressIndicator()));
}
