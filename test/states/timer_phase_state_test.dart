import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptune/models/timer_phase.dart';
import 'package:ptune/states/timer_phase_state.dart';
import 'package:ptune/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    initLoggerForTest();

    // ★ shared_preferences をテスト用メモリ実装に切り替え
    SharedPreferences.setMockInitialValues({});
  });

  group('TimerPhaseState', () {
    test('default is READY', () {
      final container = ProviderContainer();
      final phase = container.read(timerPhaseProvider);
      expect(phase, TimerPhase.ready);
    });

    test('can set to running and check flags', () {
      final container = ProviderContainer();
      final notifier = container.read(timerPhaseProvider.notifier);
      notifier.state = TimerPhase.running;
      expect(container.read(timerPhaseProvider), TimerPhase.running);
    });
  });
}
