import 'package:process_run/shell.dart';
import 'Until.dart';

class ServeHelper {
  static void run(List<String> arguments) {
    var str = 'dart run bin\\' +
        Until.getPackageName() +
        '.dart ' +
        arguments.join(' ');

    Shell().run(str);
  }
}
