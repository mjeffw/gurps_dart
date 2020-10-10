class GDuration {
  const GDuration(
      {int years: 0,
      int months: 0,
      int weeks: 0,
      int days: 0,
      int hours: 0,
      int minutes: 0,
      int seconds: 0})
      : this._seconds(secondsPerYear * years +
            secondsPerMonth * months +
            secondsPerWeek * weeks +
            secondsPerDay * days +
            secondsPerHour * hours +
            secondsPerMinute * minutes +
            seconds);

  const GDuration._seconds(this._duration);

  static const GDuration momentary = GDuration._seconds(0);

  static const int secondsPerYear = Duration.secondsPerDay * 365;
  static const int secondsPerMonth = 2628000;
  static const int secondsPerWeek = Duration.secondsPerDay * 7;
  static const int secondsPerDay = Duration.secondsPerDay;
  static const int secondsPerHour = Duration.secondsPerHour;
  static const int secondsPerMinute = Duration.secondsPerMinute;

  final int _duration;

  int get inSeconds => _duration;

  int get inHours => _duration ~/ secondsPerHour;

  GDuration operator +(GDuration other) =>
      new GDuration._seconds(_duration + other._duration);

  GDuration operator -(GDuration other) =>
      new GDuration._seconds(_duration - other._duration);

  GDuration operator *(num other) =>
      new GDuration._seconds((_duration * other).floor());

  GDuration operator ~/(num other) =>
      new GDuration._seconds((_duration ~/ other).floor());

  bool operator <(GDuration other) => _duration < other._duration;

  bool operator >(GDuration other) => _duration > other._duration;

  bool operator <=(GDuration other) => _duration <= other._duration;

  bool operator >=(GDuration other) => _duration >= other._duration;

  static String toFormattedString(int duration) {
    int years = duration ~/ secondsPerYear;
    int temp = duration - (years * secondsPerYear);
    int months = temp ~/ secondsPerMonth;
    temp -= (months * secondsPerMonth);
    int weeks = temp ~/ secondsPerWeek;
    temp -= (weeks * secondsPerWeek);
    int days = temp ~/ secondsPerDay;
    temp -= (days * secondsPerDay);
    int hours = temp ~/ secondsPerHour;
    temp -= (hours * secondsPerHour);
    int minutes = temp ~/ secondsPerMinute;
    temp -= (minutes * secondsPerMinute);
    int seconds = temp;

    StringBuffer sb = new StringBuffer();
    if (years > 0) sb.write('${years} year${_pluralize(years)} ');
    if (months > 0) sb.write('${months} month${_pluralize(months)} ');
    if (weeks > 0) sb.write('${weeks} week${_pluralize(weeks)} ');
    if (days > 0) sb.write('${days} day${_pluralize(days)} ');
    if (hours > 0) sb.write('${hours} hour${_pluralize(hours)} ');
    if (minutes > 0) sb.write('${minutes} minute${_pluralize(minutes)} ');
    if (seconds > 0) sb.write('${seconds} second${_pluralize(seconds)}');

    return sb.toString().trim();
  }

  static String _pluralize(int number) {
    if (number > 1) return 's';
    return '';
  }

  @override
  String toString() => GDuration.toFormattedString(this._duration);

  int compareTo(GDuration other) => _duration.compareTo(other._duration);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) {
      return true;
    }
    return other is GDuration && other._duration == _duration;
  }

  @override
  int get hashCode => _duration.hashCode;
}
