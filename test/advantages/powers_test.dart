import 'package:gurps_dart/src/advantages/advantage.dart';
import 'package:test/test.dart';

void main() {
  test('Air Jet', () async {
    String text =
        'Affliction 1 (HT; Accessibility, Only portals, −50%; Extended Duration,100×, +80%; Fixed Duration, +0%; Melee Attack, Reach C, −30%; No Signature, +20%; Nuisance Effect, Can be overcome by Lockmaster, −5%; Paralysis, Variant, +150%; Runecasting, −30%)';

    print(text);
    Advantage adv = await Advantage.parse(text);
    expect(adv, isNotNull);
  });
}
