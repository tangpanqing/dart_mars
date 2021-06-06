class App {
  static String content = '''
import 'dart:io';
import 'Server.dart';
import 'helper/LogHelper.dart';
import 'package:yaml/yaml.dart';

class App {
  static void startHttp(List<String> arguments) {
    try {
      int port = _getPort(arguments);
      String serve = _getServe(arguments);
      Map<String, dynamic> env = _getEnv(_getPath(), serve);

      Server.http(port, serve, env);
    } catch (e) {
      LogHelper.e('发现错误,' + e.toString());
    }
  }

  static void startHttps(List<String> arguments) {
    try {
      int port = _getPortHttps(arguments);
      String serve = _getServe(arguments);
      Map<String, dynamic> env = _getEnv(_getPath(), serve);

      Server.https(port, serve, env);
    } catch (e) {
      LogHelper.e('发现错误,' + e.toString());
    }
  }

  static String _getPath() {
    return Directory.current.path.replaceAll('\\\\', '/');
  }

  static String _getServe(List<String> arguments) {
    return 'dev';
  }

  static int _getPort(List<String> arguments) {
    return 80;
  }

  static int _getPortHttps(List<String> arguments) {
    return 443;
  }

  static Map<String, dynamic> _getEnv(String path, String serve) {
    String filePath = path + '/env/' + serve + '.yaml';

    File file = File(filePath);
    if (!file.existsSync()) throw '找不到文件,路径: ' + filePath;

    var doc = loadYaml(file.readAsStringSync());
    Map<String, dynamic> m = Map<String, dynamic>.from(doc);

    if (!m.containsKey('dbHost')) throw '缺少必须参数 dbHost';
    if (!m.containsKey('dbPort')) throw '缺少必须参数 dbPort';
    if (!m.containsKey('dbUser')) throw '缺少必须参数 dbUser';
    if (!m.containsKey('dbPassword')) throw '缺少必须参数 dbPassword';
    if (!m.containsKey('dbName')) throw '缺少必须参数 dbName';

    return m;
  }
}
  ''';
}
