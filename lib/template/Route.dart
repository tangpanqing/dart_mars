class Route {
  static String content = '''
/// 
/// don't modify this file yourself, this file will be replace by program
/// for more infomation, see dart pub global run dart_mars --serve 
/// last replace time {time} 
/// 
import '../bootstrap/helper/RouteHelper.dart';
import '../app/controller/HomeController.dart' as app_controller_HomeController;

void loadRoute(){
  RouteHelper.add('GET', '/', app_controller_HomeController.HomeController.index);
  RouteHelper.add('GET', '/other', app_controller_HomeController.HomeController.other);
}
  ''';
}
