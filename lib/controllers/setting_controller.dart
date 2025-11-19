import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptune/states/auto_mode_state.dart';
import 'package:ptune/states/theme_mode_provider.dart';
import 'package:ptune/utils/log_exporter.dart';
import 'package:ptune/utils/logger.dart';

class SettingsController {
  final WidgetRef ref;

  SettingsController(this.ref);

  AutoMode get autoMode => ref.read(autoModeProvider);

  void setAutoMode(bool enabled) {
    final current = ref.read(autoModeProvider);
    final newMode = enabled
        ? (current.isSafeEnabled ? AutoMode.autoSafe : AutoMode.auto)
        : AutoMode.manual;
    ref.read(autoModeProvider.notifier).set(newMode);
    logger.i("[SettingsController] setAutoMode → $newMode");
  }

  void setSafeMode(bool enabled) {
    final current = ref.read(autoModeProvider);
    final newMode = switch ((current, enabled)) {
      (AutoMode.manual || AutoMode.auto, true) => AutoMode.autoSafe,
      (_, false) => AutoMode.auto,
      _ => current,
    };
    ref.read(autoModeProvider.notifier).set(newMode);
    logger.i("[SettingsController] setSafeMode → $newMode");
  }

  void toggleDarkMode(bool value) {
    final notifier = ref.read(themeModeProvider.notifier);
    notifier.toggleBool(value);
  }

  Future<String> exportLogFile() async {
    final file = await LogExporter.exportToDownload();
    if (file == null) {
      logger.w("[SettingsController] exportLogFile → no file found");
      return "ログファイルが見つかりません。";
    }
    logger.i("[SettingsController] exportLogFile → ${file.path}");
    return "ログを保存しました: ${file.path}";
  }

  Future<String> deleteLogFile() async {
    final success = await LogExporter.deleteLogFile();
    if (success) {
      return "ログを削除しました。";
    } else {
      return "削除するログが見つかりません。";
    }
  }

  bool get isAutoEnabled => autoMode.isAutoEnabled;
  bool get isSafeEnabled => autoMode.isSafeEnabled;
}
