class HomeController {
  static String content = '''
import '../../bootstrap/Context.dart';
import '../../bootstrap/meta/RouteMeta.dart';

class HomeController {
  @RouteMeta('/home', 'get')
  static void query(Context ctx) async {
    ctx.html("hello world");
  }
}
  ''';
}
