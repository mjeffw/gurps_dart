import 'package:gurps_dart/src/powers/modifier.dart';
import 'package:test/test.dart';

void main() {
  test('read by name', () async {
    Modifier m = await Modifier.fetch('Affects Insubstantial');
    expect(m.name, equals('Affects Insubstantial'));

    m = await Modifier.fetch('Accurate');
    expect(m, isNotNull);
  });
}
