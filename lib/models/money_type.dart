import 'package:freezed_annotation/freezed_annotation.dart';

part 'money_type.freezed.dart';
part 'money_type.g.dart';

@freezed
class MoneyType with _$MoneyType {
  const factory MoneyType({
    required String id,
    required String name,
    required String type,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _MoneyType;

  factory MoneyType.fromJson(Map<String, dynamic> json) =>
      _$MoneyTypeFromJson(json);
}
