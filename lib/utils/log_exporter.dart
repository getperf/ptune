// lib/utils/log_exporter.dart
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:ptune/utils/logger.dart';

class LogExporter {
  static Future<bool> shareLog() async {
    try {
      final dir = await getApplicationSupportDirectory();
      final path = '${dir.path}/app_log.txt';
      final file = File(path);

      if (!await file.exists()) {
        logger.w("[LogExporter] shareLog → no file");
        return false;
      }

      final size = await file.length();
      logger.i("[LogExporter] shareLog → file exists, size: $size bytes");

      await SharePlus.instance.share(
        ShareParams(
          text: "ptune デバッグログ（${size} bytes）",
          files: [
            XFile(
              file.path,
              mimeType: "text/plain",
            )
          ],
        ),
      );

      return true;
    } catch (e, st) {
      logger.e("[LogExporter] shareLog failed", error: e, stackTrace: st);
      return false;
    }
  }

  static Future<bool> deleteLogFile() async {
    try {
      final dir = await getApplicationSupportDirectory();
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
