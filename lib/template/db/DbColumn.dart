class DbColumn {
  static String content = '''
import '../helper/ConvertHelper.dart';

class DbColumn {
  String fieldName;
  String optName;
  dynamic fieldVal;

  DbColumn(this.fieldName, this.optName, this.fieldVal);

  DbColumn.fieldToUnderLine(String fieldName, String optName, dynamic fieldVal) {
    this.fieldName = ConvertHelper.strToUnderLine(fieldName);
    this.optName = optName;
    this.fieldVal = fieldVal;
  }
}

  ''';
}
