// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'money_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MoneyTypeImpl _$$MoneyTypeImplFromJson(Map<String, dynamic> json) =>
    _$MoneyTypeImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$MoneyTypeImplToJson(_$MoneyTypeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
