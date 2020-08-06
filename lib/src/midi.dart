import 'dart:typed_data';

import 'package:reastream/reastream.dart';

abstract class MidiChannel {
  void allNotesOff();
  void allSoundOff();
  void controlChange(int controller, int value);
  void noteOff(int note);
  void noteOn(int note, int velocity);
  void programChange(int bank, int program);
  void pitchBend(int program);
}

class ReaStreamMidiChannel implements MidiChannel {
  final String identifier;
  final ReaStream reaStream;

  ReaStreamMidiChannel(
    this.identifier,
    this.reaStream,
  );

  @override
  void allNotesOff() {
    // TODO: implement allNotesOff
  }

  @override
  void allSoundOff() {
    // TODO: implement allSoundOff
  }

  @override
  void controlChange(int controller, int value) {
    // TODO: implement controlChange
  }

  @override
  void noteOff(int note) {
    // TODO: implement noteOff
  }

  @override
  void noteOn(int note, int velocity) {
    reaStream.send(MidiPacket(
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

  @override
  void pitchBend(int program) {
    // TODO: implement pitchBend
  }

  @override
  void programChange(int bank, int program) {
    // TODO: implement programChange
  }
}
