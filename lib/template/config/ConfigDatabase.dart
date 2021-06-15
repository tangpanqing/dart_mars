class ConfigDatabase {
  static String content = '''
import '../bootstrap/db/DbConfig.dart';

void configDatabase(String envType, Map<String, dynamic> env) {
  DbConfig.dbHost = env['dbHost'].toString();
  DbConfig.dbPort = int.parse(env['dbPort'].toString());
  DbConfig.dbUser = env['dbUser'].toString();
  DbConfig.dbPassword = env['dbPassword'].toString();
  DbConfig.dbName = env['dbName'].toString();
}
  ''';
}
