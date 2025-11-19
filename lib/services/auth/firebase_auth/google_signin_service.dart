import 'dart:io';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:ptune/utils/env_config.dart';
import 'package:ptune/utils/logger.dart';

class GoogleSignInService {
  final GoogleSignIn _googleSignIn;
  final List<String> _scopes;
  GoogleSignInAccount? _account;

  GoogleSignInService()
      : _googleSignIn = GoogleSignIn.instance,
        _scopes = EnvConfig.scopes.isEmpty
            ? const ['https://www.googleapis.com/auth/tasks']
            : EnvConfig.scopes;

  Future<void> initialize() async {
    final clientId = EnvConfig.getClientId();
    if (clientId.isEmpty) {
      throw Exception('GOOGLE_CLIENT_ID is not set');
    }
    logger.d(
        '[GoogleSignInService] Initializing with $clientId(platform=${Platform.operatingSystem})');
    await _googleSignIn.initialize(serverClientId: clientId);

    // 軽復元を試みる（引数なし）
    try {
      _account = await _googleSignIn.attemptLightweightAuthentication();
      if (_account != null) {
        logger.i(
            '[GoogleSignInService] Lightweight sign-in restored: ${_account?.email}');
      } else {
        logger.i('[GoogleSignInService] No previous lightweight sign-in');
      }
    } catch (e) {
      logger.w(
          '[GoogleSignInService] attemptLightweightAuthentication failed: $e');
    }
  }

  Future<GoogleSignInAccount?> tryLightweightAuth() async {
    try {
      _account = await _googleSignIn.attemptLightweightAuthentication();
      return _account;
    } catch (e) {
      logger.w('[GoogleSignInService] attemptLightweightAuth failed: $e');
      return null;
    }
  }

  Future<GoogleSignInAccount?> signInIfNeeded() async {
    if (_account != null) return _account;

    logger.i('[GoogleSignInService] Authenticating user...');
    _account = await _googleSignIn.authenticate(scopeHint: _scopes);
    if (_account == null) {
      throw Exception('Google アカウント認証に失敗しました');
    }
    return _account;
  }

  Future<String> getAccessToken({bool forceRefresh = false}) async {
    await signInIfNeeded();

    GoogleSignInClientAuthorization? auth;

    if (!forceRefresh) {
      // 既にスコープ認可済みのアクセストークンを試す
      auth =
          await _account!.authorizationClient.authorizationForScopes(_scopes);
    }

    // forceRefresh=true または未取得なら新規認可
    auth ??= await _account!.authorizationClient.authorizeScopes(_scopes);

    // // スコープ付きトークン取得（認可済みでない場合 null）
    // var auth =
    //     await _account!.authorizationClient.authorizationForScopes(_scopes);

    // // 明示的に許可を求める
    // auth ??=
    //     auth ?? await _account!.authorizationClient.authorizeScopes(_scopes);

    final token = auth.accessToken;

    logger.d(
        '[GoogleSignInService] Access token obtained: ${token.substring(0, 10)}...');

    return token;
  }

  Future<String?> getUserEmail() async {
    await signInIfNeeded();
    return _account?.email;
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    _account = null;
    logger.i('[GoogleSignInService] Signed out');
  }

  GoogleSignInAccount? get currentAccount => _account;
}
