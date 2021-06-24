import 'dart:io';

import 'package:yaml/yaml.dart';

import '../PackageHelper.dart';
import 'DataFieldHelper.dart';
import 'package:mysql1/mysql1.dart';

class DataBaseHelper {
  static Future<void> analyseFile() async {
    List<Map<String, dynamic>> allTableStructLocal = _getTableStructFromLocal();

    String devYaml = PackageHelper.getRootPath() + '/env/dev.yaml';
    var devMap = loadYaml(File(devYaml).readAsStringSync());

    await _syncTableField(allTableStructLocal, devMap);
  }

  /// 同步本地数据结构到数据库
  static Future<void> _syncTableField(
      List<Map<String, dynamic>> allTableStructLocal, dynamic devMap) async {
    List<String> sqlList = [];

    MySqlConnection conn = await _getConn(devMap);

    Map<String, Map<String, dynamic>> tableStruckDb =
        await _getTableStruckFromDb(conn, devMap['dbName'].toString());

    List<Map<String, dynamic>> insertTableStructLocal = [];
    List<Map<String, dynamic>> updateTableStructLocal = [];
    allTableStructLocal.forEach((tableStructLocal) {
      String tableName = tableStructLocal['name'].toString();
      if (tableStruckDb.keys.contains(tableName)) {
        updateTableStructLocal.add(tableStructLocal);
      } else {
        insertTableStructLocal.add(tableStructLocal);
      }
    });

    //不存在的表,新建
    if (insertTableStructLocal.isNotEmpty) {
      insertTableStructLocal.forEach((element) {
        sqlList.add(DataFieldHelper.buildSql(element));
      });
    }

    //存在的表,新建字段或者修改字段,新建索引或者修改索引
    if (updateTableStructLocal.isNotEmpty) {
      Map<String, Map<String, dynamic>> fieldStruckDb =
          await _getFieldStruckFromDb(conn, devMap['dbName'].toString());

      updateTableStructLocal.forEach((table) {
        (table['fieldList'] as List<dynamic>).forEach((fieldDynamic) {
          Map<String, dynamic> field = Map<String, dynamic>.from(fieldDynamic);

          String key =
              table['name'].toString() + '|' + field['name'].toString();

          if (!fieldStruckDb.containsKey(key)) {
            sqlList.add(_getAddOrModifyFieldSql(table, field, 'ADD'));
          } else {
            Map<String, dynamic> fieldDb = fieldStruckDb[key];
            Map<String, dynamic> fieldLocal =
                _getFieldMapFromLocal(table, field);

            bool isSame = fieldDb.toString() == fieldLocal.toString();

            if (!isSame) {
              if (fieldDb['COLUMN_KEY'].toString() ==
                  fieldLocal['COLUMN_KEY'].toString()) {
                sqlList.add(_getAddOrModifyFieldSql(table, field, 'MODIFY'));
              } else {
                //删掉已有的
                if (fieldDb['COLUMN_KEY'].toString() != '') {
                  sqlList.add('alter table ' +
                      table['name'].toString() +
                      ' drop index ' +
                      field['name'].toString());
                }

                //增加新的
                if (fieldLocal['COLUMN_KEY'].toString() != '') {
                  String key = '';

                  if ('PRI' == fieldLocal['COLUMN_KEY'].toString()) {
                    key = 'primary key';
                  }

                  if ('UNI' == fieldLocal['COLUMN_KEY'].toString()) {
                    key = 'unique';
                  }

                  if ('MUL' == fieldLocal['COLUMN_KEY'].toString()) {
                    key = 'index';
                  }

                  sqlList.add('alter table ' +
                      table['name'].toString() +
                      ' add ' +
                      key +
                      ' (' +
                      field['name'].toString() +
                      ')');
                }
              }
            }
          }
        });
      });
    }

    if (sqlList.isNotEmpty) {
      print('database stuck should be modify');
      sqlList.forEach((sql) async {
        print(sql);
        await conn.query(sql);
      });
    }
  }

  /// 生成添加或者修改字段SQL语句
  static String _getAddOrModifyFieldSql(
      Map<String, dynamic> table, Map<String, dynamic> field, String optType) {
    Map<String, dynamic> fieldMapFromLocal =
        _getFieldMapFromLocal(table, field);

    String sql = 'ALTER TABLE ' +
        table['name'].toString() +
        ' $optType ' +
        field['name'].toString();

    fieldMapFromLocal.keys.forEach((keyItem) {
      sql += _fieldTag(
          table['type'].toString(), keyItem, fieldMapFromLocal[keyItem]);
    });

    return sql;
  }

  /// 从本地数据读取字段结构
  static Map<String, dynamic> _getFieldMapFromLocal(
      Map<String, dynamic> table, Map<String, dynamic> field) {
    String COLUMN_KEY = '';
    if ('primary key' == field['key'].toString()) COLUMN_KEY = 'PRI';
    if ('unique key' == field['key'].toString()) COLUMN_KEY = 'UNI';
    if ('key' == field['key'].toString()) COLUMN_KEY = 'MUL';

    return {
      'TABLE_NAME': table['name'].toString(),
      'COLUMN_NAME': field['name'].toString(),
      'DATA_TYPE': field['type'].toString(),
      'COLUMN_TYPE':
          field['type'].toString() + '(' + field['length'].toString() + ')',
      'CHARACTER_SET_NAME': field['character'].toString(),
      'COLLATION_NAME': field['collation'].toString(),
      'IS_NULLABLE': field['nullAble'].toString(),
      'COLUMN_DEFAULT': field['def'].toString(),
      'COLUMN_KEY': COLUMN_KEY,
      'COLUMN_COMMENT': field['comment'].toString(),
    };
  }

  /// 从数据库中读取字段结构
  static Future<Map<String, Map<String, dynamic>>> _getFieldStruckFromDb(
      MySqlConnection conn, String dataBaseName) async {
    Results results = await conn.query('''
    SELECT
    A.TABLE_NAME,
    A.COLUMN_NAME,
    A.DATA_TYPE,
    A.COLUMN_TYPE,
    A.CHARACTER_SET_NAME,
    A.COLLATION_NAME,
    A.IS_NULLABLE,
    A.COLUMN_DEFAULT,
    A.COLUMN_KEY,
    A.COLUMN_COMMENT
    FROM INFORMATION_SCHEMA.COLUMNS A
    WHERE A.TABLE_SCHEMA='$dataBaseName'
    ORDER BY A.TABLE_NAME,A.ORDINAL_POSITION
    ''');

    Map<String, Map<String, dynamic>> map = {};
    results.forEach((element) {
      String key = element.fields['TABLE_NAME'].toString() +
          '|' +
          element.fields['COLUMN_NAME'].toString();
      map[key] = element.fields;
    });

    return map;
  }

  /// 从数据库中读取表结构
  static Future<Map<String, Map<String, dynamic>>> _getTableStruckFromDb(
      MySqlConnection conn, String dataBaseName) async {
    Results results = await conn.query('''
    SELECT
    A.TABLE_NAME
    FROM INFORMATION_SCHEMA.TABLES A
    WHERE A.TABLE_SCHEMA='$dataBaseName'
    ORDER BY A.TABLE_NAME
    ''');

    Map<String, Map<String, dynamic>> map = {};
    results.forEach((element) {
      String key = element.fields['TABLE_NAME'].toString();
      map[key] = element.fields;
    });

    return map;
  }

  /// 获取数据库连接
  static Future<MySqlConnection> _getConn(dynamic devMap) async {
    var settings = ConnectionSettings(
        host: devMap['dbHost'].toString(),
        port: int.parse(devMap['dbPort'].toString()),
        user: devMap['dbUser'].toString(),
        password: devMap['dbPassword'].toString(),
        db: devMap['dbName'].toString());
    MySqlConnection conn = await MySqlConnection.connect(settings);

    return conn;
  }

  /// 从本地文件读取表结构与字段结构
  static List<Map<String, dynamic>> _getTableStructFromLocal() {
    List<String> fileList = [];
    String appPath = PackageHelper.getRootPath() + '/lib/extend/model';

    _allFile(fileList, appPath);

    List<Map<String, dynamic>> tableStruct = [];
    fileList.forEach((fileName) {
      var fileContent = File(fileName).readAsStringSync();
      Map<String, dynamic> tableMap =
          _handleTableStructList(fileName, fileContent);
      tableStruct.add(tableMap);
    });

    return tableStruct;
  }

  /// 从本地文件读取表结构与字段结构,遍历给定目录的所有文件
  static void _allFile(List<String> fileList, String path) {
    Directory(path).listSync().forEach((element) {
      if (element.path.contains('.')) {
        fileList.add(element.path.replaceAll('\\', '/'));
      } else {
        _allFile(fileList, element.path);
      }
    });
  }

  /// 从本地文件读取表结构与字段结构,正则匹配表结构与字段结构
  static Map<String, dynamic> _handleTableStructList(
      String fileName, String fileContent) {
    String tableMetaAndClassName =
        RegExp(r'@TableMeta.*?\{', multiLine: true, dotAll: true)
            .firstMatch(fileContent)
            .group(0)
            .toString()
            .trim();
    Map<String, dynamic> tableMap = _getTableMap(tableMetaAndClassName);
    tableMap['fieldList'] = [];

    Iterable<Match> matchs =
        RegExp(r'@FieldMeta.*?;', multiLine: true, dotAll: true)
            .allMatches(fileContent);
    for (Match m in matchs) {
      String fieldMetaAndFieldName = m.group(0).toString();
      Map<String, dynamic> fieldMap = _getFieldMap(fieldMetaAndFieldName);
      tableMap['fieldList'].add(fieldMap);
    }

    return tableMap;
  }

  /// 从本地文件读取表结构与字段结构,正则匹配表结构与字段结构-表结构
  static Map<String, dynamic> _getTableMap(String tableMetaAndClassName) {
    Map<String, dynamic> tableMap = {};

    String tableMeta = RegExp(r'@TableMeta.*\)', multiLine: true, dotAll: true)
        .firstMatch(tableMetaAndClassName)
        .group(0)
        .toString()
        .trim();
    String className = tableMetaAndClassName.replaceFirst(tableMeta, '').trim();

    tableMeta = tableMeta.replaceFirst('@TableMeta(', '');
    tableMeta = tableMeta.substring(0, tableMeta.length - 1);
    tableMeta.split(',').forEach((e) {
      List<String> ss = e.trim().split(':');
      tableMap[ss[0].trim()] =
          ss[1].trim().replaceAll('\'', '').replaceAll('\"', '');
    });

    className = className
        .replaceAll('class', '')
        .replaceAll('{', '')
        .replaceAll(' ', '');
    if (!tableMap.containsKey('name')) {
      tableMap['name'] = _strToUnderLine(className).substring(1);
    }

    return tableMap;
  }

  /// 从本地文件读取表结构与字段结构,正则匹配表结构与字段结构-字段结构
  static Map<String, dynamic> _getFieldMap(String fieldMetaAndFieldName) {
    Map<String, dynamic> fieldMap = {};

    String fieldMeta = RegExp(r'@FieldMeta.*\)', multiLine: true, dotAll: true)
        .firstMatch(fieldMetaAndFieldName)
        .group(0)
        .toString()
        .trim();
    String fieldName = fieldMetaAndFieldName.replaceFirst(fieldMeta, '').trim();

    fieldMeta = fieldMeta.replaceFirst('@FieldMeta(', '');
    fieldMeta = fieldMeta.substring(0, fieldMeta.length - 1);
    fieldMeta.split(',').forEach((e) {
      List<String> ss = e.trim().split(':');
      fieldMap[ss[0].trim()] =
          ss[1].trim().replaceAll('\'', '').replaceAll('\"', '');
    });

    List<String> fieldNameSplit = fieldName.replaceFirst(';', '').split(' ');
    if (!fieldMap.containsKey('type')) {
      if (fieldNameSplit[0] == 'String') fieldMap['type'] = 'varchar';
      if (fieldNameSplit[0] == 'int') fieldMap['type'] = 'int';
    }

    if (!fieldMap.containsKey('name')) {
      fieldMap['name'] = _strToUnderLine(fieldNameSplit[1]);
    }

    if (!fieldMap.containsKey('length')) {
      if (fieldMap['type'] == 'varchar') fieldMap['length'] = '255';
      if (fieldMap['type'] == 'int') fieldMap['length'] = '11';
      if (fieldMap['type'] == 'bigint') fieldMap['length'] = '20';
    }

    if (!fieldMap.containsKey('comment')) {
      fieldMap['comment'] = '';
    }

    if (fieldMap['type'] == 'varchar') {
      if (!fieldMap.containsKey('character')) {
        fieldMap['character'] = 'utf8mb4';
      }

      if (!fieldMap.containsKey('collation')) {
        fieldMap['collation'] = 'utf8mb4_general_ci';
      }
    }

    if (!fieldMap.containsKey('nullAble')) {
      fieldMap['nullAble'] = 'NO';
    }

    return fieldMap;
  }

  /// 字符串驼峰转下划线
  static String _strToUnderLine(String str) {
    List<String> l = [];
    for (var i = 0; i < str.length; i++) {
      if (str[i] != str[i].toLowerCase()) {
        l.add('_');
      }

      l.add(str[i].toLowerCase());
    }
    return l.join();
  }

  /// 字段信息
  static String _fieldTag(String dataType, String keyItem, dynamic valueItem) {
    String sql = '';

    if ('COLUMN_TYPE' == keyItem) {
      sql += ' ' + valueItem.toString();
    }

    if (dataType == 'varchar') {
      if ('CHARACTER_SET_NAME' == keyItem) {
        sql += ' CHARACTER SET ' + valueItem.toString();
      }

      if ('COLLATION_NAME' == keyItem) {
        sql += ' COLLATE ' + valueItem.toString();
      }
    }

    if ('IS_NULLABLE' == keyItem) {
      sql += ' NOT NULL';
    }

    if ('COLUMN_DEFAULT' == keyItem) {
      sql += ' DEFAULT \'' + valueItem.toString() + '\'';
    }

    if ('COLUMN_COMMENT' == keyItem) {
      sql += ' COMMENT \'' + valueItem.toString() + '\'';
    }

    if ('COLUMN_KEY' == keyItem) {
      sql += valueItem.toString();
    }

    return sql;
  }
}
