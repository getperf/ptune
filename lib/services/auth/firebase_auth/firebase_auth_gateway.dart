import 'package:firebase_auth/firebase_auth.dart';
import 'package:ptune/services/auth/auth_gateway.dart';
import 'package:ptune/services/auth/firebase_auth/firebase_auth_service.dart';
import 'package:ptune/services/auth/firebase_auth/google_signin_service.dart';
import 'package:ptune/utils/logger.dart';

class FirebaseAuthGateway implements AuthGateway {
  final GoogleSignInService _google;
  final FirebaseAuthService _firebase;

  FirebaseAuthGateway()
      : _google = GoogleSignInService(),
        _firebase = FirebaseAuthService();

  @override
  Future<void> signIn() async {
    logger.i('[FirebaseAuthGateway] Start sign-in');

    final account = await _google.signInIfNeeded(); // accountを取得
    if (account == null) {
      throw Exception('Google sign-in returned null account');
    }
    await _firebase.signInWithFirebase(account); // accountを渡す

    logger.i('[FirebaseAuthGateway] Sign-in completed');
  }

  @override
  Future<void> signOut() async {
    await _firebase.signOut();
    await _google.signOut();
    logger.i('[FirebaseAuthGateway] Signed out');
  }

  @override
  Future<bool> isAuthenticated() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser == null) {
      logger
          .i('[FirebaseAuthGateway] Firebase user not found → unauthenticated');
      return false;
    }

    // GoogleSignInService 側で initialize() 済み前提
    final account = _google.currentAccount;

    if (account != null) {
      logger.i(
          '[FirebaseAuthGateway] Auth restored → firebase + google: ${account.email}');
      return true;
    }

    // Firebase ユーザだけが復元された場合（Google account は null）
    // → 軽認証で復元できるか試す（非表示）
    try {
      final restored = await _google.tryLightweightAuth(); // initialize 済み前提
      if (restored != null) {
        logger.i(
            '[FirebaseAuthGateway] Google account restored silently: ${restored.email}');
        return true;
      }
    } catch (e) {
      logger.w('[FirebaseAuthGateway] Lightweight auth failed: $e');
    }

    logger.i('[FirebaseAuthGateway] Not authenticated');
    return false;
  }

  @override
  Future<String?> getAccessToken({bool forceRefresh = false}) async =>
      _google.getAccessToken(forceRefresh: forceRefresh);

  @override
  Future<void> refreshToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final oldToken = await user.getIdToken(false);
      logger.d(
          '[FirebaseAuthGateway] Old token: ${oldToken?.substring(0, 10)}...');

      await user.getIdToken(true); // 強制リフレッシュ

      final newToken = await user.getIdToken(false);
      logger.d(
          '[FirebaseAuthGateway] New token: ${newToken?.substring(0, 10)}...');

      logger.i('[FirebaseAuthGateway] Token refreshed via FirebaseAuth');
    } else {
      throw Exception('No current user to refresh token');
    }
  }

  @override
  Future<String?> getUserEmail() async => _google.getUserEmail();

  @override
  Future<DateTime?> getTokenExpiry() async => _firebase.getTokenExpiry();

  @override
  bool get isSignedIn => _google.currentAccount != null;
}
