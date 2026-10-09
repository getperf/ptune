import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptune/controllers/setting_controller.dart';
import 'package:ptune/states/notification_permission_provider.dart';
import 'package:ptune/utils/logger.dart';

class NotificationPermissionSheet extends ConsumerWidget {
  const NotificationPermissionSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permission = ref.watch(notificationPermissionProvider);
    final controller = SettingsController(ref);
    Future<void> perform(Future<void> Function() action) async {
      try {
        await action();
      } catch (e, st) {
        logger.e(
          '[NotificationPermissionSheet] Permission action failed',
          error: e,
          stackTrace: st,
        );
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('設定を開けませんでした。再度お試しください。')),
          );
        }
      }
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: permission.when(
          loading: () => const SizedBox(
            height: 80,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, stack) => ListTile(
            title: const Text('権限状態を確認できませんでした'),
            trailing: TextButton(
              onPressed: () => ref.invalidate(notificationPermissionProvider),
              child: const Text('再確認'),
            ),
          ),
          data: (status) => !status.supported
              ? const ListTile(title: Text('この端末では通知設定を利用できません'))
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: const Text('OS通知'),
                      subtitle: Text(status.allowed ? '許可済み' : '未許可'),
                      trailing: Wrap(
                        children: [
                          if (!status.allowed)
                            TextButton(
                              onPressed: () => perform(
                                controller.requestNotificationPermission,
                              ),
                              child: const Text('許可'),
                            ),
                          TextButton(
                            onPressed: () => perform(
                              () => controller.openNotificationSettings(),
                            ),
                            child: const Text('OS設定'),
                          ),
                        ],
                      ),
                    ),
                    if (status.exactRequired)
                      ListTile(
                        title: const Text('終了時刻の予約'),
                        subtitle: Text(status.exactAllowed ? '許可済み' : '未許可'),
                        trailing: TextButton(
                          onPressed: () => perform(
                            () => controller.openNotificationSettings(
                              exact: true,
                            ),
                          ),
                          child: const Text('設定'),
                        ),
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}
