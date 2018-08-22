import "package:test/test.dart";
import '../../lib/src/units/gurps_duration.dart';

void main() {
  var oneYear = GurpsDuration(years: 1);

  test('in seconds', () {
    expect(GurpsDuration(seconds: 12).inSeconds, equals(12));
    expect(GurpsDuration(minutes: 3).inSeconds, equals(180));
    expect(GurpsDuration(hours: 1).inSeconds, equals(3600));
    expect(GurpsDuration(days: 2).inSeconds, equals(172800));
    expect(GurpsDuration(weeks: 4).inSeconds, equals(2419200));
    expect(GurpsDuration(months: 3).inSeconds, equals(7884000));
    expect(GurpsDuration(years: 5).inSeconds, equals(157680000));

    expect(
        GurpsDuration(
                years: 5, months: 3, days: 2, hours: 1, minutes: 3, seconds: 12)
            .inSeconds,
        equals(165740592));
  });

  test('in hours', () {
    expect(GurpsDuration(seconds: 12).inHours, equals(0));
    expect(GurpsDuration(minutes: 300).inHours, equals(5));
    expect(GurpsDuration(hours: 1).inHours, equals(1));
    expect(GurpsDuration(days: 2).inHours, equals(48));
    expect(GurpsDuration(weeks: 4).inHours, equals(672));
    expect(GurpsDuration(months: 3).inHours, equals(2190));
    expect(GurpsDuration(years: 5).inHours, equals(43800));

    expect(
        GurpsDuration(
                years: 5, months: 3, days: 2, hours: 1, minutes: 3, seconds: 12)
            .inHours,
        equals(46039));
  });

  test('+', () {
    expect((GurpsDuration(minutes: 3) + GurpsDuration(seconds: 45)).inSeconds,
        equals(225));
  });

  test('-', () {
    expect((GurpsDuration(minutes: 3) - GurpsDuration(seconds: 45)).inSeconds,
        equals(135));
  });

  test('*', () {
    expect((GurpsDuration(minutes: 3) * 5).inSeconds, equals(900));
  });

  test('~/', () {
    expect((GurpsDuration(years: 2) ~/ 2).inSeconds, equals(oneYear.inSeconds));
    expect((GurpsDuration(weeks: 3) ~/ 2).inSeconds, equals(907200));
  });

  test('<', () {
    expect(
        GurpsDuration(seconds: 179) < GurpsDuration(minutes: 3), equals(true));
    expect(
        GurpsDuration(seconds: 180) < GurpsDuration(minutes: 3), equals(false));
  });

  test('>', () {
    expect(GurpsDuration(days: 15) > GurpsDuration(weeks: 2), equals(true));
    expect(GurpsDuration(days: 14) > GurpsDuration(weeks: 2), equals(false));
    expect(GurpsDuration(days: 14, seconds: 1) > GurpsDuration(weeks: 2),
        equals(true));
  });

  test('<=', () {
    expect(
        GurpsDuration(seconds: 179) <= GurpsDuration(minutes: 3), equals(true));
    expect(
        GurpsDuration(seconds: 180) <= GurpsDuration(minutes: 3), equals(true));
    expect(GurpsDuration(seconds: 181) <= GurpsDuration(minutes: 3),
        equals(false));
  });

  test('>=', () {
    expect(GurpsDuration(days: 15) >= GurpsDuration(weeks: 2), equals(true));
    expect(GurpsDuration(days: 14) >= GurpsDuration(weeks: 2), equals(true));
    expect(GurpsDuration(days: 14, seconds: 1) >= GurpsDuration(weeks: 2),
        equals(true));
    expect(
        GurpsDuration(days: 13, hours: 23, minutes: 59, seconds: 59) >=
            GurpsDuration(weeks: 2),
        equals(false));
  });

  test('==', () {
    expect(GurpsDuration(days: 365) == oneYear, equals(true));
    expect(GurpsDuration(days: 366) == oneYear, equals(false));
    expect(GurpsDuration(days: 364) == oneYear, equals(false));
  });

  test('compare', () {
    expect(GurpsDuration(days: 365).compareTo(oneYear), equals(0));
    expect(GurpsDuration(days: 366).compareTo(oneYear) > 0, equals(true));
    expect(GurpsDuration(days: 364).compareTo(oneYear) < 0, equals(true));
  });

  test('pretty print', () {
    expect(
        GurpsDuration.toFormattedString(GurpsDuration(
                years: 5, months: 3, days: 2, hours: 1, minutes: 3, seconds: 12)
            .inSeconds),
        equals('5 years 3 months 2 days 1 hour 3 minutes 12 seconds'));

    expect(GurpsDuration.toFormattedString(GurpsDuration(years: 1).inSeconds),
        equals('1 year'));

    expect(GurpsDuration.toFormattedString(GurpsDuration(years: 2).inSeconds),
        equals('2 years'));

    expect(GurpsDuration.toFormattedString(GurpsDuration(seconds: 1).inSeconds),
        equals('1 second'));

    expect(GurpsDuration.toFormattedString(GurpsDuration(seconds: 2).inSeconds),
        equals('2 seconds'));

    expect(GurpsDuration.toFormattedString(GurpsDuration(minutes: 1).inSeconds),
        equals('1 minute'));

    expect(GurpsDuration.toFormattedString(GurpsDuration(minutes: 2).inSeconds),
        equals('2 minutes'));

    expect(GurpsDuration.toFormattedString(GurpsDuration(hours: 1).inSeconds),
        equals('1 hour'));

    expect(GurpsDuration.toFormattedString(GurpsDuration(hours: 2).inSeconds),
        equals('2 hours'));

    expect(GurpsDuration.toFormattedString(GurpsDuration(days: 1).inSeconds),
        equals('1 day'));

    expect(GurpsDuration.toFormattedString(GurpsDuration(days: 2).inSeconds),
        equals('2 days'));

    expect(GurpsDuration.toFormattedString(GurpsDuration(weeks: 1).inSeconds),
        equals('1 week'));

    expect(GurpsDuration.toFormattedString(GurpsDuration(weeks: 2).inSeconds),
        equals('2 weeks'));

    expect(GurpsDuration.toFormattedString(GurpsDuration(months: 1).inSeconds),
        equals('1 month'));

    expect(GurpsDuration.toFormattedString(GurpsDuration(months: 2).inSeconds),
        equals('2 months'));
  });

  test('hashcode', (){
      expect(GurpsDuration(days: 365).hashCode, equals(oneYear.hashCode));
      expect(GurpsDuration(days: 366).hashCode, isNot(equals(true)));
      expect(GurpsDuration(days: 364).hashCode, isNot(equals(true)));
  });

  test('toString', (){
    expect(GurpsDuration(seconds: 12).toString(), equals
      ('GurpsDuration[seconds: 12]'));
    expect(GurpsDuration(minutes: 3).toString(), equals
      ('GurpsDuration[seconds: 180]'));
    expect(GurpsDuration(hours: 1).toString(), equals('GurpsDuration[seconds:'
        ' 3600]'));
    expect(GurpsDuration(days: 2).toString(), equals('GurpsDuration[seconds: '
        '172800]'));
    expect(GurpsDuration(weeks: 4).toString(), equals('GurpsDuration[seconds:'
        ' 2419200]'));
    expect(GurpsDuration(months: 3).toString(), equals
      ('GurpsDuration[seconds: 7884000]'));
    expect(GurpsDuration(years: 5).toString(), equals('GurpsDuration[seconds:'
        ' 157680000]'));

  });
}
