import 'package:gurps_dart/src/powers/modifier.dart';
import 'package:test/test.dart';

void main() {
  Modifier affects;
  Modifier accurate;
  Modifier affSub;

  setUp(() async {
    affects = await Modifier.fetch('Affects Insubstantial');
    affSub = await Modifier.fetch('Affects Substantial');
    accurate = await Modifier.fetch('Accurate');
  });

  test('read by name', () async {
    expect(affects.name, equals('Affects Insubstantial'));
    expect(accurate.name, equals('Accurate'));
    expect(affSub.name, equals('Affects Substantial'));
  });

  test('has percentage', () async {
    expect(affects.percentage, equals(20));
    expect(accurate.percentage, equals(5));
    expect(affSub.percentage, equals(40));
  });

  test('is Attack modifier', () {
    expect(affects.isAttack, isFalse);
    expect(accurate.isAttack, isTrue);
    expect(affSub.isAttack, isFalse);
  });

  test('has Levels', () {
    expect(affects.hasLevels, isFalse);
    expect(affSub.hasLevels, isFalse);
    expect(accurate.hasLevels, isTrue);
    expect(accurate.percentageForLevel(1), equals(5));
    expect(accurate.percentageForLevel(2), equals(10));
    expect(accurate.percentageForLevel(3), equals(15));

    expect(() {
      affects.percentageForLevel(1);
    }, throwsA('Affects Insubstantial does not have levels'));
  });

  test('has text for level', () {
    expect(accurate.textForLevel(1), equals("+1"));
  });
}
