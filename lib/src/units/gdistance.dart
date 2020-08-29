import '../util/core_utils.dart';

class GDistance implements Comparable<GDistance> {
  const GDistance._yards(this._value);

  const GDistance({int yards: 0, int miles: 0})
      : this._yards(yardsPerMile * miles + yards);

  static const int yardsPerMile = 2000;

  final int _value;

  static String toFormattedString(int yards, {bool showFraction: true}) {
    if (yards >= yardsPerMile) {
      if (showFraction) {
        return (isWholeNumber(yards, GDistance.yardsPerMile))
            ? '${yards ~/ yardsPerMile} miles'
            : '${yards / yardsPerMile} miles';
      } else {
        return '${yards ~/ yardsPerMile} miles${isWholeNumber(yards, GDistance.yardsPerMile) ? "" : " ${yards % yardsPerMile} yards"}';
      }
    } else {
      return '${yards} yards';
    }
  }

  int get inYards => _value;

  int get inMiles => _value ~/ yardsPerMile;

  @override
  String toString() => toFormattedString(inYards);

  @override
  bool operator ==(Object any) => any is GDistance && any._value == _value;

  @override
  int get hashCode => _value.hashCode;

  @override
  int compareTo(GDistance other) => _value.compareTo(other._value);

  bool operator >(GDistance d) => this._value > d._value;
  bool operator <(GDistance d) => this._value < d._value;
  bool operator >=(GDistance d) => this._value >= d._value;
  bool operator <=(GDistance d) => this._value <= d._value;
}
