import 'package:test/test.dart';
import 'package:gurps_dart/src/advantages/advantage.dart';
import 'package:gurps_dart/src/advantages/modifier.dart';

void main() {
  setUp(() async {});

  group('advantage base', () {
    test('360 vision', () async {
      var three60Vision = await AdvantageBase.fetchByName('360° Vision');

      expect(three60Vision.name, equals('360° Vision'));
      expect(three60Vision.cost, equals(25));
      expect(three60Vision.isExotic, isTrue);
      expect(three60Vision.isMental, isFalse);
      expect(three60Vision.isSocial, isFalse);
      expect(three60Vision.isPhysical, isTrue);
      expect(three60Vision.isSupernatural, isFalse);
      expect(three60Vision.isMundane, isFalse);
      expect(three60Vision.hasLevels, isFalse);
    });

    test('absolute timing', () async {
      var absoluteTiming = await AdvantageBase.fetchByName('Absolute Timing');
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
    });

    test('Affliction', () async {
      var affliction = await AdvantageBase.fetchByName('Affliction');
      expect(affliction.name, 'Affliction');
      expect(affliction.cost, 10);
      expect(affliction.hasLevels, isTrue);
      expect(affliction.isExotic, isTrue);
      expect(affliction.isMental, isFalse);
      expect(affliction.isSocial, isFalse);
      expect(affliction.isPhysical, isTrue);
      expect(affliction.isSupernatural, isFalse);
      expect(affliction.isMundane, isFalse);
    });
  });

  group('advantage', () {
    test('create', () async {
      Advantage adv = await Advantage.build('Affliction');

      expect(adv.cost, equals(10));
      expect(adv.hasLevels, isTrue);
      expect(adv.level, equals(1));

      Modifier m = await Modifier.build('Accurate');
      adv.modifiers.add(m);

      expect(adv.cost, equals(11));

      m.level = 4;
      expect(adv.cost, equals(12));
    });
  });
}
