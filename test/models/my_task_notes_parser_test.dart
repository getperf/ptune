import 'package:flutter_test/flutter_test.dart';
import 'package:ptune/models/my_task_notes_parser.dart';

void main() {
  test('parse new notes format', () {
    const notes = '''
🍅planned=2
goal=バグ修正完了
tags=分類/修正,分類/実装
''';

    final meta = MyTaskNotesParser.parse(notes);

    expect(meta.planned, 2);
    expect(meta.goal, 'バグ修正完了');
    expect(meta.tags.length, 2);
  });
}
