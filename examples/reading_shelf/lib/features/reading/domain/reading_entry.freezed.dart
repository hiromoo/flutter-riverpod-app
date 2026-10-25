// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reading_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReadingEntry {

 String get bookId; ReadingStatus get status; int get pagesRead; int? get rating; String get note; DateTime get updatedAt;
/// Create a copy of ReadingEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReadingEntryCopyWith<ReadingEntry> get copyWith => _$ReadingEntryCopyWithImpl<ReadingEntry>(this as ReadingEntry, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ReadingEntry;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReadingEntry&&(identical(other.bookId, _this.bookId) || other.bookId == _this.bookId)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.pagesRead, _this.pagesRead) || other.pagesRead == _this.pagesRead)&&(identical(other.rating, _this.rating) || other.rating == _this.rating)&&(identical(other.note, _this.note) || other.note == _this.note)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}


@override
int get hashCode {
  final _this = this as ReadingEntry;
  return Object.hash(runtimeType,_this.bookId,_this.status,_this.pagesRead,_this.rating,_this.note,_this.updatedAt);
}

@override
String toString() {
  final _this = this as ReadingEntry;
  return 'ReadingEntry(bookId: ${_this.bookId}, status: ${_this.status}, pagesRead: ${_this.pagesRead}, rating: ${_this.rating}, note: ${_this.note}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $ReadingEntryCopyWith<$Res>  {
  factory $ReadingEntryCopyWith(ReadingEntry value, $Res Function(ReadingEntry) _then) = _$ReadingEntryCopyWithImpl;
@useResult
$Res call({
 String bookId, ReadingStatus status, int pagesRead, int? rating, String note, DateTime updatedAt
});




}
/// @nodoc
class _$ReadingEntryCopyWithImpl<$Res>
    implements $ReadingEntryCopyWith<$Res> {
  _$ReadingEntryCopyWithImpl(this._self, this._then);

  final ReadingEntry _self;
  final $Res Function(ReadingEntry) _then;

/// Create a copy of ReadingEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bookId = null,Object? status = null,Object? pagesRead = null,Object? rating = freezed,Object? note = null,Object? updatedAt = null,}) {
  return _then(ReadingEntry(
bookId: null == bookId ? _self.bookId : bookId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ReadingStatus,pagesRead: null == pagesRead ? _self.pagesRead : pagesRead // ignore: cast_nullable_to_non_nullable
as int,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int?,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ReadingEntry].
extension ReadingEntryPatterns on ReadingEntry {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReadingEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReadingEntry() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReadingEntry value)  $default,){
final _that = this;
switch (_that) {
case _ReadingEntry():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReadingEntry value)?  $default,){
final _that = this;
switch (_that) {
case _ReadingEntry() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String bookId,  ReadingStatus status,  int pagesRead,  int? rating,  String note,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReadingEntry() when $default != null:
return $default(_that.bookId,_that.status,_that.pagesRead,_that.rating,_that.note,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String bookId,  ReadingStatus status,  int pagesRead,  int? rating,  String note,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ReadingEntry():
return $default(_that.bookId,_that.status,_that.pagesRead,_that.rating,_that.note,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String bookId,  ReadingStatus status,  int pagesRead,  int? rating,  String note,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ReadingEntry() when $default != null:
return $default(_that.bookId,_that.status,_that.pagesRead,_that.rating,_that.note,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _ReadingEntry implements ReadingEntry {
  const _ReadingEntry({required this.bookId, required this.status, required this.pagesRead, required this.rating, required this.note, required this.updatedAt});
  

@override final  String bookId;
@override final  ReadingStatus status;
@override final  int pagesRead;
@override final  int? rating;
@override final  String note;
@override final  DateTime updatedAt;

/// Create a copy of ReadingEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReadingEntryCopyWith<_ReadingEntry> get copyWith => __$ReadingEntryCopyWithImpl<_ReadingEntry>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReadingEntry&&(identical(other.bookId, bookId) || other.bookId == bookId)&&(identical(other.status, status) || other.status == status)&&(identical(other.pagesRead, pagesRead) || other.pagesRead == pagesRead)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.note, note) || other.note == note)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,bookId,status,pagesRead,rating,note,updatedAt);
}

@override
String toString() {
    return 'ReadingEntry(bookId: $bookId, status: $status, pagesRead: $pagesRead, rating: $rating, note: $note, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ReadingEntryCopyWith<$Res> implements $ReadingEntryCopyWith<$Res> {
  factory _$ReadingEntryCopyWith(_ReadingEntry value, $Res Function(_ReadingEntry) _then) = __$ReadingEntryCopyWithImpl;
@override @useResult
$Res call({
 String bookId, ReadingStatus status, int pagesRead, int? rating, String note, DateTime updatedAt
});




}
/// @nodoc
class __$ReadingEntryCopyWithImpl<$Res>
    implements _$ReadingEntryCopyWith<$Res> {
  __$ReadingEntryCopyWithImpl(this._self, this._then);

  final _ReadingEntry _self;
  final $Res Function(_ReadingEntry) _then;

/// Create a copy of ReadingEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bookId = null,Object? status = null,Object? pagesRead = null,Object? rating = freezed,Object? note = null,Object? updatedAt = null,}) {
  return _then(_ReadingEntry(
bookId: null == bookId ? _self.bookId : bookId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ReadingStatus,pagesRead: null == pagesRead ? _self.pagesRead : pagesRead // ignore: cast_nullable_to_non_nullable
as int,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int?,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
