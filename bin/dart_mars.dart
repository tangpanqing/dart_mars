import 'package:dart_mars/helper/WelcomeHelper.dart';
import 'package:dart_mars/helper/CreateHelper.dart';
import 'package:dart_mars/helper/GetHelper.dart';
import 'package:dart_mars/helper/ServeHelper.dart';
import 'package:dart_mars/helper/CompileHelper.dart';
import 'package:dart_mars/helper/RunHelper.dart';
import 'package:dart_mars/helper/Helper.dart';

void main(List<String> arguments) async {
  if (arguments.isEmpty) return WelcomeHelper.run();

  if (arguments[0] == '--create') return CreateHelper.run(arguments[1]);

  if (arguments[0] == '--get') return GetHelper.run();

  if (arguments[0] == '--serve') {
    await ServeHelper.run(arguments);
    return;
  }

  if (arguments[0] == '--compile') return CompileHelper.run(arguments[1]);

  if (arguments[0] == '--run') return RunHelper.run(arguments[1]);

  if (arguments[0] == '--help') return Helper.run();
}
