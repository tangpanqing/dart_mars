class Server {
  static String content = '''
import 'dart:io';

import 'Context.dart';
import 'helper/RouteHelper.dart';
import 'helper/LogHelper.dart';
import 'helper/CommonHelper.dart';
import '../config/route.dart';
import '../config/database.dart';

class Server {
  static void http(int port, String serve, Map<String, dynamic> env) {
    loadRoute();
    loadDatabase(env);

    HttpServer.bind('0.0.0.0', port).then((httpServer) async {
      httpServer.autoCompress = true;
      await _http(httpServer, port, serve, env);
    });
  }

  static void https(int port, String serve, Map<String, dynamic> env) {
    loadRoute();
    loadDatabase(env);

    SecurityContext securityContext = SecurityContext();

    HttpServer.bindSecure('0.0.0.0', port, securityContext)
        .then((httpServer) async {
      httpServer.autoCompress = true;
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

      if (_isFile(request)) {
        await _handleFile(request);
      } else {
        Context ctx = Context(serve: serve, env: env);
        await ctx.handle(request);
        await RouteHelper.handle(ctx);
        LogHelper.e(
            'class Server ctx.responseContent = ' + ctx.responseContent);
      }

      LogHelper.e('----Http请求已处理----');
    }
  }

  static bool _isFile(HttpRequest request) {
    return request.uri.path.contains('.');
  }

  static Future<void> _handleFile(HttpRequest request) async {
    File file = File(CommonHelper.rootPath() + '/public' + request.uri.path);

    if (file.existsSync()) {
      request.response.statusCode = HttpStatus.ok;
      request.response.headers.contentType = _ContentType(request);
      request.response.write(file.readAsStringSync());
    } else {
      request.response.statusCode = HttpStatus.notFound;
    }

    await request.response.close();
  }

  static _ContentType(HttpRequest request) {
    List<String> arr = request.uri.path.split('.');
    String suffix = arr.last.toUpperCase();
    ContentType contentType = ContentType.text;

    switch (suffix) {
      case 'HTML':
        contentType = ContentType.html;
        break;
      case 'CSS':
        contentType = ContentType('text', 'css');
        break;
      case 'JS':
        contentType = ContentType('text', 'javascript');
        break;
      case 'JSON':
        contentType = ContentType.json;
        break;
      default:
    }

    return contentType;
  }
}
  ''';
}
