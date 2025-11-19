import 'package:ptune/states/auto_mode_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AutoModePrefsService {
  static const _key = 'auto_mode';

  Future<void> save(AutoMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode.name); // 'manual', 'auto', 'autoSafe'
  }

  Future<AutoMode?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_key);
    return AutoMode.values.cast<AutoMode?>().firstWhere(
          (e) => e?.name == name,
          orElse: () => null,
        );
  }
}
