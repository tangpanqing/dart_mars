import 'dart:io';

import 'package:yaml/yaml.dart';

class Util {
  static String getPackageName() {
    var file =
        File(Directory.current.path.replaceAll('\\', '/') + '/pubspec.yaml');

    var doc = loadYaml(file.readAsStringSync());

    return doc['name'].toString();
  }
}
