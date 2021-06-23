import 'dart:io';

import 'package:yaml/yaml.dart';

import '../PackageHelper.dart';
import 'DataFieldHelper.dart';
import 'package:mysql1/mysql1.dart';

class DataBaseHelper {
  static Future<void> analyseFile() async {
    List<Map<String, dynamic>> allTableStruct = _allTableStruct();

    // List<String> sqlList = allTableStruct.map((e) {
    //   return DataFieldHelper.buildSql(e);
    // }).toList();
    //print(sqlList);

    Map<String, Map<String, dynamic>> dataBaseStruck =
        await _getDataBaseStruck();

    List<Map<String, dynamic>> installList = [];

    allTableStruct.forEach((element) {
      String tableName = element['name'].toString();
      (element['fieldList'] as List<dynamic>).forEach((elementField) {
        Map<String, dynamic> elementFieldMap =
            Map<String, dynamic>.from(elementField);
        String fieldName = elementFieldMap['name'].toString();
        String key = tableName + '|' + fieldName;

        if (!dataBaseStruck.containsKey(key)) {
          installList.add({'table': element, 'field': elementField});
        } else {
          Map<String, dynamic> mapFromCode =
              _getFieldInfo(element, elementField);
          Map<String, dynamic> mapFromBase = dataBaseStruck[key];

          //print(mapFromCode);
          //print(mapFromBase);

          String sql = '';
          mapFromCode.keys.forEach((keyItem) {
            if (mapFromCode[keyItem].toString() !=
                mapFromBase[keyItem].toString()) {
              if ('COLUMN_COMMENT' == keyItem) {
                sql += ' COMMENT \'' + mapFromCode[keyItem].toString() + '\'';
              }

              if ('COLUMN_TYPE' == keyItem) {
                sql += ' ' + mapFromCode[keyItem].toString();
              }
            }
          });

          if (sql != '') {
            List<String> ss = key.split('|');
            sql = 'ALTER TABLE ' + ss[0] + ' MODIFY ' + ss[1] + sql;
            print(sql);
          }
        }
      });
    });

    print('--ok--');
  }

  static Map<String, dynamic> _getFieldInfo(
      Map<String, dynamic> table, Map<String, dynamic> field) {
    String COLUMN_KEY = '';
    if ('primary key' == field['index'].toString()) COLUMN_KEY = 'PRI';
    if ('unique key' == field['index'].toString()) COLUMN_KEY = 'UNI';
    if ('key' == field['index'].toString()) COLUMN_KEY = 'MUL';

    return {
      'TABLE_NAME': table['name'].toString(),
      'COLUMN_NAME': field['name'].toString(),
      'DATA_TYPE': field['type'].toString(),
      'COLUMN_TYPE':
          field['type'].toString() + '(' + field['length'].toString() + ')',
      'COLUMN_COMMENT': field['comment'].toString(),
      'COLUMN_KEY': COLUMN_KEY,
    };
  }

  static Future<Map<String, Map<String, dynamic>>> _getDataBaseStruck() async {
    String devYaml = PackageHelper.getRootPath() + '/env/dev.yaml';
    var devMap = loadYaml(File(devYaml).readAsStringSync());

    var settings = ConnectionSettings(
        host: devMap['dbHost'].toString(),
        port: int.parse(devMap['dbPort'].toString()),
        user: devMap['dbUser'].toString(),
        password: devMap['dbPassword'].toString(),
        db: devMap['dbName'].toString());
    MySqlConnection conn = await MySqlConnection.connect(settings);
    Results results = await conn.query('''
    SELECT
    A.TABLE_NAME,
    A.COLUMN_NAME,
    A.DATA_TYPE,
    A.COLUMN_TYPE,
    A.COLUMN_COMMENT,
    A.COLUMN_KEY
    FROM INFORMATION_SCHEMA.COLUMNS A
    WHERE A.TABLE_SCHEMA='flm_helper'
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

  static List<Map<String, dynamic>> _allTableStruct() {
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

  static void _allFile(List<String> fileList, String path) {
    Directory(path).listSync().forEach((element) {
      if (element.path.contains('.')) {
        fileList.add(element.path.replaceAll('\\', '/'));
      } else {
        _allFile(fileList, element.path);
      }
    });
  }

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

    return fieldMap;
  }

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
}

class TableStruct {}
