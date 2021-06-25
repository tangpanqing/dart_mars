class App {
  static String content = '''
import 'dart:io';
import 'Server.dart';
import 'helper/CommonHelper.dart';
import 'helper/LogHelper.dart';
import 'package:yaml/yaml.dart';
import '../config/log.dart';
import '../config/route.dart';
import '../config/database.dart';

class App {
  static String _className = 'App';
  static String serveDefault = 'prod';
  static int portDefault = 80;
  static int portHttpsDefault = 443;
  static String envPath = '/env/';
  static List<String> envFieldList = [
    'dbHost',
    'dbPort',
    'dbUser',
    'dbPassword',
    'dbName'
  ];

  static void startHttp(List<String> arguments) {
    configLog();
    LogHelper.init();
    configRoute();

    try {
      Map<String, String> argMap = _argMap(arguments);
      int port = _getPort(argMap);
      String serve = _getServe(argMap);
      Map<String, dynamic> env = _getEnv(CommonHelper.rootPath(), serve);

      configDatabase(serve, env);

      Server.http(port, serve, env);

      if (env.containsKey('ssl') && env['ssl'].toString() == 'on') {
        int portHttps = _getPortHttps(argMap);
        Server.https(portHttps, serve, env);
      }
    } catch (e, s) {
      LogHelper.warning(_className,
          'Error is found when server start , ' + e.toString(), e, s);
    }
  }

  static String _getServe(Map<String, String> argMap) {
    if (!argMap.containsKey('serve')) return serveDefault;

    String serve = argMap["serve"].toString();

    if (serve.isEmpty) return serveDefault;

    return serve;
  }

  static int _getPort(Map<String, String> argMap) {
    try {
      if (argMap.containsKey('port'))
        return int.parse(argMap["port"].toString());
    } catch (e) {
      throw 'param port must between 0 and 65535, unused by other program';
    }

    return portDefault;
  }

  static int _getPortHttps(Map<String, String> argMap) {
    try {
      if (argMap.containsKey('portHttps'))
        return int.parse(argMap["portHttps"].toString());
    } catch (e) {
      throw 'param portHttps must between 0 and 65535, unused by other program';
    }

    return portHttpsDefault;
  }

  static Map<String, dynamic> _getEnv(String path, String serve) {
    String filePath = path + envPath + serve + '.yaml';

    File file = File(filePath);
    if (!file.existsSync())
      throw 'could not find env file, the path is : ' + filePath;

    var envContent = loadYaml(file.readAsStringSync());
    Map<String, dynamic> envMap = Map<String, dynamic>.from(envContent);

    envFieldList.forEach((fieldName) {
      if (!envMap.containsKey(fieldName))
        throw 'could not find param ' + fieldName + ' in env';
    });

    return envMap;
  }

  static Map<String, String> _argMap(List<String> arguments) {
    Map<String, String> map = Map<String, String>();

    for (int i = 0; i < arguments.length; i = i + 2) {
      if (!arguments[i].startsWith('--'))
        throw 'param start with --, such like --serve, --port';
      String key = arguments[i].replaceAll('--', '');
      String val = i + 1 >= arguments.length ? "" : arguments[i + 1];

      map[key] = val;
    }

    return map;
  }
}
  ''';
}
