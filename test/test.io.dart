import 'dart:io';

void main() {
  String indexRequest = 'GET / HTTP/1.1\nConnection: close\n\n';

  //connect to google port 80
  Socket.connect("flm.zhengzhouwannengbang.com", 80).then((socket) {
    print('Connected to: '
        '${socket.remoteAddress.address}:${socket.remotePort}');

    //Establish the onData, and onDone callbacks
    socket.listen((data) {
      print(new String.fromCharCodes(data).trim());
    }, onDone: () {
      print("Done");
      socket.destroy();
    });

    //Send the request
    socket.write(indexRequest);
  });
}
