// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform_balance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlatformBalanceImpl _$$PlatformBalanceImplFromJson(
        Map<String, dynamic> json) =>
    _$PlatformBalanceImpl(
      platformId: json['platformId'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      color: (json['color'] as num).toInt(),
      moneyType: json['moneyType'] as String,
      initialBalance: (json['initialBalance'] as num).toInt(),
      transactionSum: (json['transactionSum'] as num).toInt(),
      currentBalance: (json['currentBalance'] as num).toInt(),
    );

Map<String, dynamic> _$$PlatformBalanceImplToJson(
        _$PlatformBalanceImpl instance) =>
    <String, dynamic>{
      'platformId': instance.platformId,
      'name': instance.name,
      'icon': instance.icon,
      'color': instance.color,
      'moneyType': instance.moneyType,
      'initialBalance': instance.initialBalance,
      'transactionSum': instance.transactionSum,
      'currentBalance': instance.currentBalance,
    };
