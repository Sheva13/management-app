// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'platform.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Platform _$PlatformFromJson(Map<String, dynamic> json) {
  return _Platform.fromJson(json);
}

/// @nodoc
mixin _$Platform {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get icon => throw _privateConstructorUsedError;
  int get color => throw _privateConstructorUsedError;
  String get moneyTypeId => throw _privateConstructorUsedError;
  int get initialBalance => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PlatformCopyWith<Platform> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlatformCopyWith<$Res> {
  factory $PlatformCopyWith(Platform value, $Res Function(Platform) then) =
      _$PlatformCopyWithImpl<$Res, Platform>;
  @useResult
  $Res call(
      {String id,
      String name,
      String icon,
      int color,
      String moneyTypeId,
      int initialBalance,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$PlatformCopyWithImpl<$Res, $Val extends Platform>
    implements $PlatformCopyWith<$Res> {
  _$PlatformCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? icon = null,
    Object? color = null,
    Object? moneyTypeId = null,
    Object? initialBalance = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
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
      moneyTypeId: null == moneyTypeId
          ? _value.moneyTypeId
          : moneyTypeId // ignore: cast_nullable_to_non_nullable
              as String,
      initialBalance: null == initialBalance
          ? _value.initialBalance
          : initialBalance // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlatformImplCopyWith<$Res>
    implements $PlatformCopyWith<$Res> {
  factory _$$PlatformImplCopyWith(
          _$PlatformImpl value, $Res Function(_$PlatformImpl) then) =
      __$$PlatformImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String icon,
      int color,
      String moneyTypeId,
      int initialBalance,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$PlatformImplCopyWithImpl<$Res>
    extends _$PlatformCopyWithImpl<$Res, _$PlatformImpl>
    implements _$$PlatformImplCopyWith<$Res> {
  __$$PlatformImplCopyWithImpl(
      _$PlatformImpl _value, $Res Function(_$PlatformImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? icon = null,
    Object? color = null,
    Object? moneyTypeId = null,
    Object? initialBalance = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$PlatformImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
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
      moneyTypeId: null == moneyTypeId
          ? _value.moneyTypeId
          : moneyTypeId // ignore: cast_nullable_to_non_nullable
              as String,
      initialBalance: null == initialBalance
          ? _value.initialBalance
          : initialBalance // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlatformImpl implements _Platform {
  const _$PlatformImpl(
      {required this.id,
      required this.name,
      required this.icon,
      required this.color,
      required this.moneyTypeId,
      this.initialBalance = 0,
      required this.createdAt,
      required this.updatedAt});

  factory _$PlatformImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlatformImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String icon;
  @override
  final int color;
  @override
  final String moneyTypeId;
  @override
  @JsonKey()
  final int initialBalance;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Platform(id: $id, name: $name, icon: $icon, color: $color, moneyTypeId: $moneyTypeId, initialBalance: $initialBalance, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlatformImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.moneyTypeId, moneyTypeId) ||
                other.moneyTypeId == moneyTypeId) &&
            (identical(other.initialBalance, initialBalance) ||
                other.initialBalance == initialBalance) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, icon, color,
      moneyTypeId, initialBalance, createdAt, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlatformImplCopyWith<_$PlatformImpl> get copyWith =>
      __$$PlatformImplCopyWithImpl<_$PlatformImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlatformImplToJson(
      this,
    );
  }
}

abstract class _Platform implements Platform {
  const factory _Platform(
      {required final String id,
      required final String name,
      required final String icon,
      required final int color,
      required final String moneyTypeId,
      final int initialBalance,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$PlatformImpl;

  factory _Platform.fromJson(Map<String, dynamic> json) =
      _$PlatformImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get icon;
  @override
  int get color;
  @override
  String get moneyTypeId;
  @override
  int get initialBalance;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$PlatformImplCopyWith<_$PlatformImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
