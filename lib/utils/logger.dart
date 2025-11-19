import 'dart:io';

import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ptune/utils/env_config.dart';
import 'package:ptune/utils/file_log_output.dart';

late Logger logger;

final String logLevelString = const String.fromEnvironment(
  'LOG_LEVEL',
  defaultValue: 'debug',
);

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
      return Level.debug; // 既定値
  }
}

Future<void> initLogger() async {
  final logLevelString = EnvConfig.logLevel;
  final logToFile = EnvConfig.logToFile;

  final level = _getLogLevel(logLevelString);

  List<LogOutput> outputs = [ConsoleOutput()];

  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/app_log.txt');
  if (logToFile) {
    final sink = file.openWrite(mode: FileMode.append);
    outputs.add(FileLogOutput(sink));
  }

  logger = Logger(
    level: level,
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 0,
      lineLength: 80,
      noBoxingByDefault: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
    output: MultiOutput(outputs),
  );

  final filePath = logToFile ? file.path : 'none';
  logger.i(
      "[Logger] Initialized with level: $logLevelString, file logging: $filePath");
}
