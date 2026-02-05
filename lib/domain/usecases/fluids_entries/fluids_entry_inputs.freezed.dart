// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fluids_entry_inputs.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$LogFluidsEntryInput {
  String get profileId => throw _privateConstructorUsedError;
  String get clientId => throw _privateConstructorUsedError;
  int get entryDate => throw _privateConstructorUsedError; // Epoch milliseconds
  // Water intake
  int? get waterIntakeMl => throw _privateConstructorUsedError;
  String? get waterIntakeNotes =>
      throw _privateConstructorUsedError; // Bowel tracking
  BowelCondition? get bowelCondition => throw _privateConstructorUsedError;
  MovementSize? get bowelSize => throw _privateConstructorUsedError;
  String? get bowelPhotoPath =>
      throw _privateConstructorUsedError; // Urine tracking
  UrineCondition? get urineCondition => throw _privateConstructorUsedError;
  MovementSize? get urineSize => throw _privateConstructorUsedError;
  String? get urinePhotoPath =>
      throw _privateConstructorUsedError; // Menstruation
  MenstruationFlow? get menstruationFlow =>
      throw _privateConstructorUsedError; // BBT
  double? get basalBodyTemperature => throw _privateConstructorUsedError;
  int? get bbtRecordedTime =>
      throw _privateConstructorUsedError; // Epoch milliseconds - REQUIRED when BBT provided
  // Custom "Other" fluid
  String? get otherFluidName => throw _privateConstructorUsedError;
  String? get otherFluidAmount => throw _privateConstructorUsedError;
  String? get otherFluidNotes =>
      throw _privateConstructorUsedError; // General notes
  String get notes => throw _privateConstructorUsedError;

  /// Create a copy of LogFluidsEntryInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LogFluidsEntryInputCopyWith<LogFluidsEntryInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LogFluidsEntryInputCopyWith<$Res> {
  factory $LogFluidsEntryInputCopyWith(
    LogFluidsEntryInput value,
    $Res Function(LogFluidsEntryInput) then,
  ) = _$LogFluidsEntryInputCopyWithImpl<$Res, LogFluidsEntryInput>;
  @useResult
  $Res call({
    String profileId,
    String clientId,
    int entryDate,
    int? waterIntakeMl,
    String? waterIntakeNotes,
    BowelCondition? bowelCondition,
    MovementSize? bowelSize,
    String? bowelPhotoPath,
    UrineCondition? urineCondition,
    MovementSize? urineSize,
    String? urinePhotoPath,
    MenstruationFlow? menstruationFlow,
    double? basalBodyTemperature,
    int? bbtRecordedTime,
    String? otherFluidName,
    String? otherFluidAmount,
    String? otherFluidNotes,
    String notes,
  });
}

/// @nodoc
class _$LogFluidsEntryInputCopyWithImpl<$Res, $Val extends LogFluidsEntryInput>
    implements $LogFluidsEntryInputCopyWith<$Res> {
  _$LogFluidsEntryInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LogFluidsEntryInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? clientId = null,
    Object? entryDate = null,
    Object? waterIntakeMl = freezed,
    Object? waterIntakeNotes = freezed,
    Object? bowelCondition = freezed,
    Object? bowelSize = freezed,
    Object? bowelPhotoPath = freezed,
    Object? urineCondition = freezed,
    Object? urineSize = freezed,
    Object? urinePhotoPath = freezed,
    Object? menstruationFlow = freezed,
    Object? basalBodyTemperature = freezed,
    Object? bbtRecordedTime = freezed,
    Object? otherFluidName = freezed,
    Object? otherFluidAmount = freezed,
    Object? otherFluidNotes = freezed,
    Object? notes = null,
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
            entryDate: null == entryDate
                ? _value.entryDate
                : entryDate // ignore: cast_nullable_to_non_nullable
                      as int,
            waterIntakeMl: freezed == waterIntakeMl
                ? _value.waterIntakeMl
                : waterIntakeMl // ignore: cast_nullable_to_non_nullable
                      as int?,
            waterIntakeNotes: freezed == waterIntakeNotes
                ? _value.waterIntakeNotes
                : waterIntakeNotes // ignore: cast_nullable_to_non_nullable
                      as String?,
            bowelCondition: freezed == bowelCondition
                ? _value.bowelCondition
                : bowelCondition // ignore: cast_nullable_to_non_nullable
                      as BowelCondition?,
            bowelSize: freezed == bowelSize
                ? _value.bowelSize
                : bowelSize // ignore: cast_nullable_to_non_nullable
                      as MovementSize?,
            bowelPhotoPath: freezed == bowelPhotoPath
                ? _value.bowelPhotoPath
                : bowelPhotoPath // ignore: cast_nullable_to_non_nullable
                      as String?,
            urineCondition: freezed == urineCondition
                ? _value.urineCondition
                : urineCondition // ignore: cast_nullable_to_non_nullable
                      as UrineCondition?,
            urineSize: freezed == urineSize
                ? _value.urineSize
                : urineSize // ignore: cast_nullable_to_non_nullable
                      as MovementSize?,
            urinePhotoPath: freezed == urinePhotoPath
                ? _value.urinePhotoPath
                : urinePhotoPath // ignore: cast_nullable_to_non_nullable
                      as String?,
            menstruationFlow: freezed == menstruationFlow
                ? _value.menstruationFlow
                : menstruationFlow // ignore: cast_nullable_to_non_nullable
                      as MenstruationFlow?,
            basalBodyTemperature: freezed == basalBodyTemperature
                ? _value.basalBodyTemperature
                : basalBodyTemperature // ignore: cast_nullable_to_non_nullable
                      as double?,
            bbtRecordedTime: freezed == bbtRecordedTime
                ? _value.bbtRecordedTime
                : bbtRecordedTime // ignore: cast_nullable_to_non_nullable
                      as int?,
            otherFluidName: freezed == otherFluidName
                ? _value.otherFluidName
                : otherFluidName // ignore: cast_nullable_to_non_nullable
                      as String?,
            otherFluidAmount: freezed == otherFluidAmount
                ? _value.otherFluidAmount
                : otherFluidAmount // ignore: cast_nullable_to_non_nullable
                      as String?,
            otherFluidNotes: freezed == otherFluidNotes
                ? _value.otherFluidNotes
                : otherFluidNotes // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: null == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LogFluidsEntryInputImplCopyWith<$Res>
    implements $LogFluidsEntryInputCopyWith<$Res> {
  factory _$$LogFluidsEntryInputImplCopyWith(
    _$LogFluidsEntryInputImpl value,
    $Res Function(_$LogFluidsEntryInputImpl) then,
  ) = __$$LogFluidsEntryInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String profileId,
    String clientId,
    int entryDate,
    int? waterIntakeMl,
    String? waterIntakeNotes,
    BowelCondition? bowelCondition,
    MovementSize? bowelSize,
    String? bowelPhotoPath,
    UrineCondition? urineCondition,
    MovementSize? urineSize,
    String? urinePhotoPath,
    MenstruationFlow? menstruationFlow,
    double? basalBodyTemperature,
    int? bbtRecordedTime,
    String? otherFluidName,
    String? otherFluidAmount,
    String? otherFluidNotes,
    String notes,
  });
}

/// @nodoc
class __$$LogFluidsEntryInputImplCopyWithImpl<$Res>
    extends _$LogFluidsEntryInputCopyWithImpl<$Res, _$LogFluidsEntryInputImpl>
    implements _$$LogFluidsEntryInputImplCopyWith<$Res> {
  __$$LogFluidsEntryInputImplCopyWithImpl(
    _$LogFluidsEntryInputImpl _value,
    $Res Function(_$LogFluidsEntryInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LogFluidsEntryInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? clientId = null,
    Object? entryDate = null,
    Object? waterIntakeMl = freezed,
    Object? waterIntakeNotes = freezed,
    Object? bowelCondition = freezed,
    Object? bowelSize = freezed,
    Object? bowelPhotoPath = freezed,
    Object? urineCondition = freezed,
    Object? urineSize = freezed,
    Object? urinePhotoPath = freezed,
    Object? menstruationFlow = freezed,
    Object? basalBodyTemperature = freezed,
    Object? bbtRecordedTime = freezed,
    Object? otherFluidName = freezed,
    Object? otherFluidAmount = freezed,
    Object? otherFluidNotes = freezed,
    Object? notes = null,
  }) {
    return _then(
      _$LogFluidsEntryInputImpl(
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
        clientId: null == clientId
            ? _value.clientId
            : clientId // ignore: cast_nullable_to_non_nullable
                  as String,
        entryDate: null == entryDate
            ? _value.entryDate
            : entryDate // ignore: cast_nullable_to_non_nullable
                  as int,
        waterIntakeMl: freezed == waterIntakeMl
            ? _value.waterIntakeMl
            : waterIntakeMl // ignore: cast_nullable_to_non_nullable
                  as int?,
        waterIntakeNotes: freezed == waterIntakeNotes
            ? _value.waterIntakeNotes
            : waterIntakeNotes // ignore: cast_nullable_to_non_nullable
                  as String?,
        bowelCondition: freezed == bowelCondition
            ? _value.bowelCondition
            : bowelCondition // ignore: cast_nullable_to_non_nullable
                  as BowelCondition?,
        bowelSize: freezed == bowelSize
            ? _value.bowelSize
            : bowelSize // ignore: cast_nullable_to_non_nullable
                  as MovementSize?,
        bowelPhotoPath: freezed == bowelPhotoPath
            ? _value.bowelPhotoPath
            : bowelPhotoPath // ignore: cast_nullable_to_non_nullable
                  as String?,
        urineCondition: freezed == urineCondition
            ? _value.urineCondition
            : urineCondition // ignore: cast_nullable_to_non_nullable
                  as UrineCondition?,
        urineSize: freezed == urineSize
            ? _value.urineSize
            : urineSize // ignore: cast_nullable_to_non_nullable
                  as MovementSize?,
        urinePhotoPath: freezed == urinePhotoPath
            ? _value.urinePhotoPath
            : urinePhotoPath // ignore: cast_nullable_to_non_nullable
                  as String?,
        menstruationFlow: freezed == menstruationFlow
            ? _value.menstruationFlow
            : menstruationFlow // ignore: cast_nullable_to_non_nullable
                  as MenstruationFlow?,
        basalBodyTemperature: freezed == basalBodyTemperature
            ? _value.basalBodyTemperature
            : basalBodyTemperature // ignore: cast_nullable_to_non_nullable
                  as double?,
        bbtRecordedTime: freezed == bbtRecordedTime
            ? _value.bbtRecordedTime
            : bbtRecordedTime // ignore: cast_nullable_to_non_nullable
                  as int?,
        otherFluidName: freezed == otherFluidName
            ? _value.otherFluidName
            : otherFluidName // ignore: cast_nullable_to_non_nullable
                  as String?,
        otherFluidAmount: freezed == otherFluidAmount
            ? _value.otherFluidAmount
            : otherFluidAmount // ignore: cast_nullable_to_non_nullable
                  as String?,
        otherFluidNotes: freezed == otherFluidNotes
            ? _value.otherFluidNotes
            : otherFluidNotes // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: null == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$LogFluidsEntryInputImpl implements _LogFluidsEntryInput {
  const _$LogFluidsEntryInputImpl({
    required this.profileId,
    required this.clientId,
    required this.entryDate,
    this.waterIntakeMl,
    this.waterIntakeNotes,
    this.bowelCondition,
    this.bowelSize,
    this.bowelPhotoPath,
    this.urineCondition,
    this.urineSize,
    this.urinePhotoPath,
    this.menstruationFlow,
    this.basalBodyTemperature,
    this.bbtRecordedTime,
    this.otherFluidName,
    this.otherFluidAmount,
    this.otherFluidNotes,
    this.notes = '',
  });

  @override
  final String profileId;
  @override
  final String clientId;
  @override
  final int entryDate;
  // Epoch milliseconds
  // Water intake
  @override
  final int? waterIntakeMl;
  @override
  final String? waterIntakeNotes;
  // Bowel tracking
  @override
  final BowelCondition? bowelCondition;
  @override
  final MovementSize? bowelSize;
  @override
  final String? bowelPhotoPath;
  // Urine tracking
  @override
  final UrineCondition? urineCondition;
  @override
  final MovementSize? urineSize;
  @override
  final String? urinePhotoPath;
  // Menstruation
  @override
  final MenstruationFlow? menstruationFlow;
  // BBT
  @override
  final double? basalBodyTemperature;
  @override
  final int? bbtRecordedTime;
  // Epoch milliseconds - REQUIRED when BBT provided
  // Custom "Other" fluid
  @override
  final String? otherFluidName;
  @override
  final String? otherFluidAmount;
  @override
  final String? otherFluidNotes;
  // General notes
  @override
  @JsonKey()
  final String notes;

  @override
  String toString() {
    return 'LogFluidsEntryInput(profileId: $profileId, clientId: $clientId, entryDate: $entryDate, waterIntakeMl: $waterIntakeMl, waterIntakeNotes: $waterIntakeNotes, bowelCondition: $bowelCondition, bowelSize: $bowelSize, bowelPhotoPath: $bowelPhotoPath, urineCondition: $urineCondition, urineSize: $urineSize, urinePhotoPath: $urinePhotoPath, menstruationFlow: $menstruationFlow, basalBodyTemperature: $basalBodyTemperature, bbtRecordedTime: $bbtRecordedTime, otherFluidName: $otherFluidName, otherFluidAmount: $otherFluidAmount, otherFluidNotes: $otherFluidNotes, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LogFluidsEntryInputImpl &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.entryDate, entryDate) ||
                other.entryDate == entryDate) &&
            (identical(other.waterIntakeMl, waterIntakeMl) ||
                other.waterIntakeMl == waterIntakeMl) &&
            (identical(other.waterIntakeNotes, waterIntakeNotes) ||
                other.waterIntakeNotes == waterIntakeNotes) &&
            (identical(other.bowelCondition, bowelCondition) ||
                other.bowelCondition == bowelCondition) &&
            (identical(other.bowelSize, bowelSize) ||
                other.bowelSize == bowelSize) &&
            (identical(other.bowelPhotoPath, bowelPhotoPath) ||
                other.bowelPhotoPath == bowelPhotoPath) &&
            (identical(other.urineCondition, urineCondition) ||
                other.urineCondition == urineCondition) &&
            (identical(other.urineSize, urineSize) ||
                other.urineSize == urineSize) &&
            (identical(other.urinePhotoPath, urinePhotoPath) ||
                other.urinePhotoPath == urinePhotoPath) &&
            (identical(other.menstruationFlow, menstruationFlow) ||
                other.menstruationFlow == menstruationFlow) &&
            (identical(other.basalBodyTemperature, basalBodyTemperature) ||
                other.basalBodyTemperature == basalBodyTemperature) &&
            (identical(other.bbtRecordedTime, bbtRecordedTime) ||
                other.bbtRecordedTime == bbtRecordedTime) &&
            (identical(other.otherFluidName, otherFluidName) ||
                other.otherFluidName == otherFluidName) &&
            (identical(other.otherFluidAmount, otherFluidAmount) ||
                other.otherFluidAmount == otherFluidAmount) &&
            (identical(other.otherFluidNotes, otherFluidNotes) ||
                other.otherFluidNotes == otherFluidNotes) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    profileId,
    clientId,
    entryDate,
    waterIntakeMl,
    waterIntakeNotes,
    bowelCondition,
    bowelSize,
    bowelPhotoPath,
    urineCondition,
    urineSize,
    urinePhotoPath,
    menstruationFlow,
    basalBodyTemperature,
    bbtRecordedTime,
    otherFluidName,
    otherFluidAmount,
    otherFluidNotes,
    notes,
  );

  /// Create a copy of LogFluidsEntryInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LogFluidsEntryInputImplCopyWith<_$LogFluidsEntryInputImpl> get copyWith =>
      __$$LogFluidsEntryInputImplCopyWithImpl<_$LogFluidsEntryInputImpl>(
        this,
        _$identity,
      );
}

abstract class _LogFluidsEntryInput implements LogFluidsEntryInput {
  const factory _LogFluidsEntryInput({
    required final String profileId,
    required final String clientId,
    required final int entryDate,
    final int? waterIntakeMl,
    final String? waterIntakeNotes,
    final BowelCondition? bowelCondition,
    final MovementSize? bowelSize,
    final String? bowelPhotoPath,
    final UrineCondition? urineCondition,
    final MovementSize? urineSize,
    final String? urinePhotoPath,
    final MenstruationFlow? menstruationFlow,
    final double? basalBodyTemperature,
    final int? bbtRecordedTime,
    final String? otherFluidName,
    final String? otherFluidAmount,
    final String? otherFluidNotes,
    final String notes,
  }) = _$LogFluidsEntryInputImpl;

  @override
  String get profileId;
  @override
  String get clientId;
  @override
  int get entryDate; // Epoch milliseconds
  // Water intake
  @override
  int? get waterIntakeMl;
  @override
  String? get waterIntakeNotes; // Bowel tracking
  @override
  BowelCondition? get bowelCondition;
  @override
  MovementSize? get bowelSize;
  @override
  String? get bowelPhotoPath; // Urine tracking
  @override
  UrineCondition? get urineCondition;
  @override
  MovementSize? get urineSize;
  @override
  String? get urinePhotoPath; // Menstruation
  @override
  MenstruationFlow? get menstruationFlow; // BBT
  @override
  double? get basalBodyTemperature;
  @override
  int? get bbtRecordedTime; // Epoch milliseconds - REQUIRED when BBT provided
  // Custom "Other" fluid
  @override
  String? get otherFluidName;
  @override
  String? get otherFluidAmount;
  @override
  String? get otherFluidNotes; // General notes
  @override
  String get notes;

  /// Create a copy of LogFluidsEntryInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LogFluidsEntryInputImplCopyWith<_$LogFluidsEntryInputImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$GetFluidsEntriesInput {
  String get profileId => throw _privateConstructorUsedError;
  int get startDate => throw _privateConstructorUsedError; // Epoch milliseconds
  int get endDate => throw _privateConstructorUsedError;

  /// Create a copy of GetFluidsEntriesInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetFluidsEntriesInputCopyWith<GetFluidsEntriesInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetFluidsEntriesInputCopyWith<$Res> {
  factory $GetFluidsEntriesInputCopyWith(
    GetFluidsEntriesInput value,
    $Res Function(GetFluidsEntriesInput) then,
  ) = _$GetFluidsEntriesInputCopyWithImpl<$Res, GetFluidsEntriesInput>;
  @useResult
  $Res call({String profileId, int startDate, int endDate});
}

/// @nodoc
class _$GetFluidsEntriesInputCopyWithImpl<
  $Res,
  $Val extends GetFluidsEntriesInput
>
    implements $GetFluidsEntriesInputCopyWith<$Res> {
  _$GetFluidsEntriesInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetFluidsEntriesInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? startDate = null,
    Object? endDate = null,
  }) {
    return _then(
      _value.copyWith(
            profileId: null == profileId
                ? _value.profileId
                : profileId // ignore: cast_nullable_to_non_nullable
                      as String,
            startDate: null == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as int,
            endDate: null == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GetFluidsEntriesInputImplCopyWith<$Res>
    implements $GetFluidsEntriesInputCopyWith<$Res> {
  factory _$$GetFluidsEntriesInputImplCopyWith(
    _$GetFluidsEntriesInputImpl value,
    $Res Function(_$GetFluidsEntriesInputImpl) then,
  ) = __$$GetFluidsEntriesInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String profileId, int startDate, int endDate});
}

/// @nodoc
class __$$GetFluidsEntriesInputImplCopyWithImpl<$Res>
    extends
        _$GetFluidsEntriesInputCopyWithImpl<$Res, _$GetFluidsEntriesInputImpl>
    implements _$$GetFluidsEntriesInputImplCopyWith<$Res> {
  __$$GetFluidsEntriesInputImplCopyWithImpl(
    _$GetFluidsEntriesInputImpl _value,
    $Res Function(_$GetFluidsEntriesInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GetFluidsEntriesInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? startDate = null,
    Object? endDate = null,
  }) {
    return _then(
      _$GetFluidsEntriesInputImpl(
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
        startDate: null == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as int,
        endDate: null == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$GetFluidsEntriesInputImpl implements _GetFluidsEntriesInput {
  const _$GetFluidsEntriesInputImpl({
    required this.profileId,
    required this.startDate,
    required this.endDate,
  });

  @override
  final String profileId;
  @override
  final int startDate;
  // Epoch milliseconds
  @override
  final int endDate;

  @override
  String toString() {
    return 'GetFluidsEntriesInput(profileId: $profileId, startDate: $startDate, endDate: $endDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetFluidsEntriesInputImpl &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate));
  }

  @override
  int get hashCode => Object.hash(runtimeType, profileId, startDate, endDate);

  /// Create a copy of GetFluidsEntriesInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetFluidsEntriesInputImplCopyWith<_$GetFluidsEntriesInputImpl>
  get copyWith =>
      __$$GetFluidsEntriesInputImplCopyWithImpl<_$GetFluidsEntriesInputImpl>(
        this,
        _$identity,
      );
}

abstract class _GetFluidsEntriesInput implements GetFluidsEntriesInput {
  const factory _GetFluidsEntriesInput({
    required final String profileId,
    required final int startDate,
    required final int endDate,
  }) = _$GetFluidsEntriesInputImpl;

  @override
  String get profileId;
  @override
  int get startDate; // Epoch milliseconds
  @override
  int get endDate;

  /// Create a copy of GetFluidsEntriesInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetFluidsEntriesInputImplCopyWith<_$GetFluidsEntriesInputImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$GetTodayFluidsEntryInput {
  String get profileId => throw _privateConstructorUsedError;

  /// Create a copy of GetTodayFluidsEntryInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetTodayFluidsEntryInputCopyWith<GetTodayFluidsEntryInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetTodayFluidsEntryInputCopyWith<$Res> {
  factory $GetTodayFluidsEntryInputCopyWith(
    GetTodayFluidsEntryInput value,
    $Res Function(GetTodayFluidsEntryInput) then,
  ) = _$GetTodayFluidsEntryInputCopyWithImpl<$Res, GetTodayFluidsEntryInput>;
  @useResult
  $Res call({String profileId});
}

/// @nodoc
class _$GetTodayFluidsEntryInputCopyWithImpl<
  $Res,
  $Val extends GetTodayFluidsEntryInput
>
    implements $GetTodayFluidsEntryInputCopyWith<$Res> {
  _$GetTodayFluidsEntryInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetTodayFluidsEntryInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? profileId = null}) {
    return _then(
      _value.copyWith(
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
abstract class _$$GetTodayFluidsEntryInputImplCopyWith<$Res>
    implements $GetTodayFluidsEntryInputCopyWith<$Res> {
  factory _$$GetTodayFluidsEntryInputImplCopyWith(
    _$GetTodayFluidsEntryInputImpl value,
    $Res Function(_$GetTodayFluidsEntryInputImpl) then,
  ) = __$$GetTodayFluidsEntryInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String profileId});
}

/// @nodoc
class __$$GetTodayFluidsEntryInputImplCopyWithImpl<$Res>
    extends
        _$GetTodayFluidsEntryInputCopyWithImpl<
          $Res,
          _$GetTodayFluidsEntryInputImpl
        >
    implements _$$GetTodayFluidsEntryInputImplCopyWith<$Res> {
  __$$GetTodayFluidsEntryInputImplCopyWithImpl(
    _$GetTodayFluidsEntryInputImpl _value,
    $Res Function(_$GetTodayFluidsEntryInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GetTodayFluidsEntryInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? profileId = null}) {
    return _then(
      _$GetTodayFluidsEntryInputImpl(
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$GetTodayFluidsEntryInputImpl implements _GetTodayFluidsEntryInput {
  const _$GetTodayFluidsEntryInputImpl({required this.profileId});

  @override
  final String profileId;

  @override
  String toString() {
    return 'GetTodayFluidsEntryInput(profileId: $profileId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetTodayFluidsEntryInputImpl &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, profileId);

  /// Create a copy of GetTodayFluidsEntryInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetTodayFluidsEntryInputImplCopyWith<_$GetTodayFluidsEntryInputImpl>
  get copyWith =>
      __$$GetTodayFluidsEntryInputImplCopyWithImpl<
        _$GetTodayFluidsEntryInputImpl
      >(this, _$identity);
}

abstract class _GetTodayFluidsEntryInput implements GetTodayFluidsEntryInput {
  const factory _GetTodayFluidsEntryInput({required final String profileId}) =
      _$GetTodayFluidsEntryInputImpl;

  @override
  String get profileId;

  /// Create a copy of GetTodayFluidsEntryInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetTodayFluidsEntryInputImplCopyWith<_$GetTodayFluidsEntryInputImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$GetBBTEntriesInput {
  String get profileId => throw _privateConstructorUsedError;
  int get startDate => throw _privateConstructorUsedError; // Epoch milliseconds
  int get endDate => throw _privateConstructorUsedError;

  /// Create a copy of GetBBTEntriesInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetBBTEntriesInputCopyWith<GetBBTEntriesInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetBBTEntriesInputCopyWith<$Res> {
  factory $GetBBTEntriesInputCopyWith(
    GetBBTEntriesInput value,
    $Res Function(GetBBTEntriesInput) then,
  ) = _$GetBBTEntriesInputCopyWithImpl<$Res, GetBBTEntriesInput>;
  @useResult
  $Res call({String profileId, int startDate, int endDate});
}

/// @nodoc
class _$GetBBTEntriesInputCopyWithImpl<$Res, $Val extends GetBBTEntriesInput>
    implements $GetBBTEntriesInputCopyWith<$Res> {
  _$GetBBTEntriesInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetBBTEntriesInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? startDate = null,
    Object? endDate = null,
  }) {
    return _then(
      _value.copyWith(
            profileId: null == profileId
                ? _value.profileId
                : profileId // ignore: cast_nullable_to_non_nullable
                      as String,
            startDate: null == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as int,
            endDate: null == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GetBBTEntriesInputImplCopyWith<$Res>
    implements $GetBBTEntriesInputCopyWith<$Res> {
  factory _$$GetBBTEntriesInputImplCopyWith(
    _$GetBBTEntriesInputImpl value,
    $Res Function(_$GetBBTEntriesInputImpl) then,
  ) = __$$GetBBTEntriesInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String profileId, int startDate, int endDate});
}

/// @nodoc
class __$$GetBBTEntriesInputImplCopyWithImpl<$Res>
    extends _$GetBBTEntriesInputCopyWithImpl<$Res, _$GetBBTEntriesInputImpl>
    implements _$$GetBBTEntriesInputImplCopyWith<$Res> {
  __$$GetBBTEntriesInputImplCopyWithImpl(
    _$GetBBTEntriesInputImpl _value,
    $Res Function(_$GetBBTEntriesInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GetBBTEntriesInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? startDate = null,
    Object? endDate = null,
  }) {
    return _then(
      _$GetBBTEntriesInputImpl(
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
        startDate: null == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as int,
        endDate: null == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$GetBBTEntriesInputImpl implements _GetBBTEntriesInput {
  const _$GetBBTEntriesInputImpl({
    required this.profileId,
    required this.startDate,
    required this.endDate,
  });

  @override
  final String profileId;
  @override
  final int startDate;
  // Epoch milliseconds
  @override
  final int endDate;

  @override
  String toString() {
    return 'GetBBTEntriesInput(profileId: $profileId, startDate: $startDate, endDate: $endDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetBBTEntriesInputImpl &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate));
  }

  @override
  int get hashCode => Object.hash(runtimeType, profileId, startDate, endDate);

  /// Create a copy of GetBBTEntriesInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetBBTEntriesInputImplCopyWith<_$GetBBTEntriesInputImpl> get copyWith =>
      __$$GetBBTEntriesInputImplCopyWithImpl<_$GetBBTEntriesInputImpl>(
        this,
        _$identity,
      );
}

abstract class _GetBBTEntriesInput implements GetBBTEntriesInput {
  const factory _GetBBTEntriesInput({
    required final String profileId,
    required final int startDate,
    required final int endDate,
  }) = _$GetBBTEntriesInputImpl;

  @override
  String get profileId;
  @override
  int get startDate; // Epoch milliseconds
  @override
  int get endDate;

  /// Create a copy of GetBBTEntriesInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetBBTEntriesInputImplCopyWith<_$GetBBTEntriesInputImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$GetMenstruationEntriesInput {
  String get profileId => throw _privateConstructorUsedError;
  int get startDate => throw _privateConstructorUsedError; // Epoch milliseconds
  int get endDate => throw _privateConstructorUsedError;

  /// Create a copy of GetMenstruationEntriesInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetMenstruationEntriesInputCopyWith<GetMenstruationEntriesInput>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetMenstruationEntriesInputCopyWith<$Res> {
  factory $GetMenstruationEntriesInputCopyWith(
    GetMenstruationEntriesInput value,
    $Res Function(GetMenstruationEntriesInput) then,
  ) =
      _$GetMenstruationEntriesInputCopyWithImpl<
        $Res,
        GetMenstruationEntriesInput
      >;
  @useResult
  $Res call({String profileId, int startDate, int endDate});
}

/// @nodoc
class _$GetMenstruationEntriesInputCopyWithImpl<
  $Res,
  $Val extends GetMenstruationEntriesInput
>
    implements $GetMenstruationEntriesInputCopyWith<$Res> {
  _$GetMenstruationEntriesInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetMenstruationEntriesInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? startDate = null,
    Object? endDate = null,
  }) {
    return _then(
      _value.copyWith(
            profileId: null == profileId
                ? _value.profileId
                : profileId // ignore: cast_nullable_to_non_nullable
                      as String,
            startDate: null == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as int,
            endDate: null == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GetMenstruationEntriesInputImplCopyWith<$Res>
    implements $GetMenstruationEntriesInputCopyWith<$Res> {
  factory _$$GetMenstruationEntriesInputImplCopyWith(
    _$GetMenstruationEntriesInputImpl value,
    $Res Function(_$GetMenstruationEntriesInputImpl) then,
  ) = __$$GetMenstruationEntriesInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String profileId, int startDate, int endDate});
}

/// @nodoc
class __$$GetMenstruationEntriesInputImplCopyWithImpl<$Res>
    extends
        _$GetMenstruationEntriesInputCopyWithImpl<
          $Res,
          _$GetMenstruationEntriesInputImpl
        >
    implements _$$GetMenstruationEntriesInputImplCopyWith<$Res> {
  __$$GetMenstruationEntriesInputImplCopyWithImpl(
    _$GetMenstruationEntriesInputImpl _value,
    $Res Function(_$GetMenstruationEntriesInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GetMenstruationEntriesInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? startDate = null,
    Object? endDate = null,
  }) {
    return _then(
      _$GetMenstruationEntriesInputImpl(
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
        startDate: null == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as int,
        endDate: null == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$GetMenstruationEntriesInputImpl
    implements _GetMenstruationEntriesInput {
  const _$GetMenstruationEntriesInputImpl({
    required this.profileId,
    required this.startDate,
    required this.endDate,
  });

  @override
  final String profileId;
  @override
  final int startDate;
  // Epoch milliseconds
  @override
  final int endDate;

  @override
  String toString() {
    return 'GetMenstruationEntriesInput(profileId: $profileId, startDate: $startDate, endDate: $endDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetMenstruationEntriesInputImpl &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate));
  }

  @override
  int get hashCode => Object.hash(runtimeType, profileId, startDate, endDate);

  /// Create a copy of GetMenstruationEntriesInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetMenstruationEntriesInputImplCopyWith<_$GetMenstruationEntriesInputImpl>
  get copyWith =>
      __$$GetMenstruationEntriesInputImplCopyWithImpl<
        _$GetMenstruationEntriesInputImpl
      >(this, _$identity);
}

abstract class _GetMenstruationEntriesInput
    implements GetMenstruationEntriesInput {
  const factory _GetMenstruationEntriesInput({
    required final String profileId,
    required final int startDate,
    required final int endDate,
  }) = _$GetMenstruationEntriesInputImpl;

  @override
  String get profileId;
  @override
  int get startDate; // Epoch milliseconds
  @override
  int get endDate;

  /// Create a copy of GetMenstruationEntriesInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetMenstruationEntriesInputImplCopyWith<_$GetMenstruationEntriesInputImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$UpdateFluidsEntryInput {
  String get id => throw _privateConstructorUsedError;
  String get profileId => throw _privateConstructorUsedError; // Water intake
  int? get waterIntakeMl => throw _privateConstructorUsedError;
  String? get waterIntakeNotes =>
      throw _privateConstructorUsedError; // Bowel tracking
  BowelCondition? get bowelCondition => throw _privateConstructorUsedError;
  MovementSize? get bowelSize => throw _privateConstructorUsedError;
  String? get bowelPhotoPath =>
      throw _privateConstructorUsedError; // Urine tracking
  UrineCondition? get urineCondition => throw _privateConstructorUsedError;
  MovementSize? get urineSize => throw _privateConstructorUsedError;
  String? get urinePhotoPath =>
      throw _privateConstructorUsedError; // Menstruation
  MenstruationFlow? get menstruationFlow =>
      throw _privateConstructorUsedError; // BBT
  double? get basalBodyTemperature => throw _privateConstructorUsedError;
  int? get bbtRecordedTime =>
      throw _privateConstructorUsedError; // Custom "Other" fluid
  String? get otherFluidName => throw _privateConstructorUsedError;
  String? get otherFluidAmount => throw _privateConstructorUsedError;
  String? get otherFluidNotes =>
      throw _privateConstructorUsedError; // General notes
  String? get notes => throw _privateConstructorUsedError;

  /// Create a copy of UpdateFluidsEntryInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateFluidsEntryInputCopyWith<UpdateFluidsEntryInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateFluidsEntryInputCopyWith<$Res> {
  factory $UpdateFluidsEntryInputCopyWith(
    UpdateFluidsEntryInput value,
    $Res Function(UpdateFluidsEntryInput) then,
  ) = _$UpdateFluidsEntryInputCopyWithImpl<$Res, UpdateFluidsEntryInput>;
  @useResult
  $Res call({
    String id,
    String profileId,
    int? waterIntakeMl,
    String? waterIntakeNotes,
    BowelCondition? bowelCondition,
    MovementSize? bowelSize,
    String? bowelPhotoPath,
    UrineCondition? urineCondition,
    MovementSize? urineSize,
    String? urinePhotoPath,
    MenstruationFlow? menstruationFlow,
    double? basalBodyTemperature,
    int? bbtRecordedTime,
    String? otherFluidName,
    String? otherFluidAmount,
    String? otherFluidNotes,
    String? notes,
  });
}

/// @nodoc
class _$UpdateFluidsEntryInputCopyWithImpl<
  $Res,
  $Val extends UpdateFluidsEntryInput
>
    implements $UpdateFluidsEntryInputCopyWith<$Res> {
  _$UpdateFluidsEntryInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateFluidsEntryInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? profileId = null,
    Object? waterIntakeMl = freezed,
    Object? waterIntakeNotes = freezed,
    Object? bowelCondition = freezed,
    Object? bowelSize = freezed,
    Object? bowelPhotoPath = freezed,
    Object? urineCondition = freezed,
    Object? urineSize = freezed,
    Object? urinePhotoPath = freezed,
    Object? menstruationFlow = freezed,
    Object? basalBodyTemperature = freezed,
    Object? bbtRecordedTime = freezed,
    Object? otherFluidName = freezed,
    Object? otherFluidAmount = freezed,
    Object? otherFluidNotes = freezed,
    Object? notes = freezed,
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
            waterIntakeMl: freezed == waterIntakeMl
                ? _value.waterIntakeMl
                : waterIntakeMl // ignore: cast_nullable_to_non_nullable
                      as int?,
            waterIntakeNotes: freezed == waterIntakeNotes
                ? _value.waterIntakeNotes
                : waterIntakeNotes // ignore: cast_nullable_to_non_nullable
                      as String?,
            bowelCondition: freezed == bowelCondition
                ? _value.bowelCondition
                : bowelCondition // ignore: cast_nullable_to_non_nullable
                      as BowelCondition?,
            bowelSize: freezed == bowelSize
                ? _value.bowelSize
                : bowelSize // ignore: cast_nullable_to_non_nullable
                      as MovementSize?,
            bowelPhotoPath: freezed == bowelPhotoPath
                ? _value.bowelPhotoPath
                : bowelPhotoPath // ignore: cast_nullable_to_non_nullable
                      as String?,
            urineCondition: freezed == urineCondition
                ? _value.urineCondition
                : urineCondition // ignore: cast_nullable_to_non_nullable
                      as UrineCondition?,
            urineSize: freezed == urineSize
                ? _value.urineSize
                : urineSize // ignore: cast_nullable_to_non_nullable
                      as MovementSize?,
            urinePhotoPath: freezed == urinePhotoPath
                ? _value.urinePhotoPath
                : urinePhotoPath // ignore: cast_nullable_to_non_nullable
                      as String?,
            menstruationFlow: freezed == menstruationFlow
                ? _value.menstruationFlow
                : menstruationFlow // ignore: cast_nullable_to_non_nullable
                      as MenstruationFlow?,
            basalBodyTemperature: freezed == basalBodyTemperature
                ? _value.basalBodyTemperature
                : basalBodyTemperature // ignore: cast_nullable_to_non_nullable
                      as double?,
            bbtRecordedTime: freezed == bbtRecordedTime
                ? _value.bbtRecordedTime
                : bbtRecordedTime // ignore: cast_nullable_to_non_nullable
                      as int?,
            otherFluidName: freezed == otherFluidName
                ? _value.otherFluidName
                : otherFluidName // ignore: cast_nullable_to_non_nullable
                      as String?,
            otherFluidAmount: freezed == otherFluidAmount
                ? _value.otherFluidAmount
                : otherFluidAmount // ignore: cast_nullable_to_non_nullable
                      as String?,
            otherFluidNotes: freezed == otherFluidNotes
                ? _value.otherFluidNotes
                : otherFluidNotes // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UpdateFluidsEntryInputImplCopyWith<$Res>
    implements $UpdateFluidsEntryInputCopyWith<$Res> {
  factory _$$UpdateFluidsEntryInputImplCopyWith(
    _$UpdateFluidsEntryInputImpl value,
    $Res Function(_$UpdateFluidsEntryInputImpl) then,
  ) = __$$UpdateFluidsEntryInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String profileId,
    int? waterIntakeMl,
    String? waterIntakeNotes,
    BowelCondition? bowelCondition,
    MovementSize? bowelSize,
    String? bowelPhotoPath,
    UrineCondition? urineCondition,
    MovementSize? urineSize,
    String? urinePhotoPath,
    MenstruationFlow? menstruationFlow,
    double? basalBodyTemperature,
    int? bbtRecordedTime,
    String? otherFluidName,
    String? otherFluidAmount,
    String? otherFluidNotes,
    String? notes,
  });
}

/// @nodoc
class __$$UpdateFluidsEntryInputImplCopyWithImpl<$Res>
    extends
        _$UpdateFluidsEntryInputCopyWithImpl<$Res, _$UpdateFluidsEntryInputImpl>
    implements _$$UpdateFluidsEntryInputImplCopyWith<$Res> {
  __$$UpdateFluidsEntryInputImplCopyWithImpl(
    _$UpdateFluidsEntryInputImpl _value,
    $Res Function(_$UpdateFluidsEntryInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateFluidsEntryInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? profileId = null,
    Object? waterIntakeMl = freezed,
    Object? waterIntakeNotes = freezed,
    Object? bowelCondition = freezed,
    Object? bowelSize = freezed,
    Object? bowelPhotoPath = freezed,
    Object? urineCondition = freezed,
    Object? urineSize = freezed,
    Object? urinePhotoPath = freezed,
    Object? menstruationFlow = freezed,
    Object? basalBodyTemperature = freezed,
    Object? bbtRecordedTime = freezed,
    Object? otherFluidName = freezed,
    Object? otherFluidAmount = freezed,
    Object? otherFluidNotes = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _$UpdateFluidsEntryInputImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
        waterIntakeMl: freezed == waterIntakeMl
            ? _value.waterIntakeMl
            : waterIntakeMl // ignore: cast_nullable_to_non_nullable
                  as int?,
        waterIntakeNotes: freezed == waterIntakeNotes
            ? _value.waterIntakeNotes
            : waterIntakeNotes // ignore: cast_nullable_to_non_nullable
                  as String?,
        bowelCondition: freezed == bowelCondition
            ? _value.bowelCondition
            : bowelCondition // ignore: cast_nullable_to_non_nullable
                  as BowelCondition?,
        bowelSize: freezed == bowelSize
            ? _value.bowelSize
            : bowelSize // ignore: cast_nullable_to_non_nullable
                  as MovementSize?,
        bowelPhotoPath: freezed == bowelPhotoPath
            ? _value.bowelPhotoPath
            : bowelPhotoPath // ignore: cast_nullable_to_non_nullable
                  as String?,
        urineCondition: freezed == urineCondition
            ? _value.urineCondition
            : urineCondition // ignore: cast_nullable_to_non_nullable
                  as UrineCondition?,
        urineSize: freezed == urineSize
            ? _value.urineSize
            : urineSize // ignore: cast_nullable_to_non_nullable
                  as MovementSize?,
        urinePhotoPath: freezed == urinePhotoPath
            ? _value.urinePhotoPath
            : urinePhotoPath // ignore: cast_nullable_to_non_nullable
                  as String?,
        menstruationFlow: freezed == menstruationFlow
            ? _value.menstruationFlow
            : menstruationFlow // ignore: cast_nullable_to_non_nullable
                  as MenstruationFlow?,
        basalBodyTemperature: freezed == basalBodyTemperature
            ? _value.basalBodyTemperature
            : basalBodyTemperature // ignore: cast_nullable_to_non_nullable
                  as double?,
        bbtRecordedTime: freezed == bbtRecordedTime
            ? _value.bbtRecordedTime
            : bbtRecordedTime // ignore: cast_nullable_to_non_nullable
                  as int?,
        otherFluidName: freezed == otherFluidName
            ? _value.otherFluidName
            : otherFluidName // ignore: cast_nullable_to_non_nullable
                  as String?,
        otherFluidAmount: freezed == otherFluidAmount
            ? _value.otherFluidAmount
            : otherFluidAmount // ignore: cast_nullable_to_non_nullable
                  as String?,
        otherFluidNotes: freezed == otherFluidNotes
            ? _value.otherFluidNotes
            : otherFluidNotes // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$UpdateFluidsEntryInputImpl implements _UpdateFluidsEntryInput {
  const _$UpdateFluidsEntryInputImpl({
    required this.id,
    required this.profileId,
    this.waterIntakeMl,
    this.waterIntakeNotes,
    this.bowelCondition,
    this.bowelSize,
    this.bowelPhotoPath,
    this.urineCondition,
    this.urineSize,
    this.urinePhotoPath,
    this.menstruationFlow,
    this.basalBodyTemperature,
    this.bbtRecordedTime,
    this.otherFluidName,
    this.otherFluidAmount,
    this.otherFluidNotes,
    this.notes,
  });

  @override
  final String id;
  @override
  final String profileId;
  // Water intake
  @override
  final int? waterIntakeMl;
  @override
  final String? waterIntakeNotes;
  // Bowel tracking
  @override
  final BowelCondition? bowelCondition;
  @override
  final MovementSize? bowelSize;
  @override
  final String? bowelPhotoPath;
  // Urine tracking
  @override
  final UrineCondition? urineCondition;
  @override
  final MovementSize? urineSize;
  @override
  final String? urinePhotoPath;
  // Menstruation
  @override
  final MenstruationFlow? menstruationFlow;
  // BBT
  @override
  final double? basalBodyTemperature;
  @override
  final int? bbtRecordedTime;
  // Custom "Other" fluid
  @override
  final String? otherFluidName;
  @override
  final String? otherFluidAmount;
  @override
  final String? otherFluidNotes;
  // General notes
  @override
  final String? notes;

  @override
  String toString() {
    return 'UpdateFluidsEntryInput(id: $id, profileId: $profileId, waterIntakeMl: $waterIntakeMl, waterIntakeNotes: $waterIntakeNotes, bowelCondition: $bowelCondition, bowelSize: $bowelSize, bowelPhotoPath: $bowelPhotoPath, urineCondition: $urineCondition, urineSize: $urineSize, urinePhotoPath: $urinePhotoPath, menstruationFlow: $menstruationFlow, basalBodyTemperature: $basalBodyTemperature, bbtRecordedTime: $bbtRecordedTime, otherFluidName: $otherFluidName, otherFluidAmount: $otherFluidAmount, otherFluidNotes: $otherFluidNotes, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateFluidsEntryInputImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.waterIntakeMl, waterIntakeMl) ||
                other.waterIntakeMl == waterIntakeMl) &&
            (identical(other.waterIntakeNotes, waterIntakeNotes) ||
                other.waterIntakeNotes == waterIntakeNotes) &&
            (identical(other.bowelCondition, bowelCondition) ||
                other.bowelCondition == bowelCondition) &&
            (identical(other.bowelSize, bowelSize) ||
                other.bowelSize == bowelSize) &&
            (identical(other.bowelPhotoPath, bowelPhotoPath) ||
                other.bowelPhotoPath == bowelPhotoPath) &&
            (identical(other.urineCondition, urineCondition) ||
                other.urineCondition == urineCondition) &&
            (identical(other.urineSize, urineSize) ||
                other.urineSize == urineSize) &&
            (identical(other.urinePhotoPath, urinePhotoPath) ||
                other.urinePhotoPath == urinePhotoPath) &&
            (identical(other.menstruationFlow, menstruationFlow) ||
                other.menstruationFlow == menstruationFlow) &&
            (identical(other.basalBodyTemperature, basalBodyTemperature) ||
                other.basalBodyTemperature == basalBodyTemperature) &&
            (identical(other.bbtRecordedTime, bbtRecordedTime) ||
                other.bbtRecordedTime == bbtRecordedTime) &&
            (identical(other.otherFluidName, otherFluidName) ||
                other.otherFluidName == otherFluidName) &&
            (identical(other.otherFluidAmount, otherFluidAmount) ||
                other.otherFluidAmount == otherFluidAmount) &&
            (identical(other.otherFluidNotes, otherFluidNotes) ||
                other.otherFluidNotes == otherFluidNotes) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    profileId,
    waterIntakeMl,
    waterIntakeNotes,
    bowelCondition,
    bowelSize,
    bowelPhotoPath,
    urineCondition,
    urineSize,
    urinePhotoPath,
    menstruationFlow,
    basalBodyTemperature,
    bbtRecordedTime,
    otherFluidName,
    otherFluidAmount,
    otherFluidNotes,
    notes,
  );

  /// Create a copy of UpdateFluidsEntryInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateFluidsEntryInputImplCopyWith<_$UpdateFluidsEntryInputImpl>
  get copyWith =>
      __$$UpdateFluidsEntryInputImplCopyWithImpl<_$UpdateFluidsEntryInputImpl>(
        this,
        _$identity,
      );
}

abstract class _UpdateFluidsEntryInput implements UpdateFluidsEntryInput {
  const factory _UpdateFluidsEntryInput({
    required final String id,
    required final String profileId,
    final int? waterIntakeMl,
    final String? waterIntakeNotes,
    final BowelCondition? bowelCondition,
    final MovementSize? bowelSize,
    final String? bowelPhotoPath,
    final UrineCondition? urineCondition,
    final MovementSize? urineSize,
    final String? urinePhotoPath,
    final MenstruationFlow? menstruationFlow,
    final double? basalBodyTemperature,
    final int? bbtRecordedTime,
    final String? otherFluidName,
    final String? otherFluidAmount,
    final String? otherFluidNotes,
    final String? notes,
  }) = _$UpdateFluidsEntryInputImpl;

  @override
  String get id;
  @override
  String get profileId; // Water intake
  @override
  int? get waterIntakeMl;
  @override
  String? get waterIntakeNotes; // Bowel tracking
  @override
  BowelCondition? get bowelCondition;
  @override
  MovementSize? get bowelSize;
  @override
  String? get bowelPhotoPath; // Urine tracking
  @override
  UrineCondition? get urineCondition;
  @override
  MovementSize? get urineSize;
  @override
  String? get urinePhotoPath; // Menstruation
  @override
  MenstruationFlow? get menstruationFlow; // BBT
  @override
  double? get basalBodyTemperature;
  @override
  int? get bbtRecordedTime; // Custom "Other" fluid
  @override
  String? get otherFluidName;
  @override
  String? get otherFluidAmount;
  @override
  String? get otherFluidNotes; // General notes
  @override
  String? get notes;

  /// Create a copy of UpdateFluidsEntryInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateFluidsEntryInputImplCopyWith<_$UpdateFluidsEntryInputImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$DeleteFluidsEntryInput {
  String get id => throw _privateConstructorUsedError;
  String get profileId => throw _privateConstructorUsedError;

  /// Create a copy of DeleteFluidsEntryInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeleteFluidsEntryInputCopyWith<DeleteFluidsEntryInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeleteFluidsEntryInputCopyWith<$Res> {
  factory $DeleteFluidsEntryInputCopyWith(
    DeleteFluidsEntryInput value,
    $Res Function(DeleteFluidsEntryInput) then,
  ) = _$DeleteFluidsEntryInputCopyWithImpl<$Res, DeleteFluidsEntryInput>;
  @useResult
  $Res call({String id, String profileId});
}

/// @nodoc
class _$DeleteFluidsEntryInputCopyWithImpl<
  $Res,
  $Val extends DeleteFluidsEntryInput
>
    implements $DeleteFluidsEntryInputCopyWith<$Res> {
  _$DeleteFluidsEntryInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeleteFluidsEntryInput
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
abstract class _$$DeleteFluidsEntryInputImplCopyWith<$Res>
    implements $DeleteFluidsEntryInputCopyWith<$Res> {
  factory _$$DeleteFluidsEntryInputImplCopyWith(
    _$DeleteFluidsEntryInputImpl value,
    $Res Function(_$DeleteFluidsEntryInputImpl) then,
  ) = __$$DeleteFluidsEntryInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String profileId});
}

/// @nodoc
class __$$DeleteFluidsEntryInputImplCopyWithImpl<$Res>
    extends
        _$DeleteFluidsEntryInputCopyWithImpl<$Res, _$DeleteFluidsEntryInputImpl>
    implements _$$DeleteFluidsEntryInputImplCopyWith<$Res> {
  __$$DeleteFluidsEntryInputImplCopyWithImpl(
    _$DeleteFluidsEntryInputImpl _value,
    $Res Function(_$DeleteFluidsEntryInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DeleteFluidsEntryInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? profileId = null}) {
    return _then(
      _$DeleteFluidsEntryInputImpl(
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

class _$DeleteFluidsEntryInputImpl implements _DeleteFluidsEntryInput {
  const _$DeleteFluidsEntryInputImpl({
    required this.id,
    required this.profileId,
  });

  @override
  final String id;
  @override
  final String profileId;

  @override
  String toString() {
    return 'DeleteFluidsEntryInput(id: $id, profileId: $profileId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeleteFluidsEntryInputImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, profileId);

  /// Create a copy of DeleteFluidsEntryInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeleteFluidsEntryInputImplCopyWith<_$DeleteFluidsEntryInputImpl>
  get copyWith =>
      __$$DeleteFluidsEntryInputImplCopyWithImpl<_$DeleteFluidsEntryInputImpl>(
        this,
        _$identity,
      );
}

abstract class _DeleteFluidsEntryInput implements DeleteFluidsEntryInput {
  const factory _DeleteFluidsEntryInput({
    required final String id,
    required final String profileId,
  }) = _$DeleteFluidsEntryInputImpl;

  @override
  String get id;
  @override
  String get profileId;

  /// Create a copy of DeleteFluidsEntryInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeleteFluidsEntryInputImplCopyWith<_$DeleteFluidsEntryInputImpl>
  get copyWith => throw _privateConstructorUsedError;
}
