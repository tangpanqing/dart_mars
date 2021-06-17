import 'dart:io';

import '../template/config/ConfigContext.dart';
import '../template/config/ConfigDatabase.dart';
import '../template/config/ConfigHook.dart';
import '../template/config/ConfigLog.dart';
import '../template/config/ConfigRoute.dart';

import '../template/controller/HomeController.dart';

import '../template/db/Db.dart';
import '../template/db/DbConfig.dart';
import '../template/db/DbConnection.dart';
import '../template/db/DbSqlBuilder.dart';
import '../template/db/DbColumn.dart';
import '../template/db/DbRaw.dart';

import '../template/helper/LogHelper.dart';
import '../template/helper/CommonHelper.dart';
import '../template/helper/ConvertHelper.dart';
import '../template/helper/PrintHelper.dart';
import '../template/helper/RequestHelper.dart';
import '../template/helper/RouteHelper.dart';
import '../template/helper/VerifyHelper.dart';

import '../template/meta/RouteMeta.dart';

import '../template/model/FormData.dart';
import '../template/model/UploadFile.dart';

import '../template/App.dart';
import '../template/Bin.dart';
import '../template/Context.dart';
import '../template/Env.dart';
import '../template/Pubspec.dart';
import '../template/Server.dart';

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
    'public/uploads/.gitkeep': '',

    /// env
    'env/dev.yaml': Env.content,
    'env/test.yaml': Env.content,
    'env/prod.yaml': Env.content,

    /// cert
    'cert/key.pem': '',
    'cert/cert.pem': '',

    /// log
    'log/log.txt': '',

    /// bootstrap
    'lib/bootstrap/App.dart': App.content,
    'lib/bootstrap/Server.dart': Server.content,
    'lib/bootstrap/Context.dart': Context.content,

    /// bootstrap db
    'lib/bootstrap/db/Db.dart': Db.content,
    'lib/bootstrap/db/DbColumn.dart': DbColumn.content,
    'lib/bootstrap/db/DbConfig.dart': DbConfig.content,
    'lib/bootstrap/db/DbConnection.dart': DbConnection.content,
    'lib/bootstrap/db/DbRaw.dart': DbRaw.content,
    'lib/bootstrap/db/DbSqlBuilder.dart': DbSqlBuilder.content,

    /// bootstrap helper
    'lib/bootstrap/helper/CommonHelper.dart': CommonHelper.content,
    'lib/bootstrap/helper/ConvertHelper.dart': ConvertHelper.content,
    'lib/bootstrap/helper/LogHelper.dart': LogHelper.content,
    'lib/bootstrap/helper/PrintHelper.dart': PrintHelper.content,
    'lib/bootstrap/helper/RequestHelper.dart': RequestHelper.content,
    'lib/bootstrap/helper/RouteHelper.dart': RouteHelper.content,
    'lib/bootstrap/helper/VerifyHelper.dart': VerifyHelper.content,

    /// bootstrap meta
    'lib/bootstrap/meta/RouteMeta.dart': RouteMeta.content,

    /// bootstrap model
    'lib/bootstrap/model/FormData.dart': FormData.content,
    'lib/bootstrap/model/UploadFile.dart': UploadFile.content,

    /// config
    'lib/config/context.dart': ConfigContext.content,
    'lib/config/database.dart': ConfigDatabase.content,
    'lib/config/hook.dart': ConfigHook.content,
    'lib/config/log.dart': ConfigLog.content,
    'lib/config/route.dart': ConfigRoute.content,

    /// controller
    'lib/app/controller/HomeController.dart': HomeController.content,

    /// extend
    'lib/extend/.gitkeep': '',

    /// tests
    'lib/tests/test_main.dart': '''
void main(){
  print('you can do some test in here');
}
    ''',
  };

  static void run(String package) {
    var path = Directory.current.path.replaceAll('\\', '/');
    var project = path + '/' + package;
    if (!Directory(project).existsSync()) {
      Directory(project).createSync();
    } else {
      print('dir ' +
          package +
          ' is already exists, please chose other or delete it then try again');
      return;
    }

    fileMap.forEach((filePath, fileContent) {
      var filePathArr = filePath.split('/');
      for (var i = 0; i < filePathArr.length; i++) {
        var path = project + '/' + filePathArr.getRange(0, i + 1).join('/');
        path = path.replaceAll('{package}', package);
        fileContent = fileContent.replaceAll('{package}', package);
        fileContent =
            fileContent.replaceAll('{time}', DateTime.now().toString());

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

    print('project ' + package + ' has been created');
    print('you can change dir with command: cd ' + package);
    print(
        'and then get dependent with command: dart pub global run dart_mars --get');
    print(
        'and then start it with command: dart pub global run dart_mars --serve dev');
  }
}
