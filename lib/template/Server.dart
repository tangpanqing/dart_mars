class Server {
  static String content = '''
  import 'dart:io';
  import 'Context.dart';
  import 'helper/RouteHelper.dart';
  import 'helper/PrintHelper.dart';
  import '../config/route.dart';
  class Server {
    static void http(int port, String serve, Map<String,dynamic> env){
      loadRoute();
      PrintHelper.p('----Http服务器准备启动');
      HttpServer.bind('0.0.0.0', port).then((httpServer) async {
        PrintHelper.p('----Http服务器已经启动 port=' + port.toString());
        await for (HttpRequest request in httpServer) {
          PrintHelper.p('---------------------');
          PrintHelper.p('----Http请求已接收----');
          PrintHelper.t('class Server request.uri.path = ' + request.uri.path);
          PrintHelper.t('class Server request.uri.queryParameters = ' +
              request.uri.queryParameters.toString());

          Context ctx = Context(serve:serve, env:env);
          await ctx.handle(request);
          await RouteHelper.handle(ctx);
          PrintHelper.t('class Server ctx.responseContent = ' + ctx.responseContent);
          PrintHelper.p('----Http请求已处理----');
        }
      });
    }
  }
  ''';
}
