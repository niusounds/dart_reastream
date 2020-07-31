import 'dart:io';
import 'dart:typed_data';

import 'package:reastream/reastream.dart';

void main() async {
  final reastream = await ReaStream.create(
    remote: InternetAddress.loopbackIPv4,
  );

  final noteStream = majorScale(
    from: 60,
    interval: const Duration(milliseconds: 500),
  );

  await for (final noteNumber in noteStream) {
    reastream.send(MidiPacket(
      identifier: 'default',
      events: [
        MidiEvent(
            detune: 0,
            flags: 0,
            noteLength: 0,
            noteOffVelocity: 0,
            noteOffset: 0,
            sampleFramesSinceLastEvent: 0,
            data: Uint8List.fromList([0x90, noteNumber, 96])),
      ],
    ));
    await Future.delayed(const Duration(milliseconds: 250));
    reastream.send(MidiPacket(
      identifier: 'default',
      events: [
        MidiEvent(
            detune: 0,
            flags: 0,
            noteLength: 0,
            noteOffVelocity: 0,
            noteOffset: 0,
            sampleFramesSinceLastEvent: 0,
            data: Uint8List.fromList([0x80, noteNumber, 0])),
      ],
    ));
  }
}

Stream<int> majorScale({
  int from,
  Duration interval,
}) async* {
  final notes = [0, 2, 4, 5, 7, 9, 11, 12];

  for (final relativeNote in notes) {
    final note = from + relativeNote;
    yield note;
    await Future.delayed(interval);
  }
}
