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
    _analyseFile();
    //_runServe(arguments);
  }

  static void _analyseFile() {
    List<String> fileList = [];
    String appPath = PackageHelper.getRootPath() + '/lib/app';

    _allFile(fileList, appPath);

    List<RouteStruct> routeStructList = [];

    fileList.forEach((fileName) {
      var fileContent = File(fileName).readAsStringSync();
      _handleRouteStructList(fileName, fileContent, routeStructList);
    });

    _replaceRouteConfig(routeStructList);
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
    RegExp exp = RegExp(r"@RouteMeta\((.*?)\).*?void\s+(\w+)\(.*?{",
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

  static void _replaceRouteConfig(List<RouteStruct> routeStructList) {
    var routePath = PackageHelper.getRootPath() + '/lib/config/route.dart';
    File file = File(routePath);

    List<String> fileNameList = [];
    routeStructList.forEach((element) {
      if (!fileNameList.contains(element.fileName))
        fileNameList.add(element.fileName);
    });

    file.writeAsStringSync('');
    file.writeAsStringSync('/// \n', mode: FileMode.append);
    file.writeAsStringSync(
        '/// don\'t modify this file yourself, this file will be replace by program\n',
        mode: FileMode.append);
    file.writeAsStringSync(
        '/// for more infomation, see dart pub global run dart_mars --serve \n',
        mode: FileMode.append);
    file.writeAsStringSync(
        '/// last replace time ' + DateTime.now().toString() + ' \n',
        mode: FileMode.append);
    file.writeAsStringSync('/// \n', mode: FileMode.append);
    file.writeAsStringSync('import \'../bootstrap/helper/RouteHelper.dart\';\n',
        mode: FileMode.append);

    fileNameList.forEach((element) {
      element = element.replaceAll(PackageHelper.getRootPath() + '/lib/', '');
      file.writeAsStringSync(
          'import \'../' + element + '\' as ' + _fileTag(element) + ';\n',
          mode: FileMode.append);
    });

    file.writeAsStringSync('\n', mode: FileMode.append);
    file.writeAsStringSync('void loadRoute(){\n', mode: FileMode.append);

    routeStructList.forEach((element) {
      file.writeAsStringSync('  ', mode: FileMode.append);

      file.writeAsStringSync(_routeLine(element) + '\n', mode: FileMode.append);
    });

    file.writeAsStringSync('}', mode: FileMode.append);
  }

  static String _fileTag(String element) {
    element = element.replaceAll(PackageHelper.getRootPath() + '/lib/', '');
    element = element.replaceAll('.dart', '');
    element = element.replaceAll('/', '_');
    return element;
  }

  static String _routeLine(RouteStruct element) {
    String tag = _fileTag(element.fileName);
    String file = tag.split('_').last;

    var sb = StringBuffer();
    sb
      ..write('RouteHelper(')
      ..write('\'')
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
