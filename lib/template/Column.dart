class Column {
  static String content = '''
import '../helper/ConvertHelper.dart';

class Column {
  String fieldName;
  String optName;
  dynamic fieldVal;

  Column(this.fieldName, this.optName, this.fieldVal);

  Column.fieldToUnderLine(String fieldName, String optName, dynamic fieldVal) {
    this.fieldName = ConvertHelper.strToUnderLine(fieldName);
    this.optName = optName;
    this.fieldVal = fieldVal;
  }
}

  ''';
}
