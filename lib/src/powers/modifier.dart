import 'dart:convert';
import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:math_expressions/math_expressions.dart';

part 'modifier.g.dart';

@JsonSerializable()
class Modifier {
  Modifier(
      {this.name,
      this.percentage,
      this.isAttack,
      this.hasLevels,
      this.levelTextExpression,
      this.levelTextPrefix,
      this.levelTextSuffix})
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

  @JsonKey(defaultValue: 'x')
  final String levelTextExpression;

  @JsonKey(defaultValue: '')
  final String levelTextPrefix;

  @JsonKey(defaultValue: '')
  final String levelTextSuffix;

  /// Fields below here are working variables, not persisted.
  @JsonKey(ignore: true)
  final Expression _exp;

  @JsonKey(ignore: true)
  final ContextModel cm = ContextModel();

  @JsonKey(ignore: true)
  final Variable x = Variable('x');

  int percentageForLevel(int level) {
    if (!hasLevels) {
      throw '$name does not have levels';
    }
    return level * percentage;
  }

  String textForLevel(int level) {
    if (!hasLevels) {
      throw '$name does not have levels';
    }

    cm.bindVariable(x, Number(level));
    double y = _exp.evaluate(EvaluationType.REAL, cm);

    return '$levelTextPrefix${y.floor()}$levelTextSuffix';
  }

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
