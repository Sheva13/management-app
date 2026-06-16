import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_log.freezed.dart';
part 'transaction_log.g.dart';

@freezed
class TransactionLog with _$TransactionLog {
  const factory TransactionLog({
    required String id,
    required String transactionId,
    required String type,
    String? platformId,
    required int amount,
    required int balanceBefore,
    required int balanceAfter,
    String? note,
    required DateTime createdAt,
  }) = _TransactionLog;

  factory TransactionLog.fromJson(Map<String, dynamic> json) =>
      _$TransactionLogFromJson(json);
}
