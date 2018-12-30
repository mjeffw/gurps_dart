import 'package:test/test.dart';
import 'package:gurps_dart/src/advantages/advantage.dart';
import 'package:gurps_dart/src/advantages/modifier.dart';

void main() {
  setUp(() async {
    await AdvantageBase.readAdvantageData();
  });

  group('advantage base', () {
    test('360 vision', () {
      var three60Vision = AdvantageBase.fetchByName('360° Vision');

      expect(three60Vision.name, equals('360° Vision'));
      expect(three60Vision.cost, equals(25));
      expect(three60Vision.isExotic, isTrue);
      expect(three60Vision.isMental, isFalse);
      expect(three60Vision.isSocial, isFalse);
      expect(three60Vision.isPhysical, isTrue);
      expect(three60Vision.isSupernatural, isFalse);
      expect(three60Vision.isMundane, isFalse);
      expect(three60Vision.hasLevels, isFalse);
      expect(three60Vision.hasEnhancements, isFalse);
      expect(three60Vision.requiresSpecialization, isFalse);
    });

    test('absolute timing', () {
      var absoluteTiming = AdvantageBase.fetchByName('Absolute Timing');
      expect(absoluteTiming.name, 'Absolute Timing');
      expect(absoluteTiming.cost, 2);
      expect(absoluteTiming.isExotic, isFalse);
      expect(absoluteTiming.isMental, isTrue);
      expect(absoluteTiming.isSocial, isFalse);
      expect(absoluteTiming.isPhysical, isFalse);
      expect(absoluteTiming.isSupernatural, isFalse);
      expect(absoluteTiming.isMundane, isTrue);
      expect(absoluteTiming.hasEnhancements, isTrue);
      expect(absoluteTiming.enhancements.values, hasLength(1));
      expect(absoluteTiming.enhancements['Chronolocation'].cost, equals(5));
      expect(absoluteTiming.hasLevels, isFalse);
      expect(absoluteTiming.requiresSpecialization, isFalse);
    });

    test('affliction', () {
      var affliction = AdvantageBase.fetchByName('Affliction');
      expect(affliction.name, 'Affliction');
      expect(affliction.cost, 10);
      expect(affliction.hasLevels, isTrue);
      expect(affliction.isExotic, isTrue);
      expect(affliction.isMental, isFalse);
      expect(affliction.isSocial, isFalse);
      expect(affliction.isPhysical, isTrue);
      expect(affliction.isSupernatural, isFalse);
      expect(affliction.isMundane, isFalse);
      expect(affliction.hasEnhancements, isFalse);
      expect(affliction.requiresSpecialization, isFalse);
    });

    test('create', () {
      var create = AdvantageBase.fetchByName('Create');
      expect(create.name, 'Create');
      expect(create.cost, 10);
      expect(create.hasLevels, isTrue);
      expect(create.isExotic, isTrue);
      expect(create.isMental, isFalse);
      expect(create.isSocial, isFalse);
      expect(create.isPhysical, isTrue);
      expect(create.isSupernatural, isFalse);
      expect(create.isMundane, isFalse);
      expect(create.hasEnhancements, isFalse);
      expect(create.requiresSpecialization, isTrue);
      expect(create.defaultSpecialization.name, equals('Small Category'));
    });
  });

  group('advantage', () {
    test('create', () {
      Advantage adv = Advantage.build('Affliction');

      expect(adv.cost, equals(10));
      expect(adv.hasLevels, isTrue);
      expect(adv.level, equals(1));
    });

    test('raising level', () {
      Advantage adv = Advantage.build('Affliction');
      adv.level = 4;
      expect(adv.cost, equals(40));
    });

    test('adding modifier', () async {
      Advantage adv = Advantage.build('Affliction');
      Modifier m = await Modifier.build('Accurate');
      adv.modifiers.add(m);

      expect(adv.cost, equals(11));

      m.level = 4;
      expect(adv.cost, equals(12));

      adv.level = 4;
      expect(adv.cost, equals(48));
    });

    test('Create Acid', () {
      Advantage createAcid = Advantage.build('Create');
      createAcid.specialization =
          createAcid.base.specializations['Medium Category'];
      expect(createAcid.cost, equals(20));
    });
  });
}
