import 'package:gurps_dart/src/powers/modifier.dart';
import 'package:test/test.dart';

void main() {
  test('adds one to input values', () {
    Modifier m = Modifier.fetch('Affects Insubstantial');
    expect(m.name, equals('Affects Insubstantial'));
  });
}
