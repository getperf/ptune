import '../states/haptic_setting.dart';

abstract class HapticService {
  Future<void> test(HapticSetting setting);
}
