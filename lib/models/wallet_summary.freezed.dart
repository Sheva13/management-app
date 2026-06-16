// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WalletSummary _$WalletSummaryFromJson(Map<String, dynamic> json) {
  return _WalletSummary.fromJson(json);
}

/// @nodoc
mixin _$WalletSummary {
  int get totalUang => throw _privateConstructorUsedError;
  int get totalEMoney => throw _privateConstructorUsedError;
  int get totalCash => throw _privateConstructorUsedError;
  int get totalIncome => throw _privateConstructorUsedError;
  int get totalExpense => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WalletSummaryCopyWith<WalletSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WalletSummaryCopyWith<$Res> {
  factory $WalletSummaryCopyWith(
          WalletSummary value, $Res Function(WalletSummary) then) =
      _$WalletSummaryCopyWithImpl<$Res, WalletSummary>;
  @useResult
  $Res call(
      {int totalUang,
      int totalEMoney,
      int totalCash,
      int totalIncome,
      int totalExpense});
}

/// @nodoc
class _$WalletSummaryCopyWithImpl<$Res, $Val extends WalletSummary>
    implements $WalletSummaryCopyWith<$Res> {
  _$WalletSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalUang = null,
    Object? totalEMoney = null,
    Object? totalCash = null,
    Object? totalIncome = null,
    Object? totalExpense = null,
  }) {
    return _then(_value.copyWith(
      totalUang: null == totalUang
          ? _value.totalUang
          : totalUang // ignore: cast_nullable_to_non_nullable
              as int,
      totalEMoney: null == totalEMoney
          ? _value.totalEMoney
          : totalEMoney // ignore: cast_nullable_to_non_nullable
              as int,
      totalCash: null == totalCash
          ? _value.totalCash
          : totalCash // ignore: cast_nullable_to_non_nullable
              as int,
      totalIncome: null == totalIncome
          ? _value.totalIncome
          : totalIncome // ignore: cast_nullable_to_non_nullable
              as int,
      totalExpense: null == totalExpense
          ? _value.totalExpense
          : totalExpense // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WalletSummaryImplCopyWith<$Res>
    implements $WalletSummaryCopyWith<$Res> {
  factory _$$WalletSummaryImplCopyWith(
          _$WalletSummaryImpl value, $Res Function(_$WalletSummaryImpl) then) =
      __$$WalletSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalUang,
      int totalEMoney,
      int totalCash,
      int totalIncome,
      int totalExpense});
}

/// @nodoc
class __$$WalletSummaryImplCopyWithImpl<$Res>
    extends _$WalletSummaryCopyWithImpl<$Res, _$WalletSummaryImpl>
    implements _$$WalletSummaryImplCopyWith<$Res> {
  __$$WalletSummaryImplCopyWithImpl(
      _$WalletSummaryImpl _value, $Res Function(_$WalletSummaryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalUang = null,
    Object? totalEMoney = null,
    Object? totalCash = null,
    Object? totalIncome = null,
    Object? totalExpense = null,
  }) {
    return _then(_$WalletSummaryImpl(
      totalUang: null == totalUang
          ? _value.totalUang
          : totalUang // ignore: cast_nullable_to_non_nullable
              as int,
      totalEMoney: null == totalEMoney
          ? _value.totalEMoney
          : totalEMoney // ignore: cast_nullable_to_non_nullable
              as int,
      totalCash: null == totalCash
          ? _value.totalCash
          : totalCash // ignore: cast_nullable_to_non_nullable
              as int,
      totalIncome: null == totalIncome
          ? _value.totalIncome
          : totalIncome // ignore: cast_nullable_to_non_nullable
              as int,
      totalExpense: null == totalExpense
          ? _value.totalExpense
          : totalExpense // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WalletSummaryImpl implements _WalletSummary {
  const _$WalletSummaryImpl(
      {required this.totalUang,
      required this.totalEMoney,
      required this.totalCash,
      required this.totalIncome,
      required this.totalExpense});

  factory _$WalletSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$WalletSummaryImplFromJson(json);

  @override
  final int totalUang;
  @override
  final int totalEMoney;
  @override
  final int totalCash;
  @override
  final int totalIncome;
  @override
  final int totalExpense;

  @override
  String toString() {
    return 'WalletSummary(totalUang: $totalUang, totalEMoney: $totalEMoney, totalCash: $totalCash, totalIncome: $totalIncome, totalExpense: $totalExpense)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WalletSummaryImpl &&
            (identical(other.totalUang, totalUang) ||
                other.totalUang == totalUang) &&
            (identical(other.totalEMoney, totalEMoney) ||
                other.totalEMoney == totalEMoney) &&
            (identical(other.totalCash, totalCash) ||
                other.totalCash == totalCash) &&
            (identical(other.totalIncome, totalIncome) ||
                other.totalIncome == totalIncome) &&
            (identical(other.totalExpense, totalExpense) ||
                other.totalExpense == totalExpense));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, totalUang, totalEMoney,
      totalCash, totalIncome, totalExpense);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WalletSummaryImplCopyWith<_$WalletSummaryImpl> get copyWith =>
      __$$WalletSummaryImplCopyWithImpl<_$WalletSummaryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WalletSummaryImplToJson(
      this,
    );
  }
}

abstract class _WalletSummary implements WalletSummary {
  const factory _WalletSummary(
      {required final int totalUang,
      required final int totalEMoney,
      required final int totalCash,
      required final int totalIncome,
      required final int totalExpense}) = _$WalletSummaryImpl;

  factory _WalletSummary.fromJson(Map<String, dynamic> json) =
      _$WalletSummaryImpl.fromJson;

  @override
  int get totalUang;
  @override
  int get totalEMoney;
  @override
  int get totalCash;
  @override
  int get totalIncome;
  @override
  int get totalExpense;
  @override
  @JsonKey(ignore: true)
  _$$WalletSummaryImplCopyWith<_$WalletSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
