import "package:test/test.dart";
import '../../lib/src/util/repeating_sequence.dart';

void main() {
  test('ordinal to value', () {
    var s = RepeatingSequenceConverter([2, 3, 5, 8]);

    expect(s.ordinalToValue(0), equals(2));
    expect(s.ordinalToValue(1), equals(3));
    expect(s.ordinalToValue(2), equals(5));
    expect(s.ordinalToValue(3), equals(8));
    expect(s.ordinalToValue(4), equals(20));
    expect(s.ordinalToValue(5), equals(30));
    expect(s.ordinalToValue(6), equals(50));
    expect(s.ordinalToValue(7), equals(80));
    expect(s.ordinalToValue(8), equals(200));
  });

  test('value to ordinal (exact)', (){
    var s = RepeatingSequenceConverter([2, 3, 5, 8]);

    expect(s.valueToOrdinal(2), equals(0));
    expect(s.valueToOrdinal(3), equals(1));
    expect(s.valueToOrdinal(5), equals(2));
    expect(s.valueToOrdinal(8), equals(3));
    expect(s.valueToOrdinal(20), equals(4));
    expect(s.valueToOrdinal(30), equals(5));
    expect(s.valueToOrdinal(50), equals(6));
    expect(s.valueToOrdinal(80), equals(7));
    expect(s.valueToOrdinal(200), equals(8));
  });

  test('value to ordinal (closest)', (){
    var s = RepeatingSequenceConverter([10, 30, 70]);

    expect(s.valueToOrdinal(2), equals(0));
    expect(s.valueToOrdinal(31), equals(2));
    expect(s.valueToOrdinal(50), equals(2));
    expect(s.valueToOrdinal(80), equals(3));
    expect(s.valueToOrdinal(120), equals(4));
  });
}