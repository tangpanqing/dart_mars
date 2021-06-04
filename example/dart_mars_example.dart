import 'package:dart_mars/dart_mars.dart';

void main(List<String> args) {
  App.startHttp(args);
  App.startHttps(args);
  App.startWebsocket(args);
}
