import 'package:process_run/shell.dart';
import '../util/Util.dart';

class CompileHelper {
  static void run(String type) {
    if (!Util.typeList.contains(type)) {
      print('compile type only accect value from ' + Util.typeList.join(','));
    } else {
      if ('aot' == type || 'jit' == type) type += '-snapshot';
      var str = 'dart compile $type bin\\' + Util.getPackageName() + '.dart';
      Shell().run(str);
    }
  }
}
