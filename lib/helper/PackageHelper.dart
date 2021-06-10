import 'dart:io';

import 'package:yaml/yaml.dart';

class PackageHelper {
  static List<String> typeList = ['exe', 'aot', 'jit', 'kernel', 'js'];

  static String getRootPath() {
    return Directory.current.path.replaceAll('\\', '/');
  }

  static String getPackageName() {
    var file = File(getRootPath() + '/pubspec.yaml');

    var doc = loadYaml(file.readAsStringSync());

    return doc['name'].toString();
  }
}
