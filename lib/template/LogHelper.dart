class LogHelper {
  static String content = '''
import 'dart:io';
class LogHelper {
  static void e(String text) {
    String path = Directory.current.path.replaceAll('\\\\', '/');
    File file = File(path + '/log.error.txt');
    if (!file.existsSync()) file.createSync();
    file.writeAsStringSync(DateTime.now().toString() + ' ' + text + '\\r\\n',
        mode: FileMode.append);
  }
}
  ''';
}
