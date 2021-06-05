class App {
  static String content = '''
  import 'dart:io';
  import 'Server.dart';
  import 'package:yaml/yaml.dart';

  class App {
    static void startHttp(List<String> arguments) {
      int port = _getPort(arguments);
      String serve = _getServe(arguments);
      Map<String, dynamic> env = _getEnv(_getPath(), serve);

      Server.http(port, serve, env);
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

    static Map<String, dynamic> _getEnv(String path, String serve) {
      File file = File(path + '/env/' + serve + '.yaml');

      var doc = loadYaml(file.readAsStringSync());

      return Map<String, dynamic>.from(doc);
    }
  }
  ''';
}
