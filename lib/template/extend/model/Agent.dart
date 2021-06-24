class Agent {
  static String content = '''
import '../../bootstrap/meta/FieldMeta.dart';
import '../../bootstrap/meta/TableMeta.dart';

@TableMeta(comment: '合伙人表', engine: 'InnoDB')
class Agent {
  @FieldMeta(autoIncrease: 'true', key: 'primary key')
  int id;

  @FieldMeta(comment: '合伙人id', length: '40', def: '', key: 'unique key')
  String agentNo;

  @FieldMeta(comment: '手机号', length: '11', def: '', key: 'key')
  String agentMobile;

  @FieldMeta(comment: '姓名', length: '80', def: '')
  String agentName;

  @FieldMeta(comment: '密码', length: '40', def: '')
  String password;

  @FieldMeta(comment: '创建时间', type: 'bigint', def: '0')
  int createTime;

  @FieldMeta(comment: '删除时间', type: 'bigint', def: '0')
  int deleteTime;
}
  ''';
}
