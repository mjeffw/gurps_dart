import 'package:gurps_dart/src/advantages/advantage.dart';
import 'package:gurps_dart/src/advantages/modifier.dart';
import 'package:test/test.dart';

void main() {
  test('Air Jet', () async {
    // Innate Attack, Crushing 1d (Blockable, −5%; Cosmic, Does knockback-based
    // damage against diffuse targets, +50%; Double Knockback, +20%; Increased
    // 1/2D, 2×, +5%; Increased Range, 2×, +10%; Jet, +0%; No Blunt Trauma,
    // −20%; No Wounding*, −25%; Runecasting, −30%) [6/level].
    Advantage airjet = await Advantage.build('Innate Attack');
    expect(airjet, isNotNull);
    expect(airjet.hasLevels, isTrue);
    expect(airjet.level, equals(1));
    expect(airjet.requiresSpecialization, isTrue);
    expect(airjet.specialization.name, equals('Crushing'));
    expect(airjet.cost, equals(5));

    Modifier m = await Modifier.build('Blockable');
    expect(m, isNotNull);
    airjet.modifiers.add(m);
  });
}
