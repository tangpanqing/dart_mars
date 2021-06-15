class ConfigHook {
  static String content = '''
import '../bootstrap/Context.dart';

///
/// here, you can do something before DartMars call controller
///
/// such as record request info, or verify the request param
///
/// for more infomation, see doc about Hook
///
void hookBeforeCall(Context ctx) async {}

///
/// here, you can do something after DartMars call controller
///
/// such as rewrite response content, or remove sensitive information
///
/// for more infomation, see doc about Hook
///
void hookAfterCall(Context ctx) async {}
  ''';
}
