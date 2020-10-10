import "package:test/test.dart";
import '../../lib/src/units/gduration.dart';

void main() {
  var oneYear = GDuration(years: 1);

  test('in seconds', () {
    expect(GDuration(seconds: 12).inSeconds, equals(12));
    expect(GDuration(minutes: 3).inSeconds, equals(180));
    expect(GDuration(hours: 1).inSeconds, equals(3600));
    expect(GDuration(days: 2).inSeconds, equals(172800));
    expect(GDuration(weeks: 4).inSeconds, equals(2419200));
    expect(GDuration(months: 3).inSeconds, equals(7884000));
    expect(GDuration(years: 5).inSeconds, equals(157680000));

    expect(
        GDuration(
                years: 5, months: 3, days: 2, hours: 1, minutes: 3, seconds: 12)
            .inSeconds,
        equals(165740592));
  });

  test('in hours', () {
    expect(GDuration(seconds: 12).inHours, equals(0));
    expect(GDuration(minutes: 300).inHours, equals(5));
    expect(GDuration(hours: 1).inHours, equals(1));
    expect(GDuration(days: 2).inHours, equals(48));
    expect(GDuration(weeks: 4).inHours, equals(672));
    expect(GDuration(months: 3).inHours, equals(2190));
    expect(GDuration(years: 5).inHours, equals(43800));

    expect(
        GDuration(
                years: 5, months: 3, days: 2, hours: 1, minutes: 3, seconds: 12)
            .inHours,
        equals(46039));
  });

  test('+', () {
    expect((GDuration(minutes: 3) + GDuration(seconds: 45)).inSeconds,
        equals(225));
  });

  test('-', () {
    expect((GDuration(minutes: 3) - GDuration(seconds: 45)).inSeconds,
        equals(135));
  });

  test('*', () {
    expect((GDuration(minutes: 3) * 5).inSeconds, equals(900));
  });

  test('~/', () {
    expect((GDuration(years: 2) ~/ 2).inSeconds, equals(oneYear.inSeconds));
    expect((GDuration(weeks: 3) ~/ 2).inSeconds, equals(907200));
  });

  test('<', () {
    expect(GDuration(seconds: 179) < GDuration(minutes: 3), equals(true));
    expect(GDuration(seconds: 180) < GDuration(minutes: 3), equals(false));
  });

  test('>', () {
    expect(GDuration(days: 15) > GDuration(weeks: 2), equals(true));
    expect(GDuration(days: 14) > GDuration(weeks: 2), equals(false));
    expect(GDuration(days: 14, seconds: 1) > GDuration(weeks: 2), equals(true));
  });

  test('<=', () {
    expect(GDuration(seconds: 179) <= GDuration(minutes: 3), equals(true));
    expect(GDuration(seconds: 180) <= GDuration(minutes: 3), equals(true));
    expect(GDuration(seconds: 181) <= GDuration(minutes: 3), equals(false));
  });

  test('>=', () {
    expect(GDuration(days: 15) >= GDuration(weeks: 2), equals(true));
    expect(GDuration(days: 14) >= GDuration(weeks: 2), equals(true));
    expect(
        GDuration(days: 14, seconds: 1) >= GDuration(weeks: 2), equals(true));
    expect(
        GDuration(days: 13, hours: 23, minutes: 59, seconds: 59) >=
            GDuration(weeks: 2),
        equals(false));
  });

  test('==', () {
    expect(GDuration(days: 365) == oneYear, equals(true));
    expect(GDuration(days: 366) == oneYear, equals(false));
    expect(GDuration(days: 364) == oneYear, equals(false));
  });

  test('compare', () {
    expect(GDuration(days: 365).compareTo(oneYear), equals(0));
    expect(GDuration(days: 366).compareTo(oneYear) > 0, equals(true));
    expect(GDuration(days: 364).compareTo(oneYear) < 0, equals(true));
  });

  test('pretty print', () {
    expect(
        GDuration.toFormattedString(GDuration(
                years: 5, months: 3, days: 2, hours: 1, minutes: 3, seconds: 12)
            .inSeconds),
        equals('5 years 3 months 2 days 1 hour 3 minutes 12 seconds'));

    expect(GDuration.toFormattedString(GDuration(years: 1).inSeconds),
        equals('1 year'));

    expect(GDuration.toFormattedString(GDuration(years: 2).inSeconds),
        equals('2 years'));

    expect(GDuration.toFormattedString(GDuration(seconds: 1).inSeconds),
        equals('1 second'));

    expect(GDuration.toFormattedString(GDuration(seconds: 2).inSeconds),
        equals('2 seconds'));

    expect(GDuration.toFormattedString(GDuration(minutes: 1).inSeconds),
        equals('1 minute'));

    expect(GDuration.toFormattedString(GDuration(minutes: 2).inSeconds),
        equals('2 minutes'));

    expect(GDuration.toFormattedString(GDuration(hours: 1).inSeconds),
        equals('1 hour'));

    expect(GDuration.toFormattedString(GDuration(hours: 2).inSeconds),
        equals('2 hours'));

    expect(GDuration.toFormattedString(GDuration(days: 1).inSeconds),
        equals('1 day'));

    expect(GDuration.toFormattedString(GDuration(days: 2).inSeconds),
        equals('2 days'));

    expect(GDuration.toFormattedString(GDuration(weeks: 1).inSeconds),
        equals('1 week'));

    expect(GDuration.toFormattedString(GDuration(weeks: 2).inSeconds),
        equals('2 weeks'));

    expect(GDuration.toFormattedString(GDuration(months: 1).inSeconds),
        equals('1 month'));

    expect(GDuration.toFormattedString(GDuration(months: 2).inSeconds),
        equals('2 months'));
  });

  test('hashcode', () {
    expect(GDuration(days: 365).hashCode, equals(oneYear.hashCode));
    expect(GDuration(days: 366).hashCode, isNot(equals(true)));
    expect(GDuration(days: 364).hashCode, isNot(equals(true)));
  });
}
