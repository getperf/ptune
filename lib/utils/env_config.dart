import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static Future<void> load() async {
    await dotenv.load(fileName: ".env");
  }

  static String get authProvider =>
      dotenv.env['AUTH_PROVIDER']?.trim() ?? 'google';

  static bool get isDemo =>
      (dotenv.env['USE_DEMO_SERVICE'] ?? 'false').toLowerCase() == 'true';

  static List<String> get scopes => (dotenv.env['GOOGLE_OAUTH_SCOPES'] ?? '')
      .split(',')
      .map((s) => s.trim())
      .where((s) => s.isNotEmpty)
      .toList();

  static String getClientId() {
    if (authProvider == 'firebase') {
      if (Platform.isAndroid) {
        return dotenv.env['FIREBASE_CLIENT_ID_ANDROID'] ?? '';
      } else if (Platform.isIOS) {
        return dotenv.env['FIREBASE_CLIENT_ID_IOS'] ?? '';
      }
    }
    return dotenv.env['GOOGLE_CLIENT_ID'] ?? '';
  }

  static String get clientSecret =>
      dotenv.env['GOOGLE_CLIENT_SECRET']?.trim() ?? '';

  static String get logLevel =>
      dotenv.env['LOG_LEVEL']?.toLowerCase() ?? 'debug';

  static bool get logToFile => dotenv.env['LOG_FILE'] == 'true';
}
