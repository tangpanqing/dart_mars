import 'dart:io';

import '../template/bootstrap/crypto/AES.dart';
import '../template/bootstrap/crypto/RSA.dart';
import '../template/bootstrap/crypto/Sha1WithRSA.dart';
import '../template/bootstrap/crypto/Sha256WithRSA.dart';
import '../template/bootstrap/crypto/ShaRsaHelper.dart';

import '../template/app/config/ConfigContext.dart';
import '../template/app/config/ConfigDatabase.dart';
import '../template/app/config/ConfigHook.dart';
import '../template/app/config/ConfigLog.dart';
import '../template/app/config/ConfigRoute.dart';

import '../template/app/controller/HomeController.dart';

import '../template/bootstrap/db/Db.dart';
import '../template/bootstrap/db/DbConfig.dart';
import '../template/bootstrap/db/DbConnection.dart';
import '../template/bootstrap/db/DbSqlBuilder.dart';
import '../template/bootstrap/db/DbColumn.dart';
import '../template/bootstrap/db/DbRaw.dart';

import '../template/bootstrap/helper/LogHelper.dart';
import '../template/bootstrap/helper/CommonHelper.dart';
import '../template/bootstrap/helper/ConvertHelper.dart';
import '../template/bootstrap/helper/PrintHelper.dart';
import '../template/bootstrap/helper/RequestHelper.dart';
import '../template/bootstrap/helper/RouteHelper.dart';
import '../template/bootstrap/helper/VerifyHelper.dart';
import '../template/bootstrap/helper/TransHelper.dart';

import '../template/bootstrap/meta/RouteMeta.dart';
import '../template/bootstrap/meta/TableMeta.dart';
import '../template/bootstrap/meta/FieldMeta.dart';

import '../template/bootstrap/model/FormData.dart';
import '../template/bootstrap/model/UploadFile.dart';

import '../template/bootstrap/App.dart';
import '../template/bootstrap/Context.dart';
import '../template/bootstrap/Server.dart';

import '../template/bin/Bin.dart';
import '../template/extend/model/Agent.dart';

import '../template/env/Env.dart';
import '../template/Pubspec.dart';

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
    'log/.gitkeep': '',

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
    'lib/bootstrap/helper/TransHelper.dart': TransHelper.content,

    /// bootstrap crypto
    'lib/bootstrap/crypto/AES.dart': AES.content,
    'lib/bootstrap/crypto/RSA.dart': RSA.content,
    'lib/bootstrap/crypto/Sha1WithRSA.dart': Sha1WithRSA.content,
    'lib/bootstrap/crypto/Sha256WithRSA.dart': Sha256WithRSA.content,
    'lib/bootstrap/crypto/ShaRsaHelper.dart': ShaRsaHelper.content,

    /// bootstrap meta
    'lib/bootstrap/meta/RouteMeta.dart': RouteMeta.content,
    'lib/bootstrap/meta/TableMeta.dart': TableMeta.content,
    'lib/bootstrap/meta/FieldMeta.dart': FieldMeta.content,

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
    'lib/extend/model/Agent.dart': Agent.content,

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
