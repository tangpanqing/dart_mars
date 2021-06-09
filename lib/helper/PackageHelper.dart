import 'dart:io';

import 'package:yaml/yaml.dart';

class PackageHelper {
  static List<String> typeList = ['exe', 'aot', 'jit', 'kernel', 'js'];

  static String getPackageName() {
    var file =
        File(Directory.current.path.replaceAll('\\', '/') + '/pubspec.yaml');

    var doc = loadYaml(file.readAsStringSync());

    return doc['name'].toString();
  }
}
