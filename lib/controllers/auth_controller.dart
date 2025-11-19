import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ptune/providers/auth_state_provider.dart';
import 'package:ptune/providers/google_auth_client_provider.dart';
import 'package:ptune/providers/task_list_check_provider.dart';
import 'package:ptune/services/auth/auth_gateway.dart';
import 'package:ptune/utils/logger.dart';

class AuthController {
  final Ref ref;
  AuthController(this.ref);

  AuthGateway get _gateway => ref.read(authGatewayProvider);

  Future<void> restore() async {
    final ok = await _gateway.isAuthenticated();
    ref
        .read(
          authStateProvider.notifier,
        )
        .set(ok ? AuthStatus.authenticated : AuthStatus.unauthenticated);
    logger.i('[AuthController] restore -> $ok');
    if (ok) {
      final email = await _gateway.getUserEmail();
      logger.i('[AuthController] restore -> user: $email');
    }
  }

  Future<void> signIn(BuildContext context, {String? returnTo}) async {
    logger.i("[AuthController] signIn start");
    ref.read(authStateProvider.notifier).set(AuthStatus.authenticating);
    try {
      await _gateway.signIn();
      ref.read(authStateProvider.notifier).set(AuthStatus.authenticated);

      logger.i('[AuthController] signIn -> authenticated');
      final email = await _gateway.getUserEmail();
      final expiry = await _gateway.getTokenExpiry();
      logger.i('[AuthController] user: $email');
      logger.i('[AuthController] token expiry: $expiry');
      // ✅ invalidate でタスクリスト再チェック
      ref.invalidate(taskListCheckProvider);

      if (context.mounted && returnTo != null) {
        context.go(returnTo);
      }
    } catch (e) {
      ref.read(authStateProvider.notifier).set(AuthStatus.error);
      logger.e('[AuthController] signIn failed: $e');
    }
  }

  Future<void> signOut(BuildContext context, {String? returnTo}) async {
    logger.i('[AuthController] signOut start');
    await _gateway.signOut();
    ref.read(authStateProvider.notifier).set(AuthStatus.unauthenticated);
    logger.i('[AuthController] signOut -> unauthenticated');
    if (context.mounted && returnTo != null) {
      context.go(returnTo);
    }
  }

  Future<void> reauthenticate(BuildContext context, {String? returnTo}) async {
    logger.i('[AuthController] reauthenticate start');
    try {
      await _gateway.refreshToken();
      final ok = await _gateway.isAuthenticated();
      ref.read(authStateProvider.notifier).set(
            ok ? AuthStatus.authenticated : AuthStatus.unauthenticated,
          );
      logger.i('[AuthController] reauthenticate → refreshed');
    } catch (e) {
      logger.w('[AuthController] refresh failed, fallback to full signIn');
      if (context.mounted) {
        await signOut(context);
      }
      if (context.mounted) {
        await signIn(context, returnTo: returnTo);
      }
    }
    logger.i('[AuthController] reauthenticate end');
  }
}
