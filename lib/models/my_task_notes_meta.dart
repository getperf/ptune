import 'review_flag.dart';

class MyTaskNotesMeta {
  final int? planned;
  final double? actual;
  final String? goal;
  final List<String> tags;
  final DateTime? started;
  final List<ReviewFlag> reviewFlags;

  const MyTaskNotesMeta({
    this.planned,
    this.actual,
    this.goal,
    this.tags = const [],
    this.started,
    this.reviewFlags = const [],
  });
}
