import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ptune/services/os_notification_service.dart';
import 'package:ptune/states/auto_mode_state.dart';
import 'package:ptune/states/notification_permission_provider.dart';
import 'package:ptune/states/notification_settings_provider.dart';
import 'package:ptune/utils/logger.dart';
import 'package:ptune/views/settings/timer_notification_section.dart';

class PermissionService extends OsNotificationService {
  @override
  bool get supported => true;
  @override
  Future<NotificationPermission> status() async => const NotificationPermission(
    supported: true,
    allowed: true,
    exactRequired: true,
    exactAllowed: false,
  );
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    initLoggerForTest();
  });

  testWidgets('only end notifications require exact alarm permission', (
    tester,
  ) async {
    final container = ProviderContainer(
      overrides: [
        osNotificationServiceProvider.overrideWithValue(PermissionService()),
      ],
    );
    addTearDown(container.dispose);
    await container.read(notificationSettingsProvider.future);
    await container
        .read(notificationSettingsProvider.notifier)
        .set(startEnabled: true);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: Scaffold(body: TimerNotificationSection()),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('利用可能'), findsOneWidget);
    await container
        .read(notificationSettingsProvider.notifier)
        .set(endEnabled: true);
    await tester.pumpAndSettle();
    expect(find.text('要設定'), findsOneWidget);
    await tester.tap(find.text('通知の利用状態'));
    await tester.pumpAndSettle();
    expect(find.text('終了時刻の予約'), findsOneWidget);
    expect(find.text('未許可'), findsOneWidget);
  });

  testWidgets('manual mode disables start switch but retains preference', (
    tester,
  ) async {
    final container = ProviderContainer(
      overrides: [
        osNotificationServiceProvider.overrideWithValue(PermissionService()),
      ],
    );
    addTearDown(container.dispose);
    await container.read(notificationSettingsProvider.future);
    await container
        .read(notificationSettingsProvider.notifier)
        .set(startEnabled: true);
    container.read(autoModeProvider);
    await tester.pump();
    await container.read(autoModeProvider.notifier).set(AutoMode.manual);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: Scaffold(body: TimerNotificationSection()),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final switches = tester
        .widgetList<SwitchListTile>(find.byType(SwitchListTile))
        .toList();
    expect(switches.first.value, true);
    expect(switches.first.onChanged, isNull);
    expect(switches.last.onChanged, isNotNull);
    expect(find.text('未使用'), findsOneWidget);
  });
}
