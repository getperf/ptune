// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'my_task_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MyTaskList _$MyTaskListFromJson(Map<String, dynamic> json) {
  return _MyTaskList.fromJson(json);
}

/// @nodoc
mixin _$MyTaskList {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  /// Serializes this MyTaskList to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MyTaskList
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MyTaskListCopyWith<MyTaskList> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MyTaskListCopyWith<$Res> {
  factory $MyTaskListCopyWith(
    MyTaskList value,
    $Res Function(MyTaskList) then,
  ) = _$MyTaskListCopyWithImpl<$Res, MyTaskList>;
  @useResult
  $Res call({String id, String title, String? description});
}

/// @nodoc
class _$MyTaskListCopyWithImpl<$Res, $Val extends MyTaskList>
    implements $MyTaskListCopyWith<$Res> {
  _$MyTaskListCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MyTaskList
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MyTaskListImplCopyWith<$Res>
    implements $MyTaskListCopyWith<$Res> {
  factory _$$MyTaskListImplCopyWith(
    _$MyTaskListImpl value,
    $Res Function(_$MyTaskListImpl) then,
  ) = __$$MyTaskListImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String title, String? description});
}

/// @nodoc
class __$$MyTaskListImplCopyWithImpl<$Res>
    extends _$MyTaskListCopyWithImpl<$Res, _$MyTaskListImpl>
    implements _$$MyTaskListImplCopyWith<$Res> {
  __$$MyTaskListImplCopyWithImpl(
    _$MyTaskListImpl _value,
    $Res Function(_$MyTaskListImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MyTaskList
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
  }) {
    return _then(
      _$MyTaskListImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MyTaskListImpl implements _MyTaskList {
  const _$MyTaskListImpl({
    required this.id,
    required this.title,
    this.description,
  });

  factory _$MyTaskListImpl.fromJson(Map<String, dynamic> json) =>
      _$$MyTaskListImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String? description;

  @override
  String toString() {
    return 'MyTaskList(id: $id, title: $title, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MyTaskListImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, description);

  /// Create a copy of MyTaskList
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MyTaskListImplCopyWith<_$MyTaskListImpl> get copyWith =>
      __$$MyTaskListImplCopyWithImpl<_$MyTaskListImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MyTaskListImplToJson(this);
  }
}

abstract class _MyTaskList implements MyTaskList {
  const factory _MyTaskList({
    required final String id,
    required final String title,
    final String? description,
  }) = _$MyTaskListImpl;

  factory _MyTaskList.fromJson(Map<String, dynamic> json) =
      _$MyTaskListImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String? get description;

  /// Create a copy of MyTaskList
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MyTaskListImplCopyWith<_$MyTaskListImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
