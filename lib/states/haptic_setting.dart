enum HapticSetting { off, light, medium, heavy }

extension HapticSettingX on HapticSetting {
  /// バイブが有効か
  bool get isEnabled => this != HapticSetting.off;

  /// 無効か
  bool get isOff => this == HapticSetting.off;

  /// 表示用ラベル
  String get label => switch (this) {
    HapticSetting.off => "Off",
    HapticSetting.light => "弱",
    HapticSetting.medium => "中",
    HapticSetting.heavy => "強",
  };

  /// 強度レベル（将来拡張用）
  int get levelIndex => switch (this) {
    HapticSetting.off => 0,
    HapticSetting.light => 1,
    HapticSetting.medium => 2,
    HapticSetting.heavy => 3,
  };
}
