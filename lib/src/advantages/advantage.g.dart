// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'advantage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdvantageBase _$AdvantageBaseFromJson(Map<String, dynamic> json) {
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
      types: (json['types'] as List)?.map((e) => e as String)?.toList() ?? [],
      hasLevels: json['hasLevels'] as bool ?? false,
      requiresSpecialization: json['requiresSpecialization'] as bool ?? true,
      specialization: json['specialization'] as String ?? 'Small Category',
      specializations: (json['specializations'] as Map<String, dynamic>)?.map(
          (k, e) => MapEntry(
              k,
              e == null
                  ? null
                  : Specialization.fromJson(e as Map<String, dynamic>))));
}

Map<String, dynamic> _$AdvantageBaseToJson(AdvantageBase instance) =>
    <String, dynamic>{
      'name': instance.name,
      'cost': instance.cost,
      'enhancements': instance.enhancements,
      'types': instance.types,
      'hasLevels': instance.hasLevels,
      'requiresSpecialization': instance.requiresSpecialization,
      'specialization': instance.specialization,
      'specializations': instance.specializations
    };

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

Specialization _$SpecializationFromJson(Map<String, dynamic> json) {
  return Specialization(
      name: json['name'] as String,
      cost: json['cost'] as int,
      examples: (json['examples'] as List)?.map((e) => e as String)?.toList());
}

Map<String, dynamic> _$SpecializationToJson(Specialization instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('name', instance.name);
  writeNotNull('cost', instance.cost);
  writeNotNull('examples', instance.examples);
  return val;
}
