import 'dart:convert';
import 'dart:io';

import 'package:gurps_dart/src/advantages/modifier.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:math_expressions/math_expressions.dart';

part 'advantage.g.dart';

/// Advantage is a specific instance of an advantage as it would be applied to
/// a character. It includes the AdvantageBase, potentially with a selected
/// Enhancement, any levels, and any Modifiers applied to it.
class Advantage {
  Advantage({this.base});

  final AdvantageBase base;

  int _level;

  List<ModifierBase> modifiers = [];

  int get cost => base.cost;

  bool get hasLevels => base.hasLevels;
  int get level {
    if (hasLevels && _level == null) {
      _level = 1;
    }
    return _level;
  }
}

/// AdvantageBase is the template for an Advantage. It defines the advantage
/// name, costs, enhancements, etc.
@JsonSerializable()
class AdvantageBase {
  AdvantageBase(
      {this.name, this.cost, this.enhancements, this.types, this.hasLevels});

  factory AdvantageBase.fromJson(Map<String, dynamic> json) {
    return _$AdvantageBaseFromJson(json);
  }

  @JsonKey(nullable: false, required: true)
  final String name;

  @JsonKey(nullable: false, required: true)
  final int cost;

  @JsonKey(defaultValue: <String, Enhancement>{})
  final Map<String, Enhancement> enhancements;

  @JsonKey(defaultValue: <String>[])
  final List<String> types;

  @JsonKey(defaultValue: false)
  final bool hasLevels;

  bool get hasEnhancements => !enhancements.isEmpty;
  bool get isMental => types.contains('Mental');
  bool get isPhysical => types.contains('Physical');
  bool get isSocial => types.contains('Social');
  bool get isExotic => types.contains('Exotic');
  bool get isSupernatural => types.contains('Supernatural');
  bool get isMundane => !isSupernatural && !isExotic;

  static Map<String, dynamic> _advantages = <String, dynamic>{};

  static Future<AdvantageBase> fetchByName(String name) async {
    // Read the advantage.json file int a map only once; when fetching by name,
    // look up from the map and turn the resulting map into an object.
    if (_advantages.isEmpty) {
      await readModifierData() as Map<String, dynamic>;
    }
    AdvantageBase adv =
        _$AdvantageBaseFromJson(_advantages[name] as Map<String, dynamic>);
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

/// An Enhancement is an alternate version of an Advantage, often with
/// a different cost. An example would be Absolute Timing (2 points),
/// with the Chronolocation enhancement (5 points).
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
