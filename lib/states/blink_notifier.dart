import 'package:flutter_riverpod/flutter_riverpod.dart';

final blinkStateProvider = StateNotifierProvider<BlinkNotifier, bool>(
  (ref) => BlinkNotifier(),
);

class BlinkNotifier extends StateNotifier<bool> {
  BlinkNotifier() : super(false);

  void startBlink(
      {int times = 3, Duration interval = const Duration(seconds: 1)}) async {
    state = true;
    for (int i = 0; i < times * 2; i++) {
      state = !state;
      await Future.delayed(interval ~/ 2);
    }
    state = false;
  }
}
