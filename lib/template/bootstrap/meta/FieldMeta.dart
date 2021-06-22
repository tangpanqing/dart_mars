class FieldMeta {
  static String content = '''
class FieldMeta {
  final String name;
  final String type;
  final String length;
  final String def;
  final String index;
  final String autoIncrease;
  final String comment;

  const FieldMeta(
      {this.name,
      this.type,
      this.length,
      this.def,
      this.index,
      this.autoIncrease,
      this.comment});
}
''';
}
