import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ptune/utils/logger.dart';

class FirebaseAuthService {
  Future<void> signInWithFirebase(GoogleSignInAccount account,
      {String? accessToken}) async {
    final auth = account.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: auth.idToken,
      accessToken: accessToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    logger.i('[FirebaseAuthService] Signed out from Firebase');
  }

  Future<DateTime?> getTokenExpiry() async {
    final result = await FirebaseAuth.instance.currentUser?.getIdTokenResult();
    if (result == null) {
      logger.w('[FirebaseAuthService] Token expiry: user or result is null');
      return null;
    }
    logger.d(
        '[FirebaseAuthService] Token expiry: ${result.expirationTime?.toUtc()}');
    return result.expirationTime;
  }
}
