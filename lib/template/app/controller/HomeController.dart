class HomeController {
  static String content = '''
import 'package:{package}/bootstrap/Context.dart';
import 'package:{package}/bootstrap/meta/RouteMeta.dart';

class HomeController {
  @RouteMeta('/', 'GET')
  static void index(Context ctx) async {
    ctx.html("hello world");
  }

  @RouteMeta('/user', 'GET')
  static void user(Context ctx) async {
    String name = ctx.getString('name');
    // some other code
    ctx.html("hello " + name);
  }

  @RouteMeta('/city/:cityName', 'GET')
  static void city(Context ctx, String cityName) async {
    ctx.html("hello " + cityName);
  }
}
  ''';
}
