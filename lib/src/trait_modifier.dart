import 'package:collection/collection.dart';

import 'util/core_utils.dart';

typedef bool TraitModifierPredicate(TraitModifier e);

TraitModifierPredicate any = (x) => true;
TraitModifierPredicate limitationOnly = (x) => x.percent < 0;

/// Represents a single GURPS Modifier.
///
/// A modifier is a feature that you can add to a trait – usually an advantage
/// – to change the way it works. There are two basic types of modifiers:
/// enhancements and limitations. Adding an enhancement makes the underlying
/// trait more useful, while applying a limitation attaches additional
/// restrictions to your ability.
///
/// Modifiers adjust the base cost of a trait in proportion to their effects.
/// Enhancements increase the cost, while limitations reduce the cost. This is
/// expressed as a percentage. For instance, a +20% enhancement would increase
/// the point cost of an advantage by 1/5 its base cost, while a -50%
/// limitation would reduce it by half its base cost.
class TraitModifier implements Comparable<TraitModifier> {
  TraitModifier({this.name, this.detail, this.percent});

  /// Name of this Modifier.
  final String name;

  /// Optional detail about the Modifier.
  final String detail;

  /// The value of the Modifier. This would be treated as a percent as per B101.
  final int percent;

  String get summaryText => name;

  String get typicalText =>
      '${name}${detail != null && detail.length > 0 ? ", ${detail}" : ""}, ${toSignedString(percent)}%';

  @override
  int compareTo(TraitModifier other) {
    var result = this.name.compareTo(other.name);
    return (result == 0) ? this.detail.compareTo(other.detail) : result;
  }
}

/// Represents a list of GURPS Modifiers, which can be either Enhancements or
/// Limitations.
///
/// Provides some convenience methods for getting the sum of all Enhancement
/// and Limitation values, or adjusting a value
class TraitModifierList extends DelegatingList<TraitModifier> {
  TraitModifierList() : super(new List<TraitModifier>());

  /// Determine the sum of all levels of the elements expressed as a percentage,
  /// multiplied by the baseValue, and return the smallest integer equal to or
  /// greater than the result. For example, if the sum of levels = 42 and base
  /// value is 20, then the value is 0.42 x 20 = 8.4, so we'd return 9.
  int adjustment(int baseValue) {
    // convert each TraitModifier into its int level value, then divide that by
    // 100 (thus converting it to a percentage, and sum them.
    double x = this.map((i) => i.percent / 100.0).fold(0.0, (a, b) => a + b);

    // return the sum multipled by the baseValue, truncating any fractions
    return (baseValue * x).ceil();
  }

  int get sum => this.map((e) => e.percent).fold(0, (a, b) => a + b);
}

/// Define the TraitModifiable mixin.
///
/// Classes that are extended with TraitModifiable maintain a list of
/// enhancements and limitations.
abstract class TraitModifiable {
  final TraitModifierList _modifiers = new TraitModifierList();

  void addTraitModifier(TraitModifier t) {
    _modifiers.add(t);
  }

  int adjustmentForTraitModifiers(int baseValue) =>
      _modifiers.adjustment(baseValue);

  int get sumOfTraitModifierLevels => _modifiers.sum;

  List<TraitModifier> get traitModifiers => _modifiers;

  TraitModifier getAt(int index) => _modifiers[index];

  void removeAt(int index) => _modifiers.removeAt(index);

  TraitModifiable asTraitModifiable() => this;
}
