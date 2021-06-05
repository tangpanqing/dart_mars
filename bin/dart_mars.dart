import 'package:dart_mars/TemplateHelper.dart';
import 'package:process_run/shell.dart';

void main(List<String> arguments) {
  if (arguments[0] == '--create') TemplateHelper.create(arguments[1]);
  if (arguments[0] == '--serve') Shell().run('dart run');
}
