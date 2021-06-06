import 'package:process_run/shell.dart';
import 'Util.dart';

class ServeHelper {
  static void run(List<String> arguments) {
    var str = 'dart run bin\\' +
        Util.getPackageName() +
        '.dart ' +
        arguments.join(' ');

    Shell().run(str);
  }
}
