import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 「計画超過」状態を管理するフラグ
final overLimitProvider = StateProvider<bool>((ref) => false);
