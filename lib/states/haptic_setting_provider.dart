import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'haptic_setting.dart';

final hapticSettingProvider = StateProvider<HapticSetting>((ref) {
  return HapticSetting.off; // デフォルト Off
});
