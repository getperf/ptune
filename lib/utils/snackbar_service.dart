import 'package:flutter/material.dart';

/// アプリ全体で利用するグローバル ScaffoldMessenger
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

/// エラーメッセージを表示する共通関数
void showGlobalSnackBar(String message) {
  final messenger = rootScaffoldMessengerKey.currentState;
  if (messenger == null) return;

  messenger
    ..clearSnackBars()
    ..showSnackBar(
      SnackBar(content: Text(message)),
    );
}
