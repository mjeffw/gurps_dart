class Weight {
  static const int poundsPerTon = 2000;

  final int _value;

  const Weight._pounds(this._value);

  const Weight({int pounds: 0, int tons: 0})
      : this._pounds(poundsPerTon * tons + pounds);

  int get inPounds => _value;

  static String toFormattedString(int pounds) {
    if (pounds >= poundsPerTon) {
      num total = pounds / poundsPerTon;
      if (pounds % poundsPerTon == 0) return '${(pounds ~/ poundsPerTon)} tons';
      return '${total} tons';
    }
    return '${pounds} lbs.';
  }
}
