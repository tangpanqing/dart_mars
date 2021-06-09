import 'package:process_run/shell.dart';
import 'PackageHelper.dart';

class RunHelper {
  static void run(String type) {
    var str = 'dart run bin\\' + PackageHelper.getPackageName() + '.dart';
    Shell().run(str);
  }
}
