// lib/factories/review_flag_notes_decoder.dart
import '../models/review_flag.dart';

class ReviewFlagNotesDecoder {
  static const _pattern = r'#ptune:review=([^\s]+)';

  static List<ReviewFlag> decode(String? notes) {
    if (notes == null || notes.isEmpty) return const [];

    final match = RegExp(_pattern).firstMatch(notes);
    if (match == null) return const [];

    final raw = match.group(1)!;
    final parts = raw.split(',');

    final result = <ReviewFlag>[];
    for (final p in parts) {
      final flag = ReviewFlag.values
          .where((e) => e.name == p)
          .cast<ReviewFlag?>()
          .firstWhere((e) => e != null, orElse: () => null);
      if (flag != null) {
        result.add(flag);
      }
    }
    return result;
  }
}
