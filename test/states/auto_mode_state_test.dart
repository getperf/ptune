import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptune/states/auto_mode_state.dart';
import 'package:ptune/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    initLoggerForTest();

    // ★ shared_preferences をテスト用メモリ実装に切り替え
    SharedPreferences.setMockInitialValues({});
  });

  group('AutoModeState', () {
    test('initial is auto', () {
      final container = ProviderContainer();
      final mode = container.read(autoModeProvider);
      expect(mode, AutoMode.autoSafe);
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
