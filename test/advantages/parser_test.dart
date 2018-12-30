import 'package:gurps_dart/src/advantages/advantage.dart';
import 'package:gurps_dart/src/trait_modifier.dart';
import 'package:test/test.dart';

void main() {
  test('Insubstantial Amphibians', () async {
    var text = 'Amphibious (Affects Insubstantial, +20%).';
    Advantage adv = await Advantage.parse(text);
    expect(adv.name, equals('Amphibious'));
    expect(adv.modifiers, hasLength(equals(1)));
    expect(adv.modifiers[0].name, equals('Affects Insubstantial'));
    expect(adv.modifiers[0].percent, equals(20));

    expect(adv.text, equals('Amphibious (Affects Insubstantial, +20%) [12].'));
  });
  test('Unconscious Amphibians', () async {
    var text = 'Amphibious (Unconscious Only, -20%).';
    Advantage adv = await Advantage.parse(text);
    expect(adv.name, equals('Amphibious'));

    expect(adv.modifiers, hasLength(equals(1)));
    expect(adv.modifiers[0].name, equals('Unconscious Only'));
    expect(adv.modifiers[0].percent, equals(-20));

    expect(adv.text, equals('Amphibious (Unconscious Only, -20%) [8].'));
  });
  test('Unconscious Amphibians with Alternate Negative Sign', () async {
    var text = 'Amphibious (Unconscious Only, −20%).';
    Advantage adv = await Advantage.parse(text);
    expect(adv.name, equals('Amphibious'));

    expect(adv.modifiers, hasLength(equals(1)));
    expect(adv.modifiers[0].name, equals('Unconscious Only'));
    expect(adv.modifiers[0].percent, equals(-20));

    expect(adv.text, equals('Amphibious (Unconscious Only, -20%) [8].'));
  });
  test('Inaccessible Amphibians', () async {
    var text = 'Amphibious (Accessibility, Only when eating, −20%).';
    Advantage adv = await Advantage.parse(text);
    expect(adv.name, equals('Amphibious'));

    expect(adv.modifiers, hasLength(equals(1)));
    expect(adv.modifiers[0].name, equals('Accessibility'));
    expect(adv.modifiers[0].detail, equals('Only when eating'));
    expect(adv.modifiers[0].percent, equals(-20));
    expect(adv.text,
        equals('Amphibious (Accessibility, Only when eating, -20%) [8].'));
  });

  test('Insubstantial Unconscious Inaccessible Amphibians', () async {
    var text =
        'Amphibious (Affects Insubstantial, +20%; Unconscious Only, -20%; Accessibility, Only when eating, -20%).';
    Advantage adv = await Advantage.parse(text);
    expect(adv.name, equals('Amphibious'));
    expect(adv.cost, equals(8));

    List<TraitModifier> modifiers = adv.modifiers;
    expect(modifiers, hasLength(equals(3)));
    expect(modifiers[0].name, equals('Accessibility'));
    expect(modifiers[0].detail, equals('Only when eating'));
    expect(modifiers[0].percent, equals(-20));
    expect(modifiers[1].name, equals('Affects Insubstantial'));
    expect(modifiers[1].percent, equals(20));
    expect(modifiers[2].name, equals('Unconscious Only'));
    expect(modifiers[2].percent, equals(-20));

    print(adv.text);
    expect(
        adv.text,
        equals(
            'Amphibious (Accessibility, Only when eating, -20%; Affects Insubstantial, +20%; Unconscious Only, -20%) [8].'));
  });
}
