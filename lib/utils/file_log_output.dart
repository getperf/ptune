import 'dart:io';
import 'package:logger/logger.dart';

class FileLogOutput extends LogOutput {
  final IOSink _sink;
  FileLogOutput(this._sink);

  @override
  void output(OutputEvent event) {
    for (final line in event.lines) {
      _sink.writeln(line);
    }
  }
}
