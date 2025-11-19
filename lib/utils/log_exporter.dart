// lib/utils/log_exporter.dart
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:ptune/utils/logger.dart';

class LogExporter {
  static Future<File?> exportToDownload() async {
    final docDir = await getApplicationDocumentsDirectory();
    final srcFile = File('${docDir.path}/app_log.txt');
    if (!await srcFile.exists()) return null;

    final downloadDir = Directory('/sdcard/Download');
    final dstFile = File('${downloadDir.path}/ptune_app_log.txt');
    await srcFile.copy(dstFile.path);
    return dstFile;
  }

  static Future<bool> deleteLogFile() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/app_log.txt');
      if (await file.exists()) {
        await file.delete();
        logger.i("[LogExporter] deleteLogFile → deleted: ${file.path}");
        return true;
      } else {
        logger.w("[LogExporter] deleteLogFile → no file found");
        return false;
      }
    } catch (e, st) {
      logger.e("[LogExporter] deleteLogFile failed", error: e, stackTrace: st);
      return false;
    }
  }
}
