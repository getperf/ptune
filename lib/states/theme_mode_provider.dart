import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptune/services/theme_prefs_service.dart';

final themePrefsServiceProvider = Provider((ref) => ThemePrefsService());

final themeModeProvider =
    NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  late final ThemePrefsService _prefs;

  @override
  ThemeMode build() {
    _prefs = ref.read(themePrefsServiceProvider);
    _load();
    return ThemeMode.dark;
  }

  Future<void> _load() async {
    final saved = await _prefs.load();
    if (saved != null) state = saved;
  }

  Future<void> set(ThemeMode mode) async {
    if (state == mode) return; // 無駄なwrite回避
    state = mode;
    await _prefs.save(mode);
  }

  // Switch用：true=dark/false=light
  Future<void> toggleBool(bool isDark) =>
      set(isDark ? ThemeMode.dark : ThemeMode.light);

  bool get isDark => state == ThemeMode.dark;
}
