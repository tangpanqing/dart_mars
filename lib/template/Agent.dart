class Agent {
  static String content = '''
import '../../bootstrap/meta/FieldMeta.dart';
import '../../bootstrap/meta/TableMeta.dart';

@TableMeta(comment: '合伙人表')
class Agent {
  @FieldMeta(comment: 'ID', autoIncrease: 'true')
  int id;

  @FieldMeta(comment: '合伙人编号')
  int agentNo;

  @FieldMeta(comment: '合伙人手机号')
  int agentMobile;

  @FieldMeta(comment: '姓名')
  String agentName;

  @FieldMeta(comment: '密码')
  String password;

  @FieldMeta(comment: '创建时间')
  int createTime;

  @FieldMeta(comment: '删除时间')
  int deleteTime;
}
  ''';
}
