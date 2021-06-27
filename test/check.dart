import 'dart:io';

main() {
  File file1 = File(
      'D:\\vs_project\\dart_mars\\lib\\template\\bootstrap\\redis\\Redis.dart');
  File file2 = File('D:\\vs_project\\dart_mars_doc\\src\\zh\\use\\cache.md');

  //print(file1.readAsStringSync());
  //print(file2.readAsStringSync());

  var matchs1 = RegExp(r'Future.*?\(', dotAll: true, multiLine: true)
      .allMatches(file1.readAsStringSync());

  List<String> list1 = [];
  matchs1.forEach((element) {
    String s = element.group(0).toString().split(' ').last.replaceAll('(', '');
    list1.add(s.trim());
  });
  list1.remove('connect');
  list1.remove('connectSecure');
  list1.remove('close');
  list1.remove('sendObject');
  list1.remove('_getRes');

  List<String> list22 = file2.readAsStringSync().split('|');
  list22.removeAt(0);

  List<String> list2 = [];
  list22.forEach((element) {
    String s = element
        .replaceAll(RegExp('[键字符串散列表列表集合有序集合脚本服务器发布订阅事务脚本连接-]'), '')
        .trim();
    if (s.isNotEmpty) {
      if (!s.contains(' ')) {
        list2.add(s.trim());
      } else {
        List<String> ss = s.split(' ');

        String t =
            ss[0] + ss[1].substring(0, 1).toUpperCase() + ss[1].substring(1);
        list2.add(t);
      }
    }
  });

  List<String> all = ListHelper.merge(list1, list2);
  all = ListHelper.unique(all);

  List<String> list1_meiyou = ListHelper.diff(all, list1);
  print(list1_meiyou);

  List<String> list2_meiyou = ListHelper.diff(all, list2);
  print(list2_meiyou);
}

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

// a有, b没有
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
