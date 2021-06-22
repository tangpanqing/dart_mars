class ConfigDatabase {
  static String content = '''
import '../bootstrap/db/DbConfig.dart';

///
/// here, you can accect Database config from env
///
/// for more infomation, see doc about Database
///
void configDatabase(String envType, Map<String, dynamic> env) {
  DbConfig.dbHost = env['dbHost'].toString();
  DbConfig.dbPort = int.parse(env['dbPort'].toString());
  DbConfig.dbUser = env['dbUser'].toString();
  DbConfig.dbPassword = env['dbPassword'].toString();
  DbConfig.dbName = env['dbName'].toString();
}
  ''';
}
