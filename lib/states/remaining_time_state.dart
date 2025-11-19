import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptune/models/my_timer_state.dart';
import 'package:ptune/utils/logger.dart';

final remainingTimeProvider =
    StateNotifierProvider<RemainingTimeState, MyTimerState>((ref) {
  logger.i("[Provider] remainingTimeProvider created");
  ref.onDispose(() {
    logger.i("[Provider] remainingTimeProvider disposed ❗");
  });
  return RemainingTimeState();
});

class RemainingTimeState extends StateNotifier<MyTimerState> {
  RemainingTimeState() : super(const MyTimerState(remaining: 0, total: 0)) {
    logger.d("[RemainingTimeState] constructed with state = $state");
  }

  DateTime? _endTime;
  DateTime? _pausedAt;

  void start(int durationSec) {
    _endTime = DateTime.now().add(Duration(seconds: durationSec));
    _pausedAt = null;
    state = MyTimerState(remaining: durationSec, total: durationSec);
    logger.i("[start] durationSec = $durationSec, endTime = $_endTime");
    // _update();
  }

  void stop() {
    _endTime = null;
    // _update();
    logger.i("[stop] state = $state (forced stop)");
  }

  void pause() {
    _pausedAt = DateTime.now();
    logger.d("[pause] at $_pausedAt");
  }

  void resume() {
    if (_pausedAt != null) {
      final pausedDuration = DateTime.now().difference(_pausedAt!).inSeconds;
      _endTime = _endTime?.add(Duration(seconds: pausedDuration));
      logger.d(
        "[resume] pausedDuration = $pausedDuration, new endTime = $_endTime",
      );
      _pausedAt = null;
    }
  }

  /// 残り時間を明示的にゼロ化
  void resetToZero() {
    _endTime = null;
    _pausedAt = null;
    state = const MyTimerState(remaining: 0, total: 0);
    logger.i("[RemainingTimeState] resetToZero(): state cleared");
  }

  void tick() {
    logger.d("[tick] before update - state = $state");
    _update();
    logger.d("[tick] after update - state = $state");
  }

  void _update() {
    if (_endTime == null) {
      state = MyTimerState(remaining: 0, total: state.total);
      logger.d("[_update] _endTime is null → state = 0");
      return;
    }

    var remaining = 0;
    if (_pausedAt != null) {
      remaining = _endTime!.difference(_pausedAt!).inSeconds;
      logger.d("[_update] paused - remaining = $remaining, state = $state");
    } else {
      remaining = _endTime!.difference(DateTime.now()).inSeconds;
      logger.d("[_update] running - remaining = $remaining, state = $state");
    }
    state = MyTimerState(
      remaining: remaining > 0 ? remaining : 0,
      total: state.total,
    );
  }
}
