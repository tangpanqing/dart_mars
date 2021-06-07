class Context {
  static String content = '''
import 'dart:io';
import 'dart:convert';

class Context {
  String serve;

  Map<String, dynamic> env;

  HttpRequest request;
  
  HttpResponse response;
  String responseContent;
  bool responseIsClose = false;

  String method;
  ContentType responseType;
  Map<String, dynamic> header = Map<String, dynamic>();
  Map<String, dynamic> query = Map<String, dynamic>();
  Map<String, dynamic> body = Map<String, dynamic>();
  Map<String, dynamic> session = Map<String, dynamic>();
  Map<String, dynamic> cookie = Map<String, dynamic>();

  Context({this.serve, this.env});

  Future<void> handle(HttpRequest request) async {
    this.request = request;
    this.response = request.response;
    this.method = request.method;

    this.header = _getHeader(request);
    this.query = _getQuery(request);
    this.body = await _getBody(request);
    this.session = await _getSession(request);
  }

  String getString(String key, {String def = "", int from = 0}) {
    Map<String, dynamic> all = _getAllParams(from);

    if (all.containsKey(key)) return all[key].toString();
    return def;
  }

  int getInt(String key, {int def = 0, int from = 0}) {
    Map<String, dynamic> all = _getAllParams(from);

    if (all.containsKey(key)) {
      try {
        return int.parse(all[key].toString());
      } catch (e) {}
    }

    return def;
  }

  int getPositiveInt(String key, {int def = 0, int from = 0}) {
    int i = getInt(key, def:def, from:from);
    return i > 0 ? i : 0;
  }

  int getNegativeInt(String key, {int def = 0, int from = 0}) {
    int i = getInt(key, def:def, from:from);
    return i < 0 ? i : 0;
  }

  double getDouble(String key, {double def = 0, int from = 0}) {
    Map<String, dynamic> all = _getAllParams(from);

    if (all.containsKey(key)) {
      try {
        return double.parse(all[key].toString());
      } catch (e) {}
    }

    return def;
  }

  double getPositiveDouble(String key, {double def = 0, int from = 0}) {
    double i = getDouble(key, def:def, from:from);
    return i > 0 ? i : 0;
  }

  double getNegativeDouble(String key, {double def = 0, int from = 0}) {
    double i = getDouble(key, def:def, from:from);
    return i < 0 ? i : 0;
  }

  void html(String raw) {
    responseType = ContentType.html;
    responseContent = raw;
  }

  void text(String raw) {
    responseType = ContentType.text;
    responseContent = raw;
  }

  void json(String raw) {
    responseType = ContentType.json;
    responseContent = raw;
  }

  void binary(String raw) {
    responseType = ContentType.binary;
    responseContent = raw;
  }

  Future<void> writeAndClose() async {
    response.headers.contentType = responseType;
    response.write(responseContent);
    await response.close();

    responseIsClose = true;
  }

  void showJson(num code, String msg, dynamic data) {
    Map<String, dynamic> map = {"code": code, "msg": msg, "data": data};

    json(jsonEncode(map));
  }

  void showSuccess(String msg, dynamic data) {
    showJson(200, msg, data);
  }

  void showError(String msg) {
    showJson(400, msg, {});
  }

  Map<String, dynamic> _getHeader(HttpRequest request) {
    Map<String, dynamic> map = Map<String, dynamic>();
    request.headers.forEach((name, values) {
      map[name] = values.join(",");
    });

    return map;
  }

  Map<String, dynamic> _getQuery(HttpRequest request) {
    return Map<String, dynamic>.from(
        jsonDecode(jsonEncode(request.uri.queryParameters)));
  }

  Future<Map<String, dynamic>> _getBody(HttpRequest request) async {
    Map<String, dynamic> map = Map<String, dynamic>();

    if ("GET" != request.method) {
      var bodyStr = await utf8.decoder.bind(request).join();

      if ("application/x-www-form-urlencoded" ==
          request.headers.contentType.toString()) {
        map = Uri.parse("?" + bodyStr).queryParameters;
      } else if ("application/json" == request.headers.contentType.toString()) {
        map = Map<String, dynamic>.from(jsonDecode(bodyStr));
      } else {
        print("contentType=" + request.headers.contentType.toString());
      }
    }

    return map;
  }

  Map<String, dynamic> _getSession(HttpRequest request) {
    Map<String, dynamic> map = Map<String, dynamic>();

    request.session.forEach((key, value) {
      map[key.toString()] = value.toString();
    });

    return map;
  }

  Map<String, dynamic> _getAllParams(int from) {
    Map<String, dynamic> allParams = Map<String, dynamic>();
    if (from == 0 || from == 1) allParams.addAll(this.header);
    if (from == 0 || from == 2) allParams.addAll(this.query);
    if (from == 0 || from == 3) allParams.addAll(this.body);
    if (from == 0 || from == 4) allParams.addAll(this.session);
    if (from == 0 || from == 5) allParams.addAll(this.cookie);
    return allParams;
  }
}
  ''';
}
