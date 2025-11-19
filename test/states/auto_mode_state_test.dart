import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptune/states/auto_mode_state.dart';

void main() {
  group('AutoModeState', () {
    test('initial is manual', () {
      final container = ProviderContainer();
      final mode = container.read(autoModeProvider);
      expect(mode, AutoMode.manual);
    });

    test('can switch to auto and safe', () {
      final container = ProviderContainer();
      final notifier = container.read(autoModeProvider.notifier);
      notifier.state = AutoMode.auto;
      expect(notifier.state.isAutoEnabled, true);
      notifier.state = AutoMode.autoSafe;
      expect(notifier.state.isSafeEnabled, true);
    });
  });
}
