class Route {
  static String content = '''
  import '../mars/helper/RouteHelper.dart';
  import '../app/controller/HomeController.dart';
  void loadRoute(){
    RouteHelper('/home', HomeController.query);
  }
  ''';
}
