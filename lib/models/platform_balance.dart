import 'package:freezed_annotation/freezed_annotation.dart';

part 'platform_balance.freezed.dart';
part 'platform_balance.g.dart';

@freezed
class PlatformBalance with _$PlatformBalance {
  const factory PlatformBalance({
    required String platformId,
    required String name,
    required String icon,
    required int color,
    required String moneyType,
    required int initialBalance,
    required int transactionSum,
    required int currentBalance,
  }) = _PlatformBalance;

  factory PlatformBalance.fromJson(Map<String, dynamic> json) =>
      _$PlatformBalanceFromJson(json);
}