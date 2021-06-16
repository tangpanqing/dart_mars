class CommonHelper {
  static String content = '''
import 'dart:io';

class CommonHelper {
  static String rootPath(){
    List<String> arr = _pathArr();
    return arr.getRange(0, arr.length - 2).join('/');
  }

  static String scriptName() {
    String scriptName = _pathArr().last.toLowerCase();
    return scriptName;
  }

  static List<String> _pathArr(){
    List<String> arr = Platform.script.toFilePath().replaceAll('\\\\', '/').split('/');
    return arr;
  }
}    
  ''';
}
