import 'dart:async';
import 'dart:io';

import 'codec.dart';
import 'data_handler.dart';
import 'packet.dart';

class ReaStream {
  ReaStream._({
    this.dataHandler,
    PacketCodec codec,
  }) : _codec = codec ?? PacketCodec();

  static Future<ReaStream> create({
    int port = 58710,
    InternetAddress remote,
    PacketCodec codec,
  }) async {
    return ReaStream._(
      dataHandler: await DataHandler.udp(
        remote: remote,
        port: port,
      ),
      codec: codec,
    );
  }

  final DataHandler dataHandler;
  final PacketCodec _codec;

  Stream<Packet> receive() async* {
    yield* dataHandler
        .receive()
        .map((data) => _codec.decode(data))
        .where((event) => event != null);
  }

  void send(Packet packet) {
    final data = _codec.encode(packet);
    dataHandler.send(data);
  }

  void dispose() {
    dataHandler.dispose();
  }
}
