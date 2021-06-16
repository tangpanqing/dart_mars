class LogHelper {
  static String content = '''
import 'dart:io';
import 'CommonHelper.dart';
import 'package:logging/logging.dart';

class LogHelper {
  static void init() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((LogRecord rec) {
      List<String> l = [
        rec.level.name,
        rec.time.toString(),
        rec.sequenceNumber.toString(),
        rec.loggerName,
        rec.message
      ];

      String content = l.join('::');
      print(content);

      _log(content, rec.level.value >= Level.WARNING.value ? 'err' : 'out');
    });
  }

  static void info(String loggerName, Object message) =>
      Logger(loggerName).info(message);

  static void warning(String loggerName, Object message) =>
      Logger(loggerName).warning(message);

  static void _log(String text, String type) {
    String date =
        DateTime.now().toString().substring(0, 9 + 1).replaceAll('-', '');
    File file = File(
        CommonHelper.rootPath() + '/log/log_' + type + '_' + date + '.txt');
    if (!file.existsSync()) file.createSync();
    file.writeAsStringSync(text + '\\r\\n', mode: FileMode.append);
  }
}
  ''';
}
