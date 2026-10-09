import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ptune/models/notification_settings.dart';
import 'package:ptune/services/notification_prefs_service.dart';
import 'package:ptune/states/notification_settings_provider.dart';

class FailingPrefs extends NotificationPrefsService {
  @override
  Future<void> save(NotificationSettings settings) async =>
      throw StateError('save failed');
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('defaults are off and saved values survive a new container', () async {
    final first = ProviderContainer();
    addTearDown(first.dispose);
    final initial = await first.read(notificationSettingsProvider.future);
    expect(initial.startEnabled, false);
    expect(initial.endEnabled, false);
    await first
        .read(notificationSettingsProvider.notifier)
        .set(startEnabled: true);
    await first
        .read(notificationSettingsProvider.notifier)
        .set(endEnabled: true);
    final second = ProviderContainer();
    addTearDown(second.dispose);
    final restored = await second.read(notificationSettingsProvider.future);
    expect(restored.startEnabled, true);
    expect(restored.endEnabled, true);
  });

  test('failed save restores displayed state and allows retry', () async {
    final container = ProviderContainer(
      overrides: [
        notificationPrefsServiceProvider.overrideWithValue(FailingPrefs()),
      ],
    );
    addTearDown(container.dispose);
    await container.read(notificationSettingsProvider.future);
    await expectLater(
      container
          .read(notificationSettingsProvider.notifier)
          .set(endEnabled: true),
      throwsStateError,
    );
    expect(
      container.read(notificationSettingsProvider).requireValue.endEnabled,
      false,
    );
  });
}
