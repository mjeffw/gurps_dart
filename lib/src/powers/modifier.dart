import 'package:json_annotation/json_annotation.dart';
import 'dart:io';
import 'dart:convert';

part 'modifier.g.dart';

@JsonSerializable()
class Modifier {
  Modifier({this.name, this.percentage, this.isAttack, this.hasLevels});

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

  int percentageForLevel(int level) {
    if (!hasLevels) {
      throw '$name does not have levels';
    }

    return level * percentage;
  }

  static Map<String, Modifier> _modifiers = {};

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
