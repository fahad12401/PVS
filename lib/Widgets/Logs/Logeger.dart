import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class EVSLogger {
  static String? timeStamp;

  static void appendLog(String text) async {
    timeStamp = DateFormat('dd-MM-yyyy hh:mm:ss a').format(DateTime.now());
    final Directory sdcard = await getApplicationDocumentsDirectory();
    try {
      File filelog = new File("${sdcard.path}/logs.txt");
      if (!filelog.existsSync()) {
        filelog.createSync();
      }
      try {
        // Use IOSink for better performance and to set append to file flag
        final sink = filelog.openWrite(mode: FileMode.append);
        sink.write('\n$text	$timeStamp\n');
        sink.close();
      } on OutOfMemoryError catch (e) {
        EVSLogger.appendLog(" EVSlOgger OutOfMemoryError: ${e.toString()}");
      } catch (e) {
        print(e.toString());
      }
    } on Exception catch (e) {
      EVSLogger.appendLog("Exception on EVSLOGGER: ${e.toString()}");
      print(e.toString());
    }
  }

  static void appendLogWithName(String appName, String text) {
    timeStamp = DateFormat('dd-MM-yyyy hh:mm:ss a').format(DateTime.now());
    final directory = Directory('${Directory.current.path}/logs');
    if (!directory.existsSync()) {
      directory.createSync();
    }
    final logFile = File('${directory.path}/FIOTrakkerLogs.txt');
    if (!logFile.existsSync()) {
      logFile.createSync();
    }
    try {
      // Use IOSink for better performance and to set append to file flag
      final sink = logFile.openWrite(mode: FileMode.append);
      sink.write('\nAppName: $appName $text	$timeStamp\n');
      sink.close();
    } on OutOfMemoryError catch (e) {
      print(e.toString());
    } catch (e) {
      print(e.toString());
    }
  }
}
