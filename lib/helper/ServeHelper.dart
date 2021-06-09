import 'package:process_run/shell.dart';
import 'PackageHelper.dart';

class ServeHelper {
  static void run(List<String> arguments) {
    var str = 'dart run bin\\' +
        PackageHelper.getPackageName() +
        '.dart ' +
        arguments.join(' ');

    Shell().run(str);
  }
}
