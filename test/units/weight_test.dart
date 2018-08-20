import "package:test/test.dart";
import '../../lib/src/units/weight.dart';

void main() {
  test('tons to pounds', () {
    expect(Weight(tons: 2).inPounds, equals(4000));
  });

  test('to formatted string', (){
    expect(Weight.toFormattedString(1999), equals('1999 lbs.'));
  });
}