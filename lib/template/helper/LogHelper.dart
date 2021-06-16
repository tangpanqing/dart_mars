class LogHelper {
  static String content = '''
import 'dart:io';
import 'CommonHelper.dart';
import 'package:logging/logging.dart';

class LogHelper {
  static bool isOutLog;
  static bool isErrLog;
  static String outLogName;
  static String errLogName;
  static String logSeparator;
  static String logForm;

  static void init() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((LogRecord rec) {
      List<String> l = logForm.split(',').map((e) => _c(e, rec)).toList();

      String content = l.join(logSeparator);
      print(content);

      if (rec.level.value >= Level.WARNING.value && isErrLog)
        _log(content, errLogName);
      if (rec.level.value < Level.WARNING.value && isOutLog)
        _log(content, outLogName);
    });
  }

  static String _c(String name, LogRecord rec) {
    if (name == 'levelName') return rec.level.name;
    if (name == 'time') return rec.time.toString();
    if (name == 'sequenceNumber') return rec.sequenceNumber.toString();
    if (name == 'loggerName') return rec.loggerName;
    if (name == 'message') return rec.message;

    return '';
  }

  static void info(String loggerName, Object message) =>
      Logger(loggerName).info(message);

  static void warning(String loggerName, Object message,
          [Object error, StackTrace stackTrace]) =>
      Logger(loggerName).warning(message, error, stackTrace);

  static void _log(String text, String fileName) {
    String date =
        DateTime.now().toString().substring(0, 9 + 1).replaceAll('-', '');

    fileName.replaceAll('{date}', date);

    File file = File(CommonHelper.rootPath() + '/log/' + fileName);
    if (!file.existsSync()) file.createSync();
    file.writeAsStringSync(text + '\\r\\n', mode: FileMode.append);
  }
}
  ''';
}
