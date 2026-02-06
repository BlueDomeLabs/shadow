// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'journal_entry_inputs.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CreateJournalEntryInput {
  String get profileId => throw _privateConstructorUsedError;
  String get clientId => throw _privateConstructorUsedError;
  int get timestamp => throw _privateConstructorUsedError; // Epoch milliseconds
  String get content => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  int? get mood => throw _privateConstructorUsedError; // 1-10 rating
  List<String> get tags => throw _privateConstructorUsedError;
  String? get audioUrl => throw _privateConstructorUsedError;

  /// Create a copy of CreateJournalEntryInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateJournalEntryInputCopyWith<CreateJournalEntryInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateJournalEntryInputCopyWith<$Res> {
  factory $CreateJournalEntryInputCopyWith(
    CreateJournalEntryInput value,
    $Res Function(CreateJournalEntryInput) then,
  ) = _$CreateJournalEntryInputCopyWithImpl<$Res, CreateJournalEntryInput>;
  @useResult
  $Res call({
    String profileId,
    String clientId,
    int timestamp,
    String content,
    String? title,
    int? mood,
    List<String> tags,
    String? audioUrl,
  });
}

/// @nodoc
class _$CreateJournalEntryInputCopyWithImpl<
  $Res,
  $Val extends CreateJournalEntryInput
>
    implements $CreateJournalEntryInputCopyWith<$Res> {
  _$CreateJournalEntryInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateJournalEntryInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? clientId = null,
    Object? timestamp = null,
    Object? content = null,
    Object? title = freezed,
    Object? mood = freezed,
    Object? tags = null,
    Object? audioUrl = freezed,
  }) {
    return _then(
      _value.copyWith(
            profileId: null == profileId
                ? _value.profileId
                : profileId // ignore: cast_nullable_to_non_nullable
                      as String,
            clientId: null == clientId
                ? _value.clientId
                : clientId // ignore: cast_nullable_to_non_nullable
                      as String,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as int,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            mood: freezed == mood
                ? _value.mood
                : mood // ignore: cast_nullable_to_non_nullable
                      as int?,
            tags: null == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            audioUrl: freezed == audioUrl
                ? _value.audioUrl
                : audioUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreateJournalEntryInputImplCopyWith<$Res>
    implements $CreateJournalEntryInputCopyWith<$Res> {
  factory _$$CreateJournalEntryInputImplCopyWith(
    _$CreateJournalEntryInputImpl value,
    $Res Function(_$CreateJournalEntryInputImpl) then,
  ) = __$$CreateJournalEntryInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String profileId,
    String clientId,
    int timestamp,
    String content,
    String? title,
    int? mood,
    List<String> tags,
    String? audioUrl,
  });
}

/// @nodoc
class __$$CreateJournalEntryInputImplCopyWithImpl<$Res>
    extends
        _$CreateJournalEntryInputCopyWithImpl<
          $Res,
          _$CreateJournalEntryInputImpl
        >
    implements _$$CreateJournalEntryInputImplCopyWith<$Res> {
  __$$CreateJournalEntryInputImplCopyWithImpl(
    _$CreateJournalEntryInputImpl _value,
    $Res Function(_$CreateJournalEntryInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateJournalEntryInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? clientId = null,
    Object? timestamp = null,
    Object? content = null,
    Object? title = freezed,
    Object? mood = freezed,
    Object? tags = null,
    Object? audioUrl = freezed,
  }) {
    return _then(
      _$CreateJournalEntryInputImpl(
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
        clientId: null == clientId
            ? _value.clientId
            : clientId // ignore: cast_nullable_to_non_nullable
                  as String,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as int,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        mood: freezed == mood
            ? _value.mood
            : mood // ignore: cast_nullable_to_non_nullable
                  as int?,
        tags: null == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        audioUrl: freezed == audioUrl
            ? _value.audioUrl
            : audioUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$CreateJournalEntryInputImpl implements _CreateJournalEntryInput {
  const _$CreateJournalEntryInputImpl({
    required this.profileId,
    required this.clientId,
    required this.timestamp,
    required this.content,
    this.title,
    this.mood,
    final List<String> tags = const [],
    this.audioUrl,
  }) : _tags = tags;

  @override
  final String profileId;
  @override
  final String clientId;
  @override
  final int timestamp;
  // Epoch milliseconds
  @override
  final String content;
  @override
  final String? title;
  @override
  final int? mood;
  // 1-10 rating
  final List<String> _tags;
  // 1-10 rating
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  final String? audioUrl;

  @override
  String toString() {
    return 'CreateJournalEntryInput(profileId: $profileId, clientId: $clientId, timestamp: $timestamp, content: $content, title: $title, mood: $mood, tags: $tags, audioUrl: $audioUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateJournalEntryInputImpl &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.mood, mood) || other.mood == mood) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.audioUrl, audioUrl) ||
                other.audioUrl == audioUrl));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    profileId,
    clientId,
    timestamp,
    content,
    title,
    mood,
    const DeepCollectionEquality().hash(_tags),
    audioUrl,
  );

  /// Create a copy of CreateJournalEntryInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateJournalEntryInputImplCopyWith<_$CreateJournalEntryInputImpl>
  get copyWith =>
      __$$CreateJournalEntryInputImplCopyWithImpl<
        _$CreateJournalEntryInputImpl
      >(this, _$identity);
}

abstract class _CreateJournalEntryInput implements CreateJournalEntryInput {
  const factory _CreateJournalEntryInput({
    required final String profileId,
    required final String clientId,
    required final int timestamp,
    required final String content,
    final String? title,
    final int? mood,
    final List<String> tags,
    final String? audioUrl,
  }) = _$CreateJournalEntryInputImpl;

  @override
  String get profileId;
  @override
  String get clientId;
  @override
  int get timestamp; // Epoch milliseconds
  @override
  String get content;
  @override
  String? get title;
  @override
  int? get mood; // 1-10 rating
  @override
  List<String> get tags;
  @override
  String? get audioUrl;

  /// Create a copy of CreateJournalEntryInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateJournalEntryInputImplCopyWith<_$CreateJournalEntryInputImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$GetJournalEntriesInput {
  String get profileId => throw _privateConstructorUsedError;
  int? get startDate =>
      throw _privateConstructorUsedError; // Epoch milliseconds
  int? get endDate => throw _privateConstructorUsedError; // Epoch milliseconds
  List<String>? get tags => throw _privateConstructorUsedError;
  int? get mood => throw _privateConstructorUsedError;
  int? get limit => throw _privateConstructorUsedError;
  int? get offset => throw _privateConstructorUsedError;

  /// Create a copy of GetJournalEntriesInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetJournalEntriesInputCopyWith<GetJournalEntriesInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetJournalEntriesInputCopyWith<$Res> {
  factory $GetJournalEntriesInputCopyWith(
    GetJournalEntriesInput value,
    $Res Function(GetJournalEntriesInput) then,
  ) = _$GetJournalEntriesInputCopyWithImpl<$Res, GetJournalEntriesInput>;
  @useResult
  $Res call({
    String profileId,
    int? startDate,
    int? endDate,
    List<String>? tags,
    int? mood,
    int? limit,
    int? offset,
  });
}

/// @nodoc
class _$GetJournalEntriesInputCopyWithImpl<
  $Res,
  $Val extends GetJournalEntriesInput
>
    implements $GetJournalEntriesInputCopyWith<$Res> {
  _$GetJournalEntriesInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetJournalEntriesInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? tags = freezed,
    Object? mood = freezed,
    Object? limit = freezed,
    Object? offset = freezed,
  }) {
    return _then(
      _value.copyWith(
            profileId: null == profileId
                ? _value.profileId
                : profileId // ignore: cast_nullable_to_non_nullable
                      as String,
            startDate: freezed == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as int?,
            endDate: freezed == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as int?,
            tags: freezed == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            mood: freezed == mood
                ? _value.mood
                : mood // ignore: cast_nullable_to_non_nullable
                      as int?,
            limit: freezed == limit
                ? _value.limit
                : limit // ignore: cast_nullable_to_non_nullable
                      as int?,
            offset: freezed == offset
                ? _value.offset
                : offset // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GetJournalEntriesInputImplCopyWith<$Res>
    implements $GetJournalEntriesInputCopyWith<$Res> {
  factory _$$GetJournalEntriesInputImplCopyWith(
    _$GetJournalEntriesInputImpl value,
    $Res Function(_$GetJournalEntriesInputImpl) then,
  ) = __$$GetJournalEntriesInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String profileId,
    int? startDate,
    int? endDate,
    List<String>? tags,
    int? mood,
    int? limit,
    int? offset,
  });
}

/// @nodoc
class __$$GetJournalEntriesInputImplCopyWithImpl<$Res>
    extends
        _$GetJournalEntriesInputCopyWithImpl<$Res, _$GetJournalEntriesInputImpl>
    implements _$$GetJournalEntriesInputImplCopyWith<$Res> {
  __$$GetJournalEntriesInputImplCopyWithImpl(
    _$GetJournalEntriesInputImpl _value,
    $Res Function(_$GetJournalEntriesInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GetJournalEntriesInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? tags = freezed,
    Object? mood = freezed,
    Object? limit = freezed,
    Object? offset = freezed,
  }) {
    return _then(
      _$GetJournalEntriesInputImpl(
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
        startDate: freezed == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as int?,
        endDate: freezed == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as int?,
        tags: freezed == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        mood: freezed == mood
            ? _value.mood
            : mood // ignore: cast_nullable_to_non_nullable
                  as int?,
        limit: freezed == limit
            ? _value.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int?,
        offset: freezed == offset
            ? _value.offset
            : offset // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc

class _$GetJournalEntriesInputImpl implements _GetJournalEntriesInput {
  const _$GetJournalEntriesInputImpl({
    required this.profileId,
    this.startDate,
    this.endDate,
    final List<String>? tags,
    this.mood,
    this.limit,
    this.offset,
  }) : _tags = tags;

  @override
  final String profileId;
  @override
  final int? startDate;
  // Epoch milliseconds
  @override
  final int? endDate;
  // Epoch milliseconds
  final List<String>? _tags;
  // Epoch milliseconds
  @override
  List<String>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final int? mood;
  @override
  final int? limit;
  @override
  final int? offset;

  @override
  String toString() {
    return 'GetJournalEntriesInput(profileId: $profileId, startDate: $startDate, endDate: $endDate, tags: $tags, mood: $mood, limit: $limit, offset: $offset)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetJournalEntriesInputImpl &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.mood, mood) || other.mood == mood) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.offset, offset) || other.offset == offset));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    profileId,
    startDate,
    endDate,
    const DeepCollectionEquality().hash(_tags),
    mood,
    limit,
    offset,
  );

  /// Create a copy of GetJournalEntriesInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetJournalEntriesInputImplCopyWith<_$GetJournalEntriesInputImpl>
  get copyWith =>
      __$$GetJournalEntriesInputImplCopyWithImpl<_$GetJournalEntriesInputImpl>(
        this,
        _$identity,
      );
}

abstract class _GetJournalEntriesInput implements GetJournalEntriesInput {
  const factory _GetJournalEntriesInput({
    required final String profileId,
    final int? startDate,
    final int? endDate,
    final List<String>? tags,
    final int? mood,
    final int? limit,
    final int? offset,
  }) = _$GetJournalEntriesInputImpl;

  @override
  String get profileId;
  @override
  int? get startDate; // Epoch milliseconds
  @override
  int? get endDate; // Epoch milliseconds
  @override
  List<String>? get tags;
  @override
  int? get mood;
  @override
  int? get limit;
  @override
  int? get offset;

  /// Create a copy of GetJournalEntriesInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetJournalEntriesInputImplCopyWith<_$GetJournalEntriesInputImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SearchJournalEntriesInput {
  String get profileId => throw _privateConstructorUsedError;
  String get query => throw _privateConstructorUsedError;

  /// Create a copy of SearchJournalEntriesInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SearchJournalEntriesInputCopyWith<SearchJournalEntriesInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchJournalEntriesInputCopyWith<$Res> {
  factory $SearchJournalEntriesInputCopyWith(
    SearchJournalEntriesInput value,
    $Res Function(SearchJournalEntriesInput) then,
  ) = _$SearchJournalEntriesInputCopyWithImpl<$Res, SearchJournalEntriesInput>;
  @useResult
  $Res call({String profileId, String query});
}

/// @nodoc
class _$SearchJournalEntriesInputCopyWithImpl<
  $Res,
  $Val extends SearchJournalEntriesInput
>
    implements $SearchJournalEntriesInputCopyWith<$Res> {
  _$SearchJournalEntriesInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchJournalEntriesInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? profileId = null, Object? query = null}) {
    return _then(
      _value.copyWith(
            profileId: null == profileId
                ? _value.profileId
                : profileId // ignore: cast_nullable_to_non_nullable
                      as String,
            query: null == query
                ? _value.query
                : query // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SearchJournalEntriesInputImplCopyWith<$Res>
    implements $SearchJournalEntriesInputCopyWith<$Res> {
  factory _$$SearchJournalEntriesInputImplCopyWith(
    _$SearchJournalEntriesInputImpl value,
    $Res Function(_$SearchJournalEntriesInputImpl) then,
  ) = __$$SearchJournalEntriesInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String profileId, String query});
}

/// @nodoc
class __$$SearchJournalEntriesInputImplCopyWithImpl<$Res>
    extends
        _$SearchJournalEntriesInputCopyWithImpl<
          $Res,
          _$SearchJournalEntriesInputImpl
        >
    implements _$$SearchJournalEntriesInputImplCopyWith<$Res> {
  __$$SearchJournalEntriesInputImplCopyWithImpl(
    _$SearchJournalEntriesInputImpl _value,
    $Res Function(_$SearchJournalEntriesInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SearchJournalEntriesInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? profileId = null, Object? query = null}) {
    return _then(
      _$SearchJournalEntriesInputImpl(
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
        query: null == query
            ? _value.query
            : query // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$SearchJournalEntriesInputImpl implements _SearchJournalEntriesInput {
  const _$SearchJournalEntriesInputImpl({
    required this.profileId,
    required this.query,
  });

  @override
  final String profileId;
  @override
  final String query;

  @override
  String toString() {
    return 'SearchJournalEntriesInput(profileId: $profileId, query: $query)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchJournalEntriesInputImpl &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.query, query) || other.query == query));
  }

  @override
  int get hashCode => Object.hash(runtimeType, profileId, query);

  /// Create a copy of SearchJournalEntriesInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchJournalEntriesInputImplCopyWith<_$SearchJournalEntriesInputImpl>
  get copyWith =>
      __$$SearchJournalEntriesInputImplCopyWithImpl<
        _$SearchJournalEntriesInputImpl
      >(this, _$identity);
}

abstract class _SearchJournalEntriesInput implements SearchJournalEntriesInput {
  const factory _SearchJournalEntriesInput({
    required final String profileId,
    required final String query,
  }) = _$SearchJournalEntriesInputImpl;

  @override
  String get profileId;
  @override
  String get query;

  /// Create a copy of SearchJournalEntriesInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchJournalEntriesInputImplCopyWith<_$SearchJournalEntriesInputImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$UpdateJournalEntryInput {
  String get id => throw _privateConstructorUsedError;
  String get profileId => throw _privateConstructorUsedError;
  String? get content => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  int? get mood => throw _privateConstructorUsedError;
  List<String>? get tags => throw _privateConstructorUsedError;
  String? get audioUrl => throw _privateConstructorUsedError;

  /// Create a copy of UpdateJournalEntryInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateJournalEntryInputCopyWith<UpdateJournalEntryInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateJournalEntryInputCopyWith<$Res> {
  factory $UpdateJournalEntryInputCopyWith(
    UpdateJournalEntryInput value,
    $Res Function(UpdateJournalEntryInput) then,
  ) = _$UpdateJournalEntryInputCopyWithImpl<$Res, UpdateJournalEntryInput>;
  @useResult
  $Res call({
    String id,
    String profileId,
    String? content,
    String? title,
    int? mood,
    List<String>? tags,
    String? audioUrl,
  });
}

/// @nodoc
class _$UpdateJournalEntryInputCopyWithImpl<
  $Res,
  $Val extends UpdateJournalEntryInput
>
    implements $UpdateJournalEntryInputCopyWith<$Res> {
  _$UpdateJournalEntryInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateJournalEntryInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? profileId = null,
    Object? content = freezed,
    Object? title = freezed,
    Object? mood = freezed,
    Object? tags = freezed,
    Object? audioUrl = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            profileId: null == profileId
                ? _value.profileId
                : profileId // ignore: cast_nullable_to_non_nullable
                      as String,
            content: freezed == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String?,
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            mood: freezed == mood
                ? _value.mood
                : mood // ignore: cast_nullable_to_non_nullable
                      as int?,
            tags: freezed == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            audioUrl: freezed == audioUrl
                ? _value.audioUrl
                : audioUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UpdateJournalEntryInputImplCopyWith<$Res>
    implements $UpdateJournalEntryInputCopyWith<$Res> {
  factory _$$UpdateJournalEntryInputImplCopyWith(
    _$UpdateJournalEntryInputImpl value,
    $Res Function(_$UpdateJournalEntryInputImpl) then,
  ) = __$$UpdateJournalEntryInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String profileId,
    String? content,
    String? title,
    int? mood,
    List<String>? tags,
    String? audioUrl,
  });
}

/// @nodoc
class __$$UpdateJournalEntryInputImplCopyWithImpl<$Res>
    extends
        _$UpdateJournalEntryInputCopyWithImpl<
          $Res,
          _$UpdateJournalEntryInputImpl
        >
    implements _$$UpdateJournalEntryInputImplCopyWith<$Res> {
  __$$UpdateJournalEntryInputImplCopyWithImpl(
    _$UpdateJournalEntryInputImpl _value,
    $Res Function(_$UpdateJournalEntryInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateJournalEntryInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? profileId = null,
    Object? content = freezed,
    Object? title = freezed,
    Object? mood = freezed,
    Object? tags = freezed,
    Object? audioUrl = freezed,
  }) {
    return _then(
      _$UpdateJournalEntryInputImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
        content: freezed == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String?,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        mood: freezed == mood
            ? _value.mood
            : mood // ignore: cast_nullable_to_non_nullable
                  as int?,
        tags: freezed == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        audioUrl: freezed == audioUrl
            ? _value.audioUrl
            : audioUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$UpdateJournalEntryInputImpl implements _UpdateJournalEntryInput {
  const _$UpdateJournalEntryInputImpl({
    required this.id,
    required this.profileId,
    this.content,
    this.title,
    this.mood,
    final List<String>? tags,
    this.audioUrl,
  }) : _tags = tags;

  @override
  final String id;
  @override
  final String profileId;
  @override
  final String? content;
  @override
  final String? title;
  @override
  final int? mood;
  final List<String>? _tags;
  @override
  List<String>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? audioUrl;

  @override
  String toString() {
    return 'UpdateJournalEntryInput(id: $id, profileId: $profileId, content: $content, title: $title, mood: $mood, tags: $tags, audioUrl: $audioUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateJournalEntryInputImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.mood, mood) || other.mood == mood) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.audioUrl, audioUrl) ||
                other.audioUrl == audioUrl));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    profileId,
    content,
    title,
    mood,
    const DeepCollectionEquality().hash(_tags),
    audioUrl,
  );

  /// Create a copy of UpdateJournalEntryInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateJournalEntryInputImplCopyWith<_$UpdateJournalEntryInputImpl>
  get copyWith =>
      __$$UpdateJournalEntryInputImplCopyWithImpl<
        _$UpdateJournalEntryInputImpl
      >(this, _$identity);
}

abstract class _UpdateJournalEntryInput implements UpdateJournalEntryInput {
  const factory _UpdateJournalEntryInput({
    required final String id,
    required final String profileId,
    final String? content,
    final String? title,
    final int? mood,
    final List<String>? tags,
    final String? audioUrl,
  }) = _$UpdateJournalEntryInputImpl;

  @override
  String get id;
  @override
  String get profileId;
  @override
  String? get content;
  @override
  String? get title;
  @override
  int? get mood;
  @override
  List<String>? get tags;
  @override
  String? get audioUrl;

  /// Create a copy of UpdateJournalEntryInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateJournalEntryInputImplCopyWith<_$UpdateJournalEntryInputImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$DeleteJournalEntryInput {
  String get id => throw _privateConstructorUsedError;
  String get profileId => throw _privateConstructorUsedError;

  /// Create a copy of DeleteJournalEntryInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeleteJournalEntryInputCopyWith<DeleteJournalEntryInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeleteJournalEntryInputCopyWith<$Res> {
  factory $DeleteJournalEntryInputCopyWith(
    DeleteJournalEntryInput value,
    $Res Function(DeleteJournalEntryInput) then,
  ) = _$DeleteJournalEntryInputCopyWithImpl<$Res, DeleteJournalEntryInput>;
  @useResult
  $Res call({String id, String profileId});
}

/// @nodoc
class _$DeleteJournalEntryInputCopyWithImpl<
  $Res,
  $Val extends DeleteJournalEntryInput
>
    implements $DeleteJournalEntryInputCopyWith<$Res> {
  _$DeleteJournalEntryInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeleteJournalEntryInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? profileId = null}) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            profileId: null == profileId
                ? _value.profileId
                : profileId // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DeleteJournalEntryInputImplCopyWith<$Res>
    implements $DeleteJournalEntryInputCopyWith<$Res> {
  factory _$$DeleteJournalEntryInputImplCopyWith(
    _$DeleteJournalEntryInputImpl value,
    $Res Function(_$DeleteJournalEntryInputImpl) then,
  ) = __$$DeleteJournalEntryInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String profileId});
}

/// @nodoc
class __$$DeleteJournalEntryInputImplCopyWithImpl<$Res>
    extends
        _$DeleteJournalEntryInputCopyWithImpl<
          $Res,
          _$DeleteJournalEntryInputImpl
        >
    implements _$$DeleteJournalEntryInputImplCopyWith<$Res> {
  __$$DeleteJournalEntryInputImplCopyWithImpl(
    _$DeleteJournalEntryInputImpl _value,
    $Res Function(_$DeleteJournalEntryInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DeleteJournalEntryInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? profileId = null}) {
    return _then(
      _$DeleteJournalEntryInputImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$DeleteJournalEntryInputImpl implements _DeleteJournalEntryInput {
  const _$DeleteJournalEntryInputImpl({
    required this.id,
    required this.profileId,
  });

  @override
  final String id;
  @override
  final String profileId;

  @override
  String toString() {
    return 'DeleteJournalEntryInput(id: $id, profileId: $profileId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeleteJournalEntryInputImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, profileId);

  /// Create a copy of DeleteJournalEntryInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeleteJournalEntryInputImplCopyWith<_$DeleteJournalEntryInputImpl>
  get copyWith =>
      __$$DeleteJournalEntryInputImplCopyWithImpl<
        _$DeleteJournalEntryInputImpl
      >(this, _$identity);
}

abstract class _DeleteJournalEntryInput implements DeleteJournalEntryInput {
  const factory _DeleteJournalEntryInput({
    required final String id,
    required final String profileId,
  }) = _$DeleteJournalEntryInputImpl;

  @override
  String get id;
  @override
  String get profileId;

  /// Create a copy of DeleteJournalEntryInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeleteJournalEntryInputImplCopyWith<_$DeleteJournalEntryInputImpl>
  get copyWith => throw _privateConstructorUsedError;
}
