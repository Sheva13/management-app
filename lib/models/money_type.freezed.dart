// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'money_type.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MoneyType _$MoneyTypeFromJson(Map<String, dynamic> json) {
  return _MoneyType.fromJson(json);
}

/// @nodoc
mixin _$MoneyType {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MoneyTypeCopyWith<MoneyType> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MoneyTypeCopyWith<$Res> {
  factory $MoneyTypeCopyWith(MoneyType value, $Res Function(MoneyType) then) =
      _$MoneyTypeCopyWithImpl<$Res, MoneyType>;
  @useResult
  $Res call(
      {String id,
      String name,
      String type,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$MoneyTypeCopyWithImpl<$Res, $Val extends MoneyType>
    implements $MoneyTypeCopyWith<$Res> {
  _$MoneyTypeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
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
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
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
abstract class _$$MoneyTypeImplCopyWith<$Res>
    implements $MoneyTypeCopyWith<$Res> {
  factory _$$MoneyTypeImplCopyWith(
          _$MoneyTypeImpl value, $Res Function(_$MoneyTypeImpl) then) =
      __$$MoneyTypeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String type,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$MoneyTypeImplCopyWithImpl<$Res>
    extends _$MoneyTypeCopyWithImpl<$Res, _$MoneyTypeImpl>
    implements _$$MoneyTypeImplCopyWith<$Res> {
  __$$MoneyTypeImplCopyWithImpl(
      _$MoneyTypeImpl _value, $Res Function(_$MoneyTypeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$MoneyTypeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
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
class _$MoneyTypeImpl implements _MoneyType {
  const _$MoneyTypeImpl(
      {required this.id,
      required this.name,
      required this.type,
      required this.createdAt,
      required this.updatedAt});

  factory _$MoneyTypeImpl.fromJson(Map<String, dynamic> json) =>
      _$$MoneyTypeImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String type;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'MoneyType(id: $id, name: $name, type: $type, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MoneyTypeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, type, createdAt, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MoneyTypeImplCopyWith<_$MoneyTypeImpl> get copyWith =>
      __$$MoneyTypeImplCopyWithImpl<_$MoneyTypeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MoneyTypeImplToJson(
      this,
    );
  }
}

abstract class _MoneyType implements MoneyType {
  const factory _MoneyType(
      {required final String id,
      required final String name,
      required final String type,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$MoneyTypeImpl;

  factory _MoneyType.fromJson(Map<String, dynamic> json) =
      _$MoneyTypeImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get type;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$MoneyTypeImplCopyWith<_$MoneyTypeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
