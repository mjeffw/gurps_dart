// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'advantage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Enhancement _$EnhancementFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['name']);
  return Enhancement(name: json['name'] as String, cost: json['cost'] as int);
}

Map<String, dynamic> _$EnhancementToJson(Enhancement instance) {
  final val = <String, dynamic>{
    'name': instance.name,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('cost', instance.cost);
  return val;
}

AdvantageBase _$AdvantageFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['name', 'cost']);
  return AdvantageBase(
      name: json['name'] as String,
      cost: json['cost'] as int,
      enhancements: (json['enhancements'] as Map<String, dynamic>)?.map(
              (k, e) => MapEntry(
                  k,
                  e == null
                      ? null
                      : Enhancement.fromJson(e as Map<String, dynamic>))) ??
          {},
      types: (json['types'] as List)?.map((e) => e as String)?.toList() ?? []);
}

Map<String, dynamic> _$AdvantageToJson(AdvantageBase instance) =>
    <String, dynamic>{
      'name': instance.name,
      'cost': instance.cost,
      'enhancements': instance.enhancements,
      'types': instance.types
    };
