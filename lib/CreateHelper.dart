import 'dart:io';
import 'template/Bin.dart';
import 'template/CommonHelper.dart';
import 'template/Database.dart';
import 'template/DbConfig.dart';
import 'template/DbHelper.dart';
import 'template/LogHelper.dart';
import 'template/Pubspec.dart';
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
    /// readme
    'README.md': '# {package}',

    /// pubspec
    'pubspec.yaml': Pubspec.content,

    /// bin
    'bin/{package}.dart': Bin.content,

    /// devops
    'devops/.gitkeep': '',

    /// public
    'public/hello.html': '<h1>hello world</h1>',

    /// env
    'env/dev.yaml': Env.content,
    'env/test.yaml': Env.content,
    'env/prod.yaml': Env.content,

    /// cert
    'cert/.gitkeep': '',

    /// bootstrap
    'lib/bootstrap/App.dart': App.content,
    'lib/bootstrap/Server.dart': Server.content,
    'lib/bootstrap/Context.dart': Context.content,

    /// bootstrap db
    'lib/bootstrap/db/Db.dart': Db.content,
    'lib/bootstrap/db/DbConfig.dart': DbConfig.content,
    'lib/bootstrap/db/DbHelper.dart': DbHelper.content,
    'lib/bootstrap/db/Column.dart': Column.content,
    'lib/bootstrap/db/Builder.dart': Builder.content,
    'lib/bootstrap/db/Raw.dart': Raw.content,

    /// bootstrap helper
    'lib/bootstrap/helper/ConvertHelper.dart': ConvertHelper.content,
    'lib/bootstrap/helper/PrintHelper.dart': PrintHelper.content,
    'lib/bootstrap/helper/LogHelper.dart': LogHelper.content,
    'lib/bootstrap/helper/RouteHelper.dart': RouteHelper.content,
    'lib/bootstrap/helper/VerifyHelper.dart': VerifyHelper.content,
    'lib/bootstrap/helper/CommonHelper.dart': CommonHelper.content,

    /// config
    'lib/config/route.dart': Route.content,
    'lib/config/database.dart': Database.content,

    /// controller
    'lib/app/controller/HomeController.dart': HomeController.content,

    /// extend
    'lib/extend/.gitkeep': '',

    /// tests
    'lib/tests/.gitkeep': '',
  };

  static void run(String package) {
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
        }
      }
    });
  }
}
