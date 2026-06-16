// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionLogImpl _$$TransactionLogImplFromJson(Map<String, dynamic> json) =>
    _$TransactionLogImpl(
      id: json['id'] as String,
      transactionId: json['transactionId'] as String,
      type: json['type'] as String,
      platformId: json['platformId'] as String?,
      amount: (json['amount'] as num).toInt(),
      balanceBefore: (json['balanceBefore'] as num).toInt(),
      balanceAfter: (json['balanceAfter'] as num).toInt(),
      note: json['note'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$TransactionLogImplToJson(
        _$TransactionLogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'transactionId': instance.transactionId,
      'type': instance.type,
      'platformId': instance.platformId,
      'amount': instance.amount,
      'balanceBefore': instance.balanceBefore,
      'balanceAfter': instance.balanceAfter,
      'note': instance.note,
      'createdAt': instance.createdAt.toIso8601String(),
    };
