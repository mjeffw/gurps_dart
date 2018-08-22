import "package:test/test.dart";
import '../../lib/src/units/gurps_distance.dart';

void main() {
  test('in yards', () {
    expect(GurpsDistance(yards: 1000).inYards, equals(1000));
    expect(GurpsDistance(yards: 1000).inMiles, equals(0));
    expect(GurpsDistance(miles: 10).inYards, equals(20000));
    expect(GurpsDistance(yards: 3000).inMiles, equals(1));
  });

  test('to formatted string', (){
    expect(GurpsDistance.toFormattedString(1000), equals('1000 yards'));
    expect(GurpsDistance.toFormattedString(2000), equals('1 miles'));
    expect(GurpsDistance.toFormattedString(20000), equals('10 miles'));
    expect(GurpsDistance.toFormattedString(3000), equals('1.5 miles'));
  });

  test('to formatted string with show fraction', (){
    expect(GurpsDistance.toFormattedString(1000, showFraction: false), equals('1000 yards'));
    expect(GurpsDistance.toFormattedString(2000, showFraction: false), equals('1 miles'));
    expect(GurpsDistance.toFormattedString(20000, showFraction: false), equals('10 miles'));
    expect(GurpsDistance.toFormattedString(3000, showFraction: false), equals('1 miles 1000 yards'));
  });
}