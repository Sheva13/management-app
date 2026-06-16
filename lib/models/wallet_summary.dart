import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_summary.freezed.dart';
part 'wallet_summary.g.dart';

@freezed
class WalletSummary with _$WalletSummary {
  const factory WalletSummary({
    required int totalUang,
    required int totalEMoney,
    required int totalCash,
    required int totalIncome,
    required int totalExpense,
  }) = _WalletSummary;

  factory WalletSummary.fromJson(Map<String, dynamic> json) =>
      _$WalletSummaryFromJson(json);
}
