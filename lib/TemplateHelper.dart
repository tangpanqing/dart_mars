import 'dart:io';

class TemplateHelper {
  static final String _pubspec = '''
name: {package}
environment:
  sdk: '>=2.10.0 <3.0.0'
dependencies:
  ''';

  static final String _bin_bin = '''
  import '../mars/App.dart';
  main(List<String> arguments) {
    App.startHttp(arguments);
  }
  ''';
  static final String _mars_App = '''
  import 'dart:io';
  import 'Server.dart';
  class App {
    static void startHttp(List<String> arguments){
      int port = _getPort(arguments);
      String mode = _getMode(arguments);
      Map<String,dynamic> env = _getEnv(_getPath(), mode);

      Server.http(port, mode, env);
    }

    static String _getPath(){
      return Directory.current.path.replaceAll('\\\\', '/');
    }

    static String _getMode(List<String> arguments){
      return 'dev';
    }

    static int _getPort(List<String> arguments){
      return 80;
    }

    static Map<String,dynamic> _getEnv(String path, String mode){
      return Map<String,dynamic>();
    }
  }
  ''';

  static final String _mars_Server = '''
  import 'dart:io';
  import 'Context.dart';
  import 'helper/RouteHelper.dart';
  import 'helper/PrintHelper.dart';
  import '../config/route.dart';
  class Server {
    static void http(int port, String mode, Map<String,dynamic> env){
      route();
      PrintHelper.p('----Http服务器准备启动');
      HttpServer.bind('0.0.0.0',port).then((httpServer) async {
        PrintHelper.p('----Http服务器已经启动');
        await for (HttpRequest request in httpServer) {
          PrintHelper.p('----Http请求已接收');
          PrintHelper.p('request.uri.path = ' + request.uri.path);
          PrintHelper.p('request.uri.path = ' + request.uri.path);
          Context ctx = Context(mode:mode, env:env);
          await ctx.handle(request);
          await RouteHelper.handle(ctx);
          PrintHelper.p('----Http请求已处理');
        }
      });
    }
  }
  ''';
  static final String _mars_Context = '''
  import 'dart:io';
  import 'dart:convert';

  class Context {
    String mode;

    Map<String, dynamic> env;

    HttpRequest request;
    
    HttpResponse response;
    String responseContent;
    bool responseIsClose = false;
  
    String method;
    ContentType responseType;
    Map<String, dynamic> header = Map<String, dynamic>();
    Map<String, dynamic> query = Map<String, dynamic>();
    Map<String, dynamic> body = Map<String, dynamic>();
    Map<String, dynamic> session = Map<String, dynamic>();
    Map<String, dynamic> cookie = Map<String, dynamic>();

    Context({this.mode, this.env});

    Future<void> handle(HttpRequest request) async {
      this.request = request;
      this.response = request.response;
      this.method = request.method;

      this.header = _getHeader(request);
      this.query = _getQuery(request);
      this.body = await _getBody(request);
      this.session = await _getSession(request);
    }

    String getString(String key, {String def = "", int from = 0}) {
      Map<String, dynamic> all = _getAllParams(from);

      if (all.containsKey(key)) return all[key].toString();
      return def;
    }

    int getInt(String key, {int def = 0, int from = 0}) {
      Map<String, dynamic> all = _getAllParams(from);

      if (all.containsKey(key)) {
        try {
          return int.parse(all[key].toString());
        } catch (e) {}
      }

      return def;
    }

    int getPositiveInt(String key, {int def = 0, int from = 0}) {
      int i = getInt(key, def:def, from:from);
      return i > 0 ? i : 0;
    }

    int getNegativeInt(String key, {int def = 0, int from = 0}) {
      int i = getInt(key, def:def, from:from);
      return i < 0 ? i : 0;
    }

    double getDouble(String key, {double def = 0, int from = 0}) {
      Map<String, dynamic> all = _getAllParams(from);

      if (all.containsKey(key)) {
        try {
          return double.parse(all[key].toString());
        } catch (e) {}
      }

      return def;
    }

    double getPositiveDouble(String key, {double def = 0, int from = 0}) {
      double i = getDouble(key, def:def, from:from);
      return i > 0 ? i : 0;
    }

    double getNegativeDouble(String key, {double def = 0, int from = 0}) {
      double i = getDouble(key, def:def, from:from);
      return i < 0 ? i : 0;
    }

    void html(String raw) {
      responseType = ContentType.html;
      responseContent = raw;
    }

    void text(String raw) {
      responseType = ContentType.text;
      responseContent = raw;
    }

    void json(String raw) {
      responseType = ContentType.json;
      responseContent = raw;
    }

    void binary(String raw) {
      responseType = ContentType.binary;
      responseContent = raw;
    }

    Future<void> writeAndClose() async {
      response.headers.contentType = responseType;
      response.write(responseContent);
      await response.close();

      responseIsClose = true;
    }

    void showJson(num code, String msg, dynamic data) {
      Map<String, dynamic> map = {"code": code, "msg": msg, "data": data};

      json(jsonEncode(map));
    }

    void showSuccess(String msg, dynamic data) {
      showJson(200, msg, data);
    }

    void showError(String msg) {
      showJson(400, msg, {});
    }

    Map<String, dynamic> _getHeader(HttpRequest request) {
      Map<String, dynamic> map = Map<String, dynamic>();
      request.headers.forEach((name, values) {
        map[name] = values.join(",");
      });

      return map;
    }

    Map<String, dynamic> _getQuery(HttpRequest request) {
      return Map<String, dynamic>.from(
          jsonDecode(jsonEncode(request.uri.queryParameters)));
    }

    Future<Map<String, dynamic>> _getBody(HttpRequest request) async {
      Map<String, dynamic> map = Map<String, dynamic>();

      if ("GET" != request.method) {
        var bodyStr = await utf8.decoder.bind(request).join();

        if ("application/x-www-form-urlencoded" ==
            request.headers.contentType.toString()) {
          map = Uri.parse("?" + bodyStr).queryParameters;
        } else if ("application/json" == request.headers.contentType.toString()) {
          map = Map<String, dynamic>.from(jsonDecode(bodyStr));
        } else {
          print("contentType=" + request.headers.contentType.toString());
        }
      }

      return map;
    }

    Map<String, dynamic> _getSession(HttpRequest request) {
      Map<String, dynamic> map = Map<String, dynamic>();

      request.session.forEach((key, value) {
        map[key.toString()] = value.toString();
      });

      return map;
    }

    Map<String, dynamic> _getAllParams(int from) {
      Map<String, dynamic> allParams = Map<String, dynamic>();
      if (from == 0 || from == 1) allParams.addAll(this.header);
      if (from == 0 || from == 2) allParams.addAll(this.query);
      if (from == 0 || from == 3) allParams.addAll(this.body);
      if (from == 0 || from == 4) allParams.addAll(this.session);
      if (from == 0 || from == 5) allParams.addAll(this.cookie);
      return allParams;
    }
  }
  ''';

  static final String _mars_db_Db = '''''';
  static final String _mars_db_Column = '''''';
  static final String _mars_db_Builder = '''''';
  static final String _mars_db_Raw = '''''';

  static final String _mars_helper_ConvertHelper = '''''';
  static final String _mars_helper_PrintHelper = '''
  class PrintHelper {
    static void p(String text) {
      print(DateTime.now().toString() + ' ' + text);
    }
  }
  ''';
  static final String _mars_helper_RouteHelper = '''
  import '../Context.dart';

  class RouteItem {
    String routeMethod;
    String routePath;
    Function call;

    RouteItem(this.routeMethod, this.routePath, this.call);
  }

  class RouteHelper {
    static List<RouteItem> list = [];

    RouteHelper(String routePath, Function call) {
      addMethod("*", routePath, call);
    }

    static get(String routePath, Function call) {
      addMethod("GET", routePath, call);
    }

    static post(String routePath, Function call) {
      addMethod("POST", routePath, call);
    }

    static put(String routePath, Function call) {
      addMethod("PUT", routePath, call);
    }

    static delete(String routePath, Function call) {
      addMethod("DELETE", routePath, call);
    }

    static addMethod(String method, String routePath, Function call) {
      list.add(RouteItem(method, routePath, call));
    }

    static bool matchMethod(String routeMethod, String requestMethod) {
      return requestMethod == routeMethod || "*" == routeMethod;
    }

    static bool matchPath(String routePath, String requestPath) {
      return routePath == requestPath;
    }

    static handle(Context ctx) async {
      bool notMatch = true;

      for (RouteItem item in RouteHelper.list) {
        if (matchMethod(item.routeMethod, ctx.request.method) &&
            matchPath(item.routePath, ctx.request.uri.path)) {
            notMatch = false;

          //if(!ctx.responseIsClose) await hookBeforeCall(ctx);

          if(!ctx.responseIsClose){
            List<dynamic> args = [];
            args.add(ctx);
            await Function.apply(item.call, args);
          }

          //if(!ctx.responseIsClose) await hookAfterCall(ctx);

          if(!ctx.responseIsClose) await ctx.writeAndClose();

          break;
        }

      }

      if (notMatch) {
        ctx.html("NOT FOUND");
        await ctx.writeAndClose();
      }
    }
  }
  ''';

  static final String _env_dev = '''''';
  static final String _env_test = '''''';
  static final String _env_prod = '''''';

  static final String _config_route = '''
  import '../mars/helper/RouteHelper.dart';
  import '../app/controller/HomeController.dart';
  void route(){
    RouteHelper('/home', HomeController.query);
  }
  ''';

  static final String _app_controller_HomeController = '''
  import '../../mars/Context.dart';
  class HomeController {
    static void query(Context ctx) async {
      ctx.html("hello world");
    }
  }
  ''';

  static final String _public_index = '''''';

  static final String _extend_model_User = '''''';
  static final String _extend_service_UserService = '''''';

  static Map<String, String> fileMap = {
    /// pubspec
    'pubspec.yaml': _pubspec,

    /// bin
    'bin/{package}.dart': _bin_bin,

    /// mars
    'mars/App.dart': _mars_App,
    'mars/Server.dart': _mars_Server,
    'mars/Context.dart': _mars_Context,

    // /// mars db
    // 'mars/db/Db.dart': _mars_db_Db,
    // 'mars/db/Column.dart': _mars_db_Column,
    // 'mars/db/Builder.dart': _mars_db_Builder,
    // 'mars/db/Raw.dart': _mars_db_Raw,

    // /// mars helper
    // 'mars/helper/ConvertHelper.dart': _mars_helper_ConvertHelper,

    'mars/helper/PrintHelper.dart': _mars_helper_PrintHelper,
    'mars/helper/RouteHelper.dart': _mars_helper_RouteHelper,

    // /// env
    // 'env/dev.yaml': _env_dev,
    // 'env/test.yaml': _env_test,
    // 'env/prod.yaml': _env_prod,

    /// config
    'config/route.dart': _config_route,

    /// controller
    'app/controller/HomeController.dart': _app_controller_HomeController,

    // /// public
    // 'public/index.html': _public_index,

    // /// extend
    // 'extend/model/User.dart': _extend_model_User,
    // 'extend/service/UserService.dart': _extend_service_UserService
  };

  static void create(String package) {
    var path = Directory.current.path.replaceAll('\\', '/');
    var project = path + '/' + package;
    if (!Directory(project).existsSync()) Directory(project).createSync();

    fileMap.forEach((filePath, fileContent) {
      var filePathArr = filePath.split('/');
      for (var i = 0; i < filePathArr.length; i++) {
        var path = project + '/' + filePathArr.getRange(0, i + 1).join('/');
        path = path.replaceAll('{package}', package);
        fileContent = fileContent.replaceAll('{package}', package);

        if (!path.contains('.')) {
          var directory = Directory(path);
          if (!Directory(path).existsSync()) directory.createSync();
        } else {
          var file = File(path);
          if (!file.existsSync()) file.createSync();
          file.writeAsStringSync(fileContent);

          //fileContent = fileContent.replaceAll('{package}', name);
          //print(path);
          //print(fileContent);
          //print('------------------------------------------');
        }
      }
    });
  }
}
