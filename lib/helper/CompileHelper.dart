import 'package:process_run/shell.dart';
import 'PackageHelper.dart';

class CompileHelper {
  static void run(String type) {
    if (!PackageHelper.typeList.contains(type)) {
      print('compile type only accect value from ' +
          PackageHelper.typeList.join(','));
    } else {
      if ('aot' == type || 'jit' == type) type += '-snapshot';
      var str =
          'dart compile $type bin/' + PackageHelper.getPackageName() + '.dart';
      Shell().run(str);
    }
  }
}
