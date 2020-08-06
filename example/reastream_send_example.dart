import 'dart:io';

import 'package:reastream/reastream.dart';

void main() async {
  final reastream = await ReaStream.create(
    identifier: 'default',
    remote: InternetAddress.loopbackIPv4,
  );

  final noteStream = majorScale(
    from: 60,
    interval: const Duration(milliseconds: 500),
  );

  await for (final noteNumber in noteStream) {
    reastream.noteOn(noteNumber, 96);
    await Future.delayed(const Duration(milliseconds: 250));
    reastream.noteOff(noteNumber);
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
