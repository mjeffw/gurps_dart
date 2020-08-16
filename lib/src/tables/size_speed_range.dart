import '../util/repeating_sequence.dart';

class SizeAndSpeedRangeTable {
  var _table = RepeatingSequenceConverter([2, 3, 5, 7, 10, 15]);

  int sizeForLinearMeasurement(int measure) => _table.valueToOrdinal(measure);

  int linearMeasureForSize(int size) => _table.ordinalToValue(size);
}