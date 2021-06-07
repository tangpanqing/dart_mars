import 'package:process_run/shell.dart';
import 'Util.dart';

class CompileHelper {
  static void run(String type) {
    var str = 'dart compile $type bin\\' + Util.getPackageName() + '.dart';

    Shell().run(str);
  }
}
