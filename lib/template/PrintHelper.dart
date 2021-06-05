class PrintHelper {
  static String content = '''
  class PrintHelper {
    static void p(String text) {
      print(DateTime.now().toString() + ' ' + text);
    }

    static void t(String text) {
      print(text);
    }
  }
  ''';
}
