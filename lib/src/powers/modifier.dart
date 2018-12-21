import 'dart:convert';
import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:math_expressions/math_expressions.dart';

part 'modifier.g.dart';

var indexofExpression = RegExp(r'INDEXOF\[(.*)\]');
var rangeExpression = RegExp(r'\[(\d+),(\d+)\]');

@JsonSerializable()
class Modifier {
  Modifier(
      {this.name,
      this.percentage,
      this.isAttack,
      this.hasLevels,
      this.levelTextExpression,
      this.levelTextPrefix,
      this.levelTextSuffix,
      this.levelTextExprCustom,
      this.levelRange})
      : _exp = _parser.parse(levelTextExpression);

  factory Modifier.fromJson(Map<String, dynamic> json) =>
      _$ModifierFromJson(json);

  @JsonKey(nullable: false, required: true)
  final String name;

  /// If not leveled, this is the flat value of the modifier. Else, this is the
  /// percentage cost per level.
  @JsonKey(nullable: false, required: true)
  final int percentage;

  @JsonKey(defaultValue: false)
  final bool isAttack;

  @JsonKey(defaultValue: false)
  final bool hasLevels;

  /// Leveled modifiers sometimes need to display text like "2 yards" (for
  /// level 1), "4 yards" (for level 2), etc. This is generalized to
  /// "$prefix $levelValue $suffix" where $levelValue is an equation

  @JsonKey(defaultValue: "[1,4294967296]")
  final String levelRange;

  @JsonKey(defaultValue: 'x')
  final String levelTextExpression;

  @JsonKey(defaultValue: '')
  final String levelTextPrefix;

  @JsonKey(defaultValue: '')
  final String levelTextSuffix;

  @JsonKey(defaultValue: '')
  final String levelTextExprCustom;

  /// Fields below here are working variables, not persisted.
  @JsonKey(ignore: true)
  final Expression _exp;

  @JsonKey(ignore: true)
  final ContextModel _cm = ContextModel();

  @JsonKey(ignore: true)
  final Variable _x = Variable('x');

  int percentageForLevel(int level) {
    _validLevel(level);
    return level * percentage;
  }

  void _validLevel(int level) {
    if (!hasLevels) {
      throw '$name does not have levels';
    }

    Match match = rangeExpression.firstMatch(levelRange);
    var start = int.parse(match.group(1));
    var end = int.parse(match.group(2));
    if (level < start || level > end) {
      throw RangeError('$name level must match range $levelRange');
    }
  }

  String textForLevel(int level) {
    if (!hasLevels) {
      throw '$name does not have levels';
    }

    String baseValue = _getLevelTextBaseValue(level);
    return '$levelTextPrefix$baseValue$levelTextSuffix';
  }

  String _getLevelTextBaseValue(int level) {
    if (_hasCustomLevelExpression()) {
      String group =
          indexofExpression.firstMatch(levelTextExprCustom)?.group(1);
      if (group == null) {
        return 'Bad levelTextExprCustom: $levelTextExprCustom';
      }
      return group.split(',')[level - 1];
    } else {
      _cm.bindVariable(_x, Number(level));
      double y = _exp.evaluate(EvaluationType.REAL, _cm);
      return y.floor().toString();
    }
  }

  bool _hasCustomLevelExpression() => levelTextExprCustom.length > 0;

  static Map<String, Modifier> _modifiers = {};
  static Parser _parser = Parser();

  static Future<Modifier> fetch(String name) async {
    if (_modifiers.isEmpty) {
      var list = await fetchAll();
      for (Modifier m in list) {
        _modifiers[m.name] = m;
      }
    }
    return _modifiers[name];
  }

  static Future<List<Modifier>> fetchAll() async {
    List<Modifier> list = [];
    Map data = await readModifierData();
    for (Map<String, dynamic> jsonItem in data['modifiers']) {
      list.add(Modifier.fromJson(jsonItem));
    }
    return list;
  }

  static Future<Map> readModifierData() async {
    return File('assets/data/modifiers.json')
        .readAsString()
        .then<Map>((fileContents) => json.decode(fileContents) as Map);
  }
}
