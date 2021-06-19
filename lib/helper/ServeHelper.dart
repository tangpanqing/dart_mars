import 'dart:core';
import 'dart:io';

import 'package:process_run/shell.dart';
import 'PackageHelper.dart';

class RouteStruct {
  String path;
  String method;
  String fileName;
  String functionName;

  RouteStruct(this.path, this.method, this.fileName, this.functionName);
}

class ServeHelper {
  static void run(List<String> arguments) {
    bool ispass = _analyseFile();
    if (ispass) {
      _runServe(arguments);
    } else {
      print('serve has been stop, some mistake has been print above');
    }
  }

  // ignore: omit_local_variable_types
  static bool _analyseFile() {
    List<String> fileList = [];
    String appPath = PackageHelper.getRootPath() + '/lib/app';

    _allFile(fileList, appPath);

    List<RouteStruct> routeStructList = [];

    fileList.forEach((fileName) {
      var fileContent = File(fileName).readAsStringSync();
      _handleRouteStructList(fileName, fileContent, routeStructList);
    });

    bool ispass = _checkRouteStruct(routeStructList);
    if (ispass) _replaceRouteConfig(routeStructList);
    return ispass;
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

  static void _handleRouteStructList(
      String fileName, String fileContent, List<RouteStruct> routeStructList) {
    RegExp exp = RegExp(r'@RouteMeta\((.*?)\).*?void\s+(\w+)\(.*?{',
        multiLine: true, dotAll: true);

    Iterable<Match> matchs = exp.allMatches(fileContent);

    for (Match m in matchs) {
      List<String> l = m.group(1).toString().split(',');
      String path = l[0].replaceAll('\'', '').replaceAll(' ', '');
      String method = l[1].replaceAll('\'', '').replaceAll(' ', '');
      String functionName = m.group(2).toString();

      routeStructList.add(RouteStruct(path, method, fileName, functionName));
    }
  }

  static bool _checkRouteStruct(List<RouteStruct> routeStructList) {
    bool isPass = true;
    Map<String, List<String>> map = {};

    routeStructList.forEach((element) {
      if (!map.containsKey(element.path)) map[element.path] = [];
      map[element.path].add(element.fileName);
    });

    map.forEach((key, value) {
      if (value.length > 1) {
        isPass = false;
        print('duplicate route path ' +
            key +
            ' was found, please check it from these files:');
        value.forEach((element) {
          print(element);
        });
      }
    });

    return isPass;
  }

  static void _replaceRouteConfig(List<RouteStruct> routeStructList) {
    var routePath = PackageHelper.getRootPath() + '/lib/config/route.dart';
    File file = File(routePath);

    List<String> fileNameList = [];
    routeStructList.forEach((element) {
      if (!fileNameList.contains(element.fileName)) {
        fileNameList.add(element.fileName);
      }
    });

    file.writeAsStringSync('');

    file.writeAsStringSync('import \'../bootstrap/helper/RouteHelper.dart\';\n',
        mode: FileMode.append);

    fileNameList.forEach((element) {
      element = element.replaceAll(PackageHelper.getRootPath() + '/lib/', '');
      file.writeAsStringSync(_importLine(element) + '\n',
          mode: FileMode.append);
    });

    file.writeAsStringSync('\n', mode: FileMode.append);

    file.writeAsStringSync('/// \n', mode: FileMode.append);
    file.writeAsStringSync(
        '/// don\'t modify this file yourself, this file content will be replace by DartMars\n',
        mode: FileMode.append);
    file.writeAsStringSync('/// \n', mode: FileMode.append);
    file.writeAsStringSync('/// for more infomation, see doc about Route \n',
        mode: FileMode.append);
    file.writeAsStringSync('/// \n', mode: FileMode.append);
    file.writeAsStringSync(
        '/// last replace time ' + DateTime.now().toString() + ' \n',
        mode: FileMode.append);
    file.writeAsStringSync('/// \n', mode: FileMode.append);

    file.writeAsStringSync('void configRoute(){\n', mode: FileMode.append);

    routeStructList.forEach((element) {
      file.writeAsStringSync('  ', mode: FileMode.append);

      file.writeAsStringSync(_routeLine(element) + '\n', mode: FileMode.append);
    });

    file.writeAsStringSync('}', mode: FileMode.append);

    print('route config file has been updated, see ./lib/config/route.dart');
  }

  static String _fileTag(String element) {
    element = element.replaceAll(PackageHelper.getRootPath() + '/lib/', '');
    element = element.replaceAll('.dart', '');
    element = element.replaceAll('/', '_');
    return element;
  }

  static String _importLine(String element) {
    var sb = StringBuffer();
    sb
      ..write('import')
      ..write(' \'../')
      ..write(element)
      ..write('\'')
      ..write(' as ')
      ..write(_fileTag(element))
      ..write(';');
    return sb.toString();
  }

  static String _routeLine(RouteStruct element) {
    String tag = _fileTag(element.fileName);
    String file = tag.split('_').last;

    var sb = StringBuffer();
    sb
      ..write('RouteHelper.add(')
      ..write('\'')
      ..write(element.method)
      ..write('\', \'')
      ..write(element.path)
      ..write('\', ')
      ..write(tag)
      ..write('.')
      ..write(file)
      ..write('.')
      ..write(element.functionName)
      ..write(');');
    return sb.toString();
  }
}
