import 'package:ptune/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptune/states/theme_mode_provider.dart';
import 'package:ptune/utils/app_startup_initializer.dart';
import 'package:ptune/utils/snackbar_service.dart';
import 'package:window_manager/window_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'routes/app_router.dart';
import 'utils/logger.dart';
import 'utils/env_config.dart';
import 'dart:io' show Platform;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await EnvConfig.load();
    debugPrint("✅ .env 読み込み成功");
  } catch (e) {
    debugPrint("⚠️ .env 読み込み失敗: $e");
  }
  await initLogger();
  logger.i("[main] App starting...");

  // AUTH_PROVIDER に応じて初期化
  final authProvider = EnvConfig.authProvider;

  if (authProvider == 'firebase') {
    logger.i("[main] Firebase mode - initializing Firebase");
    // await Firebase.initializeApp();
    // 修正前（flutterfire構成）
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // GoogleSignIn v7 は Web/Android/iOS 限定なので try-catch
    try {
      // 明示的に初期化（google_sign_in v7 では重要）
      final clientId = EnvConfig.getClientId();
      if (clientId.isNotEmpty) {
        logger.i(
            "[main] Initializing GoogleSignIn with CLIENT_ID=$clientId (platform=${Platform.operatingSystem})");
        await GoogleSignIn.instance.initialize(serverClientId: clientId);
      } else {
        logger.e("[main] GOOGLE_CLIENT_ID is empty, .env misconfiguration?");
      }
    } catch (e, st) {
      logger.w("[main] GoogleSignIn initialize skipped or failed: $e");
      logger.d(st.toString());
    }
  } else {
    logger.i("[main] Google mode - skipping Firebase & GoogleSignIn");
    // Firebase.initializeApp() を呼び出さない
  }

  // await windowManager.ensureInitialized();
  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    await windowManager.ensureInitialized();
    logger.d("[main] windowManager initialized");

    WindowOptions windowOptions = const WindowOptions(
      size: Size(380, 720),
      center: true,
      title: 'Pomodoro Tasks',
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      logger.i("[main] Window ready. Showing and focusing...");
      await windowManager.show();
      await windowManager.focus();
    });
  }

  logger.d("[main] windowManager initialized");

  final container = ProviderContainer();
  await AppStartupInitializer.initialize(container);

  logger.d("[main] Launching UI with ProviderScope");
  runApp(
    UncontrolledProviderScope(container: container, child: const PtuneApp()),
  );
}

class AppTheme {
  static final light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorSchemeSeed: Colors.indigo,
  );

  static final dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorSchemeSeed: Colors.indigo,
  );
}

class PtuneApp extends ConsumerWidget {
  const PtuneApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    final router = AppRouter.createRouter(ref, context); // RouterConfig<Object>

    return MaterialApp.router(
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      routerConfig: router,
      title: 'Ptune',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
    );
  }
}
