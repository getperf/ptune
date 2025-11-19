import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptune/services/auto_mode_pref_service.dart';

enum AutoMode { manual, auto, autoSafe }

extension AutoModeExtension on AutoMode {
  bool get isAutoEnabled => this == AutoMode.auto || this == AutoMode.autoSafe;
  bool get isSafeEnabled => this == AutoMode.autoSafe;
}

final autoModePrefsServiceProvider = Provider((ref) => AutoModePrefsService());

final autoModeProvider =
    NotifierProvider<AutoModeNotifier, AutoMode>(AutoModeNotifier.new);

class AutoModeNotifier extends Notifier<AutoMode> {
  late final AutoModePrefsService prefs;

  @override
  AutoMode build() {
    prefs = ref.read(autoModePrefsServiceProvider);
    _load();
    return AutoMode.autoSafe;
  }

  Future<void> _load() async {
    final saved = await prefs.load();
    if (saved != null) state = saved;
  }

  Future<void> set(AutoMode mode) async {
    state = mode;
    await prefs.save(mode);
  }
}
