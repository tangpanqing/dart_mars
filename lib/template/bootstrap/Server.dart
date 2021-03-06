class Server {
  static String content = '''
import 'dart:convert';
import 'dart:io';

import 'helper/RouteHelper.dart';
import 'helper/LogHelper.dart';
import 'helper/CommonHelper.dart';
import 'Context.dart';
import '../config/context.dart';

class Server {
  static String _className = 'Server';

  static void http(int port, String serve, Map<String, dynamic> env) {
    HttpServer.bind('0.0.0.0', port).then((httpServer) async {
      await _http(httpServer, port, serve, env);
    });
  }

  static void https(int port, String serve, Map<String, dynamic> env) {
    SecurityContext securityContext = SecurityContext();
    securityContext.useCertificateChain(
        CommonHelper.rootPath() + '/' + env['sslCertificate'].toString());
    securityContext.usePrivateKey(
        CommonHelper.rootPath() + '/' + env['sslCertificateKey'].toString());

    HttpServer.bindSecure('0.0.0.0', port, securityContext)
        .then((httpServer) async {
      await _http(httpServer, port, serve, env);
    });
  }

  static Future<void> _http(HttpServer httpServer, int port, String serve,
      Map<String, dynamic> env) async {
    httpServer.autoCompress = true;

    LogHelper.info(
        _className, 'Http Server has start, port=' + port.toString());
    LogHelper.info(_className, 'Env type is ' + serve);
    LogHelper.info(
        _className,
        'Open browser and vist http://127.0.0.1:' +
            port.toString() +
            ' , you can see some info');

    httpServer.listen((HttpRequest request) async {
      await _onData(request, serve, env);
    }, onError: _onError, onDone: _onDone);
  }

  static Future<void> _onData(
      HttpRequest request, String serve, Map<String, dynamic> env) async {
    LogHelper.info(_className, '------------------');
    LogHelper.info(_className, 'Http Request start');
    LogHelper.info(_className, 'request.uri.path = ' + request.uri.path);

    bool isFile = request.uri.path.contains('.');
    bool isExists = false;
    File file;
    if (isFile) {
      file = File(CommonHelper.rootPath() + '/public' + request.uri.path);
      isExists = file.existsSync();
    }

    if (isFile && isExists) {
      await _handleFile(request, file);
    } else {
      Context ctx = Context(serve: serve, env: env);
      configContext(ctx);
      await ctx.handle(request);

      LogHelper.info(_className, 'ctx.query = ' + jsonEncode(ctx.query));
      LogHelper.info(_className, 'ctx.body = ' + jsonEncode(ctx.body));

      await RouteHelper.handle(ctx);
      LogHelper.info(
          _className, 'ctx.responseContent = ' + ctx.responseContent);
    }

    LogHelper.info(_className, 'Http Request end');
  }

  static void _onError(Object e, StackTrace s) =>
      LogHelper.warning(_className, 'onError', e, s);

  static void _onDone() => LogHelper.info(_className, '_onDone');

  static Future<void> _handleFile(HttpRequest request, File file) async {
    try {
      request.response.statusCode = HttpStatus.ok;
      request.response.headers.contentType = _ContentType(request);
      await request.response.addStream(file.openRead());
    } catch (e) {
      request.response.statusCode = HttpStatus.internalServerError;
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
      case 'PNG':
        contentType = ContentType('image', 'png');
        break;
      default:
    }

    return contentType;
  }
}
  ''';
}
