class Redis {
  static String content = '''
import 'package:redis/redis.dart';

class Redis {
  RedisConnection _conn;

  Command _command;

  String ok = 'OK';

  Redis() {
    _conn = RedisConnection();
  }

  Future<void> connect(String host, int port) async {
    _command = await _conn.connect(host, port);
  }

  Future<void> connectSecure(String host, int port) async {
    _command = await _conn.connectSecure(host, port);
  }

  Future<void> close() async => await _conn.close();

  Future<dynamic> sendObject(List<dynamic> params) async =>
      await _command.send_object(params);

  /// return count by del;
  Future<int> del(List<String> keys) async {
    dynamic count = await _getRes('DEL', keys, []);
    return count as int;
  }

  Future<dynamic> dump(String key) async => await sendObject(['DUMP', key]);

  /// return count of keys which exists
  Future<int> exists(List<String> keys) async {
    dynamic count = await _getRes('EXISTS', keys, []);
    return count as int;
  }

  Future<dynamic> expire(String key, int seconds) async =>
      await sendObject(['EXPIRE', key, seconds]);

  Future<dynamic> expireat(String key, int unixTime) async =>
      await sendObject(['EXPIREAT', key, unixTime]);

  Future<dynamic> keys(String pattern) async =>
      await sendObject(['KEYS', pattern]);

  Future<dynamic> migrate(String host, int port, String key, int destinationDB,
          int timeout) async =>
      _command
          .send_object(['MIGRATE', host, port, key, destinationDB, timeout]);

  Future<dynamic> move(String key, int dbIndex) async =>
      await sendObject(['MOVE', key, dbIndex]);

  Future<dynamic> persist(String key) async =>
      await sendObject(['PERSIST', key]);

  Future<dynamic> pexpire(String key, int seconds) async =>
      await sendObject(['PEXPIRE', key, seconds]);

  Future<dynamic> pexpireat(String key, int unixTime) async =>
      await sendObject(['PEXPIREAT', key, unixTime]);

  Future<dynamic> pttl(String key) async => await sendObject(['PTTL', key]);

  Future<dynamic> randomkey() async => await sendObject(['RANDOMKEY']);

  Future<dynamic> rename(String oldkey, String newkey) async =>
      await sendObject(['RENAME', oldkey, newkey]);

  Future<dynamic> renamenx(String oldkey, String newkey) async =>
      await sendObject(['RENAMENX', oldkey, newkey]);

  Future<dynamic> sort(String key) async => await sendObject(['SORT', key]);

  Future<dynamic> ttl(String key) async => await sendObject(['TTL', key]);

  Future<dynamic> type(String key) async => await sendObject(['TYPE', key]);

  Future<dynamic> append(String key, String value) async =>
      await sendObject(['APPEND', key, value]);

  Future<dynamic> bitcount(String key) async =>
      await sendObject(['BITCOUNT', key]);

  Future<dynamic> decr(String key) async => await sendObject(['DECR', key]);

  Future<dynamic> decrby(String key, int decrement) async =>
      await sendObject(['DECRBY', key, decrement]);

  Future<dynamic> get(String key) async => await sendObject(['GET', key]);

  Future<dynamic> getbit(String key, int offset) async =>
      await sendObject(['GETBIT', key, offset]);

  Future<dynamic> getrange(String key, int startOffset, int endOffset) async =>
      await sendObject(['GETRANGE', key, startOffset, endOffset]);

  Future<dynamic> getset(String key, String value) async =>
      await sendObject(['GETSET', key, value]);

  Future<dynamic> incr(String key) async => await sendObject(['INCR', key]);

  Future<dynamic> incrby(String key, int increment) async =>
      await sendObject(['INCRBY', key, increment]);

  Future<dynamic> incrbyfloat(String key, double increment) async =>
      await sendObject(['INCRBYFLOAT', key, increment]);

  Future<dynamic> mget(List<String> keys) async =>
      await _getRes('MGET', keys, []);

  Future<dynamic> mset(List<String> keys) async =>
      await _getRes('MSET', keys, []);

  Future<dynamic> msetnx(List<String> keys) async =>
      await _getRes('MSETNX', keys, []);

  Future<dynamic> psetex(String key, int seconds, String value) async =>
      await sendObject(['PSETEX', key, seconds, value]);

  Future<dynamic> set(String key, String value) async =>
      await sendObject(['SET', key, value]);

  Future<dynamic> setbit(String key, int offset, List<String> value) async =>
      await sendObject(['SETBIT', key, offset, value]);

  Future<dynamic> setex(String key, int seconds, String value) async =>
      await sendObject(['SETEX', key, seconds, value]);

  Future<dynamic> setnx(String key, String value) async =>
      await sendObject(['SETNX', key, value]);

  Future<dynamic> setrange(String key, int offset, String value) async =>
      await sendObject(['SETRANGE', key, offset, value]);

  Future<dynamic> strlen(String key) async => await sendObject(['STRLEN', key]);

  Future<dynamic> hdel(String key, List<String> fields) async =>
      await _getRes('HDEL', [key], fields);

  Future<dynamic> hexists(String key, String field) async =>
      await sendObject(['HEXISTS', key, field]);

  Future<dynamic> hget(String key, String field) async =>
      await sendObject(['HGET', key, field]);

  Future<dynamic> hgetall(String key) async =>
      await sendObject(['HGETALL', key]);

  Future<dynamic> hincrby(String key, String field, int value) async =>
      await sendObject(['HINCRBY', key, field, value]);

  Future<dynamic> hincrbyfloat(String key, String field, double value) async =>
      await sendObject(['HINCRBYFLOAT', key, field, value]);

  Future<dynamic> hkeys(String key) async => await sendObject(['HKEYS', key]);

  Future<dynamic> hlen(String key) async => await sendObject(['HLEN', key]);

  Future<dynamic> hmget(String key, List<String> fields) async =>
      await _getRes('HMGET', [key], fields);

  Future<dynamic> hmset(String key, Map<String, String> hash) async {
    List<String> l = [];
    l.add('HMSET');
    l.add(key);
    hash.forEach((key1, value1) {
      l.add(key1);
      l.add(value1);
    });

    await sendObject(l);
  }

  Future<dynamic> hset(String key, String field, String value) async =>
      await sendObject(['HSET', key, field, value]);

  Future<dynamic> hsetnx(String key, String field, String value) async =>
      await sendObject(['HSETNX', key, field, value]);

  Future<dynamic> hvals(String key) async => await sendObject(['HVALS', key]);

  Future<dynamic> blpop(List<String> args) async =>
      await sendObject(['BLPOP', args]);

  Future<dynamic> brpop(List<String> args) async =>
      await sendObject(['BRPOP', args]);

  Future<dynamic> brpoplpush(
          String source, String destination, int timeout) async =>
      await sendObject(['BRPOPLPUSH', source, destination, timeout]);

  Future<dynamic> lindex(String key, int index) async =>
      await sendObject(['LINDEX', key, index]);

  Future<dynamic> llen(String key) async => await sendObject(['LLEN', key]);

  Future<dynamic> lpop(String key) async => await sendObject(['LPOP', key]);

  Future<dynamic> lpush(String key, List<String> strings) async =>
      await _getRes('LPUSH', [key], strings);

  Future<dynamic> lpushx(String key, List<String> strings) async =>
      await _getRes('LPUSHX', [key], strings);

  Future<dynamic> lrange(String key, int start, int stop) async =>
      await sendObject(['LRANGE', key, start, stop]);

  Future<dynamic> lrem(String key, int count, String value) async =>
      await sendObject(['LREM', key, count, value]);

  Future<dynamic> lset(String key, int index, String value) async =>
      await sendObject(['LSET', key, index, value]);

  Future<dynamic> ltrim(String key, int start, int stop) async =>
      await sendObject(['LTRIM', key, start, stop]);

  Future<dynamic> rpop(String key) async => await sendObject(['RPOP', key]);

  Future<dynamic> rpoplpush(String srckey, String dstkey) async =>
      await sendObject(['RPOPLPUSH', srckey, dstkey]);

  Future<dynamic> rpush(String key, List<String> strings) async =>
      await _getRes('RPUSH', [key], strings);

  Future<dynamic> rpushx(String key, List<String> strings) async =>
      await _getRes('RPUSHX', [key], strings);

  Future<dynamic> sadd(String key, List<String> members) async =>
      await _getRes('SADD', [key], members);

  Future<dynamic> scard(String key) async => await sendObject(['SCARD', key]);

  Future<dynamic> sdiff(List<String> keys) async =>
      await _getRes('SDIFF', keys, []);

  Future<dynamic> sdiffstore(String dstkey, List<String> keys) async =>
      await _getRes('SDIFFSTORE', [dstkey], keys);

  Future<dynamic> sinter(List<String> keys) async =>
      await _getRes('SINTER', keys, []);

  Future<dynamic> sinterstore(String dstkey, List<String> keys) async =>
      await _getRes('SINTERSTORE', [dstkey], keys);

  Future<dynamic> sismember(String key, String member) async =>
      await sendObject(['SISMEMBER', key, member]);

  Future<dynamic> smembers(String key) async =>
      await sendObject(['SMEMBERS', key]);

  Future<dynamic> smove(String srckey, String dstkey, String member) async =>
      await sendObject(['SMOVE', srckey, dstkey, member]);

  Future<dynamic> spop(String key) async => await sendObject(['SPOP', key]);

  Future<dynamic> srandmember(String key) async =>
      await sendObject(['SRANDMEMBER', key]);

  Future<dynamic> srem(String key, List<String> member) async =>
      await _getRes('SREM', [key], member);

  Future<dynamic> sunion(List<String> keys) async =>
      await _getRes('SUNION', keys, []);

  Future<dynamic> sunionstore(String dstkey, List<String> keys) async =>
      await _getRes('SUNIONSTORE', [dstkey], keys);

  Future<dynamic> zadd(String key, double score, String member) async =>
      await sendObject(['ZADD', key, score, member]);

  Future<dynamic> zcard(String key) async => await sendObject(['ZCARD', key]);

  Future<dynamic> zcount(String key, double min, double max) async =>
      await sendObject(['ZCOUNT', key, min, max]);

  Future<dynamic> zincrby(String key, double increment, String member) async =>
      await sendObject(['ZINCRBY', key, increment, member]);

  Future<dynamic> zrange(String key, int start, int stop) async =>
      await sendObject(['ZRANGE', key, start, stop]);

  Future<dynamic> zrangebyscore(String key, double min, double max) async =>
      await sendObject(['ZRANGEBYSCORE', key, min, max]);

  Future<dynamic> zrank(String key, String member) async =>
      await sendObject(['ZRANK', key, member]);

  Future<dynamic> zrem(String key, List<String> members) async =>
      await _getRes('ZREM', [key], members);

  Future<dynamic> zremrangebyrank(String key, int start, int stop) async =>
      await sendObject(['ZREMRANGEBYRANK', key, start, stop]);

  Future<dynamic> zremrangebyscore(String key, double min, double max) async =>
      await sendObject(['ZREMRANGEBYSCORE', key, min, max]);

  Future<dynamic> zrevrange(String key, int start, int stop) async =>
      await sendObject(['ZREVRANGE', key, start, stop]);

  Future<dynamic> zrevrangebyscore(String key, double max, double min) async =>
      await sendObject(['ZREVRANGEBYSCORE', key, max, min]);

  Future<dynamic> zrevrank(String key, String member) async =>
      await sendObject(['ZREVRANK', key, member]);

  Future<dynamic> zscore(String key, String member) async =>
      await sendObject(['ZSCORE', key, member]);

  Future<dynamic> zunionstore(String dstkey, List<String> sets) async =>
      await _getRes('ZUNIONSTORE', [dstkey], sets);

  Future<dynamic> zinterstore(String dstkey, List<String> sets) async =>
      await _getRes('ZINTERSTORE', [dstkey], sets);

  Future<dynamic> psubscribe(List<String> patterns) async =>
      await _getRes('PSUBSCRIBE', patterns, []);

  Future<dynamic> punsubscribe() async => await sendObject(['PUNSUBSCRIBE']);

  Future<dynamic> subscribe() async => await sendObject(['SUBSCRIBE']);

  Future<dynamic> unsubscribe() async => await sendObject(['UNSUBSCRIBE']);

  Future<dynamic> discard() async => await sendObject(['DISCARD']);

  Future<dynamic> exec() async => await sendObject(['EXEC']);

  Future<dynamic> multi() async => await sendObject(['MULTI']);

  Future<dynamic> unwatch() async => await sendObject(['UNWATCH']);

  Future<dynamic> watch(List<String> keys) async =>
      await _getRes('WATCH', keys, []);

  Future<dynamic> scriptFlush() async => await sendObject(['SCRIPT FLUSH']);

  Future<dynamic> scriptKill() async => await sendObject(['SCRIPT KILL']);

  /// return OK if verify auth success, otherwise err;
  Future<dynamic> auth(String password) async =>
      await sendObject(['AUTH', password]);

  Future<dynamic> echo(String string) async =>
      await sendObject(['ECHO', string]);

  Future<dynamic> ping(String message) async =>
      await sendObject(['PING', message]);

  Future<dynamic> quit() async => await sendObject(['QUIT']);

  Future<dynamic> select(int index) async =>
      await sendObject(['SELECT', index]);

  Future<dynamic> bgrewriteaof() async => await sendObject(['BGREWRITEAOF']);

  Future<dynamic> bgsave() async => await sendObject(['BGSAVE']);

  Future<dynamic> clientGetname() async => await sendObject(['CLIENT GETNAME']);

  Future<dynamic> clientKill(String ipPort) async =>
      await sendObject(['CLIENT KILL', ipPort]);

  Future<dynamic> clientList() async => await sendObject(['CLIENT LIST']);

  Future<dynamic> clientSetname(String name) async =>
      await sendObject(['CLIENT SETNAME', name]);

  Future<dynamic> configGet(String pattern) async =>
      await sendObject(['CONFIG GET', pattern]);

  Future<dynamic> configResetstat() async =>
      await sendObject(['CONFIG RESETSTAT']);

  Future<dynamic> configRewrite() async => await sendObject(['CONFIG REWRITE']);

  Future<dynamic> configSet(String parameter, String value) async =>
      await sendObject(['CONFIG SET', parameter, value]);

  Future<dynamic> dbsize() async => await sendObject(['DBSIZE']);

  Future<dynamic> flushall() async => await sendObject(['FLUSHALL']);

  Future<dynamic> flushdb() async => await sendObject(['FLUSHDB']);

  Future<dynamic> info() async => await sendObject(['INFO']);

  Future<dynamic> lastsave() async => await sendObject(['LASTSAVE']);

  Future<dynamic> save() async => await sendObject(['SAVE']);

  Future<dynamic> shutdown() async => await sendObject(['SHUTDOWN']);

  Future<dynamic> slaveof(String host, int port) async =>
      await sendObject(['SLAVEOF', host, port]);

  Future<dynamic> sync() async => await sendObject(['SYNC']);

  Future<dynamic> time(String key) async => await sendObject(['TIME', key]);

  Future<dynamic> _getRes(
      String commandName, List<dynamic> param1, List<dynamic> param2) async {
    List<dynamic> param = [];
    param.add(commandName);
    param.addAll(param1);
    param.addAll(param2);

    return await sendObject(param);
  }
}
  ''';
}
