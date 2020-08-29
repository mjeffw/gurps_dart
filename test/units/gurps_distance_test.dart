import "package:test/test.dart";
import '../../lib/src/units/gdistance.dart';

void main() {
  test('in yards', () {
    expect(GDistance(yards: 1000).inYards, equals(1000));
    expect(GDistance(yards: 1000).inMiles, equals(0));
    expect(GDistance(miles: 10).inYards, equals(20000));
    expect(GDistance(yards: 3000).inMiles, equals(1));
  });

  test('to formatted string', () {
    expect(GDistance.toFormattedString(1000), equals('1000 yards'));
    expect(GDistance.toFormattedString(2000), equals('1 miles'));
    expect(GDistance.toFormattedString(20000), equals('10 miles'));
    expect(GDistance.toFormattedString(3000), equals('1.5 miles'));
  });

  test('to formatted string with show fraction', () {
    expect(GDistance.toFormattedString(1000, showFraction: false),
        equals('1000 yards'));
    expect(GDistance.toFormattedString(2000, showFraction: false),
        equals('1 miles'));
    expect(GDistance.toFormattedString(20000, showFraction: false),
        equals('10 miles'));
    expect(GDistance.toFormattedString(3000, showFraction: false),
        equals('1 miles 1000 yards'));
  });
}
