import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/flutter_haptic_service.dart';
import '../services/haptic_service.dart';

final hapticServiceProvider = Provider<HapticService>((ref) {
  return FlutterHapticService();
});
