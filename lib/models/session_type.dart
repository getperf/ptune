enum SessionType { work, shortBreak, longBreak }

extension SessionTypeExtension on SessionType {
  String get label {
    switch (this) {
      case SessionType.work:
        return '作業';
      case SessionType.shortBreak:
        return '短い休憩';
      case SessionType.longBreak:
        return '長い休憩';
    }
  }
}
