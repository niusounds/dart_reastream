import 'dart:io';
import 'dart:typed_data';

abstract class DataSender {
  void send(Uint8List data, InternetAddress remote, int port);

  void dispose();
}

class UdpDataSender implements DataSender {
  UdpDataSender({
    this.socket,
  }) : assert(socket != null);

  final RawDatagramSocket socket;

  @override
  void send(Uint8List data, InternetAddress remote, int port) {
    socket.send(data, remote, port);
  }

  @override
  void dispose() {
    socket.close();
  }
}
