import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptune/controllers/auth_controller.dart';

/// AuthController を DI するための Provider。
/// Reader として ref.read を渡すので、内部で他の Provider にもアクセスできる。
final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController(ref);
});
