import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import '../states/haptic_setting.dart';
import 'haptic_service.dart';
import 'package:ptune/utils/logger.dart';

class FlutterHapticService implements HapticService {
  @override
  Future<void> test(HapticSetting setting) async {
    logger.i("[HAPTIC] test called: $setting");

    if (!setting.isEnabled) return;

    if (!Platform.isAndroid && !Platform.isIOS) {
      logger.i("[HAPTIC] skipped (not mobile)");
      return;
    }

    logger.i("[HAPTIC] triggering vibration");

    switch (setting) {
      case HapticSetting.light:
        await HapticFeedback.lightImpact();
        break;
      case HapticSetting.medium:
        await HapticFeedback.mediumImpact();
        await Future.delayed(const Duration(milliseconds: 120));
        await HapticFeedback.mediumImpact();
        break;
      case HapticSetting.heavy:
        await HapticFeedback.heavyImpact();
        await Future.delayed(const Duration(milliseconds: 120));
        await HapticFeedback.heavyImpact();
        await Future.delayed(const Duration(milliseconds: 120));
        await HapticFeedback.heavyImpact();
        break;
      case HapticSetting.off:
        return;
    }
  }
}
