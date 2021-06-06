import 'package:process_run/shell.dart';
import 'Until.dart';

class CompileHelper {
  static void run(String type) {
    var str = 'dart compile $type bin\\' + Until.getPackageName() + '.dart';

    Shell().run(str);
  }
}
