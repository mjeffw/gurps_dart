import 'package:test/test.dart';
import 'package:gurps_dart/src/advantages/advantage.dart';

void main() {
  Advantage three60Vision;
  Advantage absoluteTiming;

  setUp(() async {
    three60Vision = await Advantage.fetchByName('360° Vision');
    absoluteTiming = await Advantage.fetchByName('Absolute Timing');
  });

  test('360 vision', () async {
    expect(three60Vision.name, equals('360° Vision'));
    expect(three60Vision.cost, equals(25));
    expect(three60Vision.isExotic, isTrue);
  });

  test('absolute timing', () async {
    expect(absoluteTiming.name, 'Absolute Timing');
    expect(absoluteTiming.cost, 2);
    expect(absoluteTiming.hasEnhancements, isTrue);
    expect(absoluteTiming.enhancements.values, hasLength(1));
    expect(absoluteTiming.enhancements['Chronolocation'].cost, equals(5));
  });
}
