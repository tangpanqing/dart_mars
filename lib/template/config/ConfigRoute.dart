class ConfigRoute {
  static String content = '''
import '../bootstrap/helper/RouteHelper.dart';
import '../app/controller/HomeController.dart' as app_controller_HomeController;

///
/// don't modify this file yourself, this file content will be replace by DartMars
///
/// for more infomation, see doc about Route
///
/// last replace time {time}
///
void configRoute() {
  RouteHelper.add('GET', '/', app_controller_HomeController.HomeController.index);
  RouteHelper.add('GET', '/other', app_controller_HomeController.HomeController.other);
}
  ''';
}
