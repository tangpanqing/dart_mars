import 'package:process_run/shell.dart';

class GetHelper {
  static void run() {
    var str = 'dart pub get';
    Shell().run(str);
  }
}
