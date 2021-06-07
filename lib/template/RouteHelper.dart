class RouteHelper {
  static String content = '''
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
}
