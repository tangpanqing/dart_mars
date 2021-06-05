import 'package:dart_mars/HelpHelper.dart';
import 'package:dart_mars/CreateHelper.dart';
import 'package:dart_mars/ServeHelper.dart';
import 'package:dart_mars/CompileHelper.dart';

void main(List<String> arguments) {
  if (arguments.isNotEmpty) {
    if (arguments[0] == '--help') HelpHelper.run();
    if (arguments[0] == '--create') CreateHelper.run(arguments[1]);
    if (arguments[0] == '--serve') ServeHelper.run(arguments);
    if (arguments[0] == '--compile') CompileHelper.run(arguments[1]);
  } else {
    print('Welcome use dart_mars');
    print('for create project, please type:');
    print('dart pub global run dart_mars --create project_name');
    print('for help, please type:');
    print('dart pub global run dart_mars --help');
  }
}
