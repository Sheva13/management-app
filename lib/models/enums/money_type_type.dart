import 'package:json_annotation/json_annotation.dart';

enum MoneyTypeType {
  @JsonValue('emoney')
  emoney('E-Money'),

  @JsonValue('cash')
  cash('Cash');

  final String label;
  const MoneyTypeType(this.label);
}
