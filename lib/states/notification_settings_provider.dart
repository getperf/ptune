import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptune/models/notification_settings.dart';
import 'package:ptune/services/notification_prefs_service.dart';

final notificationPrefsServiceProvider = Provider(
  (ref) => NotificationPrefsService(),
);
final notificationSettingsProvider =
    AsyncNotifierProvider<NotificationSettingsNotifier, NotificationSettings>(
      NotificationSettingsNotifier.new,
    );

class NotificationSettingsNotifier extends AsyncNotifier<NotificationSettings> {
  @override
  Future<NotificationSettings> build() =>
      ref.read(notificationPrefsServiceProvider).load();

  Future<void> set({bool? startEnabled, bool? endEnabled}) async {
    final current = state.requireValue;
    final next = current.copyWith(
      startEnabled: startEnabled,
      endEnabled: endEnabled,
    );
    state = const AsyncLoading();
    try {
      await ref.read(notificationPrefsServiceProvider).save(next);
      state = AsyncData(next);
    } catch (_) {
      state = AsyncData(current);
      rethrow;
    }
  }
}
