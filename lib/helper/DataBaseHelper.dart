import 'dart:io';

import 'PackageHelper.dart';

class DataBaseHelper {
  static void analyseFile() {
    print('database helper run');

    List<String> fileList = [];
    String appPath = PackageHelper.getRootPath() + '/lib/extend/model';

    _allFile(fileList, appPath);

    List<TableStruct> tableStructList = [];

    fileList.forEach((fileName) {
      var fileContent = File(fileName).readAsStringSync();
      _handleTableStructList(fileName, fileContent, tableStructList);
    });
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

  static void _handleTableStructList(
      String fileName, String fileContent, List<TableStruct> routeStructList) {
    RegExp exp = RegExp(r'@FieldMeta.*?;', multiLine: true, dotAll: true);

    Iterable<Match> matchs = exp.allMatches(fileContent);

    for (Match m in matchs) {
      String fieldMetaAndFieldName = m.group(0).toString();

      Map<String, dynamic> fieldMap = _getFieldMap(fieldMetaAndFieldName);
      print(fieldMap);

      //List<String> l = m.group(1).toString().split(',');
      //String path = l[0].replaceAll('\'', '').replaceAll(' ', '');
      //String method = l[1].replaceAll('\'', '').replaceAll(' ', '');
      //String functionName = m.group(2).toString();
      //routeStructList.add(TableStruct());
    }
  }

  static Map<String, dynamic> _getFieldMap(String fieldMetaAndFieldName) {
    Map<String, dynamic> fieldMap = {};

    String fieldMeta = RegExp(r'@FieldMeta.*\)', multiLine: true, dotAll: true)
        .firstMatch(fieldMetaAndFieldName)
        .group(0)
        .toString()
        .trim();
    String fieldName = fieldMetaAndFieldName.replaceFirst(fieldMeta, '').trim();

    print('------');
    //print(fieldName);

    fieldMeta = fieldMeta.replaceFirst('@FieldMeta(', '');
    fieldMeta = fieldMeta.substring(0, fieldMeta.length - 1);

    fieldMeta.split(',').map((e) {
      print(e);
      //List<String> ss = e.split(':');

      //print(ss);
      //fieldMap[ss[0]] = ss[1];
    });

    //print(fieldMap);

    return fieldMap;
  }
}

class TableStruct {}
