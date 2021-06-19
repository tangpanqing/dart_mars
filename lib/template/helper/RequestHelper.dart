class RequestHelper {
  static String content = '''
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../model/FormData.dart';
import '../model/UploadFile.dart';
import 'package:mime/mime.dart';

class RequestHelper {
  static Map<String, dynamic> getHeader(HttpRequest request) {
    Map<String, dynamic> map = Map<String, dynamic>();
    request.headers.forEach((name, values) {
      map[name] = values.join(",");
    });

    return map;
  }

  static Map<String, dynamic> getQuery(HttpRequest request) {
    return Map<String, dynamic>.from(
        jsonDecode(jsonEncode(request.uri.queryParameters)));
  }

  static Map<String, dynamic> getSession(HttpRequest request) {
    Map<String, dynamic> map = Map<String, dynamic>();

    request.session.forEach((key, value) {
      map[key.toString()] = value.toString();
    });

    return map;
  }

  static Future<Map<String, dynamic>> getBody(HttpRequest request) async {
    Map<String, dynamic> map = Map<String, dynamic>();

    String contentType =
        request.headers.contentType.toString().split(';').first.toLowerCase();

    if ("application/x-www-form-urlencoded" == contentType) {
      var bodyStr = await utf8.decoder.bind(request).join();
      map = Uri.parse("?" + bodyStr).queryParameters;
    } else if ("application/json" == contentType) {
      var bodyStr = await utf8.decoder.bind(request).join();
      try {
        map = Map<String, dynamic>.from(jsonDecode(bodyStr));
      } catch (e) {}
    } else if ("multipart/form-data" == contentType) {
      try {
        map = await _asFormData(request);
      } catch (e) {}
    } else {
      print("contentType=" + contentType);
    }

    return map;
  }

  static Future<Map<String, dynamic>> _asFormData(HttpRequest request) async {
    String boundary = request.headers.contentType.parameters['boundary'];

    var values = await MimeMultipartTransformer(boundary)
        .bind(request)
        .map(
            (MimeMultipart part) => FormData.parse(part, defaultEncoding: utf8))
        .map((multipart) async {
      return [_multipartName(multipart), await _multipartData(multipart)];
    }).toList();

    var parts = await Future.wait(values);
    var map = <String, dynamic>{};
    for (var part in parts) {
      map[part[0] as String] = part[1];
    }

    return map;
  }

  static String _multipartName(FormData multipart) =>
      multipart.contentDisposition.parameters['name'];

  static dynamic _multipartData(FormData multipart) async {
    dynamic data;
    if (multipart.isText) {
      var buffer = await multipart.fold<StringBuffer>(
          StringBuffer(), (b, s) => b..write(s));
      data = buffer.toString();
    } else {
      var buffer = await multipart.fold<BytesBuilder>(
          BytesBuilder(), (b, d) => b..add(d as List<int>));
      data = buffer.takeBytes();
    }

    var filename = multipart.contentDisposition.parameters['filename'];
    if (filename != null) {
      data = UploadFile(multipart.contentType, filename, data);
    }

    return data;
  }
}
  ''';
}
