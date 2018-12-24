import 'package:test/test.dart';
import 'package:gurps_dart/src/advantages/advantage.dart';

void main() {
  setUp(() async {});

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
  });
}
