import 'package:redis/redis.dart';

// ignore: always_declare_return_types
main() async {
  RedisConnection conn = RedisConnection();
  Command command = await RedisConnection().connect('localhost', 6379);

  dynamic response = await command.send_object(['SET', 'key', '0']);
  print(response);

  dynamic response2 = await command.set('key', '1');
  print(response2);

  dynamic response3 = await command.get('key');
  print(response3);

  await conn.close();
}
