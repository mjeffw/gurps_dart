import 'dart:math';

/// This class handles a common pattern in GURPS -- a point cost that follows a
/// pattern, that repeats perhaps infinitely, which the individual values in
/// the pattern being multiplied by 10 over the previous occurrence of the
/// pattern. For example:
///
/// Pattern = 1, 3, 8
/// Sequence: 1, 3, 8, 10, 30, 80, 100, 300, 800, ...
///
/// Common usages of the pattern are to go from the index in the sequence to
/// value (ordinalToValue), or from some value to the index that represents the
/// lowest value in the sequence that is equal to or greater than the given value (valueToOrdinal).
class RepeatingSequenceConverter {
  RepeatingSequenceConverter(this._pattern);

  List<int> _pattern;
  // this can be changed if the repetition is based on another value than 10
  int _base = 10;

  // assume pattern = [10, 30], 100, 300, 1000, 3000, ...
  // if index = 5, then the result should be:
  // int x = index % pattern.length = 1
  // int y = floor(index / pattern.length) = 2
  // return pattern[x] * 10^y = 30 * 100 = 3000
  int ordinalToValue(int index) {
    int i = (index % _pattern.length);
    int exponent = index ~/ _pattern.length;
    int other = (pow(_base, exponent).toInt());
    int j = _pattern[i] * other;
    return j;
  }

  int valueToOrdinal(int value) {
    int loops = _numberOfLoops(value); // 0

    double val = value / pow(_base, loops); // 3 / 1 = 3

    int arrayValue = _smallestTableValueGreaterThanOrEqualTo(val);
    return _pattern.indexOf(arrayValue) + (loops * _pattern.length);
  }

  int _smallestTableValueGreaterThanOrEqualTo(double val) {
    return _pattern.where((i) => i >= val).first;
  }

  int _numberOfLoops(int value) {
    int loops = 0;
    while (value > (_pattern[_pattern.length - 1] * pow(_base, loops))) {
      loops++;
    }
    return loops;
  }
}
