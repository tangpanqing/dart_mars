class ConvertHelper {
  static String content = '''
class ConvertHelper {
  static String strToHump(String str) {
    List<String> a = str.split("_");

    String b =
        a.map((e) => e[0].toUpperCase() + e.substring(1)).toList().join();

    String c = b[0].toLowerCase() + b.substring(1);

    return c;
  }

  static String strToUnderLine(String str) {
    List<String> l = [];
    for (var i = 0; i < str.length; i++) {
      if (str[i] != str[i].toLowerCase()) {
        l.add("_");
      }

      l.add(str[i].toLowerCase());
    }
    return l.join();
  }

  static Map<String, dynamic> keyToHump(Map<String, dynamic> map) {
    Map<String, dynamic> newMap = Map<String, dynamic>();

    map.forEach((key, value) {
      newMap[strToHump(key)] = value;
    });

    return newMap;
  }

  static Map<String, dynamic> keyToUnderLine(Map<String, dynamic> map) {
    Map<String, dynamic> newMap = Map<String, dynamic>();

    map.forEach((key, value) {
      if (null != value) {
        newMap[strToUnderLine(key)] = value;
      }
    });

    return newMap;
  }

  static String fieldType(String type) {
    if ("tinyint" == type) return "int";
    if ("int" == type) return "int";
    if ("bigint" == type) return "int";
    if ("varchar" == type) return "String";
    if ("float" == type) return "double";
    if ("double" == type) return "double";
    return "unknow" + type;
  }
}

  ''';
}
