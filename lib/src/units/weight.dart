class GWeight {
  const GWeight._pounds(this._value);

  const GWeight({int pounds: 0, int tons: 0})
      : this._pounds(poundsPerTon * tons + pounds);

  static const int poundsPerTon = 2000;

  final int _value;

  int get inPounds => _value;

  static String toFormattedString(int pounds) {
    if (pounds >= poundsPerTon) {
      num total = pounds / poundsPerTon;
      if (pounds % poundsPerTon == 0) return '${(pounds ~/ poundsPerTon)} tons';
      return '${total} tons';
    }
    return '${pounds} lbs.';
  }

  @override
  String toString() => toFormattedString(_value);
}
