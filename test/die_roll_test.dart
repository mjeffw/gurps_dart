import "package:test/test.dart";

import "../lib/src/die_roll.dart";

void main() {
  test("can be constructed from a String", () {
    expect(DieRoll.fromString("1d-1"), equals(DieRoll(1, -1)));
    expect(DieRoll.fromString("1d"), equals(DieRoll(1, 0)));
    expect(DieRoll.fromString("1d+1"), equals(DieRoll(1, 1)));
    expect(DieRoll.fromString("1d+2"), equals(DieRoll(1, 2)));
    expect(DieRoll.fromString("4d-1"), equals(DieRoll(4, -1)));
    expect(DieRoll.fromString("4d"), equals(DieRoll(4, 0)));
    expect(DieRoll.fromString("4d+1"), equals(DieRoll(4, 1)));
    expect(DieRoll.fromString("4d+2"), equals(DieRoll(4, 2)));
  });

  test("should create normalized DieRoll", () {
    DieRoll d = DieRoll(1, 0);
    expect(d.numberOfDice, equals(1));
    expect(d.adds, equals(0));

    d = DieRoll(1, 1);
    expect(d.numberOfDice, equals(1));
    expect(d.adds, equals(1));

    d = DieRoll(1, 2);
    expect(d.numberOfDice, equals(1));
    expect(d.adds, equals(2));

    d = DieRoll(1, 3);
    expect(d.numberOfDice, equals(2));
    expect(d.adds, equals(-1));

    d = DieRoll(3, 2);
    expect(d.numberOfDice, equals(3));
    expect(d.adds, equals(2));

    d = DieRoll(3, 3);
    expect(d.numberOfDice, equals(4));
    expect(d.adds, equals(-1));

    d = DieRoll(5, -1);
    expect(d.numberOfDice, equals(5));
    expect(d.adds, equals(-1));

    d = DieRoll(5, -2);
    expect(d.numberOfDice, equals(4));
    expect(d.adds, equals(2));

    d = DieRoll(5, 20);
    expect(d.numberOfDice, equals(10));
    expect(d.adds, equals(0));

    d = DieRoll(7, -21);
    expect(d.numberOfDice, equals(2));
    expect(d.adds, equals(-1));

    d = DieRoll(1, -1);
    expect(d.numberOfDice, equals(1));
    expect(d.adds, equals(-1));
  });

  test("can denormalize", () {
    expect(DieRoll.denormalize(DieRoll(1, 0)), equals(0));
    expect(DieRoll.denormalize(DieRoll(1, 1)), equals(1));
    expect(DieRoll.denormalize(DieRoll(1, 2)), equals(2));
    expect(DieRoll.denormalize(DieRoll(2, -1)), equals(3));
    expect(DieRoll.denormalize(DieRoll(4, 2)), equals(14));
    expect(DieRoll.denormalize(DieRoll(10, 0)), equals(36));
    // 5d+0 == 2d+12
    expect(DieRoll.denormalize(DieRoll(5, 0), 2), equals(12));
    // 0d+20 ==
    expect(DieRoll.denormalize(DieRoll(0, 0), 1), equals(-4));
  });

  test("can add", () {
    expect(DieRoll(1, 0) + 1, equals(DieRoll(1, 1)));

    expect(DieRoll(2, 0) + 2, equals(DieRoll(2, 2)));
    expect(DieRoll(2, 2) + 2, equals(DieRoll(3, 0)));
    expect(DieRoll(5, 0) + 2, equals(DieRoll(5, 2)));
    expect(DieRoll(1, -1) + 2, equals(DieRoll(1, 1)));

    expect(DieRoll(2, 0) + 3, equals(DieRoll(3, -1)));
    expect(DieRoll(2, 3) + 3, equals(DieRoll(3, 2)));
    expect(DieRoll(5, 0) + 3, equals(DieRoll(6, -1)));
    expect(DieRoll(1, -1) + 3, equals(DieRoll(1, 2)));

    expect(DieRoll(2, 0) + -3, equals(DieRoll(1, 1)));
    expect(DieRoll(2, 3) + -3, equals(DieRoll(2, 0)));
    expect(DieRoll(5, 0) + -3, equals(DieRoll(4, 1)));
  });

  test("can subtract", () {
    expect(DieRoll(2, 0) - 3, equals(DieRoll(1, 1)));
    expect(DieRoll(2, 3) - 3, equals(DieRoll(2, 0)));
    expect(DieRoll(5, 0) - 3, equals(DieRoll(4, 1)));
  });

  test("can multiply", () {
    expect(DieRoll(1, 0) * 1, equals(DieRoll(1, 0)));

    expect(DieRoll(2, 0) * 2, equals(DieRoll(4, 0)));
    expect(DieRoll(2, 2) * 2, equals(DieRoll(5, 0)));
    expect(DieRoll(5, 0) * 2, equals(DieRoll(10, 0)));
    expect(DieRoll(1, -1) * 2, equals(DieRoll(1, 2)));

    expect(DieRoll(2, 0) * 3, equals(DieRoll(6, 0)));
    expect(DieRoll(2, 3) * 3, equals(DieRoll(8, 1)));
    expect(DieRoll(5, 0) * 3, equals(DieRoll(15, 0)));
    expect(DieRoll(1, -1) * 3, equals(DieRoll(2, 1)));
  });

  test("can divide", () {
    expect(DieRoll(1, 0) / 1, equals(DieRoll(1, 0)));

    expect(DieRoll(2, 0) / 2, equals(DieRoll(1, 0)));
    expect(DieRoll(2, 2) / 2, equals(DieRoll(1, 1)));
    expect(DieRoll(5, 0) / 2, equals(DieRoll(2, 2)));
    expect(DieRoll(1, -1) / 2, equals(DieRoll(0, 1)));

    expect(DieRoll(2, 0) / 3, equals(DieRoll(0, 2)));
    expect(DieRoll(2, 3) / 3, equals(DieRoll(1, -1)));
    expect(DieRoll(5, 0) / 3, equals(DieRoll(1, 2)));
    expect(DieRoll(1, -1) / 3, equals(DieRoll(0, 1)));

    expect(DieRoll(0, 6) / 2, equals(DieRoll(1, -1)));
    expect(DieRoll(0, 7) / 2, equals(DieRoll(1, -1)));
    expect(DieRoll(0, 8) / 2, equals(DieRoll(1, 0)));
  });

  test('can print', () {
    expect(DieRoll(4, -2).toString(), equals('3d+2'));
    expect(DieRoll(4, -1).toString(), equals('4d-1'));
    expect(DieRoll(4, 0).toString(), equals('4d'));
    expect(DieRoll(4, 1).toString(), equals('4d+1'));
    expect(DieRoll(4, 2).toString(), equals('4d+2'));
    expect(DieRoll(4, 3).toString(), equals('5d-1'));
  });

  test('has hashcode', () {
    expect(DieRoll(4, -2).hashCode, equals(DieRoll(3, 2).hashCode));
  });

  test('modulo normalization -- adds', () {
    expect(adds(-6), equals(2));
    expect(adds(-5), equals(-1));
    expect(adds(-4), equals(0));
    expect(adds(-3), equals(1));
    expect(adds(-2), equals(2));
    expect(adds(-1), equals(-1));
    expect(adds(0), equals(0));
    expect(adds(1), equals(1));
    expect(adds(2), equals(2));
    expect(adds(3), equals(-1));
    expect(adds(4), equals(0));
    expect(adds(5), equals(1));
    expect(adds(6), equals(2));
  });
  test('modulo normalization -- dice', () {
    expect(dice(-6), equals(-2));
    expect(dice(-5), equals(-1));
    expect(dice(-4), equals(-1));
    expect(dice(-3), equals(-1));
    expect(dice(-2), equals(-1));
    expect(dice(-1), equals(0));
    expect(dice(0), equals(0));
    expect(dice(1), equals(0));
    expect(dice(2), equals(0));
    expect(dice(3), equals(1));
    expect(dice(4), equals(1));
    expect(dice(5), equals(1));
    expect(dice(6), equals(1));
    expect(dice(7), equals(2));
  });

  test('modulo combo', () {
    int d = 1;
    int p = 0;

    d += dice(p);
    p = adds(p);

    expect(d, equals(1));
    expect(p, equals(0));
  });
}

int adds(int adds) {
  return ((adds + 1) % 4) - 1;
}

int dice(int adds) {
  return adds < 0 ? ((-adds + 2) ~/ -4) : ((adds + 1) ~/ 4);
}
