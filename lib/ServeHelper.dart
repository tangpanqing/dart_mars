import 'dart:io';
import 'package:process_run/shell.dart';
import 'package:yaml/yaml.dart';

class ServeHelper {
  static void serve(List<String> arguments) {
    var file =
        File(Directory.current.path.replaceAll('\\', '/') + '/pubspec.yaml');

    var doc = loadYaml(file.readAsStringSync());

    var str = 'dart run bin\\' +
        doc['name'].toString() +
        '.dart ' +
        arguments.join(' ');

    Shell().run(str);
  }
}
