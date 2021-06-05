class Bin {
  static String content = '''
  import 'package:{package}/bootstrap/App.dart';
  main(List<String> arguments) {
    App.startHttp(arguments);
  }
  ''';
}
