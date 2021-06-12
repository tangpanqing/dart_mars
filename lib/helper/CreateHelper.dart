import 'dart:io';
import '../template/Hook.dart';
import '../template/Bin.dart';
import '../template/CommonHelper.dart';
import '../template/Database.dart';
import '../template/DbConfig.dart';
import '../template/DbConnection.dart';
import '../template/LogHelper.dart';
import '../template/Pubspec.dart';
import '../template/App.dart';
import '../template/SqlBuilder.dart';
import '../template/Column.dart';
import '../template/Context.dart';
import '../template/ConvertHelper.dart';
import '../template/Db.dart';
import '../template/Env.dart';
import '../template/HomeController.dart';
import '../template/PrintHelper.dart';
import '../template/Raw.dart';
import '../template/Route.dart';
import '../template/RouteHelper.dart';
import '../template/Server.dart';
import '../template/VerifyHelper.dart';
import '../template/RouteMeta.dart';

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
    'lib/bootstrap/db/DbConfig.dart': DbConfig.content,
    'lib/bootstrap/db/DbConnection.dart': DbConnection.content,
    'lib/bootstrap/db/Column.dart': Column.content,
    'lib/bootstrap/db/SqlBuilder.dart': SqlBuilder.content,
    'lib/bootstrap/db/Raw.dart': Raw.content,

    /// bootstrap helper
    'lib/bootstrap/helper/ConvertHelper.dart': ConvertHelper.content,
    'lib/bootstrap/helper/PrintHelper.dart': PrintHelper.content,
    'lib/bootstrap/helper/LogHelper.dart': LogHelper.content,
    'lib/bootstrap/helper/RouteHelper.dart': RouteHelper.content,
    'lib/bootstrap/helper/VerifyHelper.dart': VerifyHelper.content,
    'lib/bootstrap/helper/CommonHelper.dart': CommonHelper.content,

    'lib/bootstrap/meta/RouteMeta.dart': RouteMeta.content,

    /// config
    'lib/config/route.dart': Route.content,
    'lib/config/hook.dart': Hook.content,
    'lib/config/database.dart': Database.content,

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
