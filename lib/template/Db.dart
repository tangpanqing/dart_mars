class Db {
  static String content = '''
import 'Column.dart';
import 'Builder.dart';
import 'DbHelper.dart';
import 'package:mysql1/mysql1.dart';

class Db {
  Map<String, dynamic> condition = {};

  Db(String tableName) {
    this.condition["table"] = tableName;
  }

  Db alias(String s) {
    this.condition["alias"] = s;
    return this;
  }

  Db where(List<Column> where) {
    this.condition["where"] = where;
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

  Db having(List<Column> having) {
    this.condition["having"] = having;
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

  Future<int> insert(Map<String, dynamic> data,{bool printSql = false}) async {
    this.condition["data"] = data;

    List values = [];
    String sql = Builder.insert(this.condition, values);

    if(printSql){
      print(sql);
      print(values);
    }

    int id = await DbHelper.insert(sql, values);

    return id;
  }

  Future<int> count({bool printSql = false}) async {
    List<Map<String, dynamic>> list = await this.select(printSql:printSql);

    return list.length;
  }

  Future<double> sum(String field,{bool printSql = false}) async {
    String fieldName = "sum(" + field + ")";

    this.condition["field"] = fieldName;
    List<Map<String, dynamic>> list = await this.select(printSql:printSql);
    double d = list[0][fieldName];

    return d;
  }

  Future<List<Map<String, dynamic>>> select({bool printSql = false}) async {
    List values = [];
    String sql = Builder.select(this.condition, values);

    if(printSql){
      print(sql);
      print(values);
    }

    List<Map<String, dynamic>> list = await DbHelper.select(sql, values);

    return list;
  }

  Future<Map<String, dynamic>> find({bool printSql = false}) async {
    List<Map<String, dynamic>> list = await this.select(printSql:printSql);

    if (list.length > 0) {
      return list[0];
    } else {
      return null;
    }
  }

  Future<int> update(Map<String, dynamic> data,{bool printSql = false}) async {
    this.condition["set"] = data;

    List<Object> values = [];
    String sql = Builder.update(this.condition, values);

    if(printSql){
      print(sql);
      print(values);
    }

    int count = await DbHelper.update(sql, values);
    
    return count;
  }

  Future<int> delete({bool printSql = false}) async {
    List<Object> values = [];
    String sql = Builder.delete(this.condition, values);

    if(printSql){
      print(sql);
      print(values);
    }

    int count = await DbHelper.update(sql, values);

    return count;
  }

  static void startTrans() async {
    await DbHelper.startTrans();
  }

  static void commit() async {
    await DbHelper.commit();
  }

  static void rollback() async {
    await DbHelper.rollback();
  }

  static Future<Results> query(String sql, [List<Object> values]) async {
    return await DbHelper.doQuery(sql, values);
  }
}
  ''';
}
