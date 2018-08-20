import "package:test/test.dart";
import '../../lib/src/util/core_utils.dart';

void main() {
  test('toSignedString', () {
    expect(toSignedString(1), equals('+1'));
    expect(toSignedString(-1), equals('-1'));
    expect(toSignedString(0), equals('+0'));
  });

  test('isWholeNumber', (){
    expect(isWholeNumber(10, 5), equals(true));
    expect(isWholeNumber(10, 6), equals(false));
  });
}