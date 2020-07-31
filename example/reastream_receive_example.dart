import 'package:reastream/reastream.dart';

void main() async {
  final reastream = await ReaStream.create();
  await for (var packet in reastream.receive()) {
    if (packet is MidiPacket) {
      // process MidiPacket
      print('Received $packet');
    } else if (packet is AudioPacket) {
      // process AudioPacket
      // print('Received $packet');
    }
  }
}
