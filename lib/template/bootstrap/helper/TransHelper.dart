class TransHelper {
  static String content = '''
import '../db/Db.dart';

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
}
  ''';
}
