class HomeController {
  static String content = '''
  import '../../mars/Context.dart';
  class HomeController {
    static void query(Context ctx) async {
      ctx.html("hello world");
    }
  }
  ''';
}
