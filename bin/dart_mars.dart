import 'package:dart_mars/CreateHelper.dart';
import 'package:dart_mars/ServeHelper.dart';

void main(List<String> arguments) {
  if (arguments[0] == '--create') CreateHelper.create(arguments[1]);
  if (arguments[0] == '--serve') ServeHelper.serve(arguments);
}
