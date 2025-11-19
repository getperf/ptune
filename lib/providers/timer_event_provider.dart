import 'package:flutter_riverpod/flutter_riverpod.dart';

final timerEventProvider = StateNotifierProvider<TimerEventNotifier, String?>(
  (ref) => TimerEventNotifier(),
);

class TimerEventNotifier extends StateNotifier<String?> {
  TimerEventNotifier() : super(null);

  void notify(String event) {
    state = event;
    // リスナで1回だけ使うので、即nullに戻す
    Future.microtask(() => state = null);
  }
}
