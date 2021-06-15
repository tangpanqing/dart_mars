class ConfigHook {
  static String content = '''
import '../bootstrap/Context.dart';

void hookBeforeCall(Context ctx) async {}

void hookAfterCall(Context ctx) async {}
  ''';
}
