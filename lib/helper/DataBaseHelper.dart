import 'dart:io';

import 'PackageHelper.dart';

class DataBaseHelper {
  static void analyseFile() {
    List<Map<String, dynamic>> allTableStruct = _allTableStruct();
    //print(allTableStruct);

    List<String> sqlList = allTableStruct.map((e) {
      String s = _buildSql(e);
      print('-------------');
      print('-------------');
      print(s);
      print('-------------');
      print('-------------');
      return s;
    }).toList();
    //print(sqlList);
  }

  static String _buildSql(Map<String, dynamic> map) {
    String name = map['name'].toString();

    var sb = StringBuffer();
    sb.write('CREATE TABLE IF NOT EXISTS \`$name\` (\n');

    //循环字段
    (map['fieldList'] as List<dynamic>).forEach((element) {
      sb.write(_buildField(Map<String, dynamic>.from(element)));
    });

    //循环索引
    (map['fieldList'] as List<dynamic>).forEach((element) {
      sb.write(_buildIndex(Map<String, dynamic>.from(element)));
    });

    sb.write(') ENGINE=InnoDB DEFAULT CHARSET=utf8;');

    return sb.toString();
  }

  static String _buildField(Map<String, dynamic> m) {
    var sb = StringBuffer();
    sb.write(_pareFieldName(m));
    sb.write(' ' + _pareFieldType(m));
    sb.write(' NOT NULL');
    sb.write(' ' + _pareFieldDefault(m));
    sb.write(' ' + _pareFieldAutoIncrease(m));
    sb.write(' ' + _pareFieldComment(m));
    sb.write(',\n');

    return sb.toString();
  }

  static String _pareFieldName(Map<String, dynamic> m) {
    String name = m['name'].toString();
    return '`' + name + '`';
  }

  static String _pareFieldType(Map<String, dynamic> m) {
    String type = m['type'].toString();

    String length = m.containsKey('length')
        ? m['length'].toString()
        : (type == 'varchar' ? '200' : '11');

    return type + '(' + length + ')';
  }

  static String _pareFieldDefault(Map<String, dynamic> m) {
    String type = m['type'].toString();

    return 'DEFAULT \'' + (type == 'varchar' ? '' : '0') + '\'';
  }

  static String _pareFieldAutoIncrease(Map<String, dynamic> m) {
    String autoIncrease =
        (m.containsKey('autoIncrease') && m['autoIncrease'] == 'true')
            ? 'AUTO_INCREMENT'
            : '';

    return autoIncrease;
  }

  static String _pareFieldComment(Map<String, dynamic> m) {
    String comment = m.containsKey('comment')
        ? 'COMMENT \'' + m['comment'].toString() + '\''
        : '';

    return comment;
  }

  static String _buildIndex(Map<String, dynamic> m) {
    return '';
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
