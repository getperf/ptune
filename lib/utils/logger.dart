import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ptune/utils/env_config.dart';

late Logger logger;

/// LOG_LEVEL を Level に変換
Level _getLogLevel(String level) {
  switch (level.toLowerCase()) {
    case 'debug':
      return Level.debug;
    case 'info':
      return Level.info;
    case 'warning':
      return Level.warning;
    case 'error':
      return Level.error;
    default:
      return Level.debug;
  }
}

class PtuneLogger extends Logger {
  final File file;

  final Level minLevel;

  PtuneLogger({
    required this.file,
    required this.minLevel,
  }) : super(
          level: minLevel,
          printer: SimplePrinter(),
          output: null,
        );

  @override
  void log(
    Level level,
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (level.index < minLevel.index) {
      return; // debug を抑制（info 以上のみなど）
    }

    final ts = time ?? DateTime.now();
    final logLine = "[${ts.toIso8601String()}][$level] $message";

    // ★ release ビルドでも 100% 残る同期書き込み
    try {
      final sink = file.openSync(mode: FileMode.append);
      sink.writeStringSync("$logLine\n");
      sink.flushSync();
      sink.closeSync();
    } catch (_) {}

    // debug モードのみ従来の logger 処理も実行
    if (!kReleaseMode) {
      super.log(
        level,
        message,
        time: ts,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}

Future<void> initLogger() async {
  final logLevel = _getLogLevel(EnvConfig.logLevel);

  final dir = await getApplicationSupportDirectory();
  final file = File('${dir.path}/app_log.txt');

  file.writeAsStringSync(
    "Log start at ${DateTime.now()}\n",
    mode: FileMode.append,
  );

  logger = PtuneLogger(
    file: file,
    minLevel: logLevel, // ★ LOG_LEVEL に基づく
  );

  logger.i("PtuneLogger initialized (LOG_LEVEL=${EnvConfig.logLevel})");
}
