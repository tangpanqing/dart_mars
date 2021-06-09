import 'dart:io';

import 'dart:math';

List<int> _getUn(String s) {
  List<int> u = s.codeUnits;
  u = [u.length, 0, 0] + [0] + u;
  return u;
}

List<int> _clientCmd(String c, String s) {
  int type = 0;
  if ('use' == c) type = 2;
  var i = [type] + s.codeUnits;
  print(i);
  return i;
}

main() async {
  print('开始');
  var host = '127.0.0.1';
  var port = 3306;
  List<int> l = [];

  await RawSocket.connect(host, port).then((socket) async {
    socket.setOption(SocketOption.tcpNoDelay, true);
    socket.listen((RawSocketEvent event) {
      if (event == RawSocketEvent.read) {
        print(1);
      } else {
        print(event);
      }
    }, onError: (e) {
      print('socket listen on error');
    }, onDone: () {
      print('socket listen on done');
    });
  }).catchError((e) {
    print(e);
  }).onError((error, stackTrace) {
    print(error.toString());
  });
}
