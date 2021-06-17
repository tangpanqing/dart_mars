class Context {
  static String content = '''
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'model/UploadFile.dart';
import 'helper/RequestHelper.dart';

class Context {
  String serve;
  Map<String, dynamic> env;

  HttpRequest request;
  HttpResponse response;
  ContentType responseType;
  String responseContent;
  bool _responseIsClose = false;

  Map<String, dynamic> header = Map<String, dynamic>();
  Map<String, dynamic> query = Map<String, dynamic>();
  Map<String, dynamic> body = Map<String, dynamic>();
  Map<String, dynamic> session = Map<String, dynamic>();
  Map<String, dynamic> cookie = Map<String, dynamic>();
  Map<String, dynamic> customize = Map<String, dynamic>();

  Context({this.serve, this.env});

  Future<void> handle(HttpRequest request) async {
    this.request = request;
    this.response = request.response;

    this.header = RequestHelper.getHeader(request);
    this.query = RequestHelper.getQuery(request);
    this.body = await RequestHelper.getBody(request);
    this.session = await RequestHelper.getSession(request);
  }

  UploadFile getUploadFile(String key, {UploadFile def = null, int from = 0}) {
    Map<String, dynamic> all = _getAllParams(from);

    if (all.containsKey(key)) {
      try {
        return all[key] as UploadFile;
      } catch (e) {
        return def;
      }
    }

    return def;
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
    int i = getInt(key, def: def, from: from);
    return i > 0 ? i : def;
  }

  int getNegativeInt(String key, {int def = 0, int from = 0}) {
    int i = getInt(key, def: def, from: from);
    return i < 0 ? i : def;
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
    double i = getDouble(key, def: def, from: from);
    return i > 0 ? i : def;
  }

  double getNegativeDouble(String key, {double def = 0, int from = 0}) {
    double i = getDouble(key, def: def, from: from);
    return i < 0 ? i : def;
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
    _responseIsClose = true;
  }

  bool responseIsClose() => _responseIsClose;

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

  Map<String, dynamic> _getAllParams(int from) {
    Map<String, dynamic> allParams = Map<String, dynamic>();
    if (from == 0 || from == 1) allParams.addAll(this.header);
    if (from == 0 || from == 2) allParams.addAll(this.query);
    if (from == 0 || from == 3) allParams.addAll(this.body);
    if (from == 0 || from == 4) allParams.addAll(this.session);
    if (from == 0 || from == 5) allParams.addAll(this.cookie);
    if (from == 0 || from == 6) allParams.addAll(this.customize);
    return allParams;
  }
}
  ''';
}
