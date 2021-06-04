import 'dart:io';
import 'Server.dart';

class App {
  static void startHttp(List<String> args) {
    String model = _getMode(args);
    String path = _getPath();

    print(model);
    print(path);

    Server.http();
  }

  static void startHttps(List<String> args) {
    Server.startHttps();
  }

  static void startWebsocket(List<String> args) {
    Server.startWebsocket();
  }

  static String _getMode(List<String> args) {
    return 'dev';
  }

  static String _getPath() {
    return Directory.current.path.replaceAll('\\', '/');
  }
}
