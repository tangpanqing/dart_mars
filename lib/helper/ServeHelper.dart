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
    analyseFile();
    //runServe(arguments);
  }

  static void analyseFile() {
    var appPath = PackageHelper.getRootPath() + '/lib/app';
    List<String> fileList = [];
    allFile(fileList, appPath);

    List<RouteStru> routeStruList = [];

    fileList.forEach((fileName) {
      var fileContent = File(fileName).readAsStringSync();
      //print(fileContent);

      RegExp exp = RegExp(r"@RouteMeta\((.*?)\).*?void\s+(\w+)\(.*?{",
          multiLine: true, dotAll: true);
      //print(exp.isMultiLine);
      //print(exp.isCaseSensitive);

      Iterable<Match> mobiles = exp.allMatches(fileContent);
      for (Match m in mobiles) {
        //print(m.group(0));
        List<String> l = m.group(1).toString().split(',');
        String path = l[0].replaceAll('\'', '').replaceAll(' ', '');
        String method = l[1].replaceAll('\'', '').replaceAll(' ', '');
        String functionName = m.group(2).toString();

        routeStruList.add(RouteStru(path, method, functionName));
      }
    });

    print(routeStruList);
  }

  static void allFile(List<String> fileList, String path) {
    Directory(path).listSync().forEach((element) {
      if (element.path.contains('.')) {
        fileList.add(element.path.replaceAll('\\', '/'));
      } else {
        allFile(fileList, element.path);
      }
    });
  }

  static void runServe(List<String> arguments) {
    var str = 'dart run bin\\' +
        PackageHelper.getPackageName() +
        '.dart ' +
        arguments.join(' ');

    Shell().run(str);
  }
}
