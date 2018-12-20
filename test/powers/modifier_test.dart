import 'package:gurps_dart/src/powers/modifier.dart';
import 'package:test/test.dart';

void main() {
  Modifier affects;
  Modifier accurate;
  Modifier affSub;
  Modifier area;

  setUp(() async {
    affects = await Modifier.fetch('Affects Insubstantial');
    affSub = await Modifier.fetch('Affects Substantial');
    accurate = await Modifier.fetch('Accurate');
    area = await Modifier.fetch('Area Effect');
  });

  test('read by name', () async {
    expect(affects.name, equals('Affects Insubstantial'));
    expect(accurate.name, equals('Accurate'));
    expect(affSub.name, equals('Affects Substantial'));
    expect(area.name, equals('Area Effect'));
  });

  test('has percentage', () async {
    expect(affects.percentage, equals(20));
    expect(accurate.percentage, equals(5));
    expect(affSub.percentage, equals(40));
    expect(area.percentage, equals(50));
  });

  test('is Attack modifier', () {
    expect(affects.isAttack, isFalse);
    expect(accurate.isAttack, isTrue);
    expect(affSub.isAttack, isFalse);
    expect(area.isAttack, isTrue);
  });

  test('has Levels', () {
    expect(affects.hasLevels, isFalse);
    expect(affSub.hasLevels, isFalse);
    expect(accurate.hasLevels, isTrue);
    expect(area.hasLevels, isTrue);

    expect(accurate.percentageForLevel(1), equals(5));
    expect(accurate.percentageForLevel(2), equals(10));
    expect(accurate.percentageForLevel(3), equals(15));

    expect(area.percentageForLevel(1), equals(50));
    expect(area.percentageForLevel(2), equals(100));
    expect(area.percentageForLevel(3), equals(150));

    expect(() {
      affects.percentageForLevel(1);
    }, throwsA('Affects Insubstantial does not have levels'));
  });

  test('has text for level', () {
    expect(accurate.textForLevel(1), equals("+1"));
    expect(accurate.textForLevel(2), equals("+2"));
    expect(accurate.textForLevel(3), equals("+3"));

    expect(area.textForLevel(1), equals("2 yards"));
    expect(area.textForLevel(2), equals("4 yards"));
    expect(area.textForLevel(3), equals("8 yards"));
  });
}
