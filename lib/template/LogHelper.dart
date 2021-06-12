class LogHelper {
  static String content = '''
import 'dart:io';
import 'CommonHelper.dart';

class LogHelper {
  static void i(String text) {
    String date = DateTime.now().toString().substring(0, 9 + 1).replaceAll('-', '');
    File file = File(CommonHelper.rootPath() + '/log/log_' + date + '.txt');
    if (!file.existsSync()) file.createSync();
    String str = DateTime.now().toString() + ' ' + text;
    file.writeAsStringSync(str + '\\r\\n', mode: FileMode.append);
    print(str);
  }
}
  ''';
}
