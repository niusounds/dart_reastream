import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

abstract class DataHandler {
  Stream<Uint8List> receive();

  void send(Uint8List data);

  void dispose();

  static Future<DataHandler> udp({
    int port = 58710,
    InternetAddress remote,
    int remotePort,
  }) async {
    final socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, port);
    if (remote == null) {
      return _UdpReceiver(socket: socket);
    } else {
      return _UdpSenderAndReceiver(
        receiver: _UdpReceiver(socket: socket),
        remote: remote,
        remotePort: remotePort ?? port,
      );
    }
  }
}

class _UdpReceiver implements DataHandler {
  _UdpReceiver({
    this.socket,
  }) : assert(socket != null);

  final RawDatagramSocket socket;

  Stream<Uint8List> receive() async* {
    yield* socket
        .where((event) => event == RawSocketEvent.read)
        .map((event) => socket.receive().data);
  }

  @override
  void send(Uint8List data) {}

  @override
  void dispose() {
    socket.close();
  }
}

class _UdpSenderAndReceiver implements DataHandler {
  _UdpSenderAndReceiver({
    this.receiver,
    this.remote,
    this.remotePort,
  }) : assert(receiver != null);

  final _UdpReceiver receiver;
  final InternetAddress remote;
  final int remotePort;

  @override
  Stream<Uint8List> receive() {
    return receiver.receive();
  }

  @override
  void send(Uint8List data) {
    receiver.socket.send(data, remote, remotePort);
  }

  @override
  void dispose() {
    receiver.dispose();
  }
}
