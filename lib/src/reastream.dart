import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:meta/meta.dart';

import 'codec.dart';
import 'data_handler.dart';
import 'packet.dart';

class ReaStream {
  ReaStream({
    @required this.identifier,
    @required this.dataHandler,
    @required this.codec,
  })  : assert(identifier != null),
        assert(dataHandler != null),
        assert(codec != null);

  static Future<ReaStream> create({
    @required String identifier,
    int port = 58710,
    InternetAddress remote,
    PacketCodec codec,
  }) async {
    return ReaStream(
      identifier: identifier,
      dataHandler: await DataHandler.udp(
        remote: remote,
        port: port,
      ),
      codec: codec ?? PacketCodec(),
    );
  }

  final String identifier;
  final DataHandler dataHandler;
  final PacketCodec codec;

  Stream<Packet> receive() async* {
    yield* dataHandler
        .receive()
        .map((data) => codec.decode(data))
        .where((event) => event != null && event.identifier == identifier);
  }

  void send(Packet packet) {
    final data = codec.encode(packet);
    dataHandler.send(data);
  }

  void dispose() {
    dataHandler.dispose();
  }

  void allNotesOff() {
    // TODO: implement allNotesOff
  }

  void allSoundOff() {
    // TODO: implement allSoundOff
  }

  void controlChange(int controller, int value) {
    // TODO: implement controlChange
  }

  void noteOff(int note) {
    send(MidiPacket(
      identifier: identifier,
      events: [
        MidiEvent(
          detune: 0,
          flags: 0,
          noteLength: 0,
          noteOffVelocity: 0,
          noteOffset: 0,
          sampleFramesSinceLastEvent: 0,
          data: Uint8List.fromList([0x80, note, 0]),
        ),
      ],
    ));
  }

  void noteOn(int note, int velocity) {
    send(MidiPacket(
      identifier: identifier,
      events: [
        MidiEvent(
          detune: 0,
          flags: 0,
          noteLength: 0,
          noteOffVelocity: 0,
          noteOffset: 0,
          sampleFramesSinceLastEvent: 0,
          data: Uint8List.fromList([0x90, note, velocity]),
        ),
      ],
    ));
  }

  void pitchBend(int program) {
    // TODO: implement pitchBend
  }

  void programChange(int bank, int program) {
    // TODO: implement programChange
  }
}
