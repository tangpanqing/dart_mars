class UploadFile {
  static String content = '''
import 'dart:io';

class UploadFile {
  /// The filename of the uploaded file.
  final String filename;

  /// The [ContentType] of the uploaded file.
  ///
  /// For `text/*` and `application/json` the [content] field will a String.
  final ContentType contentType;

  /// The content of the file.
  ///
  /// Either a [String] or a [List<int>].
  final dynamic content;

  UploadFile(this.contentType, this.filename, this.content);

  Map<String, dynamic> toJson() {
    return {
      'filename': filename,
      'contentType': contentType.toString(),
      'content': 'UploadFile Content'
    };
  }
}
  ''';
}
