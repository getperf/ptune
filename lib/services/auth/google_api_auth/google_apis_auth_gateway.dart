import 'dart:io';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:ptune/services/auth/auth_gateway.dart';
import 'package:ptune/utils/env_config.dart';
import 'package:ptune/utils/logger.dart';

class GoogleApisAuthGateway implements AuthGateway {
  String? _accessToken;
  DateTime? _expiry;
  String? _email; // 取得できない場合は null

  bool _signedIn = false;

  List<String> _readScopes() {
    return EnvConfig.scopes.isEmpty
        ? const ['https://www.googleapis.com/auth/tasks']
        : EnvConfig.scopes;
  }

  auth.ClientId _readClientId() {
    final clientId = EnvConfig.getClientId();
    final secret = EnvConfig.clientSecret;
    if (clientId.isEmpty) {
      throw StateError('GOOGLE_CLIENT_ID is not set in .env');
    }
    return auth.ClientId(clientId, secret);
  }

  @override
  Future<void> signIn() async {
    final scopes = _readScopes();
    final clientId = _readClientId();

    logger.i(
      '[GoogleApisAuthGateway] Start sign-in (scopes: ${scopes.join(" ")})',
    );

    final client = await auth.clientViaUserConsent(clientId, scopes, (
      consentUrl,
    ) {
      logger.i('Open this URL in your browser to continue:\n$consentUrl');
      stdout.writeln('Open this URL:\n$consentUrl');
    });

    _accessToken = client.credentials.accessToken.data;
    _expiry = client.credentials.accessToken.expiry;
    _signedIn = true;

    logger.i('[GoogleApisAuthGateway] Sign-in completed');
    client.close();
  }

  @override
  Future<void> signOut() async {
    _accessToken = null;
    _expiry = null;
    _signedIn = false;
    logger.i('[GoogleApisAuthGateway] Signed out');
  }

  @override
  Future<bool> isAuthenticated() async {
    return _accessToken != null;
  }

  @override
  Future<String?> getAccessToken({bool forceRefresh = false}) async {
    return _accessToken;
  }

  @override
  Future<void> refreshToken() async {
    logger.i('[GoogleApisAuthGateway] Refresh token by re-authentication');
    await signIn(); // 実質再同意
  }

  @override
  Future<DateTime?> getTokenExpiry() async => _expiry;

  @override
  Future<String?> getUserEmail() async => _email; // 対応する場合のみ

  @override
  bool get isSignedIn => _signedIn;
}
