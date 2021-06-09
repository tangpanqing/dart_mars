class LogHelper {
  static String content = '''
import 'dart:io';
import 'CommonHelper.dart';

class LogHelper {
  static void i(String text) {
    File file = File(CommonHelper.rootPath() + '/log.error.txt');
    if (!file.existsSync()) file.createSync();
    String str = DateTime.now().toString() + ' ' + text;
    file.writeAsStringSync(str + '\\r\\n', mode: FileMode.append);
    print(str);
  }
}
  ''';
}
