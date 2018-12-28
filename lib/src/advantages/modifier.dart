import 'dart:convert';
import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:gurps_dart/src/util/core_utils.dart';

part 'modifier.g.dart';

var indexofExp = RegExp(r'INDEXOF\[(.*)\]');
var rangeExp = RegExp(r'\[(\d+),(\d+)\]');

const blank = "''";

class Modifier {
  Modifier({ModifierBase base})
      : assert(base != null),
        this._base = base;

  final ModifierBase _base;

  int _level;

  bool get hasLevels => _base.hasLevels;

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
    if (_base.useLevelTextForName) {
      return _base.textForLevel(level);
    }
    return _base._name;
  }

  /// Returns the description of the Modifier usable in the 'statistics' block
  /// of a Power or Ability.
  String get text {
    return '$name${_levelText()}, ${toSignedString(percentage)}%';
  }

  int get percentage {
    return (hasLevels) ? _base.percentageForLevel(level) : _base.percentage;
  }

  static Future<Modifier> build(String name) async {
    ModifierBase base = await ModifierBase.fetchByName(name);
    return Modifier(base: base);
  }

  String _levelText() {
    return (hasLevels)
        ? _base.textForLevel(level).replaceAll(r'$LEVEL$', level.toString())
        : '';
  }
}

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
      this.useLevelTextForName})
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
  /// the format of these expressions where the level Value is represented
  /// by the $LEVELTEXT$ token.

  @JsonKey(defaultValue: r' $LEVELTEXT$')
  final String levelTextTemplate;

  /// Allowable range of level.
  @JsonKey(defaultValue: "[1,4294967296]")
  final String levelRange;

  @JsonKey(defaultValue: 'x')
  final String levelTextExpression;

  /// Custom expression string -- if the conversion from a level to text is
  /// algebraic, use the levelTextExpression, above. This field allows for
  /// other expressions. Currently supported is INDEXOF[a,b,c,...] which allows
  /// for mapping the value to a 1-based index. If present, this overrides any
  /// value in levelTextExpression.
  @JsonKey(defaultValue: '')
  final String levelTextExprCustom;

  @JsonKey(defaultValue: false)
  final bool useLevelTextForName;

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
    return level * percentage;
  }

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

  String textForLevel(int level) {
    validateLevel(level);

    String baseValue = _getLevelTextBaseValue(level);

    String result = levelTextTemplate.replaceAll(r'$LEVELTEXT$', baseValue);
    return result;
  }

  String _getLevelTextBaseValue(int level) {
    if (_hasCustomLevelExpression()) {
      return getCustomLevelExpressionValue(level);
    } else {
      _cm.bindVariable(_x, Number(level));
      return _exp.evaluate(EvaluationType.REAL, _cm).floor().toString();
    }
  }

  String getCustomLevelExpressionValue(int level) {
    String group = indexofExp.firstMatch(levelTextExprCustom)?.group(1);
    if (group == null) {
      return 'Bad levelTextExprCustom: $levelTextExprCustom';
    }
    var x = group.split(';')[level - 1];
    return (x == blank) ? '' : x.trim();
  }

  bool _hasCustomLevelExpression() => levelTextExprCustom.length > 0;

  static Map<String, ModifierBase> _modifiers = {};
  static Parser _parser = Parser();

  static Future<ModifierBase> fetchByName(String name) async {
    if (_modifiers.isEmpty) {
      var list = await fetchAll();
      for (ModifierBase m in list) {
        _modifiers[m._name] = m;
      }
    }
    return _modifiers[name];
  }

  static Future<List<ModifierBase>> fetchAll() async {
    List<ModifierBase> list = [];
    Map data = await readModifierData();
    for (Map<String, dynamic> jsonItem in data['modifiers']) {
      list.add(ModifierBase.fromJson(jsonItem));
    }
    return list;
  }

  static Future<Map> readModifierData() async {
    return File('assets/data/modifiers.json')
        .readAsString()
        .then<Map>((fileContents) => json.decode(fileContents) as Map);
  }
}
