// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TransactionLog _$TransactionLogFromJson(Map<String, dynamic> json) {
  return _TransactionLog.fromJson(json);
}

/// @nodoc
mixin _$TransactionLog {
  String get id => throw _privateConstructorUsedError;
  String get transactionId => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String? get platformId => throw _privateConstructorUsedError;
  int get amount => throw _privateConstructorUsedError;
  int get balanceBefore => throw _privateConstructorUsedError;
  int get balanceAfter => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TransactionLogCopyWith<TransactionLog> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionLogCopyWith<$Res> {
  factory $TransactionLogCopyWith(
          TransactionLog value, $Res Function(TransactionLog) then) =
      _$TransactionLogCopyWithImpl<$Res, TransactionLog>;
  @useResult
  $Res call(
      {String id,
      String transactionId,
      String type,
      String? platformId,
      int amount,
      int balanceBefore,
      int balanceAfter,
      String? note,
      DateTime createdAt});
}

/// @nodoc
class _$TransactionLogCopyWithImpl<$Res, $Val extends TransactionLog>
    implements $TransactionLogCopyWith<$Res> {
  _$TransactionLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? transactionId = null,
    Object? type = null,
    Object? platformId = freezed,
    Object? amount = null,
    Object? balanceBefore = null,
    Object? balanceAfter = null,
    Object? note = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      transactionId: null == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      platformId: freezed == platformId
          ? _value.platformId
          : platformId // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      balanceBefore: null == balanceBefore
          ? _value.balanceBefore
          : balanceBefore // ignore: cast_nullable_to_non_nullable
              as int,
      balanceAfter: null == balanceAfter
          ? _value.balanceAfter
          : balanceAfter // ignore: cast_nullable_to_non_nullable
              as int,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransactionLogImplCopyWith<$Res>
    implements $TransactionLogCopyWith<$Res> {
  factory _$$TransactionLogImplCopyWith(_$TransactionLogImpl value,
          $Res Function(_$TransactionLogImpl) then) =
      __$$TransactionLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String transactionId,
      String type,
      String? platformId,
      int amount,
      int balanceBefore,
      int balanceAfter,
      String? note,
      DateTime createdAt});
}

/// @nodoc
class __$$TransactionLogImplCopyWithImpl<$Res>
    extends _$TransactionLogCopyWithImpl<$Res, _$TransactionLogImpl>
    implements _$$TransactionLogImplCopyWith<$Res> {
  __$$TransactionLogImplCopyWithImpl(
      _$TransactionLogImpl _value, $Res Function(_$TransactionLogImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? transactionId = null,
    Object? type = null,
    Object? platformId = freezed,
    Object? amount = null,
    Object? balanceBefore = null,
    Object? balanceAfter = null,
    Object? note = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$TransactionLogImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      transactionId: null == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      platformId: freezed == platformId
          ? _value.platformId
          : platformId // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      balanceBefore: null == balanceBefore
          ? _value.balanceBefore
          : balanceBefore // ignore: cast_nullable_to_non_nullable
              as int,
      balanceAfter: null == balanceAfter
          ? _value.balanceAfter
          : balanceAfter // ignore: cast_nullable_to_non_nullable
              as int,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransactionLogImpl implements _TransactionLog {
  const _$TransactionLogImpl(
      {required this.id,
      required this.transactionId,
      required this.type,
      this.platformId,
      required this.amount,
      required this.balanceBefore,
      required this.balanceAfter,
      this.note,
      required this.createdAt});

  factory _$TransactionLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionLogImplFromJson(json);

  @override
  final String id;
  @override
  final String transactionId;
  @override
  final String type;
  @override
  final String? platformId;
  @override
  final int amount;
  @override
  final int balanceBefore;
  @override
  final int balanceAfter;
  @override
  final String? note;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'TransactionLog(id: $id, transactionId: $transactionId, type: $type, platformId: $platformId, amount: $amount, balanceBefore: $balanceBefore, balanceAfter: $balanceAfter, note: $note, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionLogImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.transactionId, transactionId) ||
                other.transactionId == transactionId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.platformId, platformId) ||
                other.platformId == platformId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.balanceBefore, balanceBefore) ||
                other.balanceBefore == balanceBefore) &&
            (identical(other.balanceAfter, balanceAfter) ||
                other.balanceAfter == balanceAfter) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, transactionId, type,
      platformId, amount, balanceBefore, balanceAfter, note, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionLogImplCopyWith<_$TransactionLogImpl> get copyWith =>
      __$$TransactionLogImplCopyWithImpl<_$TransactionLogImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionLogImplToJson(
      this,
    );
  }
}

abstract class _TransactionLog implements TransactionLog {
  const factory _TransactionLog(
      {required final String id,
      required final String transactionId,
      required final String type,
      final String? platformId,
      required final int amount,
      required final int balanceBefore,
      required final int balanceAfter,
      final String? note,
      required final DateTime createdAt}) = _$TransactionLogImpl;

  factory _TransactionLog.fromJson(Map<String, dynamic> json) =
      _$TransactionLogImpl.fromJson;

  @override
  String get id;
  @override
  String get transactionId;
  @override
  String get type;
  @override
  String? get platformId;
  @override
  int get amount;
  @override
  int get balanceBefore;
  @override
  int get balanceAfter;
  @override
  String? get note;
  @override
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$TransactionLogImplCopyWith<_$TransactionLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
