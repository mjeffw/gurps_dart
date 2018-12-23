import 'package:gurps_dart/src/advantages/modifier.dart';
import 'package:test/test.dart';

void main() {
  Modifier affects;
  Modifier accurate;
  Modifier affSub;
  Modifier area;
  Modifier armorDivisor;

  setUp(() async {
    affects = await Modifier.fetch('Affects Insubstantial');
    affSub = await Modifier.fetch('Affects Substantial');
    accurate = await Modifier.fetch('Accurate');
    area = await Modifier.fetch('Area Effect');
    armorDivisor = await Modifier.fetch('Armor Divisor');
  });

  test('read by name', () async {
    expect(affects.name, equals('Affects Insubstantial'));
    expect(accurate.name, equals('Accurate'));
    expect(affSub.name, equals('Affects Substantial'));
    expect(area.name, equals('Area Effect'));
    expect(armorDivisor.name, equals('Armor Divisor'));
  });

  test('has percentage', () async {
    expect(affects.percentage, equals(20));
    expect(accurate.percentage, equals(5));
    expect(affSub.percentage, equals(40));
    expect(area.percentage, equals(50));
  });

  test('is Attack modifier', () {
    expect(affects.isAttack, isFalse);
    expect(accurate.isAttack, isTrue);
    expect(affSub.isAttack, isFalse);
    expect(area.isAttack, isTrue);
    expect(armorDivisor.isAttack, isTrue);
  });

  group('has Levels', () {
    test('Affects Substantial', () {
      expect(affects.hasLevels, isFalse);

      expect(() {
        affects.percentageForLevel(1);
      }, throwsA('Affects Insubstantial does not have levels'));
    });

    test('Affects Substantial', () {
      expect(affSub.hasLevels, isFalse);
      expect(() {
        affSub.percentageForLevel(1);
      }, throwsA('Affects Substantial does not have levels'));
    });

    test('Accurate', () {
      expect(accurate.hasLevels, isTrue);

      expect(accurate.percentageForLevel(2), equals(10));
      expect(accurate.percentageForLevel(3), equals(15));
      expect(accurate.percentageForLevel(4), equals(20));
    });

    test('Area Effect', () {
      expect(area.hasLevels, isTrue);

      expect(area.percentageForLevel(2), equals(100));
      expect(area.percentageForLevel(3), equals(150));
      expect(area.percentageForLevel(4), equals(200));
    });

    test('Armor Divisor', () {
      expect(armorDivisor.hasLevels, isTrue);

      expect(armorDivisor.percentageForLevel(2), equals(100));
      expect(armorDivisor.percentageForLevel(3), equals(150));
      expect(armorDivisor.percentageForLevel(4), equals(200));

      expect(() {
        armorDivisor.percentageForLevel(5);
      }, throwsA(TypeMatcher<RangeError>()));
    });
  });

  group('has text for level', () {
    test('Accurate', () {
      expect(accurate.textForLevel(1), equals("+1"));
      expect(accurate.textForLevel(2), equals("+2"));
      expect(accurate.textForLevel(3), equals("+3"));
    });
    test('Area Effect', () {
      expect(area.textForLevel(1), equals("2 yards"));
      expect(area.textForLevel(2), equals("4 yards"));
      expect(area.textForLevel(3), equals("8 yards"));
      expect(area.textForLevel(4), equals("16 yards"));
    });
    test('Armor Divisor', () {
      expect(armorDivisor.textForLevel(1), equals("(2)"));
      expect(armorDivisor.textForLevel(2), equals("(3)"));
      expect(armorDivisor.textForLevel(3), equals("(5)"));
      expect(armorDivisor.textForLevel(4), equals("(10)"));
      expect(() {
        armorDivisor.textForLevel(5);
      }, throwsA(TypeMatcher<RangeError>()));
    });
  });
}
