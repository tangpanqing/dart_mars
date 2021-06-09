import 'package:process_run/shell.dart';
import '../util/Util.dart';

class RunHelper {
  static void run(String type) {
    var str = 'dart run bin\\' + Util.getPackageName() + '.dart';
    Shell().run(str);
  }
}
