// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modifier.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Modifier _$ModifierFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['name', 'percentage']);
  return Modifier(
      name: json['name'] as String,
      percentage: json['percentage'] as int,
      isAttack: json['isAttack'] as bool ?? false,
      hasLevels: json['hasLevels'] as bool ?? false,
      multiplier: json['multiplier'] as int,
      constant: json['constant'] as int,
      prefix: json['prefix'] as String,
      suffix: json['suffix'] as String);
}

Map<String, dynamic> _$ModifierToJson(Modifier instance) => <String, dynamic>{
      'name': instance.name,
      'percentage': instance.percentage,
      'isAttack': instance.isAttack,
      'hasLevels': instance.hasLevels,
      'multiplier': instance.multiplier,
      'constant': instance.constant,
      'prefix': instance.prefix,
      'suffix': instance.suffix
    };
