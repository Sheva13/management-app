// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WalletSummaryImpl _$$WalletSummaryImplFromJson(Map<String, dynamic> json) =>
    _$WalletSummaryImpl(
      totalUang: (json['totalUang'] as num).toInt(),
      totalEMoney: (json['totalEMoney'] as num).toInt(),
      totalCash: (json['totalCash'] as num).toInt(),
      totalIncome: (json['totalIncome'] as num).toInt(),
      totalExpense: (json['totalExpense'] as num).toInt(),
    );

Map<String, dynamic> _$$WalletSummaryImplToJson(_$WalletSummaryImpl instance) =>
    <String, dynamic>{
      'totalUang': instance.totalUang,
      'totalEMoney': instance.totalEMoney,
      'totalCash': instance.totalCash,
      'totalIncome': instance.totalIncome,
      'totalExpense': instance.totalExpense,
    };
