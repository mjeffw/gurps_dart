import 'package:gurps_dart/src/powers/modifier.dart';
import 'package:test/test.dart';

void main() {
  Modifier affects;
  Modifier accurate;

  setUp(() async {
    affects = await Modifier.fetch('Affects Insubstantial');
    accurate = await Modifier.fetch('Accurate');
  });

  test('read by name', () async {
    expect(affects.name, equals('Affects Insubstantial'));
    expect(accurate.name, equals('Accurate'));
  });

  test('has percentage', () async {
    expect(affects.percentage, equals(20));
    expect(accurate.percentage, equals(5));
  });

  test('is Attack modifier', () {
    expect(affects.isAttack, isFalse);
    expect(accurate.isAttack, isTrue);
  });

  test('has Levels', () {
    expect(affects.hasLevels, isFalse);
    expect(accurate.hasLevels, isTrue);
    expect(accurate.percentageForLevel(1), equals(5));
    expect(accurate.percentageForLevel(2), equals(10));
    expect(accurate.percentageForLevel(3), equals(15));

    expect(() {
      affects.percentageForLevel(1);
    }, throwsA('Affects Insubstantial does not have levels'));
  });
}
