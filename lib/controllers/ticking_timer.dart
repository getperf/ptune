import 'dart:async';
import 'package:ptune/utils/logger.dart';

typedef TickCallback = FutureOr<void> Function();

/// 非同期・安定型TickingTimer

/// 一定間隔で `onTick` コールバックを呼び出す単純なタイマー制御クラス。
/// - StreamベースでメインIsolateをブロックしない
/// - onTick()が完了するまでawaitし、遅延を蓄積しない
///
/// タイマーの起動・停止を手動で制御し、
/// 秒単位（既定: 1秒）で `onTick()` を繰り返し呼び出します。
///
/// 例: タイマーの残り秒数を1秒ごとに更新
/// ```dart
/// final timer = TickingTimer(onTick: () {
///   print("tick");
/// });
/// timer.start();
/// ```
///
/// 注意:
/// - `start()` を複数回呼び出しても重複起動しません
/// - 明示的に `stop()` で停止が必要
/// - `dispose()` がないため、ウィジェット終了時は `stop()`
class TickingTimer {
  final int intervalSeconds;
  final TickCallback onTick;
  StreamSubscription? _subscription;
  bool _isRunning = false;

  TickingTimer({this.intervalSeconds = 1, required this.onTick});

  void start() {
    if (_isRunning) {
      logger.w("[TickingTimer] start() ignored: already running");
      return;
    }

    _isRunning = true;
    final stream = Stream.periodic(Duration(seconds: intervalSeconds));
    _subscription = stream.asyncMap((_) async {
      final sw = Stopwatch()..start();
      await onTick();
      sw.stop();
      if (sw.elapsedMicroseconds > 2000) {
        // 2ms超なら警告のみ記録
        logger.d("[tick] duration=${sw.elapsedMicroseconds}µs");
      }
    }).listen(null, onError: (e, st) {
      logger.e("[TickingTimer] error: $e");
    });

    logger.i("[TickingTimer] started with interval=$intervalSeconds sec");
  }

  void stop() {
    if (!_isRunning) {
      logger.w("[TickingTimer] stop() ignored: not running");
      return;
    }
    _subscription?.cancel();
    _subscription = null;
    _isRunning = false;
    logger.i("[TickingTimer] stopped");
  }

  bool get isRunning => _isRunning;
}
