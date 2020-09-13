import 'package:gurps_dart/gurps_dart.dart';

import '../util/repeating_sequence.dart';

class SizeAndSpeedRangeTable {
  const SizeAndSpeedRangeTable();

  final RepeatingSequenceConverter _table =
      const RepeatingSequenceConverter([2, 3, 5, 7, 10, 15]);

  int sizeForLinearMeasurement(int measure) => _table.valueToIndex(measure);

  int linearMeasureForSize(int size) => _table.indexToValue(size);

  int ceilForLinearMeasurement(int measure) => _table.ceil(measure);

  int sizeFor(GDistance linearMeasure) =>
      sizeForLinearMeasurement(linearMeasure.inYards);

  GDistance linearMeasureFor(int size) =>
      GDistance(yards: linearMeasureForSize(size));

  GDistance ceilFor(GDistance value) =>
      GDistance(yards: _table.ceil(value.inYards));
}
