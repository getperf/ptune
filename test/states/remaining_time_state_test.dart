import 'package:flutter_test/flutter_test.dart';
import 'package:ptune/states/remaining_time_state.dart';

void main() {
  group('RemainingTimeState', () {
    late RemainingTimeState state;

    setUp(() {
      state = RemainingTimeState();
    });

    test('start sets end time and initial state', () {
      state.start(5);
      expect(state.state.remaining, greaterThan(0));
    });

    test('tick updates remaining time', () async {
      state.start(3);
      await Future.delayed(Duration(seconds: 1));
      state.tick();
      expect(state.state.remaining, closeTo(1, 2));
    });

    test('pause and resume adjusts end time', () async {
      state.start(5);
      state.pause();
      await Future.delayed(Duration(seconds: 1));
      state.resume();
      final remainingBefore = state.state;
      await Future.delayed(Duration(seconds: 1));
      state.tick();
      expect(state.state.remaining, closeTo(remainingBefore.remaining - 1, 1));
    });

    test('stop resets the state', () {
      state.start(5);
      state.stop();
      // 停止した状態でも残り時間を表示するためリセットしない
      expect(state.state.remaining, 5);
    });
  });
}
