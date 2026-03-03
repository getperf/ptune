import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import '../states/haptic_setting.dart';
import 'haptic_service.dart';

class FlutterHapticService implements HapticService {
  @override
  Future<void> test(HapticSetting setting) async {
    // Offなら何もしない
    if (!setting.isEnabled) return;

    // モバイル以外は何もしない（Windows等）
    if (!Platform.isAndroid && !Platform.isIOS) {
      return;
    }

    switch (setting) {
      case HapticSetting.off:
        return;
      case HapticSetting.light:
        await HapticFeedback.lightImpact();
        break;
      case HapticSetting.medium:
        await HapticFeedback.mediumImpact();
        break;
      case HapticSetting.heavy:
        await HapticFeedback.heavyImpact();
        break;
    }
  }
}
