import 'dart:typed_data';

import 'package:reastream/reastream.dart';
import 'package:test/test.dart';

void main() {
  group('PacketParser', () {
    PacketCodec parser;

    setUp(() {
      parser = PacketCodec();
    });

    test('invalid data', () {
      final result = parser.decode(Uint8List.fromList([1, 2, 3, 4, 5]));
      expect(result, isNull);
    });

    test('MIDI data decode', () {
      final result = parser.decode(Uint8List.fromList([
        109, 82, 83, 82, // type check bits
        72, 0, 0, 0, // packet size
        100, 101, 102, 97, 117, 108, 116, 0, 0, 0, // identifier 0-10
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, // identifier 11-20
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, // identifier 21-32
        1, 0, 0, 0, // type (1 = MIDI, ignore message otherwise)
        24, 0, 0, 0, // bytesize (includes type and bytesize)
        0, 0, 0, 0, // sample frames since last event
        0, 0, 0, 0, // flags (see vst spec)
        0, 0, 0, 0, // noteLength (see vst spec)
        0, 0, 0, 0, // noteOffset (see vst spec)
        144, 72, 127, // MIDI data
        0, // zero reserved
        0, // detune
        0, // noteOffVelocity
        0, 0 // ?
      ]));
      expect(
        result,
        MidiPacket(
          identifier: 'default',
          events: [
            MidiEvent(
              sampleFramesSinceLastEvent: 0,
              flags: 0,
              noteLength: 0,
              noteOffset: 0,
              data: Uint8List.fromList([0x90, 72, 127]),
              detune: 0,
              noteOffVelocity: 0,
            ),
          ],
        ),
      );
    });

    test('MIDI data encode', () {
      final result = parser.encode(MidiPacket(
        identifier: 'default',
        events: [
          MidiEvent(
            sampleFramesSinceLastEvent: 0,
            flags: 0,
            noteLength: 0,
            noteOffset: 0,
            data: Uint8List.fromList([0x90, 72, 127]),
            detune: 0,
            noteOffVelocity: 0,
          ),
        ],
      ));
      expect(
        result,
        Uint8List.fromList([
          109, 82, 83, 82, // type check bits
          72, 0, 0, 0, // packet size
          100, 101, 102, 97, 117, 108, 116, 0, 0, 0, // identifier 0-10
          0, 0, 0, 0, 0, 0, 0, 0, 0, 0, // identifier 11-20
          0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, // identifier 21-32
          1, 0, 0, 0, // type (1 = MIDI, ignore message otherwise)
          24, 0, 0, 0, // bytesize (includes type and bytesize)
          0, 0, 0, 0, // sample frames since last event
          0, 0, 0, 0, // flags (see vst spec)
          0, 0, 0, 0, // noteLength (see vst spec)
          0, 0, 0, 0, // noteOffset (see vst spec)
          144, 72, 127, // MIDI data
          0, // zero reserved
          0, // detune
          0, // noteOffVelocity
          0, 0 // ?
        ]),
      );
    });
  });
}
