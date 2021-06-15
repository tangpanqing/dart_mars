class DbConnection {
  static String content = '''
import 'dart:core';
import 'dart:async';
import 'package:mysql1/mysql1.dart';
import 'DbConfig.dart';

class DbConnection {
  DbConnection._privateConstructor();

  static final DbConnection _instance = DbConnection._privateConstructor();
  factory DbConnection() => _instance;

  static MySqlConnection conn;

  static Future<MySqlConnection> getConn() async {
    if (null == conn) {
      var settings = new ConnectionSettings(
          host: DbConfig.dbHost,
          port: DbConfig.dbPort,
          user: DbConfig.dbUser,
          password: DbConfig.dbPassword,
          db: DbConfig.dbName);
      conn = await MySqlConnection.connect(settings);
    }

    return conn;
  }

  static Future<int> insert(String sql, List<Object> values) async {
    Results result = await doQuery(sql, values);

    return result.insertId;
  }

  static Future<List<Map<String, dynamic>>> select(
      String sql, List<Object> values) async {
    Results result = await doQuery(sql, values);

    List<Map<String, dynamic>> list = [];
    result.forEach((element) {
      list.add(element.fields);
    });

    return list;
  }

  static Future<int> update(String sql, List<Object> values) async {
    Results result = await doQuery(sql, values);

    return result.affectedRows;
  }

  static Future<Results> doQuery(String sql, [List<Object> values]) async {
    var conn = await getConn();

    Results result = await conn.query(sql, values);

    return result;
  }

  static void startTrans() async {
    await doQuery("start transaction", []);
  }

  static void commit() async {
    await doQuery("commit", []);
  }

  static void rollback() async {
    await doQuery("rollback", []);
  }
}
  ''';
}
