import "package:test/test.dart";

import '../../lib/src/util/repeating_sequence.dart';

void main() {
  test('ordinal to value', () {
    var s = RepeatingSequenceConverter([2, 3, 5, 8]);

    expect(s.indexToValue(0), equals(2));
    expect(s.indexToValue(1), equals(3));
    expect(s.indexToValue(2), equals(5));
    expect(s.indexToValue(3), equals(8));
    expect(s.indexToValue(4), equals(20));
    expect(s.indexToValue(5), equals(30));
    expect(s.indexToValue(6), equals(50));
    expect(s.indexToValue(7), equals(80));
    expect(s.indexToValue(8), equals(200));
  });

  test('value to ordinal (exact)', () {
    var s = RepeatingSequenceConverter([2, 3, 5, 8]);

    expect(s.valueToIndex(2), equals(0));
    expect(s.valueToIndex(3), equals(1));
    expect(s.valueToIndex(5), equals(2));
    expect(s.valueToIndex(8), equals(3));
    expect(s.valueToIndex(20), equals(4));
    expect(s.valueToIndex(30), equals(5));
    expect(s.valueToIndex(50), equals(6));
    expect(s.valueToIndex(80), equals(7));
    expect(s.valueToIndex(200), equals(8));
  });

  test('value to ordinal (closest)', () {
    var s = RepeatingSequenceConverter([10, 30, 70]);

    expect(s.valueToIndex(2), equals(0));
    expect(s.valueToIndex(31), equals(2));
    expect(s.valueToIndex(50), equals(2));
    expect(s.valueToIndex(80), equals(3));
    expect(s.valueToIndex(120), equals(4));
  });
}
