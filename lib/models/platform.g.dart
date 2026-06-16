// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlatformImpl _$$PlatformImplFromJson(Map<String, dynamic> json) =>
    _$PlatformImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      color: (json['color'] as num).toInt(),
      moneyTypeId: json['moneyTypeId'] as String,
      initialBalance: (json['initialBalance'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$PlatformImplToJson(_$PlatformImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon': instance.icon,
      'color': instance.color,
      'moneyTypeId': instance.moneyTypeId,
      'initialBalance': instance.initialBalance,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
