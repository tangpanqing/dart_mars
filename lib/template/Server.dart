class Server {
  static String content = '''
import 'dart:io';
import 'dart:js';
import 'Context.dart';
import 'helper/RouteHelper.dart';
import 'helper/LogHelper.dart';
import '../config/route.dart';
import '../config/database.dart';

class Server {
  static void http(int port, String serve, Map<String, dynamic> env) {
    loadRoute();
    loadDatabase(env);

    HttpServer.bind('0.0.0.0', port).then((httpServer) async {
      await _http(httpServer, port, serve, env);
    });
  }

  static void https(int port, String serve, Map<String, dynamic> env) {
    loadRoute();
    loadDatabase(env);

    SecurityContext securityContext = SecurityContext();

    HttpServer.bindSecure('0.0.0.0', port, securityContext)
        .then((httpServer) async {
      await _http(httpServer, port, serve, env);
    });
  }

  static Future<void> _http(HttpServer httpServer, int port, String serve,
      Map<String, dynamic> env) async {
    LogHelper.e('----Http服务器已经启动 port=' + port.toString());
    await for (HttpRequest request in httpServer) {
      LogHelper.e('---------------------');
      LogHelper.e('----Http请求已接收----');
      LogHelper.e('class Server request.uri.path = ' + request.uri.path);
      LogHelper.e('class Server request.uri.queryParameters = ' +
          request.uri.queryParameters.toString());

      Context ctx = Context(serve: serve, env: env);
      await ctx.handle(request);
      await RouteHelper.handle(ctx);
      LogHelper.e('class Server ctx.responseContent = ' + ctx.responseContent);
      LogHelper.e('----Http请求已处理----');
    }
  }
}
  ''';
}
