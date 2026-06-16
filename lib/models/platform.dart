import 'package:freezed_annotation/freezed_annotation.dart';

part 'platform.freezed.dart';
part 'platform.g.dart';

@freezed
class Platform with _$Platform {
  const factory Platform({
    required String id,
    required String name,
    required String icon,
    required int color,
    required String moneyTypeId,
    @Default(0) int initialBalance,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Platform;

  factory Platform.fromJson(Map<String, dynamic> json) =>
      _$PlatformFromJson(json);
}
