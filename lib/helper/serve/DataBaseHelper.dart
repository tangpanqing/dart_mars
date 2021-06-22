import 'dart:io';

import 'package:yaml/yaml.dart';

import '../PackageHelper.dart';
import 'DataFieldHelper.dart';

class DataBaseHelper {
  static void analyseFile() {
    List<Map<String, dynamic>> allTableStruct = _allTableStruct();

    List<String> sqlList = allTableStruct.map((e) {
      return DataFieldHelper.buildSql(e);
    }).toList();
    //print(sqlList);

    String devYaml = PackageHelper.getRootPath() + '/env/dev.yaml';
    String prodYaml = PackageHelper.getRootPath() + '/env/prod.yaml';
    String testYaml = PackageHelper.getRootPath() + '/env/test.yaml';

    var devMap = loadYaml(File(devYaml).readAsStringSync());
    var prodMap = loadYaml(File(prodYaml).readAsStringSync());
    var testMap = loadYaml(File(testYaml).readAsStringSync());

    print(devMap['dbHost']);
    print(prodMap['dbHost']);
    print(testMap['dbHost']);

    List<dynamic> list = [];
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
