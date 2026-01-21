// lib/factories/review_flag_notes_encoder.dart
import '../models/review_flag.dart';

class ReviewFlagNotesEncoder {
  static const _prefix = '#ptune:review=';

  static String? encode(List<ReviewFlag> flags) {
    if (flags.isEmpty) return null;
    final values = flags.map((f) => f.name).join(',');
    return '$_prefix$values';
  }
}
