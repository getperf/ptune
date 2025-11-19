import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemePrefsService {
  static const _key = 'theme_mode'; // 'light'|'dark'|'system'

  Future<void> save(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, _toStr(mode));
  }

  Future<ThemeMode?> load() async {
    final prefs = await SharedPreferences.getInstance();
    return _fromStr(prefs.getString(_key));
  }

  String _toStr(ThemeMode mode) => switch (mode) {
        ThemeMode.light => 'light',
        ThemeMode.dark => 'dark',
        ThemeMode.system => 'system',
      };

  ThemeMode? _fromStr(String? v) => switch (v) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        'system' => ThemeMode.system,
        _ => null,
      };
}
