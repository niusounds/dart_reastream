import 'dart:typed_data';

import 'package:equatable/equatable.dart';

abstract class Packet extends Equatable {
  final String identifier;

  const Packet({
    this.identifier,
  });
}

/// Represents an audio sample packet.
class AudioPacket extends Packet {
  final int channel;
  final int sampleRate;
  final Float32List data;

  const AudioPacket({
    String identifier,
    this.channel,
    this.sampleRate,
    this.data,
  }) : super(identifier: identifier);

  @override
  List<Object> get props => [
        identifier,
        channel,
        sampleRate,
        data,
      ];

  @override
  String toString() {
    return 'AudioPacket{identifier: $identifier, channel: $channel, sampleRate: $sampleRate, dataLength: ${data?.length}}';
  }
}

/// Represents a MIDI events packet.
class MidiPacket extends Packet {
  static int headerByteSize = 4 + 4 + 32;
  final List<MidiEvent> events;

  const MidiPacket({
    String identifier,
    this.events,
  }) : super(identifier: identifier);

  @override
  List<Object> get props => [
        identifier,
        events,
      ];

  @override
  String toString() {
    return 'MidiPacket{identifier: $identifier, events: $events}';
  }
}

class MidiEvent extends Equatable {
  static const byteSize = 4 + 4 + 4 + 4 + 4 + 4 + 3 + 1 + 1 + 1 + 2;

  final int sampleFramesSinceLastEvent;
  final int flags;
  final int noteLength;
  final int noteOffset;
  final Uint8List data;
  final int detune;
  final int noteOffVelocity;

  const MidiEvent({
    this.sampleFramesSinceLastEvent,
    this.flags,
    this.noteLength,
    this.noteOffset,
    this.data,
    this.detune,
    this.noteOffVelocity,
  });

  @override
  List<Object> get props => [
        sampleFramesSinceLastEvent,
        flags,
        noteLength,
        noteOffset,
        data,
        detune,
        noteOffVelocity,
      ];
  // @override
  // bool operator ==(Object other) {
  //   if (other is MidiEvent) {
  //     return sampleFramesSinceLastEvent == other.sampleFramesSinceLastEvent &&
  //         flags == other.flags &&
  //         noteLength == other.noteLength &&
  //         noteOffset == other.noteOffset &&
  //         data == other.data &&
  //         detune == other.detune &&
  //         noteOffVelocity == other.noteOffVelocity;
  //   }
  //   return false;
  // }

  @override
  String toString() {
    return 'MidiEvent{sampleFramesSinceLastEvent: $sampleFramesSinceLastEvent, flags: $flags, noteLength: $noteLength, noteOffset: $noteOffset, data: $data, detune: $detune, noteOffVelocity: $noteOffVelocity}';
  }
}
