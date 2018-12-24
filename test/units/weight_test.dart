import "package:test/test.dart";

import '../../lib/src/units/weight.dart';

void main() {
  test('tons to pounds', () {
    expect(Weight(tons: 2).inPounds, equals(4000));
  });

  test('to formatted string', (){
    expect(Weight.toFormattedString(1999), equals('1999 lbs.'));
    expect(Weight.toFormattedString(2000), equals('1 tons'));
    expect(Weight.toFormattedString(3000), equals('1.5 tons'));
    expect(Weight.toFormattedString(4000), equals('2 tons'));
  });
}