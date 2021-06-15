class CommonHelper {
  static String content = '''
import 'dart:io';

class CommonHelper {
  static String rootPath(){
    List<String> arr =
        Platform.script.toFilePath().replaceAll('\\\\', '/').split('/');
    return arr.getRange(0, arr.length - 2).join('/');
  }
}    
  ''';
}
