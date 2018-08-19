import "package:test/test.dart";
import '../lib/src/trait_modifier.dart';

void main() {
  group('TraitModifier', () {
    var t = TraitModifier("name", "detail", 10);

    test('constructor', () {
      expect(t.name, equals('name'));
      expect(t.detail, equals('detail'));
      expect(t.level, equals(10));
    });

    test('has summary text', () {
      expect(t.summaryText, equals(t.name));
    });

    test('has typical text', () {
      expect(t.typicalText, equals('name, detail, +10%'));

      expect(TraitModifier('name2', null, -25).typicalText, equals('name2, -25%'));
    });
  });

  group('TraitModifierList', () {
    TraitModifierList emptyList;
    TraitModifierList filledList;

    setUp(() async {
      emptyList = TraitModifierList();
      filledList = TraitModifierList();
      filledList.addAll([
        TraitModifier('a', null, -15),
        TraitModifier('b', null, -25),
        TraitModifier('c', null, 50)
      ]);
    });

    test('by default should be empty', () {
      expect(emptyList.isEmpty, equals(true));
      expect(emptyList.sum, equals(0));
    });

    test('sum should equal sum of all element levels', () {
      emptyList.addAll([TraitModifier('a', null, -15), TraitModifier('b', null, -25)]);
      expect(emptyList.sum, equals(-40));
      expect(filledList.sum, equals(10));
    });

    test('has adjustment', () {
      expect(filledList.adjustment(30), equals(3));
    });
  });

  group('TraitModifiable', () {
    Foo foo;

    setUp(() async {
      foo = Foo();
    });

    test('default has no modifiers', () {
      expect(foo.traitModifiers.isEmpty, equals(true));
    });

    test('can be cast to TraitModifiable', () {
      expect(foo.asTraitModifiable() is TraitModifiable, equals(true));
    });

    test('can add TraitModifiers', (){
      var z = TraitModifier('z', null, 25);
      var y = TraitModifier('y', null, -12);

      foo.addTraitModifier(y);
      foo.addTraitModifier(z);

      expect(foo.getAt(0), equals(y));
      expect(foo.getAt(1), equals(z));
      expect(foo.traitModifiers.length, equals(2));

      expect(foo.sumOfTraitModifierLevels, equals(13));
      expect(foo.adjustmentForTraitModifiers(2), equals(1));

      foo.removeAt(0);

      expect(foo.getAt(0), equals(z));
      expect(foo.traitModifiers.length, equals(1));

      expect(foo.sumOfTraitModifierLevels, equals(25));
      expect(foo.adjustmentForTraitModifiers(6), equals(2));
    });
  });
}

class Foo extends Object with TraitModifiable {}
