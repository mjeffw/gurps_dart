import 'dart:convert';
import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:gurps_dart/src/util/core_utils.dart';

part 'modifier.g.dart';

var indexofExp = RegExp(r'INDEXOF\[(.*)\]');
var rangeExp = RegExp(r'\[(\d+),(\d+)\]');

const blank = "''";

/// Modifier represents a modifier as applied to an Advantage. It differs from
/// ModifierBase in that it can have state, like a level value or other
/// customizations. Modifier delegates most/all of its functionality to
/// ModifierBase.
class Modifier {
  Modifier({ModifierBase base})
      : assert(base != null),
        this._base = base;

  final ModifierBase _base;

  bool get hasLevels => _base.hasLevels;

  int _level;

  int get level {
    if (_level == null && hasLevels) {
      _level = 1;
    }
    return _level;
  }

  set level(int level) {
    _base.validateLevel(level);
    _level = level;
  }

  String get name {
    return _base._name;
  }

  /// Returns the description of the Modifier usable in the 'statistics' block
  /// of a Power or Ability.
  String get text {
    var levelText = _levelText();
    var percent = toSignedString(percentage);
    return '$name$levelText, $percent%';
  }

  int get percentage {
    return (hasLevels) ? _base.percentageForLevel(level) : _base.percentage;
  }

  String _levelText() {
    if (hasLevels) {
      var text = _base.textForLevel(level);
      var levelText = text.replaceAll(r'$LEVEL$', level.toString());
      return levelText;
    }

    return '';
  }

  static Future<Modifier> build(String name) async {
    ModifierBase base = await ModifierBase.fetchByName(name);
    return Modifier(base: base);
  }
}

/// ModifierBase represents the template of a GURPS modifier. This is an immutable
/// object.
@JsonSerializable()
class ModifierBase {
  ModifierBase(
      {String name,
      this.percentage,
      this.isAttack,
      this.hasLevels,
      this.levelTextExpression,
      this.levelTextExprCustom,
      this.levelTextTemplate,
      this.levelRange,
      this.percentPerLevel})
      : _exp = _parser.parse(levelTextExpression),
        _name = name;

  factory ModifierBase.fromJson(Map<String, dynamic> json) =>
      _$ModifierBaseFromJson(json);

  @JsonKey(nullable: false, required: true)
  final String _name;

  /// If not leveled, this is the flat value of the modifier. Else, this is the
  /// percentage cost per level.
  @JsonKey(nullable: false, required: true)
  final int percentage;

  @JsonKey(defaultValue: false)
  final bool isAttack;

  @JsonKey(defaultValue: false)
  final bool hasLevels;

  // The fields below only apply if the Modifier has levels.

  /// Leveled modifiers sometimes need to display text like "2 yards" (for
  /// level 1), "4 yards" (for level 2), etc. LevelTextTemplate captures
  /// the format of these expressions where the Level Text Value is represented
  /// by the $LEVELTEXT$ token.

  @JsonKey(defaultValue: r' $LEVELTEXT$')
  final String levelTextTemplate;

  /// Allowable range of level.
  @JsonKey(defaultValue: "[1,4294967296]")
  final String levelRange;

  /// A mathematic expression that can be used to derive the Level Text string
  /// from the integer level value.
  @JsonKey(defaultValue: 'x')
  final String levelTextExpression;

  /// Custom expression string -- if the conversion from a level to text is
  /// algebraic, use the levelTextExpression, above. This field allows for
  /// other expressions. Currently supported expressions are:
  ///
  /// - INDEXOF[a;b;c;...] which maps the level to a member of a 1-based array.
  ///   This is useful for when the level maps to a element of a pattern for
  ///   which there is no easily derived formula. OR, to map a numerical value
  ///   to a String. An empty String can be represented by ''.
  ///
  /// If present, this overrides any value in levelTextExpression.
  @JsonKey(defaultValue: '')
  final String levelTextExprCustom;

  @JsonKey(defaultValue: null)
  final List<int> percentPerLevel;

  // Fields below here are working variables, not persisted.
  @JsonKey(ignore: true)
  final Expression _exp;

  @JsonKey(ignore: true)
  final ContextModel _cm = ContextModel();

  @JsonKey(ignore: true)
  final Variable _x = Variable('x');

  String get name => _name;

  int percentageForLevel(int level) {
    validateLevel(level);
    if (percentPerLevel != null) {
      return percentPerLevel[level - 1];
    }
    return level * percentage;
  }

  /// Throws a StateError if this ModifierBase has no levels allowed. It throws
  /// a RangeError if level falls outside the allowable range.
  void validateLevel(int level) {
    if (!hasLevels) {
      throw StateError('$_name does not have levels');
    }

    Match match = rangeExp.firstMatch(levelRange);
    var start = int.parse(match.group(1));
    var end = int.parse(match.group(2));
    if (level < start || level > end) {
      throw RangeError('$_name level must match range $levelRange');
    }
  }

  /// This method is responsible for creating the "Level Text", which is any
  /// text that must be added to explain the level of the modifier. For
  /// example, for the modifier text 'Cosmic, Adds utility, +50%', the Level
  /// Text is ', Adds utility'.
  String textForLevel(int level) {
    validateLevel(level);
    return levelTextTemplate.replaceAll(
        r'$LEVELTEXT$', _getLevelTextBaseValue(level));
  }

  String _getLevelTextBaseValue(int level) {
    if (_hasCustomLevelExpression()) {
      return _customLevelExpressionValue(level);
    } else {
      _cm.bindVariable(_x, Number(level));
      return _exp.evaluate(EvaluationType.REAL, _cm).floor().toString();
    }
  }

  bool _hasCustomLevelExpression() => levelTextExprCustom.length > 0;

  String _customLevelExpressionValue(int level) {
    String group = indexofExp.firstMatch(levelTextExprCustom)?.group(1);
    if (group == null) {
      return 'Bad levelTextExprCustom: $levelTextExprCustom';
    }
    var x = group.split(';')[level - 1];
    return (x == blank) ? '' : x.trim();
  }

  // The expression parser, for executing the levelTextExpression as a math expression.
  static Parser _parser = Parser();

  // Methods for reading the ModifierBase data out of the JSON file.

  static Map<String, dynamic> _modifiers = <String, dynamic>{};

  static Future<ModifierBase> fetchByName(String name) async {
    // Read the advantage.json file int a map only once; when fetching by name,
    // look up from the map and turn the resulting map into an object.
    if (_modifiers.isEmpty) {
      await readModifierData() as Map<String, dynamic>;
    }
    ModifierBase adv =
        _$ModifierBaseFromJson(_modifiers[name] as Map<String, dynamic>);
    return adv;
  }

  static void readModifierData() async {
    var x = File('assets/data/modifiers.json').readAsString();
    Map y =
        await x.then<Map>((fileContents) => json.decode(fileContents) as Map);
    Map<String, dynamic> z = y['modifiers'] as Map<String, dynamic>;
    _modifiers = z;
  }
}
