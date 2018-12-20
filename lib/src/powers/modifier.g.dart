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
      levelTextExpression: json['levelTextExpression'] as String ?? 'x',
      levelTextPrefix: json['levelTextPrefix'] as String ?? '',
      levelTextSuffix: json['levelTextSuffix'] as String ?? '');
}

Map<String, dynamic> _$ModifierToJson(Modifier instance) => <String, dynamic>{
      'name': instance.name,
      'percentage': instance.percentage,
      'isAttack': instance.isAttack,
      'hasLevels': instance.hasLevels,
      'levelTextExpression': instance.levelTextExpression,
      'levelTextPrefix': instance.levelTextPrefix,
      'levelTextSuffix': instance.levelTextSuffix
    };
