import 'dart:core';
import 'dart:io';

import 'package:process_run/shell.dart';
import 'PackageHelper.dart';

class RouteStru {
  String path;
  String method;
  String functionName;

  RouteStru(this.path, this.method, this.functionName);
}

class ServeHelper {
  static void run(List<String> arguments) {
    _analyseFile();
    //_runServe(arguments);
  }

  static void _analyseFile() {
    var appPath = PackageHelper.getRootPath() + '/lib/app';

    List<String> fileList = [];
    _allFile(fileList, appPath);

    List<RouteStru> routeStruList = [];
    fileList.forEach((fileName) {
      var fileContent = File(fileName).readAsStringSync();

      RegExp exp = RegExp(r"@RouteMeta\((.*?)\).*?void\s+(\w+)\(.*?{",
          multiLine: true, dotAll: true);

      Iterable<Match> mobiles = exp.allMatches(fileContent);
      for (Match m in mobiles) {
        List<String> l = m.group(1).toString().split(',');
        String path = l[0].replaceAll('\'', '').replaceAll(' ', '');
        String method = l[1].replaceAll('\'', '').replaceAll(' ', '');
        String functionName =
            fileName.replaceAll('.dart', '.') + m.group(2).toString();

        routeStruList.add(RouteStru(path, method, functionName));
      }
    });

    List<String> routeContentList = [];
    routeStruList.forEach((routeStru) {
      routeContentList.add('RouteHelper(\'' +
          routeStru.path +
          '\',' +
          routeStru.functionName +
          ');');
    });

    var routePath = PackageHelper.getRootPath() + '/lib/config/route.dart';
    String content = File(routePath).readAsStringSync();
    File(routePath).writeAsStringSync(content.replaceAll('}', ''));

    routeStruList.forEach((element) {
      File(routePath).writeAsStringSync(
          '  RouteHelper(\'' +
              element.path +
              '\', ' +
              element.functionName.split('/').last +
              ');\n',
          mode: FileMode.append);
    });

    File(routePath).writeAsStringSync('}', mode: FileMode.append);
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

  static void _runServe(List<String> arguments) {
    var str = 'dart run bin\\' +
        PackageHelper.getPackageName() +
        '.dart ' +
        arguments.join(' ');

    Shell().run(str);
  }
}
