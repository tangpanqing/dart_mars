class TransHelper {
  static String content = '''
import '../Context.dart';
import '../db/Db.dart';
import '../helper/LogHelper.dart';

class TransHelper {
  static Future<void> unit({Function tryFunc, Function catchFunc}) async {
    try {
      await Db.startTrans();
      await tryFunc();
      await Db.commit();
    } catch (e, s) {
      await Db.rollback();
      await catchFunc(e, s);
    }
  }

  static Future<void> simple(Context ctx, Function tryFunc) async {
    await unit(
      tryFunc: tryFunc,
      catchFunc: (e, s) {
        LogHelper.warning('TransHelper', e.toString(), e, s);
        ctx.showError(e.toString());
      },
    );
  }
}
  ''';
}
