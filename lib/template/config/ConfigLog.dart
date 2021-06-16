class ConfigLog {
  static String content = '''
import '../bootstrap/helper/LogHelper.dart';

///
/// here, you can set config for Log
///
/// for more infomation, see doc about Log
///
void configLog() {
  LogHelper.isOutLog = true;
  LogHelper.isErrLog = true;
  LogHelper.outLogName = 'log_out_{date}.txt';
  LogHelper.errLogName = 'log_err_{date}.txt';
  LogHelper.logForm = 'levelName,time,sequenceNumber,loggerName,message';
  LogHelper.logSeparator = '::';
}
  ''';
}
