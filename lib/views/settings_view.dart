import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ptune/controllers/setting_controller.dart';
import 'package:ptune/states/auto_mode_state.dart';
import 'package:ptune/states/theme_mode_provider.dart';
import 'package:ptune/utils/logger.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final autoMode = ref.watch(autoModeProvider);
    final themeMode = ref.watch(themeModeProvider);
    final autoEnabled = autoMode.isAutoEnabled;
    final safeEnabled = autoMode.isSafeEnabled;
    final controller = SettingsController(ref);

    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text("自動モードを有効にする"),
              value: autoEnabled,
              onChanged: (value) => controller.setAutoMode(value),
            ),
            SwitchListTile(
              title: const Text("止め忘れ防止を有効にする"),
              value: safeEnabled,
              onChanged: autoEnabled
                  ? (value) => controller.setSafeMode(value)
                  : null, // 無効時は触れない
            ),
            SwitchListTile(
              title: const Text('ダークモード'),
              subtitle: const Text('ONにするとダークテーマになります'),
              value: themeMode == ThemeMode.dark,
              onChanged: controller.toggleDarkMode,
            ),
            ListTile(
              title: const Text('ログをエクスポート'),
              subtitle: const Text('アプリの動作ログを保存します'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                try {
                  final msg = await controller.exportLogFile();
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(msg)));
                } catch (e, st) {
                  logger.e(
                    "[SettingsView] Failed to export log file: $e",
                    error: e,
                    stackTrace: st,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("ログのエクスポートに失敗しました。")),
                  );
                }
              },
            ),
            ListTile(
              title: const Text('ログを削除'),
              subtitle: const Text('アプリの動作ログを削除します'),
              trailing: const Icon(Icons.delete_outline),
              onTap: () async {
                try {
                  final msg = await controller.deleteLogFile();
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(msg)));
                } catch (e, st) {
                  logger.e(
                    "[SettingsView] Failed to delete log file",
                    error: e,
                    stackTrace: st,
                  );
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("ログの削除に失敗しました。")),
                  );
                }
              },
            ),
          ],
        ),
      ),

      // タイマー画面では bottom nav bar を非表示にする場合は以下をコメントアウト
      // bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }
}
