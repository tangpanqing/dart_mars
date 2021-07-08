class DataFieldHelper {
  static String buildSql(Map<String, dynamic> map) {
    String name = map['name'].toString();
    String engine =
        map.containsKey('engine') ? map['engine'].toString() : 'InnoDB';
    String charset =
        map.containsKey('charset') ? map['charset'].toString() : 'utf8mb4';
    String comment =
        map.containsKey('comment') ? map['comment'].toString() : '';

    var sb = StringBuffer();
    sb.write('CREATE TABLE IF NOT EXISTS \`$name\` (\n');

    //循环字段
    (map['fieldList'] as List<dynamic>).forEach((element) {
      sb.write(_buildField(Map<String, dynamic>.from(element)));
    });

    //循环索引
    (map['fieldList'] as List<dynamic>).forEach((element) {
      String key = _buildKey(Map<String, dynamic>.from(element));
      if (key != '') sb.write(key + ',\n');
    });

    sb.write(') ENGINE=' +
        engine +
        ' DEFAULT CHARSET=' +
        charset +
        ' COLLATE=utf8mb4_general_ci COMMENT=\'' +
        comment +
        '\'');

    String s = sb.toString();
    int i = s.lastIndexOf('),');
    s = s.replaceRange(i, i + 2, ')');

    return s;
  }

  static String _buildField(Map<String, dynamic> m) {
    String type = m['type'].toString();

    var sb = StringBuffer();
    sb.write(_pareFieldName(m));
    sb.write(_pareFieldType(m));

    if ('varchar' == type) {
      sb.write(' CHARACTER SET utf8mb4');
      sb.write(' COLLATE utf8mb4_general_ci');
    }

    if (type != 'text') {
      sb.write(' NOT NULL');
    } else {
      sb.write(' NULL');
    }

    sb.write(_pareFieldDefault(m));
    sb.write(_pareFieldAutoIncrease(m));
    sb.write(_pareFieldComment(m));
    sb.write(',\n');

    return sb.toString();
  }

  static String _pareFieldName(Map<String, dynamic> m) {
    String name = m['name'].toString();
    return '`' + name + '`';
  }

  static String _pareFieldType(Map<String, dynamic> m) {
    String type = m['type'].toString();
    if ('text' == type) return ' text';

    String length =
        m.containsKey('length') ? m['length'].toString() : _defaultLength(type);

    return ' ' + type + '(' + length + ')';
  }

  static String _defaultLength(String type) {
    if (type == 'varchar') return '255';
    if (type == 'tinyint') return '4';
    if (type == 'int') return '11';
    if (type == 'bigint') return '20';
    return '';
  }

  static String _pareFieldDefault(Map<String, dynamic> m) {
    if (!m.containsKey('def')) return '';

    String type = m['type'].toString();

    return ' DEFAULT \'' + (type == 'varchar' ? '' : '0') + '\'';
  }

  static String _pareFieldAutoIncrease(Map<String, dynamic> m) {
    String autoIncrease =
        (m.containsKey('autoIncrease') && m['autoIncrease'] == 'true')
            ? ' AUTO_INCREMENT'
            : '';

    return autoIncrease;
  }

  static String _pareFieldComment(Map<String, dynamic> m) {
    String comment = m.containsKey('comment')
        ? ' COMMENT \'' + m['comment'].toString() + '\''
        : '';

    return comment;
  }

  static String _buildKey(Map<String, dynamic> m) {
    if (!m.containsKey('key') || m['key'].toString() == '') return '';

    String key = m['key'].toString().toUpperCase();
    String name = m['name'].toString();

    return key + ' `' + name + '` (`' + name + '`)';
  }
}
