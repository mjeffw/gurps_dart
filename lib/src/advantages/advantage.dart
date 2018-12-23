import 'dart:convert';
import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:math_expressions/math_expressions.dart';

part 'advantage.g.dart';

@JsonSerializable(includeIfNull: false)
class Enhancement {
  Enhancement({this.name, this.cost});

  factory Enhancement.fromJson(Map<String, dynamic> json) {
    return _$EnhancementFromJson(json);
  }

  @JsonKey(required: true, nullable: false)
  final String name;

  @JsonKey(defaultValue: null)
  final int cost;
}

@JsonSerializable()
class Advantage {
  Advantage({this.name, this.cost, this.enhancements, this.types});

  factory Advantage.fromJson(Map<String, dynamic> json) {
    return _$AdvantageFromJson(json);
  }

  @JsonKey(nullable: false, required: true)
  final String name;

  @JsonKey(nullable: false, required: true)
  final int cost;

  @JsonKey(defaultValue: <String, Enhancement>{})
  final Map<String, Enhancement> enhancements;

  @JsonKey(defaultValue: <String>[])
  final List<String> types;

  bool get hasEnhancements => !enhancements.isEmpty;

  static Map<String, dynamic> _advantages = <String, dynamic>{};

  bool get isExotic => types.contains('Exotic');

  static Future<Advantage> fetchByName(String name) async {
    // Read the advantage.json file int a map only once; when fetching by name,
    // look up from the map and turn the resulting map into an object.
    if (_advantages.isEmpty) {
      await readModifierData() as Map<String, dynamic>;
    }
    Advantage adv =
        _$AdvantageFromJson(_advantages[name] as Map<String, dynamic>);
    return adv;
  }

  static void readModifierData() async {
    var x = File('assets/data/advantages.json').readAsString();
    Map y =
        await x.then<Map>((fileContents) => json.decode(fileContents) as Map);
    Map<String, dynamic> z = y['advantages'] as Map<String, dynamic>;
    _advantages = z;
  }
}
