import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptune/controllers/setting_controller.dart';
import 'package:ptune/states/auto_mode_state.dart';
import 'package:ptune/states/notification_settings_provider.dart';
import 'package:ptune/states/notification_permission_provider.dart';
import 'package:ptune/utils/logger.dart';
import 'package:ptune/views/settings/notification_permission_sheet.dart';

class TimerNotificationSection extends ConsumerStatefulWidget {
  const TimerNotificationSection({super.key});

  @override
  ConsumerState<TimerNotificationSection> createState() =>
      _TimerNotificationSectionState();
}

class _TimerNotificationSectionState
    extends ConsumerState<TimerNotificationSection>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Refresh cached OS state whenever this settings section is opened.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ref.invalidate(notificationPermissionProvider);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.invalidate(notificationPermissionProvider);
    }
  }

  Future<void> _set({bool? startEnabled, bool? endEnabled}) async {
    try {
      await SettingsController(
        ref,
      ).setNotification(startEnabled: startEnabled, endEnabled: endEnabled);
    } catch (e, st) {
      logger.e(
        '[TimerNotificationSection] Save failed',
        error: e,
        stackTrace: st,
      );
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('通知設定を保存できませんでした')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(notificationSettingsProvider);
    final permission = ref.watch(notificationPermissionProvider);
    final autoEnabled = ref.watch(autoModeProvider).isAutoEnabled;
    final value = settings.asData?.value;
    final status = permission.asData?.value;
    final supported = ref.watch(osNotificationServiceProvider).supported;
    final activeStart = autoEnabled && (value?.startEnabled ?? false);
    final activeEnd = value?.endEnabled ?? false;
    final label = !supported
        ? '対象外'
        : settings.hasError
        ? '読込失敗'
        : value == null
        ? '読込中'
        : !activeStart && !activeEnd
        ? '未使用'
        : permission.hasError
        ? '確認失敗'
        : status == null
        ? '確認中'
        : status.allowed &&
              (!activeEnd || !status.exactRequired || status.exactAllowed)
        ? '利用可能'
        : '要設定';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Center(
          child: Text('タイマー通知', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        SwitchListTile(
          title: const Text('自動で作業開始を通知'),
          value: value?.startEnabled ?? false,
          onChanged: supported && value != null && autoEnabled
              ? (v) => _set(startEnabled: v)
              : null,
        ),
        SwitchListTile(
          title: const Text('作業終了を通知'),
          value: value?.endEnabled ?? false,
          onChanged: supported && value != null
              ? (v) => _set(endEnabled: v)
              : null,
        ),
        ListTile(
          title: const Text('通知の利用状態'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [Text(label), const Icon(Icons.chevron_right)],
          ),
          onTap: () {
            if (settings.hasError) ref.invalidate(notificationSettingsProvider);
            ref.invalidate(notificationPermissionProvider);
            showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              builder: (_) => const NotificationPermissionSheet(),
            );
          },
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
