import 'dart:typed_data';

class Uint8ListIterator {
  final Uint8List list;
  int _currentIndex;

  Uint8ListIterator(
    this.list, {
    int from = 0,
  }) : _currentIndex = from;

  int nextByte() {
    return list[_currentIndex++];
  }

  int nextShort() {
    final value0 = nextByte();
    final value1 = nextByte();
    return value1 << 8 | value0;
  }

  int nextInt() {
    final value0 = nextByte();
    final value1 = nextByte();
    final value2 = nextByte();
    final value3 = nextByte();
    return value3 << 24 | value2 << 16 | value1 << 8 | value0;
  }

  Uint8List nextBytes(int count) {
    final from = _currentIndex;
    final to = _currentIndex + count;
    final result = list.sublist(from, to);
    _currentIndex += count;
    return result;
  }

  Float32List nextFloats(int byteCount) {
    final from = _currentIndex;
    final to = _currentIndex + byteCount;
    final result = list.sublist(from, to).buffer.asFloat32List();
    _currentIndex = to;
    return result;
  }
}
