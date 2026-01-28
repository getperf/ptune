import 'package:flutter_test/flutter_test.dart';
import 'package:ptune/models/review_flag.dart';
import 'package:ptune/factories/review_flag_notes_encoder.dart';
import 'package:ptune/factories/review_flag_notes_decoder.dart';
import 'package:ptune/utils/logger.dart';

void main() {
  setUpAll(() {
    initLoggerForTest();
  });

  group('ReviewFlagNotes encode/decode', () {
    test('encode empty returns null', () {
      expect(ReviewFlagNotesEncoder.encode([]), isNull);
    });

    test('encode multiple flags', () {
      final s = ReviewFlagNotesEncoder.encode([
        ReviewFlag.operationMiss,
        ReviewFlag.decisionPending,
      ]);
      expect(s, '#ptune:review=operationMiss,decisionPending');
    });

    test('decode returns flags', () {
      final flags = ReviewFlagNotesDecoder.decode(
        'memo text #ptune:review=toolOrEnvIssue,newIssueFound',
      );
      expect(flags, [ReviewFlag.toolOrEnvIssue, ReviewFlag.newIssueFound]);
    });

    test('decode ignores unknown flags', () {
      final flags = ReviewFlagNotesDecoder.decode(
        '#ptune:review=unknown,operationMiss',
      );
      expect(flags, [ReviewFlag.operationMiss]);
    });

    test('decode with no review returns empty', () {
      final flags = ReviewFlagNotesDecoder.decode('just memo');
      expect(flags, isEmpty);
    });
  });
}
