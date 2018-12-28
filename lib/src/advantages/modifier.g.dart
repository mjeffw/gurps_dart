// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modifier.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModifierBase _$ModifierBaseFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['percentage']);
  return ModifierBase(
      name: json['name'] as String,
      percentage: json['percentage'] as int,
      isAttack: json['isAttack'] as bool ?? false,
      hasLevels: json['hasLevels'] as bool ?? false,
      levelTextExpression: json['levelTextExpression'] as String ?? 'x',
      levelTextExprCustom: json['levelTextExprCustom'] as String ?? '',
      levelTextTemplate: json['levelTextTemplate'] as String ?? r' $LEVELTEXT$',
      levelRange: json['levelRange'] as String ?? '[1,4294967296]',
      percentPerLevel:
          (json['percentPerLevel'] as List)?.map((e) => e as int)?.toList());
}

Map<String, dynamic> _$ModifierBaseToJson(ModifierBase instance) =>
    <String, dynamic>{
      'percentage': instance.percentage,
      'isAttack': instance.isAttack,
      'hasLevels': instance.hasLevels,
      'levelTextTemplate': instance.levelTextTemplate,
      'levelRange': instance.levelRange,
      'levelTextExpression': instance.levelTextExpression,
      'levelTextExprCustom': instance.levelTextExprCustom,
      'percentPerLevel': instance.percentPerLevel,
      'name': instance.name
    };
