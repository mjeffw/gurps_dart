import 'package:gurps_dart/src/advantages/modifier.dart';
import 'package:test/test.dart';

void main() {
  ModifierBase affects;
  ModifierBase accurate;
  ModifierBase affSub;
  ModifierBase area;
  ModifierBase armorDivisor;

  setUp(() async {
    await ModifierBase.readModifierData();

    affects = ModifierBase.fetchByName('Affects Insubstantial');
    affSub = ModifierBase.fetchByName('Affects Substantial');
    accurate = ModifierBase.fetchByName('Accurate');
    area = ModifierBase.fetchByName('Area Effect');
    armorDivisor = ModifierBase.fetchByName('Armor Divisor');
  });

  group('Modifier Base', () {
    test('read by name', () {
      expect(affects.name, equals('Affects Insubstantial'));
      expect(accurate.name, equals('Accurate'));
      expect(affSub.name, equals('Affects Substantial'));
      expect(area.name, equals('Area Effect'));
      expect(armorDivisor.name, equals('Armor Divisor'));
    });

    test('has percentage', () {
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
      expect(mod.percent, equals(5));
      expect(mod.typicalText, equals('Accurate +1, +5%'));

      mod.level = 2;
      expect(mod.percent, equals(10));
      expect(mod.typicalText, equals('Accurate +2, +10%'));
    });

    test('Affects Insubstantial', () {
      var mod = Modifier(base: affects);
      expect(mod.hasLevels, isFalse);
      expect(mod.level, isNull);
      expect(mod.typicalText, equals('Affects Insubstantial, +20%'));

      expect(() {
        mod.level = 2;
      }, throwsStateError);
    });

    test('Affects Substantial', () {
      var mod = Modifier(base: affSub);
      expect(mod.hasLevels, isFalse);
      expect(mod.level, isNull);
      expect(mod.typicalText, equals('Affects Substantial, +40%'));

      expect(() {
        mod.level = 2;
      }, throwsStateError);
    });

    test('Area Effect', () {
      var mod = Modifier(base: area);
      expect(mod.hasLevels, isTrue);
      expect(mod.level, 1);
      expect(mod.typicalText, equals('Area Effect, 2 yards, +50%'));

      mod.level = 2;
      expect(mod.typicalText, equals('Area Effect, 4 yards, +100%'));

      mod.level = 3;
      expect(mod.typicalText, equals('Area Effect, 8 yards, +150%'));
    });

    test('Armor Divisor', () {
      var mod = Modifier.build('Armor Divisor');
      expect(mod.name, equals('Armor Divisor'));
      expect(mod.typicalText, equals('Armor Divisor (2), +50%'));

      mod.level = 2;
      expect(mod.typicalText, equals('Armor Divisor (3), +100%'));

      mod.level = 3;
      expect(mod.typicalText, equals('Armor Divisor (5), +150%'));

      mod.level = 4;
      expect(mod.typicalText, equals('Armor Divisor (10), +200%'));

      expect(() {
        mod.level = 5;
      }, throwsRangeError);
    });

    test('Blockable', () {
      var mod = Modifier.build('Blockable');
      expect(mod.name, equals('Blockable'));
      expect(mod.hasLevels, isTrue);
      expect(mod.level, equals(1));
      expect(mod.percent, equals(-5));
      expect(mod.typicalText, equals('Blockable, -5%'));

      mod.level = 2;
      expect(mod.name, equals('Blockable'));
      expect(mod.level, equals(2));
      expect(mod.percent, equals(-10));

      expect(mod.typicalText, equals('Blockable, and can be parried, -10%'));
    });

    test('Cosmic', () {
      var mod = Modifier.build('Cosmic');
      expect(mod.name, equals('Cosmic'));
      expect(mod.typicalText, equals('Cosmic, Adding utility, +50%'));
      expect(mod.hasLevels, isTrue);
      expect(mod.level, equals(1));
      expect(mod.percent, equals(50));

      mod.level = 2;
      expect(mod.typicalText, equals('Cosmic, Cheating, +100%'));

      mod.level = 3;
      expect(mod.typicalText, equals('Cosmic, Godlike tricks, +300%'));

      mod.level = 1;
      mod.specializationText =
          'Does knockback-based damage against diffuse targets';
      expect(
          mod.typicalText,
          equals(
              'Cosmic, Does knockback-based damage against diffuse targets, +50%'));
    });
  });
}
