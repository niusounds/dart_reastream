import 'dart:typed_data';

import 'packet.dart';
import 'uint8_list_iterator.dart';

class PacketCodec {
  /// Parse raw byte array to produce [Packet].
  /// See reastream_spec.txt on this repository.
  Packet decode(Uint8List data) {
    final iterator = Uint8ListIterator(data);
    final typeCheckBit = iterator.nextByte();
    final messageValidateBits = [
      iterator.nextByte(),
      iterator.nextByte(),
      iterator.nextByte(),
    ];

    if (typeCheckBit == 77 &&
        messageValidateBits[0] == 82 &&
        messageValidateBits[1] == 83 &&
        messageValidateBits[2] == 82) {
      /* final packetSize = */ iterator.nextInt();
      final identifierBytes = iterator.nextBytes(32);
      final identifier = String.fromCharCodes(
          identifierBytes.where((element) => element != 0));
      final channel = iterator.nextByte();
      final sampleRate = iterator.nextInt();
      final blockLength = iterator.nextShort();

      final data = iterator.nextFloats(blockLength);

      return AudioPacket(
        identifier: identifier,
        channel: channel,
        sampleRate: sampleRate,
        data: data,
      );
    } else if (typeCheckBit == 109 &&
        messageValidateBits[0] == 82 &&
        messageValidateBits[1] == 83 &&
        messageValidateBits[2] == 82) {
      final packetSize = iterator.nextInt();

      final identifierBytes = iterator.nextBytes(32);
      final identifier = String.fromCharCodes(
          identifierBytes.where((element) => element != 0));

      final eventsBytes = packetSize - 4 - 4 - 32;
      final eventCount = eventsBytes ~/ MidiEvent.byteSize;

      final events = List.generate(eventCount, (index) {
        final type = iterator.nextInt();
        if (type != 1) {
          return null;
        }
        /* final byteSize = */ iterator.nextInt();
        final sampleFramesSinceLastEvent = iterator.nextInt();
        final flags = iterator.nextInt();
        final noteLength = iterator.nextInt();
        final noteOffset = iterator.nextInt();
        final data = iterator.nextBytes(3);
        /* final reservedZero = */ iterator.nextByte();
        final detune = iterator.nextByte();
        final noteOffVelocity = iterator.nextByte();
        return MidiEvent(
          sampleFramesSinceLastEvent: sampleFramesSinceLastEvent,
          flags: flags,
          noteLength: noteLength,
          noteOffset: noteOffset,
          data: data,
          detune: detune,
          noteOffVelocity: noteOffVelocity,
        );
      });

      return MidiPacket(
        identifier: identifier,
        events: events,
      );
    }

    return null;
  }

  Uint8List encode(Packet packet) {
    if (packet is MidiPacket) {
      final packetSize =
          MidiPacket.headerByteSize + packet.events.length * MidiEvent.byteSize;
      final data = ByteData(packetSize);
      data.setUint8(0, 109);
      data.setUint8(1, 82);
      data.setUint8(2, 83);
      data.setUint8(3, 82);
      data.setInt32(4, packetSize, Endian.little);
      data.buffer.asUint8List(8, 32).setAll(0, packet.identifier.codeUnits);

      for (var i = 0; i < packet.events.length; i++) {
        final event = packet.events[i];
        data.setInt32(i + 40, 1, Endian.little);
        data.setInt32(i + 44, MidiEvent.byteSize - 8, Endian.little);
        data.setInt32(i + 48, event.sampleFramesSinceLastEvent, Endian.little);
        data.setInt32(i + 52, event.flags, Endian.little);
        data.setInt32(i + 56, event.noteLength, Endian.little);
        data.setInt32(i + 60, event.noteOffset, Endian.little);
        data.buffer.asUint8List(i + 64, 3).setAll(0, event.data);
        data.setInt8(i + 67, 0);
        data.setInt8(i + 68, event.detune);
        data.setInt8(i + 69, event.noteOffVelocity);
      }

      return data.buffer.asUint8List();
    }

    throw UnimplementedError();
  }
}
