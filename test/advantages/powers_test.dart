import 'package:gurps_dart/src/advantages/advantage.dart';
import 'package:test/test.dart';

void main() {
  setUp(() async {
    await AdvantageBase.readAdvantageData();
  });

  test('Animal Control', () {
    String text =
        'Mind Control (Accessibility, Animals only, -25%; Suggestion, -40%; Sorcery, -15%)';

    Advantage adv = Advantage.parse(text);
    expect(adv, isNotNull);
    expect(
        adv.text,
        equals(
            'Mind Control (Accessibility, Animals only, -25%; Sorcery, -15%; Suggestion, -40%) [10].'));
  });

  test('Shape Fire', () {
    String text =
        'Control Fire (Accessibility, Only to shape and move fire, -30%; Ranged, +40%; Sorcery, -15%)';

    Advantage adv = Advantage.parse(text);
    expect(adv, isNotNull);
    expect(
        adv.text,
        equals(
            'Control Fire 1 (Accessibility, Only to shape and move fire, -30%; Ranged, +40%; Sorcery, -15%) [19].'));
  });
}
