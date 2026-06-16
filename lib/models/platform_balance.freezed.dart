// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'platform_balance.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PlatformBalance _$PlatformBalanceFromJson(Map<String, dynamic> json) {
  return _PlatformBalance.fromJson(json);
}

/// @nodoc
mixin _$PlatformBalance {
  String get platformId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get icon => throw _privateConstructorUsedError;
  int get color => throw _privateConstructorUsedError;
  String get moneyType => throw _privateConstructorUsedError;
  int get initialBalance => throw _privateConstructorUsedError;
  int get transactionSum => throw _privateConstructorUsedError;
  int get currentBalance => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PlatformBalanceCopyWith<PlatformBalance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlatformBalanceCopyWith<$Res> {
  factory $PlatformBalanceCopyWith(
          PlatformBalance value, $Res Function(PlatformBalance) then) =
      _$PlatformBalanceCopyWithImpl<$Res, PlatformBalance>;
  @useResult
  $Res call(
      {String platformId,
      String name,
      String icon,
      int color,
      String moneyType,
      int initialBalance,
      int transactionSum,
      int currentBalance});
}

/// @nodoc
class _$PlatformBalanceCopyWithImpl<$Res, $Val extends PlatformBalance>
    implements $PlatformBalanceCopyWith<$Res> {
  _$PlatformBalanceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? platformId = null,
    Object? name = null,
    Object? icon = null,
    Object? color = null,
    Object? moneyType = null,
    Object? initialBalance = null,
    Object? transactionSum = null,
    Object? currentBalance = null,
  }) {
    return _then(_value.copyWith(
      platformId: null == platformId
          ? _value.platformId
          : platformId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as int,
      moneyType: null == moneyType
          ? _value.moneyType
          : moneyType // ignore: cast_nullable_to_non_nullable
              as String,
      initialBalance: null == initialBalance
          ? _value.initialBalance
          : initialBalance // ignore: cast_nullable_to_non_nullable
              as int,
      transactionSum: null == transactionSum
          ? _value.transactionSum
          : transactionSum // ignore: cast_nullable_to_non_nullable
              as int,
      currentBalance: null == currentBalance
          ? _value.currentBalance
          : currentBalance // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlatformBalanceImplCopyWith<$Res>
    implements $PlatformBalanceCopyWith<$Res> {
  factory _$$PlatformBalanceImplCopyWith(_$PlatformBalanceImpl value,
          $Res Function(_$PlatformBalanceImpl) then) =
      __$$PlatformBalanceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String platformId,
      String name,
      String icon,
      int color,
      String moneyType,
      int initialBalance,
      int transactionSum,
      int currentBalance});
}

/// @nodoc
class __$$PlatformBalanceImplCopyWithImpl<$Res>
    extends _$PlatformBalanceCopyWithImpl<$Res, _$PlatformBalanceImpl>
    implements _$$PlatformBalanceImplCopyWith<$Res> {
  __$$PlatformBalanceImplCopyWithImpl(
      _$PlatformBalanceImpl _value, $Res Function(_$PlatformBalanceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? platformId = null,
    Object? name = null,
    Object? icon = null,
    Object? color = null,
    Object? moneyType = null,
    Object? initialBalance = null,
    Object? transactionSum = null,
    Object? currentBalance = null,
  }) {
    return _then(_$PlatformBalanceImpl(
      platformId: null == platformId
          ? _value.platformId
          : platformId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as int,
      moneyType: null == moneyType
          ? _value.moneyType
          : moneyType // ignore: cast_nullable_to_non_nullable
              as String,
      initialBalance: null == initialBalance
          ? _value.initialBalance
          : initialBalance // ignore: cast_nullable_to_non_nullable
              as int,
      transactionSum: null == transactionSum
          ? _value.transactionSum
          : transactionSum // ignore: cast_nullable_to_non_nullable
              as int,
      currentBalance: null == currentBalance
          ? _value.currentBalance
          : currentBalance // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlatformBalanceImpl implements _PlatformBalance {
  const _$PlatformBalanceImpl(
      {required this.platformId,
      required this.name,
      required this.icon,
      required this.color,
      required this.moneyType,
      required this.initialBalance,
      required this.transactionSum,
      required this.currentBalance});

  factory _$PlatformBalanceImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlatformBalanceImplFromJson(json);

  @override
  final String platformId;
  @override
  final String name;
  @override
  final String icon;
  @override
  final int color;
  @override
  final String moneyType;
  @override
  final int initialBalance;
  @override
  final int transactionSum;
  @override
  final int currentBalance;

  @override
  String toString() {
    return 'PlatformBalance(platformId: $platformId, name: $name, icon: $icon, color: $color, moneyType: $moneyType, initialBalance: $initialBalance, transactionSum: $transactionSum, currentBalance: $currentBalance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlatformBalanceImpl &&
            (identical(other.platformId, platformId) ||
                other.platformId == platformId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.moneyType, moneyType) ||
                other.moneyType == moneyType) &&
            (identical(other.initialBalance, initialBalance) ||
                other.initialBalance == initialBalance) &&
            (identical(other.transactionSum, transactionSum) ||
                other.transactionSum == transactionSum) &&
            (identical(other.currentBalance, currentBalance) ||
                other.currentBalance == currentBalance));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, platformId, name, icon, color,
      moneyType, initialBalance, transactionSum, currentBalance);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlatformBalanceImplCopyWith<_$PlatformBalanceImpl> get copyWith =>
      __$$PlatformBalanceImplCopyWithImpl<_$PlatformBalanceImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlatformBalanceImplToJson(
      this,
    );
  }
}

abstract class _PlatformBalance implements PlatformBalance {
  const factory _PlatformBalance(
      {required final String platformId,
      required final String name,
      required final String icon,
      required final int color,
      required final String moneyType,
      required final int initialBalance,
      required final int transactionSum,
      required final int currentBalance}) = _$PlatformBalanceImpl;

  factory _PlatformBalance.fromJson(Map<String, dynamic> json) =
      _$PlatformBalanceImpl.fromJson;

  @override
  String get platformId;
  @override
  String get name;
  @override
  String get icon;
  @override
  int get color;
  @override
  String get moneyType;
  @override
  int get initialBalance;
  @override
  int get transactionSum;
  @override
  int get currentBalance;
  @override
  @JsonKey(ignore: true)
  _$$PlatformBalanceImplCopyWith<_$PlatformBalanceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
