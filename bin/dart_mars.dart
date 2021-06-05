import '../lib/CreateHelper.dart';
import '../lib/ServeHelper.dart';
import '../lib/WelcomeHelper.dart';

void main(List<String> arguments) {
  if (arguments.isEmpty) return WelcomeHelper.run();

  if (arguments[0] == '--create') return CreateHelper.run(arguments[1]);

  if (arguments[0] == '--serve') return ServeHelper.run(arguments);
}
