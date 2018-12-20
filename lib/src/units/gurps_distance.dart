import '../util/core_utils.dart';

class GurpsDistance {
  const GurpsDistance._yards(this._value);

  const GurpsDistance({int yards: 0, int miles: 0})
      : this._yards(yardsPerMile * miles + yards);

  static const int yardsPerMile = 2000;

  final int _value;

  static String toFormattedString(int yards, {bool showFraction: true}) {
    if (yards >= yardsPerMile) {
      if (showFraction) {
        return (isWholeNumber(yards, GurpsDistance.yardsPerMile))
            ? '${yards ~/ yardsPerMile} miles'
            : '${yards / yardsPerMile} miles';
      } else {
        return '${yards ~/ yardsPerMile} miles${isWholeNumber(yards, GurpsDistance.yardsPerMile) ? "" : " ${yards % yardsPerMile} yards"}';
      }
    } else {
      return '${yards} yards';
    }
  }

  int get inYards => _value;

  int get inMiles => _value ~/ yardsPerMile;
}
