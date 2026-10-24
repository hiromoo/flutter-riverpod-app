// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FirebaseEmulatorEndpoints implements DiagnosticableTreeMixin {

 String get host;
/// Create a copy of FirebaseEmulatorEndpoints
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FirebaseEmulatorEndpointsCopyWith<FirebaseEmulatorEndpoints> get copyWith => _$FirebaseEmulatorEndpointsCopyWithImpl<FirebaseEmulatorEndpoints>(this as FirebaseEmulatorEndpoints, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  final _this = this as FirebaseEmulatorEndpoints;
  properties
    ..add(DiagnosticsProperty('type', 'FirebaseEmulatorEndpoints'))
    ..add(DiagnosticsProperty('host', _this.host));
}

@override
bool operator ==(Object other) {
  final _this = this as FirebaseEmulatorEndpoints;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FirebaseEmulatorEndpoints&&(identical(other.host, _this.host) || other.host == _this.host));
}


@override
int get hashCode {
  final _this = this as FirebaseEmulatorEndpoints;
  return Object.hash(runtimeType,_this.host);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  final _this = this as FirebaseEmulatorEndpoints;
  return 'FirebaseEmulatorEndpoints(host: ${_this.host})';
}


}

/// @nodoc
abstract mixin class $FirebaseEmulatorEndpointsCopyWith<$Res>  {
  factory $FirebaseEmulatorEndpointsCopyWith(FirebaseEmulatorEndpoints value, $Res Function(FirebaseEmulatorEndpoints) _then) = _$FirebaseEmulatorEndpointsCopyWithImpl;
@useResult
$Res call({
 String host
});




}
/// @nodoc
class _$FirebaseEmulatorEndpointsCopyWithImpl<$Res>
    implements $FirebaseEmulatorEndpointsCopyWith<$Res> {
  _$FirebaseEmulatorEndpointsCopyWithImpl(this._self, this._then);

  final FirebaseEmulatorEndpoints _self;
  final $Res Function(FirebaseEmulatorEndpoints) _then;

/// Create a copy of FirebaseEmulatorEndpoints
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? host = null,}) {
  return _then(FirebaseEmulatorEndpoints(
host: null == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [FirebaseEmulatorEndpoints].
extension FirebaseEmulatorEndpointsPatterns on FirebaseEmulatorEndpoints {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FirebaseEmulatorEndpoints value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FirebaseEmulatorEndpoints() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FirebaseEmulatorEndpoints value)  $default,){
final _that = this;
switch (_that) {
case _FirebaseEmulatorEndpoints():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FirebaseEmulatorEndpoints value)?  $default,){
final _that = this;
switch (_that) {
case _FirebaseEmulatorEndpoints() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String host)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FirebaseEmulatorEndpoints() when $default != null:
return $default(_that.host);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String host)  $default,) {final _that = this;
switch (_that) {
case _FirebaseEmulatorEndpoints():
return $default(_that.host);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String host)?  $default,) {final _that = this;
switch (_that) {
case _FirebaseEmulatorEndpoints() when $default != null:
return $default(_that.host);case _:
  return null;

}
}

}

/// @nodoc


class _FirebaseEmulatorEndpoints with DiagnosticableTreeMixin implements FirebaseEmulatorEndpoints {
  const _FirebaseEmulatorEndpoints({required this.host});
  

@override final  String host;

/// Create a copy of FirebaseEmulatorEndpoints
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FirebaseEmulatorEndpointsCopyWith<_FirebaseEmulatorEndpoints> get copyWith => __$FirebaseEmulatorEndpointsCopyWithImpl<_FirebaseEmulatorEndpoints>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'FirebaseEmulatorEndpoints'))
    ..add(DiagnosticsProperty('host', host));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FirebaseEmulatorEndpoints&&(identical(other.host, host) || other.host == host));
}


@override
int get hashCode {
    return Object.hash(runtimeType,host);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'FirebaseEmulatorEndpoints(host: $host)';
}


}

/// @nodoc
abstract mixin class _$FirebaseEmulatorEndpointsCopyWith<$Res> implements $FirebaseEmulatorEndpointsCopyWith<$Res> {
  factory _$FirebaseEmulatorEndpointsCopyWith(_FirebaseEmulatorEndpoints value, $Res Function(_FirebaseEmulatorEndpoints) _then) = __$FirebaseEmulatorEndpointsCopyWithImpl;
@override @useResult
$Res call({
 String host
});




}
/// @nodoc
class __$FirebaseEmulatorEndpointsCopyWithImpl<$Res>
    implements _$FirebaseEmulatorEndpointsCopyWith<$Res> {
  __$FirebaseEmulatorEndpointsCopyWithImpl(this._self, this._then);

  final _FirebaseEmulatorEndpoints _self;
  final $Res Function(_FirebaseEmulatorEndpoints) _then;

/// Create a copy of FirebaseEmulatorEndpoints
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? host = null,}) {
  return _then(_FirebaseEmulatorEndpoints(
host: null == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$AppConfig implements DiagnosticableTreeMixin {

 AppEnvironment get environment; String get apiBaseUrl; String get supabaseUrl; String get supabasePublishableKey; String get firebaseEmulatorHost; String get localHostOverride;
/// Create a copy of AppConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppConfigCopyWith<AppConfig> get copyWith => _$AppConfigCopyWithImpl<AppConfig>(this as AppConfig, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  final _this = this as AppConfig;
  properties
    ..add(DiagnosticsProperty('type', 'AppConfig'))
    ..add(DiagnosticsProperty('environment', _this.environment))..add(DiagnosticsProperty('apiBaseUrl', _this.apiBaseUrl))..add(DiagnosticsProperty('supabaseUrl', _this.supabaseUrl))..add(DiagnosticsProperty('supabasePublishableKey', _this.supabasePublishableKey))..add(DiagnosticsProperty('firebaseEmulatorHost', _this.firebaseEmulatorHost))..add(DiagnosticsProperty('localHostOverride', _this.localHostOverride));
}

@override
bool operator ==(Object other) {
  final _this = this as AppConfig;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppConfig&&(identical(other.environment, _this.environment) || other.environment == _this.environment)&&(identical(other.apiBaseUrl, _this.apiBaseUrl) || other.apiBaseUrl == _this.apiBaseUrl)&&(identical(other.supabaseUrl, _this.supabaseUrl) || other.supabaseUrl == _this.supabaseUrl)&&(identical(other.supabasePublishableKey, _this.supabasePublishableKey) || other.supabasePublishableKey == _this.supabasePublishableKey)&&(identical(other.firebaseEmulatorHost, _this.firebaseEmulatorHost) || other.firebaseEmulatorHost == _this.firebaseEmulatorHost)&&(identical(other.localHostOverride, _this.localHostOverride) || other.localHostOverride == _this.localHostOverride));
}


@override
int get hashCode {
  final _this = this as AppConfig;
  return Object.hash(runtimeType,_this.environment,_this.apiBaseUrl,_this.supabaseUrl,_this.supabasePublishableKey,_this.firebaseEmulatorHost,_this.localHostOverride);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  final _this = this as AppConfig;
  return 'AppConfig(environment: ${_this.environment}, apiBaseUrl: ${_this.apiBaseUrl}, supabaseUrl: ${_this.supabaseUrl}, supabasePublishableKey: ${_this.supabasePublishableKey}, firebaseEmulatorHost: ${_this.firebaseEmulatorHost}, localHostOverride: ${_this.localHostOverride})';
}


}

/// @nodoc
abstract mixin class $AppConfigCopyWith<$Res>  {
  factory $AppConfigCopyWith(AppConfig value, $Res Function(AppConfig) _then) = _$AppConfigCopyWithImpl;
@useResult
$Res call({
 AppEnvironment environment, String apiBaseUrl, String supabaseUrl, String supabasePublishableKey, String firebaseEmulatorHost, String localHostOverride
});




}
/// @nodoc
class _$AppConfigCopyWithImpl<$Res>
    implements $AppConfigCopyWith<$Res> {
  _$AppConfigCopyWithImpl(this._self, this._then);

  final AppConfig _self;
  final $Res Function(AppConfig) _then;

/// Create a copy of AppConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? environment = null,Object? apiBaseUrl = null,Object? supabaseUrl = null,Object? supabasePublishableKey = null,Object? firebaseEmulatorHost = null,Object? localHostOverride = null,}) {
  return _then(AppConfig(
environment: null == environment ? _self.environment : environment // ignore: cast_nullable_to_non_nullable
as AppEnvironment,apiBaseUrl: null == apiBaseUrl ? _self.apiBaseUrl : apiBaseUrl // ignore: cast_nullable_to_non_nullable
as String,supabaseUrl: null == supabaseUrl ? _self.supabaseUrl : supabaseUrl // ignore: cast_nullable_to_non_nullable
as String,supabasePublishableKey: null == supabasePublishableKey ? _self.supabasePublishableKey : supabasePublishableKey // ignore: cast_nullable_to_non_nullable
as String,firebaseEmulatorHost: null == firebaseEmulatorHost ? _self.firebaseEmulatorHost : firebaseEmulatorHost // ignore: cast_nullable_to_non_nullable
as String,localHostOverride: null == localHostOverride ? _self.localHostOverride : localHostOverride // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AppConfig].
extension AppConfigPatterns on AppConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppConfig value)  $default,){
final _that = this;
switch (_that) {
case _AppConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppConfig value)?  $default,){
final _that = this;
switch (_that) {
case _AppConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AppEnvironment environment,  String apiBaseUrl,  String supabaseUrl,  String supabasePublishableKey,  String firebaseEmulatorHost,  String localHostOverride)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppConfig() when $default != null:
return $default(_that.environment,_that.apiBaseUrl,_that.supabaseUrl,_that.supabasePublishableKey,_that.firebaseEmulatorHost,_that.localHostOverride);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AppEnvironment environment,  String apiBaseUrl,  String supabaseUrl,  String supabasePublishableKey,  String firebaseEmulatorHost,  String localHostOverride)  $default,) {final _that = this;
switch (_that) {
case _AppConfig():
return $default(_that.environment,_that.apiBaseUrl,_that.supabaseUrl,_that.supabasePublishableKey,_that.firebaseEmulatorHost,_that.localHostOverride);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AppEnvironment environment,  String apiBaseUrl,  String supabaseUrl,  String supabasePublishableKey,  String firebaseEmulatorHost,  String localHostOverride)?  $default,) {final _that = this;
switch (_that) {
case _AppConfig() when $default != null:
return $default(_that.environment,_that.apiBaseUrl,_that.supabaseUrl,_that.supabasePublishableKey,_that.firebaseEmulatorHost,_that.localHostOverride);case _:
  return null;

}
}

}

/// @nodoc


class _AppConfig extends AppConfig with DiagnosticableTreeMixin {
  const _AppConfig({required this.environment, required this.apiBaseUrl, required this.supabaseUrl, required this.supabasePublishableKey, this.firebaseEmulatorHost = '', this.localHostOverride = ''}): super._();
  

@override final  AppEnvironment environment;
@override final  String apiBaseUrl;
@override final  String supabaseUrl;
@override final  String supabasePublishableKey;
@override@JsonKey() final  String firebaseEmulatorHost;
@override@JsonKey() final  String localHostOverride;

/// Create a copy of AppConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppConfigCopyWith<_AppConfig> get copyWith => __$AppConfigCopyWithImpl<_AppConfig>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'AppConfig'))
    ..add(DiagnosticsProperty('environment', environment))..add(DiagnosticsProperty('apiBaseUrl', apiBaseUrl))..add(DiagnosticsProperty('supabaseUrl', supabaseUrl))..add(DiagnosticsProperty('supabasePublishableKey', supabasePublishableKey))..add(DiagnosticsProperty('firebaseEmulatorHost', firebaseEmulatorHost))..add(DiagnosticsProperty('localHostOverride', localHostOverride));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppConfig&&(identical(other.environment, environment) || other.environment == environment)&&(identical(other.apiBaseUrl, apiBaseUrl) || other.apiBaseUrl == apiBaseUrl)&&(identical(other.supabaseUrl, supabaseUrl) || other.supabaseUrl == supabaseUrl)&&(identical(other.supabasePublishableKey, supabasePublishableKey) || other.supabasePublishableKey == supabasePublishableKey)&&(identical(other.firebaseEmulatorHost, firebaseEmulatorHost) || other.firebaseEmulatorHost == firebaseEmulatorHost)&&(identical(other.localHostOverride, localHostOverride) || other.localHostOverride == localHostOverride));
}


@override
int get hashCode {
    return Object.hash(runtimeType,environment,apiBaseUrl,supabaseUrl,supabasePublishableKey,firebaseEmulatorHost,localHostOverride);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'AppConfig(environment: $environment, apiBaseUrl: $apiBaseUrl, supabaseUrl: $supabaseUrl, supabasePublishableKey: $supabasePublishableKey, firebaseEmulatorHost: $firebaseEmulatorHost, localHostOverride: $localHostOverride)';
}


}

/// @nodoc
abstract mixin class _$AppConfigCopyWith<$Res> implements $AppConfigCopyWith<$Res> {
  factory _$AppConfigCopyWith(_AppConfig value, $Res Function(_AppConfig) _then) = __$AppConfigCopyWithImpl;
@override @useResult
$Res call({
 AppEnvironment environment, String apiBaseUrl, String supabaseUrl, String supabasePublishableKey, String firebaseEmulatorHost, String localHostOverride
});




}
/// @nodoc
class __$AppConfigCopyWithImpl<$Res>
    implements _$AppConfigCopyWith<$Res> {
  __$AppConfigCopyWithImpl(this._self, this._then);

  final _AppConfig _self;
  final $Res Function(_AppConfig) _then;

/// Create a copy of AppConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? environment = null,Object? apiBaseUrl = null,Object? supabaseUrl = null,Object? supabasePublishableKey = null,Object? firebaseEmulatorHost = null,Object? localHostOverride = null,}) {
  return _then(_AppConfig(
environment: null == environment ? _self.environment : environment // ignore: cast_nullable_to_non_nullable
as AppEnvironment,apiBaseUrl: null == apiBaseUrl ? _self.apiBaseUrl : apiBaseUrl // ignore: cast_nullable_to_non_nullable
as String,supabaseUrl: null == supabaseUrl ? _self.supabaseUrl : supabaseUrl // ignore: cast_nullable_to_non_nullable
as String,supabasePublishableKey: null == supabasePublishableKey ? _self.supabasePublishableKey : supabasePublishableKey // ignore: cast_nullable_to_non_nullable
as String,firebaseEmulatorHost: null == firebaseEmulatorHost ? _self.firebaseEmulatorHost : firebaseEmulatorHost // ignore: cast_nullable_to_non_nullable
as String,localHostOverride: null == localHostOverride ? _self.localHostOverride : localHostOverride // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
