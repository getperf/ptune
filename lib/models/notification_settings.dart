class NotificationSettings {
  final bool startEnabled;
  final bool endEnabled;

  const NotificationSettings({
    this.startEnabled = false,
    this.endEnabled = false,
  });

  NotificationSettings copyWith({bool? startEnabled, bool? endEnabled}) =>
      NotificationSettings(
        startEnabled: startEnabled ?? this.startEnabled,
        endEnabled: endEnabled ?? this.endEnabled,
      );
}
