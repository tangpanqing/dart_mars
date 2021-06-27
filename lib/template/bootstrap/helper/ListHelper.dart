class ListHelper {
  static String content = '''
class ListHelper {
  static List<String> merge(List<String> a, List<String> b) {
    List<String> c = [];
    c.addAll(a);
    c.addAll(b);
    return c;
  }

  static List<String> unique(List<String> c) {
    Set temp = Set();
    temp.addAll(c);
    return temp.map((e) => e.toString()).toList();
  }

  // in a, not in b
  static List<String> diff(List<String> a, List<String> b) {
    List<String> c = [];

    a.forEach((element) {
      if (!b.contains(element)) {
        c.add(element);
      }
    });

    return c;
  }
}  
  ''';
}
