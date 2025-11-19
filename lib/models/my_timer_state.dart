class MyTimerState {
  final int remaining;
  final int total;

  const MyTimerState({required this.remaining, required this.total});

  double get progress =>
      total == 0 ? 0.0 : (1.0 - (remaining / total)).clamp(0.0, 1.0);

  String get formattedTime {
    final minutes = remaining ~/ 60;
    final seconds = remaining % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  String toString() {
    return 'MyTimerState($remaining, $total)';
  }
}
