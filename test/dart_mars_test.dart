import 'dart:io';
import 'dart:svg';
import 'dart:typed_data';

Future<void> main() async {
  var host = '127.0.0.1';
  var port = 3306;

  // await RawSocket.connect(host, port).then((socket) async {
  //   print('socket is ok');
  //   socket.listen((RawSocketEvent event) {
  //     print(event);
  //   }, onError: (e) {
  //     print('socket listen on error');
  //   }, onDone: () {
  //     print('socket listen on done');
  //   });

  //   //socket.write(c.utf8.encode('hello'));

  //   await Future.delayed(Duration(seconds: 1));

  //   await socket.close();
  // });

  print('finish');
}

void _onData(dynamic s) {
  print('_onData');
  print(s.runtimeType);
}

void _onError(dynamic s) {
  print('_onError');
  print(s.runtimeType);
}

void _onDone() {
  print('_onDone');
}
