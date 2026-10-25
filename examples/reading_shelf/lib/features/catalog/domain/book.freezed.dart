// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'book.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Book {

 String get id; String get title; String get author; String get description; int get pageCount; int get publishedYear; String get genre;
/// Create a copy of Book
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookCopyWith<Book> get copyWith => _$BookCopyWithImpl<Book>(this as Book, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Book;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Book&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.author, _this.author) || other.author == _this.author)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.pageCount, _this.pageCount) || other.pageCount == _this.pageCount)&&(identical(other.publishedYear, _this.publishedYear) || other.publishedYear == _this.publishedYear)&&(identical(other.genre, _this.genre) || other.genre == _this.genre));
}


@override
int get hashCode {
  final _this = this as Book;
  return Object.hash(runtimeType,_this.id,_this.title,_this.author,_this.description,_this.pageCount,_this.publishedYear,_this.genre);
}

@override
String toString() {
  final _this = this as Book;
  return 'Book(id: ${_this.id}, title: ${_this.title}, author: ${_this.author}, description: ${_this.description}, pageCount: ${_this.pageCount}, publishedYear: ${_this.publishedYear}, genre: ${_this.genre})';
}


}

/// @nodoc
abstract mixin class $BookCopyWith<$Res>  {
  factory $BookCopyWith(Book value, $Res Function(Book) _then) = _$BookCopyWithImpl;
@useResult
$Res call({
 String id, String title, String author, String description, int pageCount, int publishedYear, String genre
});




}
/// @nodoc
class _$BookCopyWithImpl<$Res>
    implements $BookCopyWith<$Res> {
  _$BookCopyWithImpl(this._self, this._then);

  final Book _self;
  final $Res Function(Book) _then;

/// Create a copy of Book
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? author = null,Object? description = null,Object? pageCount = null,Object? publishedYear = null,Object? genre = null,}) {
  return _then(Book(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,pageCount: null == pageCount ? _self.pageCount : pageCount // ignore: cast_nullable_to_non_nullable
as int,publishedYear: null == publishedYear ? _self.publishedYear : publishedYear // ignore: cast_nullable_to_non_nullable
as int,genre: null == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Book].
extension BookPatterns on Book {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Book value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Book() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Book value)  $default,){
final _that = this;
switch (_that) {
case _Book():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Book value)?  $default,){
final _that = this;
switch (_that) {
case _Book() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String author,  String description,  int pageCount,  int publishedYear,  String genre)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Book() when $default != null:
return $default(_that.id,_that.title,_that.author,_that.description,_that.pageCount,_that.publishedYear,_that.genre);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String author,  String description,  int pageCount,  int publishedYear,  String genre)  $default,) {final _that = this;
switch (_that) {
case _Book():
return $default(_that.id,_that.title,_that.author,_that.description,_that.pageCount,_that.publishedYear,_that.genre);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String author,  String description,  int pageCount,  int publishedYear,  String genre)?  $default,) {final _that = this;
switch (_that) {
case _Book() when $default != null:
return $default(_that.id,_that.title,_that.author,_that.description,_that.pageCount,_that.publishedYear,_that.genre);case _:
  return null;

}
}

}

/// @nodoc


class _Book implements Book {
  const _Book({required this.id, required this.title, required this.author, required this.description, required this.pageCount, required this.publishedYear, required this.genre});
  

@override final  String id;
@override final  String title;
@override final  String author;
@override final  String description;
@override final  int pageCount;
@override final  int publishedYear;
@override final  String genre;

/// Create a copy of Book
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookCopyWith<_Book> get copyWith => __$BookCopyWithImpl<_Book>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Book&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.author, author) || other.author == author)&&(identical(other.description, description) || other.description == description)&&(identical(other.pageCount, pageCount) || other.pageCount == pageCount)&&(identical(other.publishedYear, publishedYear) || other.publishedYear == publishedYear)&&(identical(other.genre, genre) || other.genre == genre));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,title,author,description,pageCount,publishedYear,genre);
}

@override
String toString() {
    return 'Book(id: $id, title: $title, author: $author, description: $description, pageCount: $pageCount, publishedYear: $publishedYear, genre: $genre)';
}


}

/// @nodoc
abstract mixin class _$BookCopyWith<$Res> implements $BookCopyWith<$Res> {
  factory _$BookCopyWith(_Book value, $Res Function(_Book) _then) = __$BookCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String author, String description, int pageCount, int publishedYear, String genre
});




}
/// @nodoc
class __$BookCopyWithImpl<$Res>
    implements _$BookCopyWith<$Res> {
  __$BookCopyWithImpl(this._self, this._then);

  final _Book _self;
  final $Res Function(_Book) _then;

/// Create a copy of Book
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? author = null,Object? description = null,Object? pageCount = null,Object? publishedYear = null,Object? genre = null,}) {
  return _then(_Book(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,pageCount: null == pageCount ? _self.pageCount : pageCount // ignore: cast_nullable_to_non_nullable
as int,publishedYear: null == publishedYear ? _self.publishedYear : publishedYear // ignore: cast_nullable_to_non_nullable
as int,genre: null == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$BookSearchPage {

 List<Book> get items; int get page; int get pageSize; int get total;
/// Create a copy of BookSearchPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookSearchPageCopyWith<BookSearchPage> get copyWith => _$BookSearchPageCopyWithImpl<BookSearchPage>(this as BookSearchPage, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BookSearchPage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookSearchPage&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.page, _this.page) || other.page == _this.page)&&(identical(other.pageSize, _this.pageSize) || other.pageSize == _this.pageSize)&&(identical(other.total, _this.total) || other.total == _this.total));
}


@override
int get hashCode {
  final _this = this as BookSearchPage;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items),_this.page,_this.pageSize,_this.total);
}

@override
String toString() {
  final _this = this as BookSearchPage;
  return 'BookSearchPage(items: ${_this.items}, page: ${_this.page}, pageSize: ${_this.pageSize}, total: ${_this.total})';
}


}

/// @nodoc
abstract mixin class $BookSearchPageCopyWith<$Res>  {
  factory $BookSearchPageCopyWith(BookSearchPage value, $Res Function(BookSearchPage) _then) = _$BookSearchPageCopyWithImpl;
@useResult
$Res call({
 List<Book> items, int page, int pageSize, int total
});




}
/// @nodoc
class _$BookSearchPageCopyWithImpl<$Res>
    implements $BookSearchPageCopyWith<$Res> {
  _$BookSearchPageCopyWithImpl(this._self, this._then);

  final BookSearchPage _self;
  final $Res Function(BookSearchPage) _then;

/// Create a copy of BookSearchPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? page = null,Object? pageSize = null,Object? total = null,}) {
  return _then(BookSearchPage(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<Book>,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BookSearchPage].
extension BookSearchPagePatterns on BookSearchPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookSearchPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookSearchPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookSearchPage value)  $default,){
final _that = this;
switch (_that) {
case _BookSearchPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookSearchPage value)?  $default,){
final _that = this;
switch (_that) {
case _BookSearchPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Book> items,  int page,  int pageSize,  int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookSearchPage() when $default != null:
return $default(_that.items,_that.page,_that.pageSize,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Book> items,  int page,  int pageSize,  int total)  $default,) {final _that = this;
switch (_that) {
case _BookSearchPage():
return $default(_that.items,_that.page,_that.pageSize,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Book> items,  int page,  int pageSize,  int total)?  $default,) {final _that = this;
switch (_that) {
case _BookSearchPage() when $default != null:
return $default(_that.items,_that.page,_that.pageSize,_that.total);case _:
  return null;

}
}

}

/// @nodoc


class _BookSearchPage implements BookSearchPage {
  const _BookSearchPage({required  List<Book> items, required this.page, required this.pageSize, required this.total}): _items = items;
  

 final  List<Book> _items;
@override List<Book> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  int page;
@override final  int pageSize;
@override final  int total;

/// Create a copy of BookSearchPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookSearchPageCopyWith<_BookSearchPage> get copyWith => __$BookSearchPageCopyWithImpl<_BookSearchPage>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookSearchPage&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.page, page) || other.page == page)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&(identical(other.total, total) || other.total == total));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),page,pageSize,total);
}

@override
String toString() {
    return 'BookSearchPage(items: $items, page: $page, pageSize: $pageSize, total: $total)';
}


}

/// @nodoc
abstract mixin class _$BookSearchPageCopyWith<$Res> implements $BookSearchPageCopyWith<$Res> {
  factory _$BookSearchPageCopyWith(_BookSearchPage value, $Res Function(_BookSearchPage) _then) = __$BookSearchPageCopyWithImpl;
@override @useResult
$Res call({
 List<Book> items, int page, int pageSize, int total
});




}
/// @nodoc
class __$BookSearchPageCopyWithImpl<$Res>
    implements _$BookSearchPageCopyWith<$Res> {
  __$BookSearchPageCopyWithImpl(this._self, this._then);

  final _BookSearchPage _self;
  final $Res Function(_BookSearchPage) _then;

/// Create a copy of BookSearchPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? page = null,Object? pageSize = null,Object? total = null,}) {
  return _then(_BookSearchPage(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Book>,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
