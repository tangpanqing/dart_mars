class RouteHelper {
  static String content = '''
import '../Context.dart';
import '../../config/hook.dart';

class RouteItem {
  String routeMethod;
  String routePath;
  Function call;

  RouteItem(this.routeMethod, this.routePath, this.call);
}

class RouteHelper {
  static List<RouteItem> list = [];

  RouteHelper(String routePath, Function call) {
    add("*", routePath, call);
  }

  static get(String routePath, Function call) {
    add("GET", routePath, call);
  }

  static post(String routePath, Function call) {
    add("POST", routePath, call);
  }

  static put(String routePath, Function call) {
    add("PUT", routePath, call);
  }

  static delete(String routePath, Function call) {
    add("DELETE", routePath, call);
  }

  static add(String method, String routePath, Function call) {
    list.add(RouteItem(method, routePath, call));
  }

  static bool _matchMethod(String routeMethod, String requestMethod) {
    return routeMethod.split('|').contains(requestMethod) || "*" == routeMethod;
  }

  static bool _matchPath(String routePath, String requestPath) {
    if (!routePath.contains(':')) {
      return routePath == requestPath;
    } else {
      RegExp exp = new RegExp(routePath);
      return null != exp.firstMatch(requestPath);
    }
  }

  static handle(Context ctx) async {
    bool notMatch = true;

    for (RouteItem item in RouteHelper.list) {
      if (_matchMethod(item.routeMethod, ctx.request.method) &&
          _matchPath(item.routePath, ctx.request.uri.path)) {
        notMatch = false;
        print('RouteItemCall = ' + item.call.toString());

        if (!ctx.responseIsClose()) await hookBeforeCall(ctx);

        if (!ctx.responseIsClose()) {
          List<dynamic> args = [];
          args.add(ctx);
          await Function.apply(item.call, args);
        }

        if (!ctx.responseIsClose()) await hookAfterCall(ctx);

        if (!ctx.responseIsClose()) await ctx.writeAndClose();

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
