import 'package:gurps_dart/src/advantages/advantage.dart';
import 'package:gurps_dart/src/trait_modifier.dart';
import 'package:gurps_dart/src/advantages/ability_parser.dart';

import 'package:test/test.dart';

void main() {
  test('Insubstantial Amphibians', () async {
    var text = 'Amphibious (Affects Insubstantial, +20%).';
    AbilityParser parser = AbilityParser(text);
    Advantage adv = await parser.advantage();
    expect(adv.name, equals('Amphibious'));

    List<TraitModifier> modifiers = await parser.modifiers();
    expect(modifiers, hasLength(equals(1)));
    expect(modifiers[0].name, equals('Affects Insubstantial'));
    expect(modifiers[0].percent, equals(20));
  });
  test('Unconscious Amphibians', () async {
    var text = 'Amphibious (Unconscious Only, -20%).';
    AbilityParser parser = AbilityParser(text);
    Advantage adv = await parser.advantage();
    expect(adv.name, equals('Amphibious'));

    List<TraitModifier> modifiers = await parser.modifiers();
    expect(modifiers, hasLength(equals(1)));
    expect(modifiers[0].name, equals('Unconscious Only'));
    expect(modifiers[0].percent, equals(-20));
  });
  test('Unconscious Amphibians with Alternate Negative Sign', () async {
    var text = 'Amphibious (Unconscious Only, −20%).';
    AbilityParser parser = AbilityParser(text);
    Advantage adv = await parser.advantage();
    expect(adv.name, equals('Amphibious'));

    List<TraitModifier> modifiers = await parser.modifiers();
    expect(modifiers, hasLength(equals(1)));
    expect(modifiers[0].name, equals('Unconscious Only'));
    expect(modifiers[0].percent, equals(-20));
  });
  test('Inaccessible Amphibians', () async {
    var text = 'Amphibious (Accessibility, Only when eating, −20%).';
    AbilityParser parser = AbilityParser(text);
    Advantage adv = await parser.advantage();
    expect(adv.name, equals('Amphibious'));

    List<TraitModifier> modifiers = await parser.modifiers();
    expect(modifiers, hasLength(equals(1)));
    expect(modifiers[0].name, equals('Accessibility'));
    expect(modifiers[0].detail, equals('Only when eating'));
    expect(modifiers[0].percent, equals(-20));
  });

  test('Insubstantial Unconscious Amphibians', () async {
    var text =
        'Amphibious (Affects Insubstantial, +20%; Unconscious Only, -20%).';
    Advantage adv = await Advantage.parse(text);
    expect(adv.name, equals('Amphibious'));
    expect(adv.cost, equals(10));

    List<TraitModifier> modifiers = adv.modifiers;
    expect(modifiers, hasLength(equals(2)));
    expect(modifiers[0].name, equals('Affects Insubstantial'));
    expect(modifiers[0].percent, equals(20));
    expect(modifiers[1].name, equals('Unconscious Only'));
    expect(modifiers[1].percent, equals(-20));

    expect(
        adv.text,
        equals(
            'Amphibious (Affects Insubstantial, +20%; Unconscious Only, -20%) [10].'));
  });
}
