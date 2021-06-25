class DbSqlBuilder {
  static String content = '''
import 'DbColumn.dart';
import 'DbRaw.dart';

class DbSqlBuilder {
  static String selectSql =
      'SELECT%DISTINCT%%EXTRA% %FIELD% FROM %TABLE%%ALIAS%%FORCE%%JOIN%%WHERE%%GROUP%%HAVING%%UNION%%ORDER%%LIMIT%%LOCK%%COMMENT%';
  static String insertSql =
      '%INSERT%%EXTRA% INTO %TABLE% (%FIELD%) VALUES (%DATA%)%COMMENT%';
  static String insertAllSql =
      '%INSERT%%EXTRA% INTO %TABLE% (%FIELD%) %DATA%%COMMENT%';
  static String updateSql =
      'UPDATE%EXTRA% %TABLE% SET %SET%%JOIN%%WHERE%%ORDER%%LIMIT%%LOCK%%COMMENT%';
  static String deleteSql =
      'DELETE%EXTRA% FROM %TABLE%%USING%%JOIN%%WHERE%%ORDER%%LIMIT%%LOCK%%COMMENT%';

  static String insert(Map<String, dynamic> options, List values) {
    Map<String, dynamic> data = {};
    try {
      data = options["data"] as Map<String, dynamic>;
    } catch (e) {
      throw 'data for insert is not map';
    }

    List keys = [];
    List vals = [];
    data.forEach((key, value) {
      keys.add(key);
      vals.add(value);
    });

    options["field"] = keys.join(",");
    options["data"] = vals;

    var sql = insertSql;

    sql = sql.replaceFirst('%INSERT%', 'INSERT');
    sql = sql.replaceFirst('%EXTRA%', _parseExtra(options));
    sql = sql.replaceFirst('%TABLE%', _parseTable(options));
    sql = sql.replaceFirst('%FIELD%', _parseField(options));
    sql = sql.replaceFirst('%DATA%', _parseData(options, values));
    sql = sql.replaceFirst('%COMMENT%', _parseComment(options));

    return sql;
  }

  static String select(Map<String, dynamic> options, List values) {
    var sql = selectSql;

    sql = sql.replaceFirst('%TABLE%', _parseTable(options));
    sql = sql.replaceFirst('%ALIAS%', _parseAlias(options));
    sql = sql.replaceFirst('%DISTINCT%', _parseDistinct(options));
    sql = sql.replaceFirst('%EXTRA%', _parseExtra(options));
    sql = sql.replaceFirst('%FIELD%', _parseField(options));
    sql = sql.replaceFirst('%JOIN%', _parseJoin(options));
    sql = sql.replaceFirst('%WHERE%', _parseWhere(options, values));
    sql = sql.replaceFirst('%GROUP%', _parseGroup(options));
    sql = sql.replaceFirst('%HAVING%', _parseHaving(options, values));
    sql = sql.replaceFirst('%ORDER%', _parseOrder(options));
    sql = sql.replaceFirst('%LIMIT%', _parseLimit(options, values));
    sql = sql.replaceFirst('%UNION%', _parseUnion(options));
    sql = sql.replaceFirst('%LOCK%', _parseLock(options));
    sql = sql.replaceFirst('%COMMENT%', _parseComment(options));
    sql = sql.replaceFirst('%FORCE%', _parseForce(options));

    return sql;
  }

  static String update(Map<String, dynamic> options, List values) {
    String sql = updateSql;

    sql = sql.replaceFirst('%EXTRA%', _parseExtra(options));
    sql = sql.replaceFirst('%TABLE%', _parseTable(options));
    sql = sql.replaceFirst('%SET%', _parseSet(options, values));
    sql = sql.replaceFirst('%JOIN%', _parseJoin(options));
    sql = sql.replaceFirst('%WHERE%', _parseWhere(options, values));
    sql = sql.replaceFirst('%ORDER%', _parseOrder(options));
    sql = sql.replaceFirst('%LIMIT%', _parseLimit(options, values));
    sql = sql.replaceFirst('%LOCK%', _parseLock(options));
    sql = sql.replaceFirst('%COMMENT%', _parseComment(options));

    return sql;
  }

  static String delete(Map<String, dynamic> options, List values) {
    var sql = deleteSql;

    sql = sql.replaceFirst('%TABLE%', _parseTable(options));
    sql = sql.replaceFirst('%USING%', _parseUsing(options));
    sql = sql.replaceFirst('%EXTRA%', _parseExtra(options));
    sql = sql.replaceFirst('%FIELD%', _parseField(options));
    sql = sql.replaceFirst('%JOIN%', _parseJoin(options));
    sql = sql.replaceFirst('%WHERE%', _parseWhere(options, values));
    sql = sql.replaceFirst('%HAVING%', _parseHaving(options, values));
    sql = sql.replaceFirst('%ORDER%', _parseOrder(options));
    sql = sql.replaceFirst('%LIMIT%', _parseLimit(options, values));
    sql = sql.replaceFirst('%UNION%', _parseUnion(options));
    sql = sql.replaceFirst('%LOCK%', _parseLock(options));
    sql = sql.replaceFirst('%COMMENT%', _parseComment(options));
    sql = sql.replaceFirst('%FORCE%', _parseForce(options));

    return sql;
  }

  static String _parseData(Map<String, dynamic> options, List<dynamic> values) {
    if (!options.containsKey("data")) return "";

    List<dynamic> data = [];
    try {
      data = options["data"] as List<dynamic>;
    } catch (e) {
      throw 'data for parseData is not list';
    }

    values.addAll(data);
    return data.map((e) => "?").join(",");
  }

  static String _parseSet(Map<String, dynamic> options, List<dynamic> values) {
    if (!options.containsKey("set")) return "";

    List<String> list = [];
    Map<String, dynamic> map = Map<String, dynamic>.from(options["set"]);

    map.forEach((key, value) {
      if (value.runtimeType == DbRaw) {
        list.add(key + "=" + (value as DbRaw).raw);
      } else {
        list.add(key + "=?");
        values.add(value);
      }
    });

    return list.join(",");
  }

  static String _parseTable(Map<String, dynamic> options) {
    if (!options.containsKey("table")) return "";

    return options['table'].toString();
  }

  static String _parseDistinct(Map<String, dynamic> options) {
    if (!options.containsKey("distinct")) return "";

    bool distinct = false;
    try {
      distinct = options["distinct"] as bool;
    } catch (e) {
      throw 'distinct for parseDistinct is not bool';
    }

    return distinct ? " Distinct" : "";
  }

  static String _parseExtra(Map<String, dynamic> options) {
    if (!options.containsKey("extra")) return "";

    return "";
  }

  static String _parseField(Map<String, dynamic> options) {
    if (!options.containsKey("field")) return "*";

    return options["field"].toString();
  }

  static String _parseAlias(Map<String, dynamic> options) {
    if (!options.containsKey("alias")) return "";

    return " " + options["alias"].toString();
  }

  static String _parseJoin(Map<String, dynamic> options) {
    if (!options.containsKey("join")) return "";

    List<List<String>> list = [];
    try {
      list = options["join"] as List<List<String>>;
    } catch (e) {
      throw 'list for parseJoin is not List<List<String>>';
    }

    return list
        .map((e) {
          return " " + e[2].toUpperCase() + " JOIN " + e[0] + " ON " + e[1];
        })
        .toList()
        .join();
  }

  static String _parseWhere(Map<String, dynamic> options, List values) {
    if (!options.containsKey("where")) return "";

    List<DbColumn> list = [];
    try {
      list = options["where"] as List<DbColumn>;
    } catch (e) {
      throw 'list for parseWhere is not List<DbColumn>';
    }

    if (list.length == 0) return "";

    List<String> l = list.map((e) => _parseWhereItem(e, values)).toList();

    return " WHERE " + l.join(" AND ");
  }

  static String _parseWhereItem(DbColumn item, List values) {
    String optName = item.optName.toUpperCase();

    if (['=', '!=', '<>', '>', '<', '>=', '<='].contains(optName)) {
      values.add(item.fieldVal);
      return item.fieldName + ' ' + optName + ' ' + '?';
    }

    if (['IN', 'NOT IN'].contains(optName)) {
      List inValue = item.fieldVal;
      values.addAll(inValue);

      String s = inValue.map((e) => '?').toList().join(',');
      s = '(' + s + ')';

      return item.fieldName + ' ' + optName + ' ' + s;
    }

    if (['BETWEEN', 'NOT BETWEEN'].contains(optName)) {
      List inValue = item.fieldVal;
      values.addAll(inValue);

      String s = inValue.map((e) => '?').toList().join(' AND ');
      return item.fieldName + ' ' + optName + ' ' + s;
    }

    if (['LIKE', 'NOT LIKE'].contains(optName)) {
      String s = item.fieldVal.toString();

      List<String> l = [];
      for (int i = 0; i < s.length; i++) {
        if (s[i] != '%') l.add(s[i]);
      }
      String value = l.join();
      values.add(value);

      s = s.replaceAll(value, '?');
      s = 'concat(' + s.split('').join(',').replaceAll("%", "'%'") + ')';

      return item.fieldName + ' ' + optName + ' ' + s;
    }

    if ('EXP' == optName) {
      String s = item.fieldVal.toString();
      return item.fieldName + s;
    }

    return "";
  }

  static String _parseGroup(Map<String, dynamic> options) {
    if (!options.containsKey("group")) return "";

    return " GROUP BY " + options["group"].toString();
  }

  static String _parseHaving(Map<String, dynamic> options, List values) {
    if (!options.containsKey("having")) return "";

    List<DbColumn> list = [];
    try {
      list = options["having"] as List<DbColumn>;
    } catch (e) {
      throw 'list for parseHaving is not List<DbColumn>';
    }

    if (list.length == 0) return "";

    List<String> l = list.map((e) => _parseWhereItem(e, values)).toList();

    return " HAVING " + l.join(" AND ");
  }

  static String _parseOrder(Map<String, dynamic> options) {
    if (!options.containsKey("order")) return "";

    return " ORDER BY " + options["order"].toString();
  }

  static String _parseLimit(Map<String, dynamic> options, List values) {
    if (!options.containsKey("limit")) return "";

    values.addAll(options["limit"]);

    return " LIMIT ?,?";
  }

  static String _parseUnion(Map<String, dynamic> options) {
    if (!options.containsKey("union")) return "";

    return "";
  }

  static String _parseLock(Map<String, dynamic> options) {
    if (!options.containsKey("lock")) return "";

    bool lock = false;
    try {
      lock = options["lock"] as bool;
    } catch (e) {
      throw 'lock for parseLock is not bool';
    }

    return lock ? " FOR UPDATE" : "";
  }

  static String _parseUsing(Map<String, dynamic> options) {
    if (!options.containsKey("using")) return "";

    return "";
  }

  static String _parseComment(Map<String, dynamic> options) {
    if (!options.containsKey("comment")) return "";

    return " COMMENT " + options["comment"].toString();
  }

  static String _parseForce(Map<String, dynamic> options) {
    if (!options.containsKey("force")) return "";

    return " FORCE INDEX " + options["force"].toString();
  }
}
  ''';
}
