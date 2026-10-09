import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:ptune/models/notification_settings.dart';

class NotificationPrefsService {
  Future<NotificationSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('timer_notification_settings');
    if (saved == null) return const NotificationSettings();
    final values = jsonDecode(saved) as Map<String, dynamic>;
    return NotificationSettings(
      startEnabled: values['startEnabled'] == true,
      endEnabled: values['endEnabled'] == true,
    );
  }

  Future<void> save(NotificationSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    if (!await prefs.setString(
      'timer_notification_settings',
      jsonEncode({
        'startEnabled': settings.startEnabled,
        'endEnabled': settings.endEnabled,
      }),
    )) {
      throw StateError('通知設定を保存できませんでした');
    }
  }
}
