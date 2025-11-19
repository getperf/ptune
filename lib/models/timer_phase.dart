enum TimerPhase { ready, running, paused, end }

extension TimerPhaseExtension on TimerPhase {
  String get label {
    switch (this) {
      case TimerPhase.ready:
        return '準備中';
      case TimerPhase.running:
        return '実行中';
      case TimerPhase.paused:
        return '一時停止';
      case TimerPhase.end:
        return '終了';
    }
  }
}
