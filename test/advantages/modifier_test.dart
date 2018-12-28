import 'package:gurps_dart/src/advantages/modifier.dart';
import 'package:test/test.dart';

void main() {
  ModifierBase affects;
  ModifierBase accurate;
  ModifierBase affSub;
  ModifierBase area;
  ModifierBase armorDivisor;

  setUp(() async {
    affects = await ModifierBase.fetchByName('Affects Insubstantial');
    affSub = await ModifierBase.fetchByName('Affects Substantial');
    accurate = await ModifierBase.fetchByName('Accurate');
    area = await ModifierBase.fetchByName('Area Effect');
    armorDivisor = await ModifierBase.fetchByName('Armor Divisor');
  });

  group('Modifier Base', () {
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
        }, throwsStateError);
      });

      test('Affects Substantial', () {
        expect(affSub.hasLevels, isFalse);
        expect(() {
          affSub.percentageForLevel(1);
        }, throwsStateError);
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
        expect(accurate.textForLevel(1), equals(" +1"));
        expect(accurate.textForLevel(2), equals(" +2"));
        expect(accurate.textForLevel(3), equals(" +3"));
      });
      test('Area Effect', () {
        expect(area.textForLevel(1), equals(", 2 yards"));
        expect(area.textForLevel(2), equals(", 4 yards"));
        expect(area.textForLevel(3), equals(", 8 yards"));
        expect(area.textForLevel(4), equals(", 16 yards"));
      });
      test('Armor Divisor', () {
        expect(armorDivisor.textForLevel(1), equals(" (2)"));
        expect(armorDivisor.textForLevel(2), equals(" (3)"));
        expect(armorDivisor.textForLevel(3), equals(" (5)"));
        expect(armorDivisor.textForLevel(4), equals(" (10)"));
        expect(() {
          armorDivisor.textForLevel(5);
        }, throwsA(TypeMatcher<RangeError>()));
      });
    });
  });

  group("Modifier", () {
    test('Accurate', () {
      Modifier mod = Modifier(base: accurate);

      expect(mod.hasLevels, isTrue);
      expect(mod.level, equals(1));
      expect(mod.percentage, equals(5));
      expect(mod.text, equals('Accurate +1, +5%'));

      mod.level = 2;
      expect(mod.percentage, equals(10));
      expect(mod.text, equals('Accurate +2, +10%'));
    });

    test('Affects Insubstantial', () {
      var mod = Modifier(base: affects);
      expect(mod.hasLevels, isFalse);
      expect(mod.level, isNull);
      expect(mod.text, equals('Affects Insubstantial, +20%'));

      expect(() {
        mod.level = 2;
      }, throwsStateError);
    });

    test('Affects Substantial', () {
      var mod = Modifier(base: affSub);
      expect(mod.hasLevels, isFalse);
      expect(mod.level, isNull);
      expect(mod.text, equals('Affects Substantial, +40%'));

      expect(() {
        mod.level = 2;
      }, throwsStateError);
    });

    test('Area Effect', () {
      var mod = Modifier(base: area);
      expect(mod.hasLevels, isTrue);
      expect(mod.level, 1);
      expect(mod.text, equals('Area Effect, 2 yards, +50%'));

      mod.level = 2;
      expect(mod.text, equals('Area Effect, 4 yards, +100%'));

      mod.level = 3;
      expect(mod.text, equals('Area Effect, 8 yards, +150%'));
    });

    test('Armor Divisor', () async {
      var mod = await Modifier.build('Armor Divisor');
      expect(mod.name, equals('Armor Divisor'));
      expect(mod.text, equals('Armor Divisor (2), +50%'));

      mod.level = 2;
      expect(mod.text, equals('Armor Divisor (3), +100%'));

      mod.level = 3;
      expect(mod.text, equals('Armor Divisor (5), +150%'));

      mod.level = 4;
      expect(mod.text, equals('Armor Divisor (10), +200%'));

      expect(() {
        mod.level = 5;
      }, throwsRangeError);
    });

    test('Blockable', () async {
      var mod = await Modifier.build('Blockable');
      expect(mod.name, equals('Blockable'));
      expect(mod.hasLevels, isTrue);
      expect(mod.level, equals(1));
      expect(mod.percentage, equals(-5));
      expect(mod.text, equals('Blockable, -5%'));

      mod.level = 2;
      expect(mod.name, equals('Blockable'));
      expect(mod.level, equals(2));
      expect(mod.percentage, equals(-10));

      expect(mod.text, equals('Blockable, and can be parried, -10%'));
    });

    test('Cosmic', () async {
      var mod = await Modifier.build('Cosmic');
      expect(mod.name, equals('Cosmic'));
      expect(mod.text, equals('Cosmic, Adding utility, +50%'));
      expect(mod.hasLevels, isTrue);
      expect(mod.level, equals(1));
      expect(mod.percentage, equals(50));

      mod.level = 2;
      expect(mod.text, equals('Cosmic, Cheating, +100%'));

      mod.level = 3;
      expect(mod.text, equals('Cosmic, Godlike tricks, +300%'));
    });
  });
}
