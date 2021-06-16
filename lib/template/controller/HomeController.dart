class HomeController {
  static String content = '''
import 'package:{package}/bootstrap/Context.dart';
import 'package:{package}/bootstrap/meta/RouteMeta.dart';

class HomeController {
  @RouteMeta('/', 'GET')
  static void index(Context ctx) async {
    ctx.html("hello world");
  }

  @RouteMeta('/other', 'GET')
  static void other(Context ctx) async {
    ctx.html("this is text from home");
  }

  @RouteMeta('/city/:cityName', 'GET')
  static void city(Context ctx, String cityName) async {
    ctx.html("this is text from city " + cityName);
  }
}
  ''';
}
