import 'dart:io';
import './template/Bin.dart';
import './template/Pubspec.dart';
import 'template/App.dart';
import 'template/Builder.dart';
import 'template/Column.dart';
import 'template/Context.dart';
import 'template/ConvertHelper.dart';
import 'template/Db.dart';
import 'template/Env.dart';
import 'template/HomeController.dart';
import 'template/PrintHelper.dart';
import 'template/Raw.dart';
import 'template/Route.dart';
import 'template/RouteHelper.dart';
import 'template/Server.dart';
import 'template/VerifyHelper.dart';

class CreateHelper {
  static Map<String, String> fileMap = {
    /// pubspec
    'pubspec.yaml': Pubspec.content,

    /// bin
    'bin/{package}.dart': Bin.content,

    /// bootstrap
    'bootstrap/App.dart': App.content,
    'bootstrap/Server.dart': Server.content,
    'bootstrap/Context.dart': Context.content,

    /// bootstrap db
    'bootstrap/db/Db.dart': Db.content,
    'bootstrap/db/Column.dart': Column.content,
    'bootstrap/db/Builder.dart': Builder.content,
    'bootstrap/db/Raw.dart': Raw.content,

    /// bootstrap helper
    'bootstrap/helper/ConvertHelper.dart': ConvertHelper.content,
    'bootstrap/helper/PrintHelper.dart': PrintHelper.content,
    'bootstrap/helper/RouteHelper.dart': RouteHelper.content,
    'bootstrap/helper/VerifyHelper.dart': VerifyHelper.content,

    /// env
    'env/dev.yaml': Env.content,
    'env/test.yaml': Env.content,
    'env/prod.yaml': Env.content,

    /// config
    'config/route.dart': Route.content,

    /// controller
    'app/controller/HomeController.dart': HomeController.content,

    // /// extend
    // 'extend/model/User.dart': _extend_model_User,
    // 'extend/service/UserService.dart': _extend_service_UserService
  };

  static void create(String package) {
    var path = Directory.current.path.replaceAll('\\', '/');
    var project = path + '/' + package;
    if (!Directory(project).existsSync()) Directory(project).createSync();

    fileMap.forEach((filePath, fileContent) {
      var filePathArr = filePath.split('/');
      for (var i = 0; i < filePathArr.length; i++) {
        var path = project + '/' + filePathArr.getRange(0, i + 1).join('/');
        path = path.replaceAll('{package}', package);
        fileContent = fileContent.replaceAll('{package}', package);

        if (!path.contains('.')) {
          var directory = Directory(path);
          if (!Directory(path).existsSync()) directory.createSync();
        } else {
          var file = File(path);
          if (!file.existsSync()) file.createSync();
          file.writeAsStringSync(fileContent);

          //fileContent = fileContent.replaceAll('{package}', name);
          //print(path);
          //print(fileContent);
          //print('------------------------------------------');
        }
      }
    });
  }
}
