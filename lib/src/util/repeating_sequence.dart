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
  const RepeatingSequenceConverter(this._pattern, {int base = 10})
      : _base = base ?? 10;

  final List<int> _pattern;

  // this can be changed if the repetition is based on another value than 10
  final int _base;

  // assume pattern = [10, 30], 100, 300, 1000, 3000, ...
  // if index = 5, then the result should be:
  // int x = index % pattern.length = 1
  // int y = floor(index / pattern.length) = 2
  // return pattern[x] * 10^y = 30 * 100 = 3000
  int indexToValue(int index) {
    int i = (index % _pattern.length);
    int exponent = index ~/ _pattern.length;
    int other = (pow(_base, exponent).toInt());
    int j = _pattern[i] * other;
    return j;
  }

  int valueToIndex(int value) {
    int loops = _numberOfLoops(value); // 0

    double val = value / pow(_base, loops); // 3 / 1 = 3

    int arrayValue = _smallestTableValueGreaterThanOrEqualTo(val);
    return _pattern.indexOf(arrayValue) + (loops * _pattern.length);
  }

  /// Return the least value from the repeating sequence greater than or equal
  /// to the passed value.
  int ceil(num value) {
    if (value < 0) throw ArgumentError('must be non-negative');
    int index = 0;
    int temp = 0;
    do {
      temp = indexToValue(index++);
    } while (temp < value);

    return temp;
  }

  int _smallestTableValueGreaterThanOrEqualTo(num val) =>
      _pattern.where((i) => i >= val).first;

  int _numberOfLoops(int value) {
    int loops = 0;
    while (value > (_pattern[_pattern.length - 1] * pow(_base, loops))) {
      loops++;
    }
    return loops;
  }
}
