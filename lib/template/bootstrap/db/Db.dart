class Db {
  static String content = '''
import 'package:mysql1/mysql1.dart';
import 'DbConnection.dart';
import 'DbSqlBuilder.dart';
import 'DbColumn.dart';

class Db {
  Map<String, dynamic> condition = {};

  Db(String tableName) {
    this.condition["table"] = tableName;
  }

  Future<int> insert(Map<String, dynamic> data) async {
    this.condition["data"] = data;

    List values = [];
    String sql = DbSqlBuilder.insert(this.condition, values);

    int id = await DbConnection.insert(sql, values);

    return id;
  }

  Future<List<Map<String, dynamic>>> select() async {
    List values = [];
    String sql = DbSqlBuilder.select(this.condition, values);

    List<Map<String, dynamic>> list = await DbConnection.select(sql, values);

    return list;
  }

  Future<Map<String, dynamic>> find() async {
    List<Map<String, dynamic>> list = await this.select();

    if (list.length > 0) {
      return list[0];
    } else {
      return null;
    }
  }

  Future<int> update(Map<String, dynamic> data) async {
    this.condition["set"] = data;

    List<Object> values = [];
    String sql = DbSqlBuilder.update(this.condition, values);

    int count = await DbConnection.update(sql, values);

    return count;
  }

  Future<int> delete() async {
    List<Object> values = [];
    String sql = DbSqlBuilder.delete(this.condition, values);

    int count = await DbConnection.update(sql, values);

    return count;
  }

  static Future<Results> query(String sql, [List<Object> values]) async {
    return await DbConnection.doQuery(sql, values);
  }

  Future<int> count(String field) async {
    String fieldName = "count(" + field + ")";

    num n = await _n(fieldName);

    return int.parse(n.toString());
  }

  Future<double> sum(String field) async {
    String fieldName = "sum(" + field + ")";

    num n = await _n(fieldName);

    return double.parse(n.toString());
  }

  Future<double> avg(String field) async {
    String fieldName = "avg(" + field + ")";

    num n = await _n(fieldName);

    return double.parse(n.toString());
  }

  Future<num> min(String field) async {
    String fieldName = "min(" + field + ")";
    return await _n(fieldName);
  }

  Future<num> max(String field) async {
    String fieldName = "max(" + field + ")";
    return await _n(fieldName);
  }

  Future<num> _n(String fieldName) async {
    this.condition["field"] = fieldName;
    List<Map<String, dynamic>> list = await this.select();
    if (!list[0].containsKey(fieldName)) return 0;
    return list[0][fieldName];
  }

  static void startTrans() async {
    await DbConnection.startTrans();
  }

  static void commit() async {
    await DbConnection.commit();
  }

  static void rollback() async {
    await DbConnection.rollback();
  }

  Db alias(String s) {
    this.condition["alias"] = s;
    return this;
  }

  Db where(List<DbColumn> where) {
    this.condition["where"] = where;
    return this;
  }

  Db having(List<DbColumn> having) {
    this.condition["having"] = having;
    return this;
  }

  Db field(String s) {
    this.condition["field"] = s;
    return this;
  }

  Db lock(bool s) {
    this.condition["lock"] = s;
    return this;
  }

  Db page(int pageNum, int pageSize) {
    this.limit((pageNum - 1) * pageSize, pageSize);
    return this;
  }

  Db limit(int offset, int count) {
    this.condition["limit"] = [offset, count];
    return this;
  }

  Db join(String name, String onCondition, String type) {
    if (!this.condition.containsKey("join")) {
      this.condition["join"] = [];
    }
    this.condition["join"].add([name, onCondition, type]);
    return this;
  }

  Db innerJoin(String name, String onCondition) {
    return join(name, onCondition, "inner");
  }

  Db leftJoin(String name, String onCondition) {
    return join(name, onCondition, "left");
  }

  Db rightJoin(String name, String onCondition) {
    return join(name, onCondition, "right");
  }

  Db group(String s) {
    this.condition["group"] = s;
    return this;
  }

  Db distinct(bool s) {
    this.condition["distinct"] = s;
    return this;
  }

  Db extra(String s) {
    this.condition["extra"] = s;
    return this;
  }

  Db order(String s) {
    this.condition["order"] = s;
    return this;
  }

  Db union(String s) {
    this.condition["union"] = s;
    return this;
  }

  Db using(String s) {
    this.condition["using"] = s;
    return this;
  }

  Db comment(String s) {
    this.condition["comment"] = s;
    return this;
  }

  Db force(String s) {
    this.condition["force"] = s;
    return this;
  }
}
  ''';
}
