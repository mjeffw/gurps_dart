import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:gurps_dart/src/advantages/ability_parser.dart';
import 'package:gurps_dart/src/advantages/modifier.dart';
import 'package:gurps_dart/src/trait_modifier.dart';
import 'package:json_annotation/json_annotation.dart';

part 'advantage.g.dart';

/// Advantage is a specific instance of an advantage as it would be applied to
/// a character. It includes the AdvantageBase, potentially with a selected
/// Enhancement, any levels, and any Modifiers applied to it.
class Advantage {
  Advantage({this.base});

  final AdvantageBase base;

  int _level;
  final _Modifiers modifiers = _Modifiers();
  Specialization specialization;

  int get cost {
    int value = _adjustedBaseCost();
    double result = value.toDouble() * level;
    var modifierCostFactor = modifiers.netPercentage.toDouble() / 100.0;
    result += result * modifierCostFactor;
    return result.ceil();
  }

  String get name => base.name;

  String get text {
    return [name, modifiers.detailText, '[$cost]'].join(' ') + '.';
  }

  int _adjustedBaseCost() => specialization?.cost ?? base.cost;

  bool get requiresSpecialization => base.requiresSpecialization;

  bool get hasLevels => base.hasLevels;

  int get level {
    if (_level == null) {
      _level = 1;
    }
    return _level;
  }

  set level(int newLevel) {
    _level = newLevel;
  }

  static Future<Advantage> build(String name) async {
    var base = await AdvantageBase.fetchByName(name);
    var adv = Advantage(base: base);
    if (base.requiresSpecialization) {
      adv.specialization = base.defaultSpecialization;
    }
    return adv;
  }

  static Future<Advantage> parse(String text) async {
    AbilityParser parser = AbilityParser(text);
    Advantage adv = await parser.advantage();
    adv.modifiers.addAll(await parser.modifiers());
    return adv;
  }
}

class _Modifiers extends ListBase<TraitModifier> {
  final List<TraitModifier> l = [];

  // return the canonical representation of a list of modifiers, like:
  // '(Affects Insubstantial, +20%; Unconscious Only, -20%)'
  String get detailText =>
      l.length > 0 ? '(${l.map<String>((a) => a.typicalText).join('; ')})' : '';

  int get netPercentage =>
      l.length > 0 ? l.map<int>((a) => a.percent).reduce((a, b) => a + b) : 0;

  @override
  int get length => l.length;

  @override
  set length(int newLength) => l.length = newLength;

  @override
  TraitModifier operator [](int index) => l[index];

  @override
  void operator []=(int index, TraitModifier value) => l[index] = value;
}

/// AdvantageBase is the template for an Advantage. It defines the advantage
/// name, costs, enhancements, etc.
@JsonSerializable()
class AdvantageBase {
  AdvantageBase(
      {this.name,
      int cost,
      this.enhancements,
      this.types,
      this.hasLevels,
      this.requiresSpecialization,
      String defaultSpecialization,
      this.specializations})
      : _cost = cost,
        _defaultSpecialization = (specializations == null)
            ? null
            : specializations[defaultSpecialization];

  factory AdvantageBase.fromJson(Map<String, dynamic> json) {
    return _$AdvantageBaseFromJson(json);
  }

  @JsonKey(nullable: false, required: true)
  final String name;

  @JsonKey(nullable: false, required: true)
  final int _cost;

  @JsonKey(defaultValue: <String, Enhancement>{})
  final Map<String, Enhancement> enhancements;

  @JsonKey(defaultValue: <String>[])
  final List<String> types;

  @JsonKey(defaultValue: false)
  final bool hasLevels;

  @JsonKey(defaultValue: false)
  final bool requiresSpecialization;

  @JsonKey(defaultValue: null)
  final Specialization _defaultSpecialization;

  @JsonKey(defaultValue: null)
  final Map<String, Specialization> specializations;

  Specialization get defaultSpecialization => _defaultSpecialization;

  bool get hasEnhancements => !enhancements.isEmpty;
  bool get isMental => types.contains('Mental');
  bool get isPhysical => types.contains('Physical');
  bool get isSocial => types.contains('Social');
  bool get isExotic => types.contains('Exotic');
  bool get isSupernatural => types.contains('Supernatural');
  bool get isMundane => !isSupernatural && !isExotic;

  int get cost {
    if (requiresSpecialization) {
      return _defaultSpecialization.cost;
    }
    return _cost;
  }

  static Map<String, dynamic> _advantages = <String, dynamic>{};

  static Future<AdvantageBase> fetchByName(String name) async {
    // Read the advantage.json file int a map only once; when fetching by name,
    // look up from the map and turn the resulting map into an object.
    if (_advantages.isEmpty) {
      await readAdvantageData() as Map<String, dynamic>;
    }
    Map<String, dynamic> rawText = _advantages[name];
    return (rawText == null)
        ? null
        : _$AdvantageBaseFromJson(_advantages[name] as Map<String, dynamic>);
  }

  static void readAdvantageData() async {
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

  factory Enhancement.fromJson(Map<String, dynamic> json) =>
      _$EnhancementFromJson(json);

  @JsonKey(required: true, nullable: false)
  final String name;

  @JsonKey(defaultValue: null)
  final int cost;
}

/// An advantage may require specialization, and the specialization chosen may
/// affect the cost. This class represents one such specialization along with a
/// list of examples if applicable.
@JsonSerializable(includeIfNull: false)
class Specialization {
  Specialization({this.name, this.cost, this.examples});

  factory Specialization.fromJson(Map<String, dynamic> e) =>
      _$SpecializationFromJson(e);

  final String name;
  final int cost;
  final List<String> examples;
}
