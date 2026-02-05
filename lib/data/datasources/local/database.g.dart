// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $SupplementsTable extends Supplements
    with TableInfo<$SupplementsTable, SupplementRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SupplementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
    'client_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _formMeta = const VerificationMeta('form');
  @override
  late final GeneratedColumn<int> form = GeneratedColumn<int>(
    'form',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dosageQuantityMeta = const VerificationMeta(
    'dosageQuantity',
  );
  @override
  late final GeneratedColumn<int> dosageQuantity = GeneratedColumn<int>(
    'dosage_quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dosageUnitMeta = const VerificationMeta(
    'dosageUnit',
  );
  @override
  late final GeneratedColumn<int> dosageUnit = GeneratedColumn<int>(
    'dosage_unit',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customFormMeta = const VerificationMeta(
    'customForm',
  );
  @override
  late final GeneratedColumn<String> customForm = GeneratedColumn<String>(
    'custom_form',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
    'brand',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _ingredientsMeta = const VerificationMeta(
    'ingredients',
  );
  @override
  late final GeneratedColumn<String> ingredients = GeneratedColumn<String>(
    'ingredients',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _schedulesMeta = const VerificationMeta(
    'schedules',
  );
  @override
  late final GeneratedColumn<String> schedules = GeneratedColumn<String>(
    'schedules',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<int> startDate = GeneratedColumn<int>(
    'start_date',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<int> endDate = GeneratedColumn<int>(
    'end_date',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncCreatedAtMeta = const VerificationMeta(
    'syncCreatedAt',
  );
  @override
  late final GeneratedColumn<int> syncCreatedAt = GeneratedColumn<int>(
    'sync_created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncUpdatedAtMeta = const VerificationMeta(
    'syncUpdatedAt',
  );
  @override
  late final GeneratedColumn<int> syncUpdatedAt = GeneratedColumn<int>(
    'sync_updated_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncDeletedAtMeta = const VerificationMeta(
    'syncDeletedAt',
  );
  @override
  late final GeneratedColumn<int> syncDeletedAt = GeneratedColumn<int>(
    'sync_deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncLastSyncedAtMeta = const VerificationMeta(
    'syncLastSyncedAt',
  );
  @override
  late final GeneratedColumn<int> syncLastSyncedAt = GeneratedColumn<int>(
    'sync_last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _syncVersionMeta = const VerificationMeta(
    'syncVersion',
  );
  @override
  late final GeneratedColumn<int> syncVersion = GeneratedColumn<int>(
    'sync_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _syncDeviceIdMeta = const VerificationMeta(
    'syncDeviceId',
  );
  @override
  late final GeneratedColumn<String> syncDeviceId = GeneratedColumn<String>(
    'sync_device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncIsDirtyMeta = const VerificationMeta(
    'syncIsDirty',
  );
  @override
  late final GeneratedColumn<bool> syncIsDirty = GeneratedColumn<bool>(
    'sync_is_dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sync_is_dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _conflictDataMeta = const VerificationMeta(
    'conflictData',
  );
  @override
  late final GeneratedColumn<String> conflictData = GeneratedColumn<String>(
    'conflict_data',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    clientId,
    profileId,
    name,
    form,
    dosageQuantity,
    dosageUnit,
    customForm,
    brand,
    notes,
    ingredients,
    schedules,
    startDate,
    endDate,
    isArchived,
    syncCreatedAt,
    syncUpdatedAt,
    syncDeletedAt,
    syncLastSyncedAt,
    syncStatus,
    syncVersion,
    syncDeviceId,
    syncIsDirty,
    conflictData,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'supplements';
  @override
  VerificationContext validateIntegrity(
    Insertable<SupplementRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('form')) {
      context.handle(
        _formMeta,
        form.isAcceptableOrUnknown(data['form']!, _formMeta),
      );
    } else if (isInserting) {
      context.missing(_formMeta);
    }
    if (data.containsKey('dosage_quantity')) {
      context.handle(
        _dosageQuantityMeta,
        dosageQuantity.isAcceptableOrUnknown(
          data['dosage_quantity']!,
          _dosageQuantityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dosageQuantityMeta);
    }
    if (data.containsKey('dosage_unit')) {
      context.handle(
        _dosageUnitMeta,
        dosageUnit.isAcceptableOrUnknown(data['dosage_unit']!, _dosageUnitMeta),
      );
    } else if (isInserting) {
      context.missing(_dosageUnitMeta);
    }
    if (data.containsKey('custom_form')) {
      context.handle(
        _customFormMeta,
        customForm.isAcceptableOrUnknown(data['custom_form']!, _customFormMeta),
      );
    }
    if (data.containsKey('brand')) {
      context.handle(
        _brandMeta,
        brand.isAcceptableOrUnknown(data['brand']!, _brandMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('ingredients')) {
      context.handle(
        _ingredientsMeta,
        ingredients.isAcceptableOrUnknown(
          data['ingredients']!,
          _ingredientsMeta,
        ),
      );
    }
    if (data.containsKey('schedules')) {
      context.handle(
        _schedulesMeta,
        schedules.isAcceptableOrUnknown(data['schedules']!, _schedulesMeta),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('sync_created_at')) {
      context.handle(
        _syncCreatedAtMeta,
        syncCreatedAt.isAcceptableOrUnknown(
          data['sync_created_at']!,
          _syncCreatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_syncCreatedAtMeta);
    }
    if (data.containsKey('sync_updated_at')) {
      context.handle(
        _syncUpdatedAtMeta,
        syncUpdatedAt.isAcceptableOrUnknown(
          data['sync_updated_at']!,
          _syncUpdatedAtMeta,
        ),
      );
    }
    if (data.containsKey('sync_deleted_at')) {
      context.handle(
        _syncDeletedAtMeta,
        syncDeletedAt.isAcceptableOrUnknown(
          data['sync_deleted_at']!,
          _syncDeletedAtMeta,
        ),
      );
    }
    if (data.containsKey('sync_last_synced_at')) {
      context.handle(
        _syncLastSyncedAtMeta,
        syncLastSyncedAt.isAcceptableOrUnknown(
          data['sync_last_synced_at']!,
          _syncLastSyncedAtMeta,
        ),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('sync_version')) {
      context.handle(
        _syncVersionMeta,
        syncVersion.isAcceptableOrUnknown(
          data['sync_version']!,
          _syncVersionMeta,
        ),
      );
    }
    if (data.containsKey('sync_device_id')) {
      context.handle(
        _syncDeviceIdMeta,
        syncDeviceId.isAcceptableOrUnknown(
          data['sync_device_id']!,
          _syncDeviceIdMeta,
        ),
      );
    }
    if (data.containsKey('sync_is_dirty')) {
      context.handle(
        _syncIsDirtyMeta,
        syncIsDirty.isAcceptableOrUnknown(
          data['sync_is_dirty']!,
          _syncIsDirtyMeta,
        ),
      );
    }
    if (data.containsKey('conflict_data')) {
      context.handle(
        _conflictDataMeta,
        conflictData.isAcceptableOrUnknown(
          data['conflict_data']!,
          _conflictDataMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SupplementRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SupplementRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      form: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}form'],
      )!,
      dosageQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dosage_quantity'],
      )!,
      dosageUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dosage_unit'],
      )!,
      customForm: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}custom_form'],
      ),
      brand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      ingredients: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ingredients'],
      )!,
      schedules: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}schedules'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_date'],
      ),
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_date'],
      ),
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      syncCreatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_created_at'],
      )!,
      syncUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_updated_at'],
      ),
      syncDeletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_deleted_at'],
      ),
      syncLastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_last_synced_at'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_status'],
      )!,
      syncVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_version'],
      )!,
      syncDeviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_device_id'],
      ),
      syncIsDirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sync_is_dirty'],
      )!,
      conflictData: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conflict_data'],
      ),
    );
  }

  @override
  $SupplementsTable createAlias(String alias) {
    return $SupplementsTable(attachedDatabase, alias);
  }
}

class SupplementRow extends DataClass implements Insertable<SupplementRow> {
  final String id;
  final String clientId;
  final String profileId;
  final String name;
  final int form;
  final int dosageQuantity;
  final int dosageUnit;
  final String? customForm;
  final String brand;
  final String notes;
  final String ingredients;
  final String schedules;
  final int? startDate;
  final int? endDate;
  final bool isArchived;
  final int syncCreatedAt;
  final int? syncUpdatedAt;
  final int? syncDeletedAt;
  final int? syncLastSyncedAt;
  final int syncStatus;
  final int syncVersion;
  final String? syncDeviceId;
  final bool syncIsDirty;
  final String? conflictData;
  const SupplementRow({
    required this.id,
    required this.clientId,
    required this.profileId,
    required this.name,
    required this.form,
    required this.dosageQuantity,
    required this.dosageUnit,
    this.customForm,
    required this.brand,
    required this.notes,
    required this.ingredients,
    required this.schedules,
    this.startDate,
    this.endDate,
    required this.isArchived,
    required this.syncCreatedAt,
    this.syncUpdatedAt,
    this.syncDeletedAt,
    this.syncLastSyncedAt,
    required this.syncStatus,
    required this.syncVersion,
    this.syncDeviceId,
    required this.syncIsDirty,
    this.conflictData,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['client_id'] = Variable<String>(clientId);
    map['profile_id'] = Variable<String>(profileId);
    map['name'] = Variable<String>(name);
    map['form'] = Variable<int>(form);
    map['dosage_quantity'] = Variable<int>(dosageQuantity);
    map['dosage_unit'] = Variable<int>(dosageUnit);
    if (!nullToAbsent || customForm != null) {
      map['custom_form'] = Variable<String>(customForm);
    }
    map['brand'] = Variable<String>(brand);
    map['notes'] = Variable<String>(notes);
    map['ingredients'] = Variable<String>(ingredients);
    map['schedules'] = Variable<String>(schedules);
    if (!nullToAbsent || startDate != null) {
      map['start_date'] = Variable<int>(startDate);
    }
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<int>(endDate);
    }
    map['is_archived'] = Variable<bool>(isArchived);
    map['sync_created_at'] = Variable<int>(syncCreatedAt);
    if (!nullToAbsent || syncUpdatedAt != null) {
      map['sync_updated_at'] = Variable<int>(syncUpdatedAt);
    }
    if (!nullToAbsent || syncDeletedAt != null) {
      map['sync_deleted_at'] = Variable<int>(syncDeletedAt);
    }
    if (!nullToAbsent || syncLastSyncedAt != null) {
      map['sync_last_synced_at'] = Variable<int>(syncLastSyncedAt);
    }
    map['sync_status'] = Variable<int>(syncStatus);
    map['sync_version'] = Variable<int>(syncVersion);
    if (!nullToAbsent || syncDeviceId != null) {
      map['sync_device_id'] = Variable<String>(syncDeviceId);
    }
    map['sync_is_dirty'] = Variable<bool>(syncIsDirty);
    if (!nullToAbsent || conflictData != null) {
      map['conflict_data'] = Variable<String>(conflictData);
    }
    return map;
  }

  SupplementsCompanion toCompanion(bool nullToAbsent) {
    return SupplementsCompanion(
      id: Value(id),
      clientId: Value(clientId),
      profileId: Value(profileId),
      name: Value(name),
      form: Value(form),
      dosageQuantity: Value(dosageQuantity),
      dosageUnit: Value(dosageUnit),
      customForm: customForm == null && nullToAbsent
          ? const Value.absent()
          : Value(customForm),
      brand: Value(brand),
      notes: Value(notes),
      ingredients: Value(ingredients),
      schedules: Value(schedules),
      startDate: startDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      isArchived: Value(isArchived),
      syncCreatedAt: Value(syncCreatedAt),
      syncUpdatedAt: syncUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncUpdatedAt),
      syncDeletedAt: syncDeletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncDeletedAt),
      syncLastSyncedAt: syncLastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncLastSyncedAt),
      syncStatus: Value(syncStatus),
      syncVersion: Value(syncVersion),
      syncDeviceId: syncDeviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(syncDeviceId),
      syncIsDirty: Value(syncIsDirty),
      conflictData: conflictData == null && nullToAbsent
          ? const Value.absent()
          : Value(conflictData),
    );
  }

  factory SupplementRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SupplementRow(
      id: serializer.fromJson<String>(json['id']),
      clientId: serializer.fromJson<String>(json['clientId']),
      profileId: serializer.fromJson<String>(json['profileId']),
      name: serializer.fromJson<String>(json['name']),
      form: serializer.fromJson<int>(json['form']),
      dosageQuantity: serializer.fromJson<int>(json['dosageQuantity']),
      dosageUnit: serializer.fromJson<int>(json['dosageUnit']),
      customForm: serializer.fromJson<String?>(json['customForm']),
      brand: serializer.fromJson<String>(json['brand']),
      notes: serializer.fromJson<String>(json['notes']),
      ingredients: serializer.fromJson<String>(json['ingredients']),
      schedules: serializer.fromJson<String>(json['schedules']),
      startDate: serializer.fromJson<int?>(json['startDate']),
      endDate: serializer.fromJson<int?>(json['endDate']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      syncCreatedAt: serializer.fromJson<int>(json['syncCreatedAt']),
      syncUpdatedAt: serializer.fromJson<int?>(json['syncUpdatedAt']),
      syncDeletedAt: serializer.fromJson<int?>(json['syncDeletedAt']),
      syncLastSyncedAt: serializer.fromJson<int?>(json['syncLastSyncedAt']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
      syncVersion: serializer.fromJson<int>(json['syncVersion']),
      syncDeviceId: serializer.fromJson<String?>(json['syncDeviceId']),
      syncIsDirty: serializer.fromJson<bool>(json['syncIsDirty']),
      conflictData: serializer.fromJson<String?>(json['conflictData']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'clientId': serializer.toJson<String>(clientId),
      'profileId': serializer.toJson<String>(profileId),
      'name': serializer.toJson<String>(name),
      'form': serializer.toJson<int>(form),
      'dosageQuantity': serializer.toJson<int>(dosageQuantity),
      'dosageUnit': serializer.toJson<int>(dosageUnit),
      'customForm': serializer.toJson<String?>(customForm),
      'brand': serializer.toJson<String>(brand),
      'notes': serializer.toJson<String>(notes),
      'ingredients': serializer.toJson<String>(ingredients),
      'schedules': serializer.toJson<String>(schedules),
      'startDate': serializer.toJson<int?>(startDate),
      'endDate': serializer.toJson<int?>(endDate),
      'isArchived': serializer.toJson<bool>(isArchived),
      'syncCreatedAt': serializer.toJson<int>(syncCreatedAt),
      'syncUpdatedAt': serializer.toJson<int?>(syncUpdatedAt),
      'syncDeletedAt': serializer.toJson<int?>(syncDeletedAt),
      'syncLastSyncedAt': serializer.toJson<int?>(syncLastSyncedAt),
      'syncStatus': serializer.toJson<int>(syncStatus),
      'syncVersion': serializer.toJson<int>(syncVersion),
      'syncDeviceId': serializer.toJson<String?>(syncDeviceId),
      'syncIsDirty': serializer.toJson<bool>(syncIsDirty),
      'conflictData': serializer.toJson<String?>(conflictData),
    };
  }

  SupplementRow copyWith({
    String? id,
    String? clientId,
    String? profileId,
    String? name,
    int? form,
    int? dosageQuantity,
    int? dosageUnit,
    Value<String?> customForm = const Value.absent(),
    String? brand,
    String? notes,
    String? ingredients,
    String? schedules,
    Value<int?> startDate = const Value.absent(),
    Value<int?> endDate = const Value.absent(),
    bool? isArchived,
    int? syncCreatedAt,
    Value<int?> syncUpdatedAt = const Value.absent(),
    Value<int?> syncDeletedAt = const Value.absent(),
    Value<int?> syncLastSyncedAt = const Value.absent(),
    int? syncStatus,
    int? syncVersion,
    Value<String?> syncDeviceId = const Value.absent(),
    bool? syncIsDirty,
    Value<String?> conflictData = const Value.absent(),
  }) => SupplementRow(
    id: id ?? this.id,
    clientId: clientId ?? this.clientId,
    profileId: profileId ?? this.profileId,
    name: name ?? this.name,
    form: form ?? this.form,
    dosageQuantity: dosageQuantity ?? this.dosageQuantity,
    dosageUnit: dosageUnit ?? this.dosageUnit,
    customForm: customForm.present ? customForm.value : this.customForm,
    brand: brand ?? this.brand,
    notes: notes ?? this.notes,
    ingredients: ingredients ?? this.ingredients,
    schedules: schedules ?? this.schedules,
    startDate: startDate.present ? startDate.value : this.startDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    isArchived: isArchived ?? this.isArchived,
    syncCreatedAt: syncCreatedAt ?? this.syncCreatedAt,
    syncUpdatedAt: syncUpdatedAt.present
        ? syncUpdatedAt.value
        : this.syncUpdatedAt,
    syncDeletedAt: syncDeletedAt.present
        ? syncDeletedAt.value
        : this.syncDeletedAt,
    syncLastSyncedAt: syncLastSyncedAt.present
        ? syncLastSyncedAt.value
        : this.syncLastSyncedAt,
    syncStatus: syncStatus ?? this.syncStatus,
    syncVersion: syncVersion ?? this.syncVersion,
    syncDeviceId: syncDeviceId.present ? syncDeviceId.value : this.syncDeviceId,
    syncIsDirty: syncIsDirty ?? this.syncIsDirty,
    conflictData: conflictData.present ? conflictData.value : this.conflictData,
  );
  SupplementRow copyWithCompanion(SupplementsCompanion data) {
    return SupplementRow(
      id: data.id.present ? data.id.value : this.id,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      name: data.name.present ? data.name.value : this.name,
      form: data.form.present ? data.form.value : this.form,
      dosageQuantity: data.dosageQuantity.present
          ? data.dosageQuantity.value
          : this.dosageQuantity,
      dosageUnit: data.dosageUnit.present
          ? data.dosageUnit.value
          : this.dosageUnit,
      customForm: data.customForm.present
          ? data.customForm.value
          : this.customForm,
      brand: data.brand.present ? data.brand.value : this.brand,
      notes: data.notes.present ? data.notes.value : this.notes,
      ingredients: data.ingredients.present
          ? data.ingredients.value
          : this.ingredients,
      schedules: data.schedules.present ? data.schedules.value : this.schedules,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      syncCreatedAt: data.syncCreatedAt.present
          ? data.syncCreatedAt.value
          : this.syncCreatedAt,
      syncUpdatedAt: data.syncUpdatedAt.present
          ? data.syncUpdatedAt.value
          : this.syncUpdatedAt,
      syncDeletedAt: data.syncDeletedAt.present
          ? data.syncDeletedAt.value
          : this.syncDeletedAt,
      syncLastSyncedAt: data.syncLastSyncedAt.present
          ? data.syncLastSyncedAt.value
          : this.syncLastSyncedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      syncVersion: data.syncVersion.present
          ? data.syncVersion.value
          : this.syncVersion,
      syncDeviceId: data.syncDeviceId.present
          ? data.syncDeviceId.value
          : this.syncDeviceId,
      syncIsDirty: data.syncIsDirty.present
          ? data.syncIsDirty.value
          : this.syncIsDirty,
      conflictData: data.conflictData.present
          ? data.conflictData.value
          : this.conflictData,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SupplementRow(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('profileId: $profileId, ')
          ..write('name: $name, ')
          ..write('form: $form, ')
          ..write('dosageQuantity: $dosageQuantity, ')
          ..write('dosageUnit: $dosageUnit, ')
          ..write('customForm: $customForm, ')
          ..write('brand: $brand, ')
          ..write('notes: $notes, ')
          ..write('ingredients: $ingredients, ')
          ..write('schedules: $schedules, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('isArchived: $isArchived, ')
          ..write('syncCreatedAt: $syncCreatedAt, ')
          ..write('syncUpdatedAt: $syncUpdatedAt, ')
          ..write('syncDeletedAt: $syncDeletedAt, ')
          ..write('syncLastSyncedAt: $syncLastSyncedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncVersion: $syncVersion, ')
          ..write('syncDeviceId: $syncDeviceId, ')
          ..write('syncIsDirty: $syncIsDirty, ')
          ..write('conflictData: $conflictData')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    clientId,
    profileId,
    name,
    form,
    dosageQuantity,
    dosageUnit,
    customForm,
    brand,
    notes,
    ingredients,
    schedules,
    startDate,
    endDate,
    isArchived,
    syncCreatedAt,
    syncUpdatedAt,
    syncDeletedAt,
    syncLastSyncedAt,
    syncStatus,
    syncVersion,
    syncDeviceId,
    syncIsDirty,
    conflictData,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SupplementRow &&
          other.id == this.id &&
          other.clientId == this.clientId &&
          other.profileId == this.profileId &&
          other.name == this.name &&
          other.form == this.form &&
          other.dosageQuantity == this.dosageQuantity &&
          other.dosageUnit == this.dosageUnit &&
          other.customForm == this.customForm &&
          other.brand == this.brand &&
          other.notes == this.notes &&
          other.ingredients == this.ingredients &&
          other.schedules == this.schedules &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.isArchived == this.isArchived &&
          other.syncCreatedAt == this.syncCreatedAt &&
          other.syncUpdatedAt == this.syncUpdatedAt &&
          other.syncDeletedAt == this.syncDeletedAt &&
          other.syncLastSyncedAt == this.syncLastSyncedAt &&
          other.syncStatus == this.syncStatus &&
          other.syncVersion == this.syncVersion &&
          other.syncDeviceId == this.syncDeviceId &&
          other.syncIsDirty == this.syncIsDirty &&
          other.conflictData == this.conflictData);
}

class SupplementsCompanion extends UpdateCompanion<SupplementRow> {
  final Value<String> id;
  final Value<String> clientId;
  final Value<String> profileId;
  final Value<String> name;
  final Value<int> form;
  final Value<int> dosageQuantity;
  final Value<int> dosageUnit;
  final Value<String?> customForm;
  final Value<String> brand;
  final Value<String> notes;
  final Value<String> ingredients;
  final Value<String> schedules;
  final Value<int?> startDate;
  final Value<int?> endDate;
  final Value<bool> isArchived;
  final Value<int> syncCreatedAt;
  final Value<int?> syncUpdatedAt;
  final Value<int?> syncDeletedAt;
  final Value<int?> syncLastSyncedAt;
  final Value<int> syncStatus;
  final Value<int> syncVersion;
  final Value<String?> syncDeviceId;
  final Value<bool> syncIsDirty;
  final Value<String?> conflictData;
  final Value<int> rowid;
  const SupplementsCompanion({
    this.id = const Value.absent(),
    this.clientId = const Value.absent(),
    this.profileId = const Value.absent(),
    this.name = const Value.absent(),
    this.form = const Value.absent(),
    this.dosageQuantity = const Value.absent(),
    this.dosageUnit = const Value.absent(),
    this.customForm = const Value.absent(),
    this.brand = const Value.absent(),
    this.notes = const Value.absent(),
    this.ingredients = const Value.absent(),
    this.schedules = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.syncCreatedAt = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
    this.syncDeletedAt = const Value.absent(),
    this.syncLastSyncedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncVersion = const Value.absent(),
    this.syncDeviceId = const Value.absent(),
    this.syncIsDirty = const Value.absent(),
    this.conflictData = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SupplementsCompanion.insert({
    required String id,
    required String clientId,
    required String profileId,
    required String name,
    required int form,
    required int dosageQuantity,
    required int dosageUnit,
    this.customForm = const Value.absent(),
    this.brand = const Value.absent(),
    this.notes = const Value.absent(),
    this.ingredients = const Value.absent(),
    this.schedules = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.isArchived = const Value.absent(),
    required int syncCreatedAt,
    this.syncUpdatedAt = const Value.absent(),
    this.syncDeletedAt = const Value.absent(),
    this.syncLastSyncedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncVersion = const Value.absent(),
    this.syncDeviceId = const Value.absent(),
    this.syncIsDirty = const Value.absent(),
    this.conflictData = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       clientId = Value(clientId),
       profileId = Value(profileId),
       name = Value(name),
       form = Value(form),
       dosageQuantity = Value(dosageQuantity),
       dosageUnit = Value(dosageUnit),
       syncCreatedAt = Value(syncCreatedAt);
  static Insertable<SupplementRow> custom({
    Expression<String>? id,
    Expression<String>? clientId,
    Expression<String>? profileId,
    Expression<String>? name,
    Expression<int>? form,
    Expression<int>? dosageQuantity,
    Expression<int>? dosageUnit,
    Expression<String>? customForm,
    Expression<String>? brand,
    Expression<String>? notes,
    Expression<String>? ingredients,
    Expression<String>? schedules,
    Expression<int>? startDate,
    Expression<int>? endDate,
    Expression<bool>? isArchived,
    Expression<int>? syncCreatedAt,
    Expression<int>? syncUpdatedAt,
    Expression<int>? syncDeletedAt,
    Expression<int>? syncLastSyncedAt,
    Expression<int>? syncStatus,
    Expression<int>? syncVersion,
    Expression<String>? syncDeviceId,
    Expression<bool>? syncIsDirty,
    Expression<String>? conflictData,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clientId != null) 'client_id': clientId,
      if (profileId != null) 'profile_id': profileId,
      if (name != null) 'name': name,
      if (form != null) 'form': form,
      if (dosageQuantity != null) 'dosage_quantity': dosageQuantity,
      if (dosageUnit != null) 'dosage_unit': dosageUnit,
      if (customForm != null) 'custom_form': customForm,
      if (brand != null) 'brand': brand,
      if (notes != null) 'notes': notes,
      if (ingredients != null) 'ingredients': ingredients,
      if (schedules != null) 'schedules': schedules,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (isArchived != null) 'is_archived': isArchived,
      if (syncCreatedAt != null) 'sync_created_at': syncCreatedAt,
      if (syncUpdatedAt != null) 'sync_updated_at': syncUpdatedAt,
      if (syncDeletedAt != null) 'sync_deleted_at': syncDeletedAt,
      if (syncLastSyncedAt != null) 'sync_last_synced_at': syncLastSyncedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncVersion != null) 'sync_version': syncVersion,
      if (syncDeviceId != null) 'sync_device_id': syncDeviceId,
      if (syncIsDirty != null) 'sync_is_dirty': syncIsDirty,
      if (conflictData != null) 'conflict_data': conflictData,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SupplementsCompanion copyWith({
    Value<String>? id,
    Value<String>? clientId,
    Value<String>? profileId,
    Value<String>? name,
    Value<int>? form,
    Value<int>? dosageQuantity,
    Value<int>? dosageUnit,
    Value<String?>? customForm,
    Value<String>? brand,
    Value<String>? notes,
    Value<String>? ingredients,
    Value<String>? schedules,
    Value<int?>? startDate,
    Value<int?>? endDate,
    Value<bool>? isArchived,
    Value<int>? syncCreatedAt,
    Value<int?>? syncUpdatedAt,
    Value<int?>? syncDeletedAt,
    Value<int?>? syncLastSyncedAt,
    Value<int>? syncStatus,
    Value<int>? syncVersion,
    Value<String?>? syncDeviceId,
    Value<bool>? syncIsDirty,
    Value<String?>? conflictData,
    Value<int>? rowid,
  }) {
    return SupplementsCompanion(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      profileId: profileId ?? this.profileId,
      name: name ?? this.name,
      form: form ?? this.form,
      dosageQuantity: dosageQuantity ?? this.dosageQuantity,
      dosageUnit: dosageUnit ?? this.dosageUnit,
      customForm: customForm ?? this.customForm,
      brand: brand ?? this.brand,
      notes: notes ?? this.notes,
      ingredients: ingredients ?? this.ingredients,
      schedules: schedules ?? this.schedules,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isArchived: isArchived ?? this.isArchived,
      syncCreatedAt: syncCreatedAt ?? this.syncCreatedAt,
      syncUpdatedAt: syncUpdatedAt ?? this.syncUpdatedAt,
      syncDeletedAt: syncDeletedAt ?? this.syncDeletedAt,
      syncLastSyncedAt: syncLastSyncedAt ?? this.syncLastSyncedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      syncVersion: syncVersion ?? this.syncVersion,
      syncDeviceId: syncDeviceId ?? this.syncDeviceId,
      syncIsDirty: syncIsDirty ?? this.syncIsDirty,
      conflictData: conflictData ?? this.conflictData,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (form.present) {
      map['form'] = Variable<int>(form.value);
    }
    if (dosageQuantity.present) {
      map['dosage_quantity'] = Variable<int>(dosageQuantity.value);
    }
    if (dosageUnit.present) {
      map['dosage_unit'] = Variable<int>(dosageUnit.value);
    }
    if (customForm.present) {
      map['custom_form'] = Variable<String>(customForm.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (ingredients.present) {
      map['ingredients'] = Variable<String>(ingredients.value);
    }
    if (schedules.present) {
      map['schedules'] = Variable<String>(schedules.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<int>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<int>(endDate.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (syncCreatedAt.present) {
      map['sync_created_at'] = Variable<int>(syncCreatedAt.value);
    }
    if (syncUpdatedAt.present) {
      map['sync_updated_at'] = Variable<int>(syncUpdatedAt.value);
    }
    if (syncDeletedAt.present) {
      map['sync_deleted_at'] = Variable<int>(syncDeletedAt.value);
    }
    if (syncLastSyncedAt.present) {
      map['sync_last_synced_at'] = Variable<int>(syncLastSyncedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (syncVersion.present) {
      map['sync_version'] = Variable<int>(syncVersion.value);
    }
    if (syncDeviceId.present) {
      map['sync_device_id'] = Variable<String>(syncDeviceId.value);
    }
    if (syncIsDirty.present) {
      map['sync_is_dirty'] = Variable<bool>(syncIsDirty.value);
    }
    if (conflictData.present) {
      map['conflict_data'] = Variable<String>(conflictData.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SupplementsCompanion(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('profileId: $profileId, ')
          ..write('name: $name, ')
          ..write('form: $form, ')
          ..write('dosageQuantity: $dosageQuantity, ')
          ..write('dosageUnit: $dosageUnit, ')
          ..write('customForm: $customForm, ')
          ..write('brand: $brand, ')
          ..write('notes: $notes, ')
          ..write('ingredients: $ingredients, ')
          ..write('schedules: $schedules, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('isArchived: $isArchived, ')
          ..write('syncCreatedAt: $syncCreatedAt, ')
          ..write('syncUpdatedAt: $syncUpdatedAt, ')
          ..write('syncDeletedAt: $syncDeletedAt, ')
          ..write('syncLastSyncedAt: $syncLastSyncedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncVersion: $syncVersion, ')
          ..write('syncDeviceId: $syncDeviceId, ')
          ..write('syncIsDirty: $syncIsDirty, ')
          ..write('conflictData: $conflictData, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $IntakeLogsTable extends IntakeLogs
    with TableInfo<$IntakeLogsTable, IntakeLogRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IntakeLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
    'client_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _supplementIdMeta = const VerificationMeta(
    'supplementId',
  );
  @override
  late final GeneratedColumn<String> supplementId = GeneratedColumn<String>(
    'supplement_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scheduledTimeMeta = const VerificationMeta(
    'scheduledTime',
  );
  @override
  late final GeneratedColumn<int> scheduledTime = GeneratedColumn<int>(
    'scheduled_time',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actualTimeMeta = const VerificationMeta(
    'actualTime',
  );
  @override
  late final GeneratedColumn<int> actualTime = GeneratedColumn<int>(
    'actual_time',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncCreatedAtMeta = const VerificationMeta(
    'syncCreatedAt',
  );
  @override
  late final GeneratedColumn<int> syncCreatedAt = GeneratedColumn<int>(
    'sync_created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncUpdatedAtMeta = const VerificationMeta(
    'syncUpdatedAt',
  );
  @override
  late final GeneratedColumn<int> syncUpdatedAt = GeneratedColumn<int>(
    'sync_updated_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncDeletedAtMeta = const VerificationMeta(
    'syncDeletedAt',
  );
  @override
  late final GeneratedColumn<int> syncDeletedAt = GeneratedColumn<int>(
    'sync_deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncLastSyncedAtMeta = const VerificationMeta(
    'syncLastSyncedAt',
  );
  @override
  late final GeneratedColumn<int> syncLastSyncedAt = GeneratedColumn<int>(
    'sync_last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _syncVersionMeta = const VerificationMeta(
    'syncVersion',
  );
  @override
  late final GeneratedColumn<int> syncVersion = GeneratedColumn<int>(
    'sync_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _syncDeviceIdMeta = const VerificationMeta(
    'syncDeviceId',
  );
  @override
  late final GeneratedColumn<String> syncDeviceId = GeneratedColumn<String>(
    'sync_device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncIsDirtyMeta = const VerificationMeta(
    'syncIsDirty',
  );
  @override
  late final GeneratedColumn<bool> syncIsDirty = GeneratedColumn<bool>(
    'sync_is_dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sync_is_dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _conflictDataMeta = const VerificationMeta(
    'conflictData',
  );
  @override
  late final GeneratedColumn<String> conflictData = GeneratedColumn<String>(
    'conflict_data',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    clientId,
    profileId,
    supplementId,
    scheduledTime,
    status,
    actualTime,
    reason,
    note,
    syncCreatedAt,
    syncUpdatedAt,
    syncDeletedAt,
    syncLastSyncedAt,
    syncStatus,
    syncVersion,
    syncDeviceId,
    syncIsDirty,
    conflictData,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'intake_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<IntakeLogRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('supplement_id')) {
      context.handle(
        _supplementIdMeta,
        supplementId.isAcceptableOrUnknown(
          data['supplement_id']!,
          _supplementIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_supplementIdMeta);
    }
    if (data.containsKey('scheduled_time')) {
      context.handle(
        _scheduledTimeMeta,
        scheduledTime.isAcceptableOrUnknown(
          data['scheduled_time']!,
          _scheduledTimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledTimeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('actual_time')) {
      context.handle(
        _actualTimeMeta,
        actualTime.isAcceptableOrUnknown(data['actual_time']!, _actualTimeMeta),
      );
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('sync_created_at')) {
      context.handle(
        _syncCreatedAtMeta,
        syncCreatedAt.isAcceptableOrUnknown(
          data['sync_created_at']!,
          _syncCreatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_syncCreatedAtMeta);
    }
    if (data.containsKey('sync_updated_at')) {
      context.handle(
        _syncUpdatedAtMeta,
        syncUpdatedAt.isAcceptableOrUnknown(
          data['sync_updated_at']!,
          _syncUpdatedAtMeta,
        ),
      );
    }
    if (data.containsKey('sync_deleted_at')) {
      context.handle(
        _syncDeletedAtMeta,
        syncDeletedAt.isAcceptableOrUnknown(
          data['sync_deleted_at']!,
          _syncDeletedAtMeta,
        ),
      );
    }
    if (data.containsKey('sync_last_synced_at')) {
      context.handle(
        _syncLastSyncedAtMeta,
        syncLastSyncedAt.isAcceptableOrUnknown(
          data['sync_last_synced_at']!,
          _syncLastSyncedAtMeta,
        ),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('sync_version')) {
      context.handle(
        _syncVersionMeta,
        syncVersion.isAcceptableOrUnknown(
          data['sync_version']!,
          _syncVersionMeta,
        ),
      );
    }
    if (data.containsKey('sync_device_id')) {
      context.handle(
        _syncDeviceIdMeta,
        syncDeviceId.isAcceptableOrUnknown(
          data['sync_device_id']!,
          _syncDeviceIdMeta,
        ),
      );
    }
    if (data.containsKey('sync_is_dirty')) {
      context.handle(
        _syncIsDirtyMeta,
        syncIsDirty.isAcceptableOrUnknown(
          data['sync_is_dirty']!,
          _syncIsDirtyMeta,
        ),
      );
    }
    if (data.containsKey('conflict_data')) {
      context.handle(
        _conflictDataMeta,
        conflictData.isAcceptableOrUnknown(
          data['conflict_data']!,
          _conflictDataMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IntakeLogRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IntakeLogRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      supplementId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supplement_id'],
      )!,
      scheduledTime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}scheduled_time'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}status'],
      )!,
      actualTime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}actual_time'],
      ),
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      syncCreatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_created_at'],
      )!,
      syncUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_updated_at'],
      ),
      syncDeletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_deleted_at'],
      ),
      syncLastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_last_synced_at'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_status'],
      )!,
      syncVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_version'],
      )!,
      syncDeviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_device_id'],
      ),
      syncIsDirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sync_is_dirty'],
      )!,
      conflictData: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conflict_data'],
      ),
    );
  }

  @override
  $IntakeLogsTable createAlias(String alias) {
    return $IntakeLogsTable(attachedDatabase, alias);
  }
}

class IntakeLogRow extends DataClass implements Insertable<IntakeLogRow> {
  final String id;
  final String clientId;
  final String profileId;
  final String supplementId;
  final int scheduledTime;
  final int status;
  final int? actualTime;
  final String? reason;
  final String? note;
  final int syncCreatedAt;
  final int? syncUpdatedAt;
  final int? syncDeletedAt;
  final int? syncLastSyncedAt;
  final int syncStatus;
  final int syncVersion;
  final String? syncDeviceId;
  final bool syncIsDirty;
  final String? conflictData;
  const IntakeLogRow({
    required this.id,
    required this.clientId,
    required this.profileId,
    required this.supplementId,
    required this.scheduledTime,
    required this.status,
    this.actualTime,
    this.reason,
    this.note,
    required this.syncCreatedAt,
    this.syncUpdatedAt,
    this.syncDeletedAt,
    this.syncLastSyncedAt,
    required this.syncStatus,
    required this.syncVersion,
    this.syncDeviceId,
    required this.syncIsDirty,
    this.conflictData,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['client_id'] = Variable<String>(clientId);
    map['profile_id'] = Variable<String>(profileId);
    map['supplement_id'] = Variable<String>(supplementId);
    map['scheduled_time'] = Variable<int>(scheduledTime);
    map['status'] = Variable<int>(status);
    if (!nullToAbsent || actualTime != null) {
      map['actual_time'] = Variable<int>(actualTime);
    }
    if (!nullToAbsent || reason != null) {
      map['reason'] = Variable<String>(reason);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['sync_created_at'] = Variable<int>(syncCreatedAt);
    if (!nullToAbsent || syncUpdatedAt != null) {
      map['sync_updated_at'] = Variable<int>(syncUpdatedAt);
    }
    if (!nullToAbsent || syncDeletedAt != null) {
      map['sync_deleted_at'] = Variable<int>(syncDeletedAt);
    }
    if (!nullToAbsent || syncLastSyncedAt != null) {
      map['sync_last_synced_at'] = Variable<int>(syncLastSyncedAt);
    }
    map['sync_status'] = Variable<int>(syncStatus);
    map['sync_version'] = Variable<int>(syncVersion);
    if (!nullToAbsent || syncDeviceId != null) {
      map['sync_device_id'] = Variable<String>(syncDeviceId);
    }
    map['sync_is_dirty'] = Variable<bool>(syncIsDirty);
    if (!nullToAbsent || conflictData != null) {
      map['conflict_data'] = Variable<String>(conflictData);
    }
    return map;
  }

  IntakeLogsCompanion toCompanion(bool nullToAbsent) {
    return IntakeLogsCompanion(
      id: Value(id),
      clientId: Value(clientId),
      profileId: Value(profileId),
      supplementId: Value(supplementId),
      scheduledTime: Value(scheduledTime),
      status: Value(status),
      actualTime: actualTime == null && nullToAbsent
          ? const Value.absent()
          : Value(actualTime),
      reason: reason == null && nullToAbsent
          ? const Value.absent()
          : Value(reason),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      syncCreatedAt: Value(syncCreatedAt),
      syncUpdatedAt: syncUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncUpdatedAt),
      syncDeletedAt: syncDeletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncDeletedAt),
      syncLastSyncedAt: syncLastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncLastSyncedAt),
      syncStatus: Value(syncStatus),
      syncVersion: Value(syncVersion),
      syncDeviceId: syncDeviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(syncDeviceId),
      syncIsDirty: Value(syncIsDirty),
      conflictData: conflictData == null && nullToAbsent
          ? const Value.absent()
          : Value(conflictData),
    );
  }

  factory IntakeLogRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IntakeLogRow(
      id: serializer.fromJson<String>(json['id']),
      clientId: serializer.fromJson<String>(json['clientId']),
      profileId: serializer.fromJson<String>(json['profileId']),
      supplementId: serializer.fromJson<String>(json['supplementId']),
      scheduledTime: serializer.fromJson<int>(json['scheduledTime']),
      status: serializer.fromJson<int>(json['status']),
      actualTime: serializer.fromJson<int?>(json['actualTime']),
      reason: serializer.fromJson<String?>(json['reason']),
      note: serializer.fromJson<String?>(json['note']),
      syncCreatedAt: serializer.fromJson<int>(json['syncCreatedAt']),
      syncUpdatedAt: serializer.fromJson<int?>(json['syncUpdatedAt']),
      syncDeletedAt: serializer.fromJson<int?>(json['syncDeletedAt']),
      syncLastSyncedAt: serializer.fromJson<int?>(json['syncLastSyncedAt']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
      syncVersion: serializer.fromJson<int>(json['syncVersion']),
      syncDeviceId: serializer.fromJson<String?>(json['syncDeviceId']),
      syncIsDirty: serializer.fromJson<bool>(json['syncIsDirty']),
      conflictData: serializer.fromJson<String?>(json['conflictData']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'clientId': serializer.toJson<String>(clientId),
      'profileId': serializer.toJson<String>(profileId),
      'supplementId': serializer.toJson<String>(supplementId),
      'scheduledTime': serializer.toJson<int>(scheduledTime),
      'status': serializer.toJson<int>(status),
      'actualTime': serializer.toJson<int?>(actualTime),
      'reason': serializer.toJson<String?>(reason),
      'note': serializer.toJson<String?>(note),
      'syncCreatedAt': serializer.toJson<int>(syncCreatedAt),
      'syncUpdatedAt': serializer.toJson<int?>(syncUpdatedAt),
      'syncDeletedAt': serializer.toJson<int?>(syncDeletedAt),
      'syncLastSyncedAt': serializer.toJson<int?>(syncLastSyncedAt),
      'syncStatus': serializer.toJson<int>(syncStatus),
      'syncVersion': serializer.toJson<int>(syncVersion),
      'syncDeviceId': serializer.toJson<String?>(syncDeviceId),
      'syncIsDirty': serializer.toJson<bool>(syncIsDirty),
      'conflictData': serializer.toJson<String?>(conflictData),
    };
  }

  IntakeLogRow copyWith({
    String? id,
    String? clientId,
    String? profileId,
    String? supplementId,
    int? scheduledTime,
    int? status,
    Value<int?> actualTime = const Value.absent(),
    Value<String?> reason = const Value.absent(),
    Value<String?> note = const Value.absent(),
    int? syncCreatedAt,
    Value<int?> syncUpdatedAt = const Value.absent(),
    Value<int?> syncDeletedAt = const Value.absent(),
    Value<int?> syncLastSyncedAt = const Value.absent(),
    int? syncStatus,
    int? syncVersion,
    Value<String?> syncDeviceId = const Value.absent(),
    bool? syncIsDirty,
    Value<String?> conflictData = const Value.absent(),
  }) => IntakeLogRow(
    id: id ?? this.id,
    clientId: clientId ?? this.clientId,
    profileId: profileId ?? this.profileId,
    supplementId: supplementId ?? this.supplementId,
    scheduledTime: scheduledTime ?? this.scheduledTime,
    status: status ?? this.status,
    actualTime: actualTime.present ? actualTime.value : this.actualTime,
    reason: reason.present ? reason.value : this.reason,
    note: note.present ? note.value : this.note,
    syncCreatedAt: syncCreatedAt ?? this.syncCreatedAt,
    syncUpdatedAt: syncUpdatedAt.present
        ? syncUpdatedAt.value
        : this.syncUpdatedAt,
    syncDeletedAt: syncDeletedAt.present
        ? syncDeletedAt.value
        : this.syncDeletedAt,
    syncLastSyncedAt: syncLastSyncedAt.present
        ? syncLastSyncedAt.value
        : this.syncLastSyncedAt,
    syncStatus: syncStatus ?? this.syncStatus,
    syncVersion: syncVersion ?? this.syncVersion,
    syncDeviceId: syncDeviceId.present ? syncDeviceId.value : this.syncDeviceId,
    syncIsDirty: syncIsDirty ?? this.syncIsDirty,
    conflictData: conflictData.present ? conflictData.value : this.conflictData,
  );
  IntakeLogRow copyWithCompanion(IntakeLogsCompanion data) {
    return IntakeLogRow(
      id: data.id.present ? data.id.value : this.id,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      supplementId: data.supplementId.present
          ? data.supplementId.value
          : this.supplementId,
      scheduledTime: data.scheduledTime.present
          ? data.scheduledTime.value
          : this.scheduledTime,
      status: data.status.present ? data.status.value : this.status,
      actualTime: data.actualTime.present
          ? data.actualTime.value
          : this.actualTime,
      reason: data.reason.present ? data.reason.value : this.reason,
      note: data.note.present ? data.note.value : this.note,
      syncCreatedAt: data.syncCreatedAt.present
          ? data.syncCreatedAt.value
          : this.syncCreatedAt,
      syncUpdatedAt: data.syncUpdatedAt.present
          ? data.syncUpdatedAt.value
          : this.syncUpdatedAt,
      syncDeletedAt: data.syncDeletedAt.present
          ? data.syncDeletedAt.value
          : this.syncDeletedAt,
      syncLastSyncedAt: data.syncLastSyncedAt.present
          ? data.syncLastSyncedAt.value
          : this.syncLastSyncedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      syncVersion: data.syncVersion.present
          ? data.syncVersion.value
          : this.syncVersion,
      syncDeviceId: data.syncDeviceId.present
          ? data.syncDeviceId.value
          : this.syncDeviceId,
      syncIsDirty: data.syncIsDirty.present
          ? data.syncIsDirty.value
          : this.syncIsDirty,
      conflictData: data.conflictData.present
          ? data.conflictData.value
          : this.conflictData,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IntakeLogRow(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('profileId: $profileId, ')
          ..write('supplementId: $supplementId, ')
          ..write('scheduledTime: $scheduledTime, ')
          ..write('status: $status, ')
          ..write('actualTime: $actualTime, ')
          ..write('reason: $reason, ')
          ..write('note: $note, ')
          ..write('syncCreatedAt: $syncCreatedAt, ')
          ..write('syncUpdatedAt: $syncUpdatedAt, ')
          ..write('syncDeletedAt: $syncDeletedAt, ')
          ..write('syncLastSyncedAt: $syncLastSyncedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncVersion: $syncVersion, ')
          ..write('syncDeviceId: $syncDeviceId, ')
          ..write('syncIsDirty: $syncIsDirty, ')
          ..write('conflictData: $conflictData')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    clientId,
    profileId,
    supplementId,
    scheduledTime,
    status,
    actualTime,
    reason,
    note,
    syncCreatedAt,
    syncUpdatedAt,
    syncDeletedAt,
    syncLastSyncedAt,
    syncStatus,
    syncVersion,
    syncDeviceId,
    syncIsDirty,
    conflictData,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IntakeLogRow &&
          other.id == this.id &&
          other.clientId == this.clientId &&
          other.profileId == this.profileId &&
          other.supplementId == this.supplementId &&
          other.scheduledTime == this.scheduledTime &&
          other.status == this.status &&
          other.actualTime == this.actualTime &&
          other.reason == this.reason &&
          other.note == this.note &&
          other.syncCreatedAt == this.syncCreatedAt &&
          other.syncUpdatedAt == this.syncUpdatedAt &&
          other.syncDeletedAt == this.syncDeletedAt &&
          other.syncLastSyncedAt == this.syncLastSyncedAt &&
          other.syncStatus == this.syncStatus &&
          other.syncVersion == this.syncVersion &&
          other.syncDeviceId == this.syncDeviceId &&
          other.syncIsDirty == this.syncIsDirty &&
          other.conflictData == this.conflictData);
}

class IntakeLogsCompanion extends UpdateCompanion<IntakeLogRow> {
  final Value<String> id;
  final Value<String> clientId;
  final Value<String> profileId;
  final Value<String> supplementId;
  final Value<int> scheduledTime;
  final Value<int> status;
  final Value<int?> actualTime;
  final Value<String?> reason;
  final Value<String?> note;
  final Value<int> syncCreatedAt;
  final Value<int?> syncUpdatedAt;
  final Value<int?> syncDeletedAt;
  final Value<int?> syncLastSyncedAt;
  final Value<int> syncStatus;
  final Value<int> syncVersion;
  final Value<String?> syncDeviceId;
  final Value<bool> syncIsDirty;
  final Value<String?> conflictData;
  final Value<int> rowid;
  const IntakeLogsCompanion({
    this.id = const Value.absent(),
    this.clientId = const Value.absent(),
    this.profileId = const Value.absent(),
    this.supplementId = const Value.absent(),
    this.scheduledTime = const Value.absent(),
    this.status = const Value.absent(),
    this.actualTime = const Value.absent(),
    this.reason = const Value.absent(),
    this.note = const Value.absent(),
    this.syncCreatedAt = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
    this.syncDeletedAt = const Value.absent(),
    this.syncLastSyncedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncVersion = const Value.absent(),
    this.syncDeviceId = const Value.absent(),
    this.syncIsDirty = const Value.absent(),
    this.conflictData = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IntakeLogsCompanion.insert({
    required String id,
    required String clientId,
    required String profileId,
    required String supplementId,
    required int scheduledTime,
    required int status,
    this.actualTime = const Value.absent(),
    this.reason = const Value.absent(),
    this.note = const Value.absent(),
    required int syncCreatedAt,
    this.syncUpdatedAt = const Value.absent(),
    this.syncDeletedAt = const Value.absent(),
    this.syncLastSyncedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncVersion = const Value.absent(),
    this.syncDeviceId = const Value.absent(),
    this.syncIsDirty = const Value.absent(),
    this.conflictData = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       clientId = Value(clientId),
       profileId = Value(profileId),
       supplementId = Value(supplementId),
       scheduledTime = Value(scheduledTime),
       status = Value(status),
       syncCreatedAt = Value(syncCreatedAt);
  static Insertable<IntakeLogRow> custom({
    Expression<String>? id,
    Expression<String>? clientId,
    Expression<String>? profileId,
    Expression<String>? supplementId,
    Expression<int>? scheduledTime,
    Expression<int>? status,
    Expression<int>? actualTime,
    Expression<String>? reason,
    Expression<String>? note,
    Expression<int>? syncCreatedAt,
    Expression<int>? syncUpdatedAt,
    Expression<int>? syncDeletedAt,
    Expression<int>? syncLastSyncedAt,
    Expression<int>? syncStatus,
    Expression<int>? syncVersion,
    Expression<String>? syncDeviceId,
    Expression<bool>? syncIsDirty,
    Expression<String>? conflictData,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clientId != null) 'client_id': clientId,
      if (profileId != null) 'profile_id': profileId,
      if (supplementId != null) 'supplement_id': supplementId,
      if (scheduledTime != null) 'scheduled_time': scheduledTime,
      if (status != null) 'status': status,
      if (actualTime != null) 'actual_time': actualTime,
      if (reason != null) 'reason': reason,
      if (note != null) 'note': note,
      if (syncCreatedAt != null) 'sync_created_at': syncCreatedAt,
      if (syncUpdatedAt != null) 'sync_updated_at': syncUpdatedAt,
      if (syncDeletedAt != null) 'sync_deleted_at': syncDeletedAt,
      if (syncLastSyncedAt != null) 'sync_last_synced_at': syncLastSyncedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncVersion != null) 'sync_version': syncVersion,
      if (syncDeviceId != null) 'sync_device_id': syncDeviceId,
      if (syncIsDirty != null) 'sync_is_dirty': syncIsDirty,
      if (conflictData != null) 'conflict_data': conflictData,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IntakeLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? clientId,
    Value<String>? profileId,
    Value<String>? supplementId,
    Value<int>? scheduledTime,
    Value<int>? status,
    Value<int?>? actualTime,
    Value<String?>? reason,
    Value<String?>? note,
    Value<int>? syncCreatedAt,
    Value<int?>? syncUpdatedAt,
    Value<int?>? syncDeletedAt,
    Value<int?>? syncLastSyncedAt,
    Value<int>? syncStatus,
    Value<int>? syncVersion,
    Value<String?>? syncDeviceId,
    Value<bool>? syncIsDirty,
    Value<String?>? conflictData,
    Value<int>? rowid,
  }) {
    return IntakeLogsCompanion(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      profileId: profileId ?? this.profileId,
      supplementId: supplementId ?? this.supplementId,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      status: status ?? this.status,
      actualTime: actualTime ?? this.actualTime,
      reason: reason ?? this.reason,
      note: note ?? this.note,
      syncCreatedAt: syncCreatedAt ?? this.syncCreatedAt,
      syncUpdatedAt: syncUpdatedAt ?? this.syncUpdatedAt,
      syncDeletedAt: syncDeletedAt ?? this.syncDeletedAt,
      syncLastSyncedAt: syncLastSyncedAt ?? this.syncLastSyncedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      syncVersion: syncVersion ?? this.syncVersion,
      syncDeviceId: syncDeviceId ?? this.syncDeviceId,
      syncIsDirty: syncIsDirty ?? this.syncIsDirty,
      conflictData: conflictData ?? this.conflictData,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (supplementId.present) {
      map['supplement_id'] = Variable<String>(supplementId.value);
    }
    if (scheduledTime.present) {
      map['scheduled_time'] = Variable<int>(scheduledTime.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (actualTime.present) {
      map['actual_time'] = Variable<int>(actualTime.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (syncCreatedAt.present) {
      map['sync_created_at'] = Variable<int>(syncCreatedAt.value);
    }
    if (syncUpdatedAt.present) {
      map['sync_updated_at'] = Variable<int>(syncUpdatedAt.value);
    }
    if (syncDeletedAt.present) {
      map['sync_deleted_at'] = Variable<int>(syncDeletedAt.value);
    }
    if (syncLastSyncedAt.present) {
      map['sync_last_synced_at'] = Variable<int>(syncLastSyncedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (syncVersion.present) {
      map['sync_version'] = Variable<int>(syncVersion.value);
    }
    if (syncDeviceId.present) {
      map['sync_device_id'] = Variable<String>(syncDeviceId.value);
    }
    if (syncIsDirty.present) {
      map['sync_is_dirty'] = Variable<bool>(syncIsDirty.value);
    }
    if (conflictData.present) {
      map['conflict_data'] = Variable<String>(conflictData.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IntakeLogsCompanion(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('profileId: $profileId, ')
          ..write('supplementId: $supplementId, ')
          ..write('scheduledTime: $scheduledTime, ')
          ..write('status: $status, ')
          ..write('actualTime: $actualTime, ')
          ..write('reason: $reason, ')
          ..write('note: $note, ')
          ..write('syncCreatedAt: $syncCreatedAt, ')
          ..write('syncUpdatedAt: $syncUpdatedAt, ')
          ..write('syncDeletedAt: $syncDeletedAt, ')
          ..write('syncLastSyncedAt: $syncLastSyncedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncVersion: $syncVersion, ')
          ..write('syncDeviceId: $syncDeviceId, ')
          ..write('syncIsDirty: $syncIsDirty, ')
          ..write('conflictData: $conflictData, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ConditionsTable extends Conditions
    with TableInfo<$ConditionsTable, ConditionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConditionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
    'client_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyLocationsMeta = const VerificationMeta(
    'bodyLocations',
  );
  @override
  late final GeneratedColumn<String> bodyLocations = GeneratedColumn<String>(
    'body_locations',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _startTimeframeMeta = const VerificationMeta(
    'startTimeframe',
  );
  @override
  late final GeneratedColumn<int> startTimeframe = GeneratedColumn<int>(
    'start_timeframe',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _baselinePhotoPathMeta = const VerificationMeta(
    'baselinePhotoPath',
  );
  @override
  late final GeneratedColumn<String> baselinePhotoPath =
      GeneratedColumn<String>(
        'baseline_photo_path',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<int> endDate = GeneratedColumn<int>(
    'end_date',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _activityIdMeta = const VerificationMeta(
    'activityId',
  );
  @override
  late final GeneratedColumn<String> activityId = GeneratedColumn<String>(
    'activity_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cloudStorageUrlMeta = const VerificationMeta(
    'cloudStorageUrl',
  );
  @override
  late final GeneratedColumn<String> cloudStorageUrl = GeneratedColumn<String>(
    'cloud_storage_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fileHashMeta = const VerificationMeta(
    'fileHash',
  );
  @override
  late final GeneratedColumn<String> fileHash = GeneratedColumn<String>(
    'file_hash',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fileSizeBytesMeta = const VerificationMeta(
    'fileSizeBytes',
  );
  @override
  late final GeneratedColumn<int> fileSizeBytes = GeneratedColumn<int>(
    'file_size_bytes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isFileUploadedMeta = const VerificationMeta(
    'isFileUploaded',
  );
  @override
  late final GeneratedColumn<bool> isFileUploaded = GeneratedColumn<bool>(
    'is_file_uploaded',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_file_uploaded" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncCreatedAtMeta = const VerificationMeta(
    'syncCreatedAt',
  );
  @override
  late final GeneratedColumn<int> syncCreatedAt = GeneratedColumn<int>(
    'sync_created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncUpdatedAtMeta = const VerificationMeta(
    'syncUpdatedAt',
  );
  @override
  late final GeneratedColumn<int> syncUpdatedAt = GeneratedColumn<int>(
    'sync_updated_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncDeletedAtMeta = const VerificationMeta(
    'syncDeletedAt',
  );
  @override
  late final GeneratedColumn<int> syncDeletedAt = GeneratedColumn<int>(
    'sync_deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncLastSyncedAtMeta = const VerificationMeta(
    'syncLastSyncedAt',
  );
  @override
  late final GeneratedColumn<int> syncLastSyncedAt = GeneratedColumn<int>(
    'sync_last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _syncVersionMeta = const VerificationMeta(
    'syncVersion',
  );
  @override
  late final GeneratedColumn<int> syncVersion = GeneratedColumn<int>(
    'sync_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _syncDeviceIdMeta = const VerificationMeta(
    'syncDeviceId',
  );
  @override
  late final GeneratedColumn<String> syncDeviceId = GeneratedColumn<String>(
    'sync_device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncIsDirtyMeta = const VerificationMeta(
    'syncIsDirty',
  );
  @override
  late final GeneratedColumn<bool> syncIsDirty = GeneratedColumn<bool>(
    'sync_is_dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sync_is_dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _conflictDataMeta = const VerificationMeta(
    'conflictData',
  );
  @override
  late final GeneratedColumn<String> conflictData = GeneratedColumn<String>(
    'conflict_data',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    clientId,
    profileId,
    name,
    category,
    bodyLocations,
    startTimeframe,
    status,
    description,
    baselinePhotoPath,
    endDate,
    isArchived,
    activityId,
    cloudStorageUrl,
    fileHash,
    fileSizeBytes,
    isFileUploaded,
    syncCreatedAt,
    syncUpdatedAt,
    syncDeletedAt,
    syncLastSyncedAt,
    syncStatus,
    syncVersion,
    syncDeviceId,
    syncIsDirty,
    conflictData,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'conditions';
  @override
  VerificationContext validateIntegrity(
    Insertable<ConditionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('body_locations')) {
      context.handle(
        _bodyLocationsMeta,
        bodyLocations.isAcceptableOrUnknown(
          data['body_locations']!,
          _bodyLocationsMeta,
        ),
      );
    }
    if (data.containsKey('start_timeframe')) {
      context.handle(
        _startTimeframeMeta,
        startTimeframe.isAcceptableOrUnknown(
          data['start_timeframe']!,
          _startTimeframeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startTimeframeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('baseline_photo_path')) {
      context.handle(
        _baselinePhotoPathMeta,
        baselinePhotoPath.isAcceptableOrUnknown(
          data['baseline_photo_path']!,
          _baselinePhotoPathMeta,
        ),
      );
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('activity_id')) {
      context.handle(
        _activityIdMeta,
        activityId.isAcceptableOrUnknown(data['activity_id']!, _activityIdMeta),
      );
    }
    if (data.containsKey('cloud_storage_url')) {
      context.handle(
        _cloudStorageUrlMeta,
        cloudStorageUrl.isAcceptableOrUnknown(
          data['cloud_storage_url']!,
          _cloudStorageUrlMeta,
        ),
      );
    }
    if (data.containsKey('file_hash')) {
      context.handle(
        _fileHashMeta,
        fileHash.isAcceptableOrUnknown(data['file_hash']!, _fileHashMeta),
      );
    }
    if (data.containsKey('file_size_bytes')) {
      context.handle(
        _fileSizeBytesMeta,
        fileSizeBytes.isAcceptableOrUnknown(
          data['file_size_bytes']!,
          _fileSizeBytesMeta,
        ),
      );
    }
    if (data.containsKey('is_file_uploaded')) {
      context.handle(
        _isFileUploadedMeta,
        isFileUploaded.isAcceptableOrUnknown(
          data['is_file_uploaded']!,
          _isFileUploadedMeta,
        ),
      );
    }
    if (data.containsKey('sync_created_at')) {
      context.handle(
        _syncCreatedAtMeta,
        syncCreatedAt.isAcceptableOrUnknown(
          data['sync_created_at']!,
          _syncCreatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_syncCreatedAtMeta);
    }
    if (data.containsKey('sync_updated_at')) {
      context.handle(
        _syncUpdatedAtMeta,
        syncUpdatedAt.isAcceptableOrUnknown(
          data['sync_updated_at']!,
          _syncUpdatedAtMeta,
        ),
      );
    }
    if (data.containsKey('sync_deleted_at')) {
      context.handle(
        _syncDeletedAtMeta,
        syncDeletedAt.isAcceptableOrUnknown(
          data['sync_deleted_at']!,
          _syncDeletedAtMeta,
        ),
      );
    }
    if (data.containsKey('sync_last_synced_at')) {
      context.handle(
        _syncLastSyncedAtMeta,
        syncLastSyncedAt.isAcceptableOrUnknown(
          data['sync_last_synced_at']!,
          _syncLastSyncedAtMeta,
        ),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('sync_version')) {
      context.handle(
        _syncVersionMeta,
        syncVersion.isAcceptableOrUnknown(
          data['sync_version']!,
          _syncVersionMeta,
        ),
      );
    }
    if (data.containsKey('sync_device_id')) {
      context.handle(
        _syncDeviceIdMeta,
        syncDeviceId.isAcceptableOrUnknown(
          data['sync_device_id']!,
          _syncDeviceIdMeta,
        ),
      );
    }
    if (data.containsKey('sync_is_dirty')) {
      context.handle(
        _syncIsDirtyMeta,
        syncIsDirty.isAcceptableOrUnknown(
          data['sync_is_dirty']!,
          _syncIsDirtyMeta,
        ),
      );
    }
    if (data.containsKey('conflict_data')) {
      context.handle(
        _conflictDataMeta,
        conflictData.isAcceptableOrUnknown(
          data['conflict_data']!,
          _conflictDataMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ConditionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConditionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      bodyLocations: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body_locations'],
      )!,
      startTimeframe: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_timeframe'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}status'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      baselinePhotoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}baseline_photo_path'],
      ),
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_date'],
      ),
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      activityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_id'],
      ),
      cloudStorageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cloud_storage_url'],
      ),
      fileHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_hash'],
      ),
      fileSizeBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}file_size_bytes'],
      ),
      isFileUploaded: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_file_uploaded'],
      )!,
      syncCreatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_created_at'],
      )!,
      syncUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_updated_at'],
      ),
      syncDeletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_deleted_at'],
      ),
      syncLastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_last_synced_at'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_status'],
      )!,
      syncVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_version'],
      )!,
      syncDeviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_device_id'],
      ),
      syncIsDirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sync_is_dirty'],
      )!,
      conflictData: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conflict_data'],
      ),
    );
  }

  @override
  $ConditionsTable createAlias(String alias) {
    return $ConditionsTable(attachedDatabase, alias);
  }
}

class ConditionRow extends DataClass implements Insertable<ConditionRow> {
  final String id;
  final String clientId;
  final String profileId;
  final String name;
  final String category;
  final String bodyLocations;
  final int startTimeframe;
  final int status;
  final String? description;
  final String? baselinePhotoPath;
  final int? endDate;
  final bool isArchived;
  final String? activityId;
  final String? cloudStorageUrl;
  final String? fileHash;
  final int? fileSizeBytes;
  final bool isFileUploaded;
  final int syncCreatedAt;
  final int? syncUpdatedAt;
  final int? syncDeletedAt;
  final int? syncLastSyncedAt;
  final int syncStatus;
  final int syncVersion;
  final String? syncDeviceId;
  final bool syncIsDirty;
  final String? conflictData;
  const ConditionRow({
    required this.id,
    required this.clientId,
    required this.profileId,
    required this.name,
    required this.category,
    required this.bodyLocations,
    required this.startTimeframe,
    required this.status,
    this.description,
    this.baselinePhotoPath,
    this.endDate,
    required this.isArchived,
    this.activityId,
    this.cloudStorageUrl,
    this.fileHash,
    this.fileSizeBytes,
    required this.isFileUploaded,
    required this.syncCreatedAt,
    this.syncUpdatedAt,
    this.syncDeletedAt,
    this.syncLastSyncedAt,
    required this.syncStatus,
    required this.syncVersion,
    this.syncDeviceId,
    required this.syncIsDirty,
    this.conflictData,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['client_id'] = Variable<String>(clientId);
    map['profile_id'] = Variable<String>(profileId);
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    map['body_locations'] = Variable<String>(bodyLocations);
    map['start_timeframe'] = Variable<int>(startTimeframe);
    map['status'] = Variable<int>(status);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || baselinePhotoPath != null) {
      map['baseline_photo_path'] = Variable<String>(baselinePhotoPath);
    }
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<int>(endDate);
    }
    map['is_archived'] = Variable<bool>(isArchived);
    if (!nullToAbsent || activityId != null) {
      map['activity_id'] = Variable<String>(activityId);
    }
    if (!nullToAbsent || cloudStorageUrl != null) {
      map['cloud_storage_url'] = Variable<String>(cloudStorageUrl);
    }
    if (!nullToAbsent || fileHash != null) {
      map['file_hash'] = Variable<String>(fileHash);
    }
    if (!nullToAbsent || fileSizeBytes != null) {
      map['file_size_bytes'] = Variable<int>(fileSizeBytes);
    }
    map['is_file_uploaded'] = Variable<bool>(isFileUploaded);
    map['sync_created_at'] = Variable<int>(syncCreatedAt);
    if (!nullToAbsent || syncUpdatedAt != null) {
      map['sync_updated_at'] = Variable<int>(syncUpdatedAt);
    }
    if (!nullToAbsent || syncDeletedAt != null) {
      map['sync_deleted_at'] = Variable<int>(syncDeletedAt);
    }
    if (!nullToAbsent || syncLastSyncedAt != null) {
      map['sync_last_synced_at'] = Variable<int>(syncLastSyncedAt);
    }
    map['sync_status'] = Variable<int>(syncStatus);
    map['sync_version'] = Variable<int>(syncVersion);
    if (!nullToAbsent || syncDeviceId != null) {
      map['sync_device_id'] = Variable<String>(syncDeviceId);
    }
    map['sync_is_dirty'] = Variable<bool>(syncIsDirty);
    if (!nullToAbsent || conflictData != null) {
      map['conflict_data'] = Variable<String>(conflictData);
    }
    return map;
  }

  ConditionsCompanion toCompanion(bool nullToAbsent) {
    return ConditionsCompanion(
      id: Value(id),
      clientId: Value(clientId),
      profileId: Value(profileId),
      name: Value(name),
      category: Value(category),
      bodyLocations: Value(bodyLocations),
      startTimeframe: Value(startTimeframe),
      status: Value(status),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      baselinePhotoPath: baselinePhotoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(baselinePhotoPath),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      isArchived: Value(isArchived),
      activityId: activityId == null && nullToAbsent
          ? const Value.absent()
          : Value(activityId),
      cloudStorageUrl: cloudStorageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(cloudStorageUrl),
      fileHash: fileHash == null && nullToAbsent
          ? const Value.absent()
          : Value(fileHash),
      fileSizeBytes: fileSizeBytes == null && nullToAbsent
          ? const Value.absent()
          : Value(fileSizeBytes),
      isFileUploaded: Value(isFileUploaded),
      syncCreatedAt: Value(syncCreatedAt),
      syncUpdatedAt: syncUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncUpdatedAt),
      syncDeletedAt: syncDeletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncDeletedAt),
      syncLastSyncedAt: syncLastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncLastSyncedAt),
      syncStatus: Value(syncStatus),
      syncVersion: Value(syncVersion),
      syncDeviceId: syncDeviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(syncDeviceId),
      syncIsDirty: Value(syncIsDirty),
      conflictData: conflictData == null && nullToAbsent
          ? const Value.absent()
          : Value(conflictData),
    );
  }

  factory ConditionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConditionRow(
      id: serializer.fromJson<String>(json['id']),
      clientId: serializer.fromJson<String>(json['clientId']),
      profileId: serializer.fromJson<String>(json['profileId']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
      bodyLocations: serializer.fromJson<String>(json['bodyLocations']),
      startTimeframe: serializer.fromJson<int>(json['startTimeframe']),
      status: serializer.fromJson<int>(json['status']),
      description: serializer.fromJson<String?>(json['description']),
      baselinePhotoPath: serializer.fromJson<String?>(
        json['baselinePhotoPath'],
      ),
      endDate: serializer.fromJson<int?>(json['endDate']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      activityId: serializer.fromJson<String?>(json['activityId']),
      cloudStorageUrl: serializer.fromJson<String?>(json['cloudStorageUrl']),
      fileHash: serializer.fromJson<String?>(json['fileHash']),
      fileSizeBytes: serializer.fromJson<int?>(json['fileSizeBytes']),
      isFileUploaded: serializer.fromJson<bool>(json['isFileUploaded']),
      syncCreatedAt: serializer.fromJson<int>(json['syncCreatedAt']),
      syncUpdatedAt: serializer.fromJson<int?>(json['syncUpdatedAt']),
      syncDeletedAt: serializer.fromJson<int?>(json['syncDeletedAt']),
      syncLastSyncedAt: serializer.fromJson<int?>(json['syncLastSyncedAt']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
      syncVersion: serializer.fromJson<int>(json['syncVersion']),
      syncDeviceId: serializer.fromJson<String?>(json['syncDeviceId']),
      syncIsDirty: serializer.fromJson<bool>(json['syncIsDirty']),
      conflictData: serializer.fromJson<String?>(json['conflictData']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'clientId': serializer.toJson<String>(clientId),
      'profileId': serializer.toJson<String>(profileId),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(category),
      'bodyLocations': serializer.toJson<String>(bodyLocations),
      'startTimeframe': serializer.toJson<int>(startTimeframe),
      'status': serializer.toJson<int>(status),
      'description': serializer.toJson<String?>(description),
      'baselinePhotoPath': serializer.toJson<String?>(baselinePhotoPath),
      'endDate': serializer.toJson<int?>(endDate),
      'isArchived': serializer.toJson<bool>(isArchived),
      'activityId': serializer.toJson<String?>(activityId),
      'cloudStorageUrl': serializer.toJson<String?>(cloudStorageUrl),
      'fileHash': serializer.toJson<String?>(fileHash),
      'fileSizeBytes': serializer.toJson<int?>(fileSizeBytes),
      'isFileUploaded': serializer.toJson<bool>(isFileUploaded),
      'syncCreatedAt': serializer.toJson<int>(syncCreatedAt),
      'syncUpdatedAt': serializer.toJson<int?>(syncUpdatedAt),
      'syncDeletedAt': serializer.toJson<int?>(syncDeletedAt),
      'syncLastSyncedAt': serializer.toJson<int?>(syncLastSyncedAt),
      'syncStatus': serializer.toJson<int>(syncStatus),
      'syncVersion': serializer.toJson<int>(syncVersion),
      'syncDeviceId': serializer.toJson<String?>(syncDeviceId),
      'syncIsDirty': serializer.toJson<bool>(syncIsDirty),
      'conflictData': serializer.toJson<String?>(conflictData),
    };
  }

  ConditionRow copyWith({
    String? id,
    String? clientId,
    String? profileId,
    String? name,
    String? category,
    String? bodyLocations,
    int? startTimeframe,
    int? status,
    Value<String?> description = const Value.absent(),
    Value<String?> baselinePhotoPath = const Value.absent(),
    Value<int?> endDate = const Value.absent(),
    bool? isArchived,
    Value<String?> activityId = const Value.absent(),
    Value<String?> cloudStorageUrl = const Value.absent(),
    Value<String?> fileHash = const Value.absent(),
    Value<int?> fileSizeBytes = const Value.absent(),
    bool? isFileUploaded,
    int? syncCreatedAt,
    Value<int?> syncUpdatedAt = const Value.absent(),
    Value<int?> syncDeletedAt = const Value.absent(),
    Value<int?> syncLastSyncedAt = const Value.absent(),
    int? syncStatus,
    int? syncVersion,
    Value<String?> syncDeviceId = const Value.absent(),
    bool? syncIsDirty,
    Value<String?> conflictData = const Value.absent(),
  }) => ConditionRow(
    id: id ?? this.id,
    clientId: clientId ?? this.clientId,
    profileId: profileId ?? this.profileId,
    name: name ?? this.name,
    category: category ?? this.category,
    bodyLocations: bodyLocations ?? this.bodyLocations,
    startTimeframe: startTimeframe ?? this.startTimeframe,
    status: status ?? this.status,
    description: description.present ? description.value : this.description,
    baselinePhotoPath: baselinePhotoPath.present
        ? baselinePhotoPath.value
        : this.baselinePhotoPath,
    endDate: endDate.present ? endDate.value : this.endDate,
    isArchived: isArchived ?? this.isArchived,
    activityId: activityId.present ? activityId.value : this.activityId,
    cloudStorageUrl: cloudStorageUrl.present
        ? cloudStorageUrl.value
        : this.cloudStorageUrl,
    fileHash: fileHash.present ? fileHash.value : this.fileHash,
    fileSizeBytes: fileSizeBytes.present
        ? fileSizeBytes.value
        : this.fileSizeBytes,
    isFileUploaded: isFileUploaded ?? this.isFileUploaded,
    syncCreatedAt: syncCreatedAt ?? this.syncCreatedAt,
    syncUpdatedAt: syncUpdatedAt.present
        ? syncUpdatedAt.value
        : this.syncUpdatedAt,
    syncDeletedAt: syncDeletedAt.present
        ? syncDeletedAt.value
        : this.syncDeletedAt,
    syncLastSyncedAt: syncLastSyncedAt.present
        ? syncLastSyncedAt.value
        : this.syncLastSyncedAt,
    syncStatus: syncStatus ?? this.syncStatus,
    syncVersion: syncVersion ?? this.syncVersion,
    syncDeviceId: syncDeviceId.present ? syncDeviceId.value : this.syncDeviceId,
    syncIsDirty: syncIsDirty ?? this.syncIsDirty,
    conflictData: conflictData.present ? conflictData.value : this.conflictData,
  );
  ConditionRow copyWithCompanion(ConditionsCompanion data) {
    return ConditionRow(
      id: data.id.present ? data.id.value : this.id,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      bodyLocations: data.bodyLocations.present
          ? data.bodyLocations.value
          : this.bodyLocations,
      startTimeframe: data.startTimeframe.present
          ? data.startTimeframe.value
          : this.startTimeframe,
      status: data.status.present ? data.status.value : this.status,
      description: data.description.present
          ? data.description.value
          : this.description,
      baselinePhotoPath: data.baselinePhotoPath.present
          ? data.baselinePhotoPath.value
          : this.baselinePhotoPath,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      activityId: data.activityId.present
          ? data.activityId.value
          : this.activityId,
      cloudStorageUrl: data.cloudStorageUrl.present
          ? data.cloudStorageUrl.value
          : this.cloudStorageUrl,
      fileHash: data.fileHash.present ? data.fileHash.value : this.fileHash,
      fileSizeBytes: data.fileSizeBytes.present
          ? data.fileSizeBytes.value
          : this.fileSizeBytes,
      isFileUploaded: data.isFileUploaded.present
          ? data.isFileUploaded.value
          : this.isFileUploaded,
      syncCreatedAt: data.syncCreatedAt.present
          ? data.syncCreatedAt.value
          : this.syncCreatedAt,
      syncUpdatedAt: data.syncUpdatedAt.present
          ? data.syncUpdatedAt.value
          : this.syncUpdatedAt,
      syncDeletedAt: data.syncDeletedAt.present
          ? data.syncDeletedAt.value
          : this.syncDeletedAt,
      syncLastSyncedAt: data.syncLastSyncedAt.present
          ? data.syncLastSyncedAt.value
          : this.syncLastSyncedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      syncVersion: data.syncVersion.present
          ? data.syncVersion.value
          : this.syncVersion,
      syncDeviceId: data.syncDeviceId.present
          ? data.syncDeviceId.value
          : this.syncDeviceId,
      syncIsDirty: data.syncIsDirty.present
          ? data.syncIsDirty.value
          : this.syncIsDirty,
      conflictData: data.conflictData.present
          ? data.conflictData.value
          : this.conflictData,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConditionRow(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('profileId: $profileId, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('bodyLocations: $bodyLocations, ')
          ..write('startTimeframe: $startTimeframe, ')
          ..write('status: $status, ')
          ..write('description: $description, ')
          ..write('baselinePhotoPath: $baselinePhotoPath, ')
          ..write('endDate: $endDate, ')
          ..write('isArchived: $isArchived, ')
          ..write('activityId: $activityId, ')
          ..write('cloudStorageUrl: $cloudStorageUrl, ')
          ..write('fileHash: $fileHash, ')
          ..write('fileSizeBytes: $fileSizeBytes, ')
          ..write('isFileUploaded: $isFileUploaded, ')
          ..write('syncCreatedAt: $syncCreatedAt, ')
          ..write('syncUpdatedAt: $syncUpdatedAt, ')
          ..write('syncDeletedAt: $syncDeletedAt, ')
          ..write('syncLastSyncedAt: $syncLastSyncedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncVersion: $syncVersion, ')
          ..write('syncDeviceId: $syncDeviceId, ')
          ..write('syncIsDirty: $syncIsDirty, ')
          ..write('conflictData: $conflictData')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    clientId,
    profileId,
    name,
    category,
    bodyLocations,
    startTimeframe,
    status,
    description,
    baselinePhotoPath,
    endDate,
    isArchived,
    activityId,
    cloudStorageUrl,
    fileHash,
    fileSizeBytes,
    isFileUploaded,
    syncCreatedAt,
    syncUpdatedAt,
    syncDeletedAt,
    syncLastSyncedAt,
    syncStatus,
    syncVersion,
    syncDeviceId,
    syncIsDirty,
    conflictData,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConditionRow &&
          other.id == this.id &&
          other.clientId == this.clientId &&
          other.profileId == this.profileId &&
          other.name == this.name &&
          other.category == this.category &&
          other.bodyLocations == this.bodyLocations &&
          other.startTimeframe == this.startTimeframe &&
          other.status == this.status &&
          other.description == this.description &&
          other.baselinePhotoPath == this.baselinePhotoPath &&
          other.endDate == this.endDate &&
          other.isArchived == this.isArchived &&
          other.activityId == this.activityId &&
          other.cloudStorageUrl == this.cloudStorageUrl &&
          other.fileHash == this.fileHash &&
          other.fileSizeBytes == this.fileSizeBytes &&
          other.isFileUploaded == this.isFileUploaded &&
          other.syncCreatedAt == this.syncCreatedAt &&
          other.syncUpdatedAt == this.syncUpdatedAt &&
          other.syncDeletedAt == this.syncDeletedAt &&
          other.syncLastSyncedAt == this.syncLastSyncedAt &&
          other.syncStatus == this.syncStatus &&
          other.syncVersion == this.syncVersion &&
          other.syncDeviceId == this.syncDeviceId &&
          other.syncIsDirty == this.syncIsDirty &&
          other.conflictData == this.conflictData);
}

class ConditionsCompanion extends UpdateCompanion<ConditionRow> {
  final Value<String> id;
  final Value<String> clientId;
  final Value<String> profileId;
  final Value<String> name;
  final Value<String> category;
  final Value<String> bodyLocations;
  final Value<int> startTimeframe;
  final Value<int> status;
  final Value<String?> description;
  final Value<String?> baselinePhotoPath;
  final Value<int?> endDate;
  final Value<bool> isArchived;
  final Value<String?> activityId;
  final Value<String?> cloudStorageUrl;
  final Value<String?> fileHash;
  final Value<int?> fileSizeBytes;
  final Value<bool> isFileUploaded;
  final Value<int> syncCreatedAt;
  final Value<int?> syncUpdatedAt;
  final Value<int?> syncDeletedAt;
  final Value<int?> syncLastSyncedAt;
  final Value<int> syncStatus;
  final Value<int> syncVersion;
  final Value<String?> syncDeviceId;
  final Value<bool> syncIsDirty;
  final Value<String?> conflictData;
  final Value<int> rowid;
  const ConditionsCompanion({
    this.id = const Value.absent(),
    this.clientId = const Value.absent(),
    this.profileId = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.bodyLocations = const Value.absent(),
    this.startTimeframe = const Value.absent(),
    this.status = const Value.absent(),
    this.description = const Value.absent(),
    this.baselinePhotoPath = const Value.absent(),
    this.endDate = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.activityId = const Value.absent(),
    this.cloudStorageUrl = const Value.absent(),
    this.fileHash = const Value.absent(),
    this.fileSizeBytes = const Value.absent(),
    this.isFileUploaded = const Value.absent(),
    this.syncCreatedAt = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
    this.syncDeletedAt = const Value.absent(),
    this.syncLastSyncedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncVersion = const Value.absent(),
    this.syncDeviceId = const Value.absent(),
    this.syncIsDirty = const Value.absent(),
    this.conflictData = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ConditionsCompanion.insert({
    required String id,
    required String clientId,
    required String profileId,
    required String name,
    required String category,
    this.bodyLocations = const Value.absent(),
    required int startTimeframe,
    required int status,
    this.description = const Value.absent(),
    this.baselinePhotoPath = const Value.absent(),
    this.endDate = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.activityId = const Value.absent(),
    this.cloudStorageUrl = const Value.absent(),
    this.fileHash = const Value.absent(),
    this.fileSizeBytes = const Value.absent(),
    this.isFileUploaded = const Value.absent(),
    required int syncCreatedAt,
    this.syncUpdatedAt = const Value.absent(),
    this.syncDeletedAt = const Value.absent(),
    this.syncLastSyncedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncVersion = const Value.absent(),
    this.syncDeviceId = const Value.absent(),
    this.syncIsDirty = const Value.absent(),
    this.conflictData = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       clientId = Value(clientId),
       profileId = Value(profileId),
       name = Value(name),
       category = Value(category),
       startTimeframe = Value(startTimeframe),
       status = Value(status),
       syncCreatedAt = Value(syncCreatedAt);
  static Insertable<ConditionRow> custom({
    Expression<String>? id,
    Expression<String>? clientId,
    Expression<String>? profileId,
    Expression<String>? name,
    Expression<String>? category,
    Expression<String>? bodyLocations,
    Expression<int>? startTimeframe,
    Expression<int>? status,
    Expression<String>? description,
    Expression<String>? baselinePhotoPath,
    Expression<int>? endDate,
    Expression<bool>? isArchived,
    Expression<String>? activityId,
    Expression<String>? cloudStorageUrl,
    Expression<String>? fileHash,
    Expression<int>? fileSizeBytes,
    Expression<bool>? isFileUploaded,
    Expression<int>? syncCreatedAt,
    Expression<int>? syncUpdatedAt,
    Expression<int>? syncDeletedAt,
    Expression<int>? syncLastSyncedAt,
    Expression<int>? syncStatus,
    Expression<int>? syncVersion,
    Expression<String>? syncDeviceId,
    Expression<bool>? syncIsDirty,
    Expression<String>? conflictData,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clientId != null) 'client_id': clientId,
      if (profileId != null) 'profile_id': profileId,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (bodyLocations != null) 'body_locations': bodyLocations,
      if (startTimeframe != null) 'start_timeframe': startTimeframe,
      if (status != null) 'status': status,
      if (description != null) 'description': description,
      if (baselinePhotoPath != null) 'baseline_photo_path': baselinePhotoPath,
      if (endDate != null) 'end_date': endDate,
      if (isArchived != null) 'is_archived': isArchived,
      if (activityId != null) 'activity_id': activityId,
      if (cloudStorageUrl != null) 'cloud_storage_url': cloudStorageUrl,
      if (fileHash != null) 'file_hash': fileHash,
      if (fileSizeBytes != null) 'file_size_bytes': fileSizeBytes,
      if (isFileUploaded != null) 'is_file_uploaded': isFileUploaded,
      if (syncCreatedAt != null) 'sync_created_at': syncCreatedAt,
      if (syncUpdatedAt != null) 'sync_updated_at': syncUpdatedAt,
      if (syncDeletedAt != null) 'sync_deleted_at': syncDeletedAt,
      if (syncLastSyncedAt != null) 'sync_last_synced_at': syncLastSyncedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncVersion != null) 'sync_version': syncVersion,
      if (syncDeviceId != null) 'sync_device_id': syncDeviceId,
      if (syncIsDirty != null) 'sync_is_dirty': syncIsDirty,
      if (conflictData != null) 'conflict_data': conflictData,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ConditionsCompanion copyWith({
    Value<String>? id,
    Value<String>? clientId,
    Value<String>? profileId,
    Value<String>? name,
    Value<String>? category,
    Value<String>? bodyLocations,
    Value<int>? startTimeframe,
    Value<int>? status,
    Value<String?>? description,
    Value<String?>? baselinePhotoPath,
    Value<int?>? endDate,
    Value<bool>? isArchived,
    Value<String?>? activityId,
    Value<String?>? cloudStorageUrl,
    Value<String?>? fileHash,
    Value<int?>? fileSizeBytes,
    Value<bool>? isFileUploaded,
    Value<int>? syncCreatedAt,
    Value<int?>? syncUpdatedAt,
    Value<int?>? syncDeletedAt,
    Value<int?>? syncLastSyncedAt,
    Value<int>? syncStatus,
    Value<int>? syncVersion,
    Value<String?>? syncDeviceId,
    Value<bool>? syncIsDirty,
    Value<String?>? conflictData,
    Value<int>? rowid,
  }) {
    return ConditionsCompanion(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      profileId: profileId ?? this.profileId,
      name: name ?? this.name,
      category: category ?? this.category,
      bodyLocations: bodyLocations ?? this.bodyLocations,
      startTimeframe: startTimeframe ?? this.startTimeframe,
      status: status ?? this.status,
      description: description ?? this.description,
      baselinePhotoPath: baselinePhotoPath ?? this.baselinePhotoPath,
      endDate: endDate ?? this.endDate,
      isArchived: isArchived ?? this.isArchived,
      activityId: activityId ?? this.activityId,
      cloudStorageUrl: cloudStorageUrl ?? this.cloudStorageUrl,
      fileHash: fileHash ?? this.fileHash,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
      isFileUploaded: isFileUploaded ?? this.isFileUploaded,
      syncCreatedAt: syncCreatedAt ?? this.syncCreatedAt,
      syncUpdatedAt: syncUpdatedAt ?? this.syncUpdatedAt,
      syncDeletedAt: syncDeletedAt ?? this.syncDeletedAt,
      syncLastSyncedAt: syncLastSyncedAt ?? this.syncLastSyncedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      syncVersion: syncVersion ?? this.syncVersion,
      syncDeviceId: syncDeviceId ?? this.syncDeviceId,
      syncIsDirty: syncIsDirty ?? this.syncIsDirty,
      conflictData: conflictData ?? this.conflictData,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (bodyLocations.present) {
      map['body_locations'] = Variable<String>(bodyLocations.value);
    }
    if (startTimeframe.present) {
      map['start_timeframe'] = Variable<int>(startTimeframe.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (baselinePhotoPath.present) {
      map['baseline_photo_path'] = Variable<String>(baselinePhotoPath.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<int>(endDate.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (activityId.present) {
      map['activity_id'] = Variable<String>(activityId.value);
    }
    if (cloudStorageUrl.present) {
      map['cloud_storage_url'] = Variable<String>(cloudStorageUrl.value);
    }
    if (fileHash.present) {
      map['file_hash'] = Variable<String>(fileHash.value);
    }
    if (fileSizeBytes.present) {
      map['file_size_bytes'] = Variable<int>(fileSizeBytes.value);
    }
    if (isFileUploaded.present) {
      map['is_file_uploaded'] = Variable<bool>(isFileUploaded.value);
    }
    if (syncCreatedAt.present) {
      map['sync_created_at'] = Variable<int>(syncCreatedAt.value);
    }
    if (syncUpdatedAt.present) {
      map['sync_updated_at'] = Variable<int>(syncUpdatedAt.value);
    }
    if (syncDeletedAt.present) {
      map['sync_deleted_at'] = Variable<int>(syncDeletedAt.value);
    }
    if (syncLastSyncedAt.present) {
      map['sync_last_synced_at'] = Variable<int>(syncLastSyncedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (syncVersion.present) {
      map['sync_version'] = Variable<int>(syncVersion.value);
    }
    if (syncDeviceId.present) {
      map['sync_device_id'] = Variable<String>(syncDeviceId.value);
    }
    if (syncIsDirty.present) {
      map['sync_is_dirty'] = Variable<bool>(syncIsDirty.value);
    }
    if (conflictData.present) {
      map['conflict_data'] = Variable<String>(conflictData.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConditionsCompanion(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('profileId: $profileId, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('bodyLocations: $bodyLocations, ')
          ..write('startTimeframe: $startTimeframe, ')
          ..write('status: $status, ')
          ..write('description: $description, ')
          ..write('baselinePhotoPath: $baselinePhotoPath, ')
          ..write('endDate: $endDate, ')
          ..write('isArchived: $isArchived, ')
          ..write('activityId: $activityId, ')
          ..write('cloudStorageUrl: $cloudStorageUrl, ')
          ..write('fileHash: $fileHash, ')
          ..write('fileSizeBytes: $fileSizeBytes, ')
          ..write('isFileUploaded: $isFileUploaded, ')
          ..write('syncCreatedAt: $syncCreatedAt, ')
          ..write('syncUpdatedAt: $syncUpdatedAt, ')
          ..write('syncDeletedAt: $syncDeletedAt, ')
          ..write('syncLastSyncedAt: $syncLastSyncedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncVersion: $syncVersion, ')
          ..write('syncDeviceId: $syncDeviceId, ')
          ..write('syncIsDirty: $syncIsDirty, ')
          ..write('conflictData: $conflictData, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ConditionLogsTable extends ConditionLogs
    with TableInfo<$ConditionLogsTable, ConditionLogRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConditionLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
    'client_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _conditionIdMeta = const VerificationMeta(
    'conditionId',
  );
  @override
  late final GeneratedColumn<String> conditionId = GeneratedColumn<String>(
    'condition_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<int> timestamp = GeneratedColumn<int>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _severityMeta = const VerificationMeta(
    'severity',
  );
  @override
  late final GeneratedColumn<int> severity = GeneratedColumn<int>(
    'severity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isFlareMeta = const VerificationMeta(
    'isFlare',
  );
  @override
  late final GeneratedColumn<bool> isFlare = GeneratedColumn<bool>(
    'is_flare',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_flare" IN (0, 1))',
    ),
  );
  static const VerificationMeta _flarePhotoIdsMeta = const VerificationMeta(
    'flarePhotoIds',
  );
  @override
  late final GeneratedColumn<String> flarePhotoIds = GeneratedColumn<String>(
    'flare_photo_ids',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activityIdMeta = const VerificationMeta(
    'activityId',
  );
  @override
  late final GeneratedColumn<String> activityId = GeneratedColumn<String>(
    'activity_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _triggersMeta = const VerificationMeta(
    'triggers',
  );
  @override
  late final GeneratedColumn<String> triggers = GeneratedColumn<String>(
    'triggers',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cloudStorageUrlMeta = const VerificationMeta(
    'cloudStorageUrl',
  );
  @override
  late final GeneratedColumn<String> cloudStorageUrl = GeneratedColumn<String>(
    'cloud_storage_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fileHashMeta = const VerificationMeta(
    'fileHash',
  );
  @override
  late final GeneratedColumn<String> fileHash = GeneratedColumn<String>(
    'file_hash',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fileSizeBytesMeta = const VerificationMeta(
    'fileSizeBytes',
  );
  @override
  late final GeneratedColumn<int> fileSizeBytes = GeneratedColumn<int>(
    'file_size_bytes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isFileUploadedMeta = const VerificationMeta(
    'isFileUploaded',
  );
  @override
  late final GeneratedColumn<bool> isFileUploaded = GeneratedColumn<bool>(
    'is_file_uploaded',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_file_uploaded" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncCreatedAtMeta = const VerificationMeta(
    'syncCreatedAt',
  );
  @override
  late final GeneratedColumn<int> syncCreatedAt = GeneratedColumn<int>(
    'sync_created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncUpdatedAtMeta = const VerificationMeta(
    'syncUpdatedAt',
  );
  @override
  late final GeneratedColumn<int> syncUpdatedAt = GeneratedColumn<int>(
    'sync_updated_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncDeletedAtMeta = const VerificationMeta(
    'syncDeletedAt',
  );
  @override
  late final GeneratedColumn<int> syncDeletedAt = GeneratedColumn<int>(
    'sync_deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncLastSyncedAtMeta = const VerificationMeta(
    'syncLastSyncedAt',
  );
  @override
  late final GeneratedColumn<int> syncLastSyncedAt = GeneratedColumn<int>(
    'sync_last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _syncVersionMeta = const VerificationMeta(
    'syncVersion',
  );
  @override
  late final GeneratedColumn<int> syncVersion = GeneratedColumn<int>(
    'sync_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _syncDeviceIdMeta = const VerificationMeta(
    'syncDeviceId',
  );
  @override
  late final GeneratedColumn<String> syncDeviceId = GeneratedColumn<String>(
    'sync_device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncIsDirtyMeta = const VerificationMeta(
    'syncIsDirty',
  );
  @override
  late final GeneratedColumn<bool> syncIsDirty = GeneratedColumn<bool>(
    'sync_is_dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sync_is_dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _conflictDataMeta = const VerificationMeta(
    'conflictData',
  );
  @override
  late final GeneratedColumn<String> conflictData = GeneratedColumn<String>(
    'conflict_data',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    clientId,
    profileId,
    conditionId,
    timestamp,
    severity,
    isFlare,
    flarePhotoIds,
    notes,
    photoPath,
    activityId,
    triggers,
    cloudStorageUrl,
    fileHash,
    fileSizeBytes,
    isFileUploaded,
    syncCreatedAt,
    syncUpdatedAt,
    syncDeletedAt,
    syncLastSyncedAt,
    syncStatus,
    syncVersion,
    syncDeviceId,
    syncIsDirty,
    conflictData,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'condition_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<ConditionLogRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('condition_id')) {
      context.handle(
        _conditionIdMeta,
        conditionId.isAcceptableOrUnknown(
          data['condition_id']!,
          _conditionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_conditionIdMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('severity')) {
      context.handle(
        _severityMeta,
        severity.isAcceptableOrUnknown(data['severity']!, _severityMeta),
      );
    } else if (isInserting) {
      context.missing(_severityMeta);
    }
    if (data.containsKey('is_flare')) {
      context.handle(
        _isFlareMeta,
        isFlare.isAcceptableOrUnknown(data['is_flare']!, _isFlareMeta),
      );
    } else if (isInserting) {
      context.missing(_isFlareMeta);
    }
    if (data.containsKey('flare_photo_ids')) {
      context.handle(
        _flarePhotoIdsMeta,
        flarePhotoIds.isAcceptableOrUnknown(
          data['flare_photo_ids']!,
          _flarePhotoIdsMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    if (data.containsKey('activity_id')) {
      context.handle(
        _activityIdMeta,
        activityId.isAcceptableOrUnknown(data['activity_id']!, _activityIdMeta),
      );
    }
    if (data.containsKey('triggers')) {
      context.handle(
        _triggersMeta,
        triggers.isAcceptableOrUnknown(data['triggers']!, _triggersMeta),
      );
    }
    if (data.containsKey('cloud_storage_url')) {
      context.handle(
        _cloudStorageUrlMeta,
        cloudStorageUrl.isAcceptableOrUnknown(
          data['cloud_storage_url']!,
          _cloudStorageUrlMeta,
        ),
      );
    }
    if (data.containsKey('file_hash')) {
      context.handle(
        _fileHashMeta,
        fileHash.isAcceptableOrUnknown(data['file_hash']!, _fileHashMeta),
      );
    }
    if (data.containsKey('file_size_bytes')) {
      context.handle(
        _fileSizeBytesMeta,
        fileSizeBytes.isAcceptableOrUnknown(
          data['file_size_bytes']!,
          _fileSizeBytesMeta,
        ),
      );
    }
    if (data.containsKey('is_file_uploaded')) {
      context.handle(
        _isFileUploadedMeta,
        isFileUploaded.isAcceptableOrUnknown(
          data['is_file_uploaded']!,
          _isFileUploadedMeta,
        ),
      );
    }
    if (data.containsKey('sync_created_at')) {
      context.handle(
        _syncCreatedAtMeta,
        syncCreatedAt.isAcceptableOrUnknown(
          data['sync_created_at']!,
          _syncCreatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_syncCreatedAtMeta);
    }
    if (data.containsKey('sync_updated_at')) {
      context.handle(
        _syncUpdatedAtMeta,
        syncUpdatedAt.isAcceptableOrUnknown(
          data['sync_updated_at']!,
          _syncUpdatedAtMeta,
        ),
      );
    }
    if (data.containsKey('sync_deleted_at')) {
      context.handle(
        _syncDeletedAtMeta,
        syncDeletedAt.isAcceptableOrUnknown(
          data['sync_deleted_at']!,
          _syncDeletedAtMeta,
        ),
      );
    }
    if (data.containsKey('sync_last_synced_at')) {
      context.handle(
        _syncLastSyncedAtMeta,
        syncLastSyncedAt.isAcceptableOrUnknown(
          data['sync_last_synced_at']!,
          _syncLastSyncedAtMeta,
        ),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('sync_version')) {
      context.handle(
        _syncVersionMeta,
        syncVersion.isAcceptableOrUnknown(
          data['sync_version']!,
          _syncVersionMeta,
        ),
      );
    }
    if (data.containsKey('sync_device_id')) {
      context.handle(
        _syncDeviceIdMeta,
        syncDeviceId.isAcceptableOrUnknown(
          data['sync_device_id']!,
          _syncDeviceIdMeta,
        ),
      );
    }
    if (data.containsKey('sync_is_dirty')) {
      context.handle(
        _syncIsDirtyMeta,
        syncIsDirty.isAcceptableOrUnknown(
          data['sync_is_dirty']!,
          _syncIsDirtyMeta,
        ),
      );
    }
    if (data.containsKey('conflict_data')) {
      context.handle(
        _conflictDataMeta,
        conflictData.isAcceptableOrUnknown(
          data['conflict_data']!,
          _conflictDataMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ConditionLogRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConditionLogRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      conditionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}condition_id'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}timestamp'],
      )!,
      severity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}severity'],
      )!,
      isFlare: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_flare'],
      )!,
      flarePhotoIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}flare_photo_ids'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
      activityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_id'],
      ),
      triggers: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}triggers'],
      ),
      cloudStorageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cloud_storage_url'],
      ),
      fileHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_hash'],
      ),
      fileSizeBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}file_size_bytes'],
      ),
      isFileUploaded: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_file_uploaded'],
      )!,
      syncCreatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_created_at'],
      )!,
      syncUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_updated_at'],
      ),
      syncDeletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_deleted_at'],
      ),
      syncLastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_last_synced_at'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_status'],
      )!,
      syncVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_version'],
      )!,
      syncDeviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_device_id'],
      ),
      syncIsDirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sync_is_dirty'],
      )!,
      conflictData: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conflict_data'],
      ),
    );
  }

  @override
  $ConditionLogsTable createAlias(String alias) {
    return $ConditionLogsTable(attachedDatabase, alias);
  }
}

class ConditionLogRow extends DataClass implements Insertable<ConditionLogRow> {
  final String id;
  final String clientId;
  final String profileId;
  final String conditionId;
  final int timestamp;
  final int severity;
  final bool isFlare;
  final String flarePhotoIds;
  final String? notes;
  final String? photoPath;
  final String? activityId;
  final String? triggers;
  final String? cloudStorageUrl;
  final String? fileHash;
  final int? fileSizeBytes;
  final bool isFileUploaded;
  final int syncCreatedAt;
  final int? syncUpdatedAt;
  final int? syncDeletedAt;
  final int? syncLastSyncedAt;
  final int syncStatus;
  final int syncVersion;
  final String? syncDeviceId;
  final bool syncIsDirty;
  final String? conflictData;
  const ConditionLogRow({
    required this.id,
    required this.clientId,
    required this.profileId,
    required this.conditionId,
    required this.timestamp,
    required this.severity,
    required this.isFlare,
    required this.flarePhotoIds,
    this.notes,
    this.photoPath,
    this.activityId,
    this.triggers,
    this.cloudStorageUrl,
    this.fileHash,
    this.fileSizeBytes,
    required this.isFileUploaded,
    required this.syncCreatedAt,
    this.syncUpdatedAt,
    this.syncDeletedAt,
    this.syncLastSyncedAt,
    required this.syncStatus,
    required this.syncVersion,
    this.syncDeviceId,
    required this.syncIsDirty,
    this.conflictData,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['client_id'] = Variable<String>(clientId);
    map['profile_id'] = Variable<String>(profileId);
    map['condition_id'] = Variable<String>(conditionId);
    map['timestamp'] = Variable<int>(timestamp);
    map['severity'] = Variable<int>(severity);
    map['is_flare'] = Variable<bool>(isFlare);
    map['flare_photo_ids'] = Variable<String>(flarePhotoIds);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    if (!nullToAbsent || activityId != null) {
      map['activity_id'] = Variable<String>(activityId);
    }
    if (!nullToAbsent || triggers != null) {
      map['triggers'] = Variable<String>(triggers);
    }
    if (!nullToAbsent || cloudStorageUrl != null) {
      map['cloud_storage_url'] = Variable<String>(cloudStorageUrl);
    }
    if (!nullToAbsent || fileHash != null) {
      map['file_hash'] = Variable<String>(fileHash);
    }
    if (!nullToAbsent || fileSizeBytes != null) {
      map['file_size_bytes'] = Variable<int>(fileSizeBytes);
    }
    map['is_file_uploaded'] = Variable<bool>(isFileUploaded);
    map['sync_created_at'] = Variable<int>(syncCreatedAt);
    if (!nullToAbsent || syncUpdatedAt != null) {
      map['sync_updated_at'] = Variable<int>(syncUpdatedAt);
    }
    if (!nullToAbsent || syncDeletedAt != null) {
      map['sync_deleted_at'] = Variable<int>(syncDeletedAt);
    }
    if (!nullToAbsent || syncLastSyncedAt != null) {
      map['sync_last_synced_at'] = Variable<int>(syncLastSyncedAt);
    }
    map['sync_status'] = Variable<int>(syncStatus);
    map['sync_version'] = Variable<int>(syncVersion);
    if (!nullToAbsent || syncDeviceId != null) {
      map['sync_device_id'] = Variable<String>(syncDeviceId);
    }
    map['sync_is_dirty'] = Variable<bool>(syncIsDirty);
    if (!nullToAbsent || conflictData != null) {
      map['conflict_data'] = Variable<String>(conflictData);
    }
    return map;
  }

  ConditionLogsCompanion toCompanion(bool nullToAbsent) {
    return ConditionLogsCompanion(
      id: Value(id),
      clientId: Value(clientId),
      profileId: Value(profileId),
      conditionId: Value(conditionId),
      timestamp: Value(timestamp),
      severity: Value(severity),
      isFlare: Value(isFlare),
      flarePhotoIds: Value(flarePhotoIds),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      activityId: activityId == null && nullToAbsent
          ? const Value.absent()
          : Value(activityId),
      triggers: triggers == null && nullToAbsent
          ? const Value.absent()
          : Value(triggers),
      cloudStorageUrl: cloudStorageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(cloudStorageUrl),
      fileHash: fileHash == null && nullToAbsent
          ? const Value.absent()
          : Value(fileHash),
      fileSizeBytes: fileSizeBytes == null && nullToAbsent
          ? const Value.absent()
          : Value(fileSizeBytes),
      isFileUploaded: Value(isFileUploaded),
      syncCreatedAt: Value(syncCreatedAt),
      syncUpdatedAt: syncUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncUpdatedAt),
      syncDeletedAt: syncDeletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncDeletedAt),
      syncLastSyncedAt: syncLastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncLastSyncedAt),
      syncStatus: Value(syncStatus),
      syncVersion: Value(syncVersion),
      syncDeviceId: syncDeviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(syncDeviceId),
      syncIsDirty: Value(syncIsDirty),
      conflictData: conflictData == null && nullToAbsent
          ? const Value.absent()
          : Value(conflictData),
    );
  }

  factory ConditionLogRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConditionLogRow(
      id: serializer.fromJson<String>(json['id']),
      clientId: serializer.fromJson<String>(json['clientId']),
      profileId: serializer.fromJson<String>(json['profileId']),
      conditionId: serializer.fromJson<String>(json['conditionId']),
      timestamp: serializer.fromJson<int>(json['timestamp']),
      severity: serializer.fromJson<int>(json['severity']),
      isFlare: serializer.fromJson<bool>(json['isFlare']),
      flarePhotoIds: serializer.fromJson<String>(json['flarePhotoIds']),
      notes: serializer.fromJson<String?>(json['notes']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      activityId: serializer.fromJson<String?>(json['activityId']),
      triggers: serializer.fromJson<String?>(json['triggers']),
      cloudStorageUrl: serializer.fromJson<String?>(json['cloudStorageUrl']),
      fileHash: serializer.fromJson<String?>(json['fileHash']),
      fileSizeBytes: serializer.fromJson<int?>(json['fileSizeBytes']),
      isFileUploaded: serializer.fromJson<bool>(json['isFileUploaded']),
      syncCreatedAt: serializer.fromJson<int>(json['syncCreatedAt']),
      syncUpdatedAt: serializer.fromJson<int?>(json['syncUpdatedAt']),
      syncDeletedAt: serializer.fromJson<int?>(json['syncDeletedAt']),
      syncLastSyncedAt: serializer.fromJson<int?>(json['syncLastSyncedAt']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
      syncVersion: serializer.fromJson<int>(json['syncVersion']),
      syncDeviceId: serializer.fromJson<String?>(json['syncDeviceId']),
      syncIsDirty: serializer.fromJson<bool>(json['syncIsDirty']),
      conflictData: serializer.fromJson<String?>(json['conflictData']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'clientId': serializer.toJson<String>(clientId),
      'profileId': serializer.toJson<String>(profileId),
      'conditionId': serializer.toJson<String>(conditionId),
      'timestamp': serializer.toJson<int>(timestamp),
      'severity': serializer.toJson<int>(severity),
      'isFlare': serializer.toJson<bool>(isFlare),
      'flarePhotoIds': serializer.toJson<String>(flarePhotoIds),
      'notes': serializer.toJson<String?>(notes),
      'photoPath': serializer.toJson<String?>(photoPath),
      'activityId': serializer.toJson<String?>(activityId),
      'triggers': serializer.toJson<String?>(triggers),
      'cloudStorageUrl': serializer.toJson<String?>(cloudStorageUrl),
      'fileHash': serializer.toJson<String?>(fileHash),
      'fileSizeBytes': serializer.toJson<int?>(fileSizeBytes),
      'isFileUploaded': serializer.toJson<bool>(isFileUploaded),
      'syncCreatedAt': serializer.toJson<int>(syncCreatedAt),
      'syncUpdatedAt': serializer.toJson<int?>(syncUpdatedAt),
      'syncDeletedAt': serializer.toJson<int?>(syncDeletedAt),
      'syncLastSyncedAt': serializer.toJson<int?>(syncLastSyncedAt),
      'syncStatus': serializer.toJson<int>(syncStatus),
      'syncVersion': serializer.toJson<int>(syncVersion),
      'syncDeviceId': serializer.toJson<String?>(syncDeviceId),
      'syncIsDirty': serializer.toJson<bool>(syncIsDirty),
      'conflictData': serializer.toJson<String?>(conflictData),
    };
  }

  ConditionLogRow copyWith({
    String? id,
    String? clientId,
    String? profileId,
    String? conditionId,
    int? timestamp,
    int? severity,
    bool? isFlare,
    String? flarePhotoIds,
    Value<String?> notes = const Value.absent(),
    Value<String?> photoPath = const Value.absent(),
    Value<String?> activityId = const Value.absent(),
    Value<String?> triggers = const Value.absent(),
    Value<String?> cloudStorageUrl = const Value.absent(),
    Value<String?> fileHash = const Value.absent(),
    Value<int?> fileSizeBytes = const Value.absent(),
    bool? isFileUploaded,
    int? syncCreatedAt,
    Value<int?> syncUpdatedAt = const Value.absent(),
    Value<int?> syncDeletedAt = const Value.absent(),
    Value<int?> syncLastSyncedAt = const Value.absent(),
    int? syncStatus,
    int? syncVersion,
    Value<String?> syncDeviceId = const Value.absent(),
    bool? syncIsDirty,
    Value<String?> conflictData = const Value.absent(),
  }) => ConditionLogRow(
    id: id ?? this.id,
    clientId: clientId ?? this.clientId,
    profileId: profileId ?? this.profileId,
    conditionId: conditionId ?? this.conditionId,
    timestamp: timestamp ?? this.timestamp,
    severity: severity ?? this.severity,
    isFlare: isFlare ?? this.isFlare,
    flarePhotoIds: flarePhotoIds ?? this.flarePhotoIds,
    notes: notes.present ? notes.value : this.notes,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    activityId: activityId.present ? activityId.value : this.activityId,
    triggers: triggers.present ? triggers.value : this.triggers,
    cloudStorageUrl: cloudStorageUrl.present
        ? cloudStorageUrl.value
        : this.cloudStorageUrl,
    fileHash: fileHash.present ? fileHash.value : this.fileHash,
    fileSizeBytes: fileSizeBytes.present
        ? fileSizeBytes.value
        : this.fileSizeBytes,
    isFileUploaded: isFileUploaded ?? this.isFileUploaded,
    syncCreatedAt: syncCreatedAt ?? this.syncCreatedAt,
    syncUpdatedAt: syncUpdatedAt.present
        ? syncUpdatedAt.value
        : this.syncUpdatedAt,
    syncDeletedAt: syncDeletedAt.present
        ? syncDeletedAt.value
        : this.syncDeletedAt,
    syncLastSyncedAt: syncLastSyncedAt.present
        ? syncLastSyncedAt.value
        : this.syncLastSyncedAt,
    syncStatus: syncStatus ?? this.syncStatus,
    syncVersion: syncVersion ?? this.syncVersion,
    syncDeviceId: syncDeviceId.present ? syncDeviceId.value : this.syncDeviceId,
    syncIsDirty: syncIsDirty ?? this.syncIsDirty,
    conflictData: conflictData.present ? conflictData.value : this.conflictData,
  );
  ConditionLogRow copyWithCompanion(ConditionLogsCompanion data) {
    return ConditionLogRow(
      id: data.id.present ? data.id.value : this.id,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      conditionId: data.conditionId.present
          ? data.conditionId.value
          : this.conditionId,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      severity: data.severity.present ? data.severity.value : this.severity,
      isFlare: data.isFlare.present ? data.isFlare.value : this.isFlare,
      flarePhotoIds: data.flarePhotoIds.present
          ? data.flarePhotoIds.value
          : this.flarePhotoIds,
      notes: data.notes.present ? data.notes.value : this.notes,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      activityId: data.activityId.present
          ? data.activityId.value
          : this.activityId,
      triggers: data.triggers.present ? data.triggers.value : this.triggers,
      cloudStorageUrl: data.cloudStorageUrl.present
          ? data.cloudStorageUrl.value
          : this.cloudStorageUrl,
      fileHash: data.fileHash.present ? data.fileHash.value : this.fileHash,
      fileSizeBytes: data.fileSizeBytes.present
          ? data.fileSizeBytes.value
          : this.fileSizeBytes,
      isFileUploaded: data.isFileUploaded.present
          ? data.isFileUploaded.value
          : this.isFileUploaded,
      syncCreatedAt: data.syncCreatedAt.present
          ? data.syncCreatedAt.value
          : this.syncCreatedAt,
      syncUpdatedAt: data.syncUpdatedAt.present
          ? data.syncUpdatedAt.value
          : this.syncUpdatedAt,
      syncDeletedAt: data.syncDeletedAt.present
          ? data.syncDeletedAt.value
          : this.syncDeletedAt,
      syncLastSyncedAt: data.syncLastSyncedAt.present
          ? data.syncLastSyncedAt.value
          : this.syncLastSyncedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      syncVersion: data.syncVersion.present
          ? data.syncVersion.value
          : this.syncVersion,
      syncDeviceId: data.syncDeviceId.present
          ? data.syncDeviceId.value
          : this.syncDeviceId,
      syncIsDirty: data.syncIsDirty.present
          ? data.syncIsDirty.value
          : this.syncIsDirty,
      conflictData: data.conflictData.present
          ? data.conflictData.value
          : this.conflictData,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConditionLogRow(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('profileId: $profileId, ')
          ..write('conditionId: $conditionId, ')
          ..write('timestamp: $timestamp, ')
          ..write('severity: $severity, ')
          ..write('isFlare: $isFlare, ')
          ..write('flarePhotoIds: $flarePhotoIds, ')
          ..write('notes: $notes, ')
          ..write('photoPath: $photoPath, ')
          ..write('activityId: $activityId, ')
          ..write('triggers: $triggers, ')
          ..write('cloudStorageUrl: $cloudStorageUrl, ')
          ..write('fileHash: $fileHash, ')
          ..write('fileSizeBytes: $fileSizeBytes, ')
          ..write('isFileUploaded: $isFileUploaded, ')
          ..write('syncCreatedAt: $syncCreatedAt, ')
          ..write('syncUpdatedAt: $syncUpdatedAt, ')
          ..write('syncDeletedAt: $syncDeletedAt, ')
          ..write('syncLastSyncedAt: $syncLastSyncedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncVersion: $syncVersion, ')
          ..write('syncDeviceId: $syncDeviceId, ')
          ..write('syncIsDirty: $syncIsDirty, ')
          ..write('conflictData: $conflictData')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    clientId,
    profileId,
    conditionId,
    timestamp,
    severity,
    isFlare,
    flarePhotoIds,
    notes,
    photoPath,
    activityId,
    triggers,
    cloudStorageUrl,
    fileHash,
    fileSizeBytes,
    isFileUploaded,
    syncCreatedAt,
    syncUpdatedAt,
    syncDeletedAt,
    syncLastSyncedAt,
    syncStatus,
    syncVersion,
    syncDeviceId,
    syncIsDirty,
    conflictData,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConditionLogRow &&
          other.id == this.id &&
          other.clientId == this.clientId &&
          other.profileId == this.profileId &&
          other.conditionId == this.conditionId &&
          other.timestamp == this.timestamp &&
          other.severity == this.severity &&
          other.isFlare == this.isFlare &&
          other.flarePhotoIds == this.flarePhotoIds &&
          other.notes == this.notes &&
          other.photoPath == this.photoPath &&
          other.activityId == this.activityId &&
          other.triggers == this.triggers &&
          other.cloudStorageUrl == this.cloudStorageUrl &&
          other.fileHash == this.fileHash &&
          other.fileSizeBytes == this.fileSizeBytes &&
          other.isFileUploaded == this.isFileUploaded &&
          other.syncCreatedAt == this.syncCreatedAt &&
          other.syncUpdatedAt == this.syncUpdatedAt &&
          other.syncDeletedAt == this.syncDeletedAt &&
          other.syncLastSyncedAt == this.syncLastSyncedAt &&
          other.syncStatus == this.syncStatus &&
          other.syncVersion == this.syncVersion &&
          other.syncDeviceId == this.syncDeviceId &&
          other.syncIsDirty == this.syncIsDirty &&
          other.conflictData == this.conflictData);
}

class ConditionLogsCompanion extends UpdateCompanion<ConditionLogRow> {
  final Value<String> id;
  final Value<String> clientId;
  final Value<String> profileId;
  final Value<String> conditionId;
  final Value<int> timestamp;
  final Value<int> severity;
  final Value<bool> isFlare;
  final Value<String> flarePhotoIds;
  final Value<String?> notes;
  final Value<String?> photoPath;
  final Value<String?> activityId;
  final Value<String?> triggers;
  final Value<String?> cloudStorageUrl;
  final Value<String?> fileHash;
  final Value<int?> fileSizeBytes;
  final Value<bool> isFileUploaded;
  final Value<int> syncCreatedAt;
  final Value<int?> syncUpdatedAt;
  final Value<int?> syncDeletedAt;
  final Value<int?> syncLastSyncedAt;
  final Value<int> syncStatus;
  final Value<int> syncVersion;
  final Value<String?> syncDeviceId;
  final Value<bool> syncIsDirty;
  final Value<String?> conflictData;
  final Value<int> rowid;
  const ConditionLogsCompanion({
    this.id = const Value.absent(),
    this.clientId = const Value.absent(),
    this.profileId = const Value.absent(),
    this.conditionId = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.severity = const Value.absent(),
    this.isFlare = const Value.absent(),
    this.flarePhotoIds = const Value.absent(),
    this.notes = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.activityId = const Value.absent(),
    this.triggers = const Value.absent(),
    this.cloudStorageUrl = const Value.absent(),
    this.fileHash = const Value.absent(),
    this.fileSizeBytes = const Value.absent(),
    this.isFileUploaded = const Value.absent(),
    this.syncCreatedAt = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
    this.syncDeletedAt = const Value.absent(),
    this.syncLastSyncedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncVersion = const Value.absent(),
    this.syncDeviceId = const Value.absent(),
    this.syncIsDirty = const Value.absent(),
    this.conflictData = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ConditionLogsCompanion.insert({
    required String id,
    required String clientId,
    required String profileId,
    required String conditionId,
    required int timestamp,
    required int severity,
    required bool isFlare,
    this.flarePhotoIds = const Value.absent(),
    this.notes = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.activityId = const Value.absent(),
    this.triggers = const Value.absent(),
    this.cloudStorageUrl = const Value.absent(),
    this.fileHash = const Value.absent(),
    this.fileSizeBytes = const Value.absent(),
    this.isFileUploaded = const Value.absent(),
    required int syncCreatedAt,
    this.syncUpdatedAt = const Value.absent(),
    this.syncDeletedAt = const Value.absent(),
    this.syncLastSyncedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncVersion = const Value.absent(),
    this.syncDeviceId = const Value.absent(),
    this.syncIsDirty = const Value.absent(),
    this.conflictData = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       clientId = Value(clientId),
       profileId = Value(profileId),
       conditionId = Value(conditionId),
       timestamp = Value(timestamp),
       severity = Value(severity),
       isFlare = Value(isFlare),
       syncCreatedAt = Value(syncCreatedAt);
  static Insertable<ConditionLogRow> custom({
    Expression<String>? id,
    Expression<String>? clientId,
    Expression<String>? profileId,
    Expression<String>? conditionId,
    Expression<int>? timestamp,
    Expression<int>? severity,
    Expression<bool>? isFlare,
    Expression<String>? flarePhotoIds,
    Expression<String>? notes,
    Expression<String>? photoPath,
    Expression<String>? activityId,
    Expression<String>? triggers,
    Expression<String>? cloudStorageUrl,
    Expression<String>? fileHash,
    Expression<int>? fileSizeBytes,
    Expression<bool>? isFileUploaded,
    Expression<int>? syncCreatedAt,
    Expression<int>? syncUpdatedAt,
    Expression<int>? syncDeletedAt,
    Expression<int>? syncLastSyncedAt,
    Expression<int>? syncStatus,
    Expression<int>? syncVersion,
    Expression<String>? syncDeviceId,
    Expression<bool>? syncIsDirty,
    Expression<String>? conflictData,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clientId != null) 'client_id': clientId,
      if (profileId != null) 'profile_id': profileId,
      if (conditionId != null) 'condition_id': conditionId,
      if (timestamp != null) 'timestamp': timestamp,
      if (severity != null) 'severity': severity,
      if (isFlare != null) 'is_flare': isFlare,
      if (flarePhotoIds != null) 'flare_photo_ids': flarePhotoIds,
      if (notes != null) 'notes': notes,
      if (photoPath != null) 'photo_path': photoPath,
      if (activityId != null) 'activity_id': activityId,
      if (triggers != null) 'triggers': triggers,
      if (cloudStorageUrl != null) 'cloud_storage_url': cloudStorageUrl,
      if (fileHash != null) 'file_hash': fileHash,
      if (fileSizeBytes != null) 'file_size_bytes': fileSizeBytes,
      if (isFileUploaded != null) 'is_file_uploaded': isFileUploaded,
      if (syncCreatedAt != null) 'sync_created_at': syncCreatedAt,
      if (syncUpdatedAt != null) 'sync_updated_at': syncUpdatedAt,
      if (syncDeletedAt != null) 'sync_deleted_at': syncDeletedAt,
      if (syncLastSyncedAt != null) 'sync_last_synced_at': syncLastSyncedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncVersion != null) 'sync_version': syncVersion,
      if (syncDeviceId != null) 'sync_device_id': syncDeviceId,
      if (syncIsDirty != null) 'sync_is_dirty': syncIsDirty,
      if (conflictData != null) 'conflict_data': conflictData,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ConditionLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? clientId,
    Value<String>? profileId,
    Value<String>? conditionId,
    Value<int>? timestamp,
    Value<int>? severity,
    Value<bool>? isFlare,
    Value<String>? flarePhotoIds,
    Value<String?>? notes,
    Value<String?>? photoPath,
    Value<String?>? activityId,
    Value<String?>? triggers,
    Value<String?>? cloudStorageUrl,
    Value<String?>? fileHash,
    Value<int?>? fileSizeBytes,
    Value<bool>? isFileUploaded,
    Value<int>? syncCreatedAt,
    Value<int?>? syncUpdatedAt,
    Value<int?>? syncDeletedAt,
    Value<int?>? syncLastSyncedAt,
    Value<int>? syncStatus,
    Value<int>? syncVersion,
    Value<String?>? syncDeviceId,
    Value<bool>? syncIsDirty,
    Value<String?>? conflictData,
    Value<int>? rowid,
  }) {
    return ConditionLogsCompanion(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      profileId: profileId ?? this.profileId,
      conditionId: conditionId ?? this.conditionId,
      timestamp: timestamp ?? this.timestamp,
      severity: severity ?? this.severity,
      isFlare: isFlare ?? this.isFlare,
      flarePhotoIds: flarePhotoIds ?? this.flarePhotoIds,
      notes: notes ?? this.notes,
      photoPath: photoPath ?? this.photoPath,
      activityId: activityId ?? this.activityId,
      triggers: triggers ?? this.triggers,
      cloudStorageUrl: cloudStorageUrl ?? this.cloudStorageUrl,
      fileHash: fileHash ?? this.fileHash,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
      isFileUploaded: isFileUploaded ?? this.isFileUploaded,
      syncCreatedAt: syncCreatedAt ?? this.syncCreatedAt,
      syncUpdatedAt: syncUpdatedAt ?? this.syncUpdatedAt,
      syncDeletedAt: syncDeletedAt ?? this.syncDeletedAt,
      syncLastSyncedAt: syncLastSyncedAt ?? this.syncLastSyncedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      syncVersion: syncVersion ?? this.syncVersion,
      syncDeviceId: syncDeviceId ?? this.syncDeviceId,
      syncIsDirty: syncIsDirty ?? this.syncIsDirty,
      conflictData: conflictData ?? this.conflictData,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (conditionId.present) {
      map['condition_id'] = Variable<String>(conditionId.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<int>(timestamp.value);
    }
    if (severity.present) {
      map['severity'] = Variable<int>(severity.value);
    }
    if (isFlare.present) {
      map['is_flare'] = Variable<bool>(isFlare.value);
    }
    if (flarePhotoIds.present) {
      map['flare_photo_ids'] = Variable<String>(flarePhotoIds.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (activityId.present) {
      map['activity_id'] = Variable<String>(activityId.value);
    }
    if (triggers.present) {
      map['triggers'] = Variable<String>(triggers.value);
    }
    if (cloudStorageUrl.present) {
      map['cloud_storage_url'] = Variable<String>(cloudStorageUrl.value);
    }
    if (fileHash.present) {
      map['file_hash'] = Variable<String>(fileHash.value);
    }
    if (fileSizeBytes.present) {
      map['file_size_bytes'] = Variable<int>(fileSizeBytes.value);
    }
    if (isFileUploaded.present) {
      map['is_file_uploaded'] = Variable<bool>(isFileUploaded.value);
    }
    if (syncCreatedAt.present) {
      map['sync_created_at'] = Variable<int>(syncCreatedAt.value);
    }
    if (syncUpdatedAt.present) {
      map['sync_updated_at'] = Variable<int>(syncUpdatedAt.value);
    }
    if (syncDeletedAt.present) {
      map['sync_deleted_at'] = Variable<int>(syncDeletedAt.value);
    }
    if (syncLastSyncedAt.present) {
      map['sync_last_synced_at'] = Variable<int>(syncLastSyncedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (syncVersion.present) {
      map['sync_version'] = Variable<int>(syncVersion.value);
    }
    if (syncDeviceId.present) {
      map['sync_device_id'] = Variable<String>(syncDeviceId.value);
    }
    if (syncIsDirty.present) {
      map['sync_is_dirty'] = Variable<bool>(syncIsDirty.value);
    }
    if (conflictData.present) {
      map['conflict_data'] = Variable<String>(conflictData.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConditionLogsCompanion(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('profileId: $profileId, ')
          ..write('conditionId: $conditionId, ')
          ..write('timestamp: $timestamp, ')
          ..write('severity: $severity, ')
          ..write('isFlare: $isFlare, ')
          ..write('flarePhotoIds: $flarePhotoIds, ')
          ..write('notes: $notes, ')
          ..write('photoPath: $photoPath, ')
          ..write('activityId: $activityId, ')
          ..write('triggers: $triggers, ')
          ..write('cloudStorageUrl: $cloudStorageUrl, ')
          ..write('fileHash: $fileHash, ')
          ..write('fileSizeBytes: $fileSizeBytes, ')
          ..write('isFileUploaded: $isFileUploaded, ')
          ..write('syncCreatedAt: $syncCreatedAt, ')
          ..write('syncUpdatedAt: $syncUpdatedAt, ')
          ..write('syncDeletedAt: $syncDeletedAt, ')
          ..write('syncLastSyncedAt: $syncLastSyncedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncVersion: $syncVersion, ')
          ..write('syncDeviceId: $syncDeviceId, ')
          ..write('syncIsDirty: $syncIsDirty, ')
          ..write('conflictData: $conflictData, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FluidsEntriesTable extends FluidsEntries
    with TableInfo<$FluidsEntriesTable, FluidsEntryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FluidsEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
    'client_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entryDateMeta = const VerificationMeta(
    'entryDate',
  );
  @override
  late final GeneratedColumn<int> entryDate = GeneratedColumn<int>(
    'entry_date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _waterIntakeMlMeta = const VerificationMeta(
    'waterIntakeMl',
  );
  @override
  late final GeneratedColumn<int> waterIntakeMl = GeneratedColumn<int>(
    'water_intake_ml',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _waterIntakeNotesMeta = const VerificationMeta(
    'waterIntakeNotes',
  );
  @override
  late final GeneratedColumn<String> waterIntakeNotes = GeneratedColumn<String>(
    'water_intake_notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hasBowelMovementMeta = const VerificationMeta(
    'hasBowelMovement',
  );
  @override
  late final GeneratedColumn<bool> hasBowelMovement = GeneratedColumn<bool>(
    'has_bowel_movement',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_bowel_movement" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _bowelConditionMeta = const VerificationMeta(
    'bowelCondition',
  );
  @override
  late final GeneratedColumn<int> bowelCondition = GeneratedColumn<int>(
    'bowel_condition',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bowelCustomConditionMeta =
      const VerificationMeta('bowelCustomCondition');
  @override
  late final GeneratedColumn<String> bowelCustomCondition =
      GeneratedColumn<String>(
        'bowel_custom_condition',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _bowelSizeMeta = const VerificationMeta(
    'bowelSize',
  );
  @override
  late final GeneratedColumn<int> bowelSize = GeneratedColumn<int>(
    'bowel_size',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bowelPhotoPathMeta = const VerificationMeta(
    'bowelPhotoPath',
  );
  @override
  late final GeneratedColumn<String> bowelPhotoPath = GeneratedColumn<String>(
    'bowel_photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hasUrineMovementMeta = const VerificationMeta(
    'hasUrineMovement',
  );
  @override
  late final GeneratedColumn<bool> hasUrineMovement = GeneratedColumn<bool>(
    'has_urine_movement',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_urine_movement" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _urineConditionMeta = const VerificationMeta(
    'urineCondition',
  );
  @override
  late final GeneratedColumn<int> urineCondition = GeneratedColumn<int>(
    'urine_condition',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _urineCustomConditionMeta =
      const VerificationMeta('urineCustomCondition');
  @override
  late final GeneratedColumn<String> urineCustomCondition =
      GeneratedColumn<String>(
        'urine_custom_condition',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _urineSizeMeta = const VerificationMeta(
    'urineSize',
  );
  @override
  late final GeneratedColumn<int> urineSize = GeneratedColumn<int>(
    'urine_size',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _urinePhotoPathMeta = const VerificationMeta(
    'urinePhotoPath',
  );
  @override
  late final GeneratedColumn<String> urinePhotoPath = GeneratedColumn<String>(
    'urine_photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _menstruationFlowMeta = const VerificationMeta(
    'menstruationFlow',
  );
  @override
  late final GeneratedColumn<int> menstruationFlow = GeneratedColumn<int>(
    'menstruation_flow',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _basalBodyTemperatureMeta =
      const VerificationMeta('basalBodyTemperature');
  @override
  late final GeneratedColumn<double> basalBodyTemperature =
      GeneratedColumn<double>(
        'basal_body_temperature',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _bbtRecordedTimeMeta = const VerificationMeta(
    'bbtRecordedTime',
  );
  @override
  late final GeneratedColumn<int> bbtRecordedTime = GeneratedColumn<int>(
    'bbt_recorded_time',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _otherFluidNameMeta = const VerificationMeta(
    'otherFluidName',
  );
  @override
  late final GeneratedColumn<String> otherFluidName = GeneratedColumn<String>(
    'other_fluid_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _otherFluidAmountMeta = const VerificationMeta(
    'otherFluidAmount',
  );
  @override
  late final GeneratedColumn<String> otherFluidAmount = GeneratedColumn<String>(
    'other_fluid_amount',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _otherFluidNotesMeta = const VerificationMeta(
    'otherFluidNotes',
  );
  @override
  late final GeneratedColumn<String> otherFluidNotes = GeneratedColumn<String>(
    'other_fluid_notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _importSourceMeta = const VerificationMeta(
    'importSource',
  );
  @override
  late final GeneratedColumn<String> importSource = GeneratedColumn<String>(
    'import_source',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _importExternalIdMeta = const VerificationMeta(
    'importExternalId',
  );
  @override
  late final GeneratedColumn<String> importExternalId = GeneratedColumn<String>(
    'import_external_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cloudStorageUrlMeta = const VerificationMeta(
    'cloudStorageUrl',
  );
  @override
  late final GeneratedColumn<String> cloudStorageUrl = GeneratedColumn<String>(
    'cloud_storage_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fileHashMeta = const VerificationMeta(
    'fileHash',
  );
  @override
  late final GeneratedColumn<String> fileHash = GeneratedColumn<String>(
    'file_hash',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fileSizeBytesMeta = const VerificationMeta(
    'fileSizeBytes',
  );
  @override
  late final GeneratedColumn<int> fileSizeBytes = GeneratedColumn<int>(
    'file_size_bytes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isFileUploadedMeta = const VerificationMeta(
    'isFileUploaded',
  );
  @override
  late final GeneratedColumn<bool> isFileUploaded = GeneratedColumn<bool>(
    'is_file_uploaded',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_file_uploaded" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _photoIdsMeta = const VerificationMeta(
    'photoIds',
  );
  @override
  late final GeneratedColumn<String> photoIds = GeneratedColumn<String>(
    'photo_ids',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _syncCreatedAtMeta = const VerificationMeta(
    'syncCreatedAt',
  );
  @override
  late final GeneratedColumn<int> syncCreatedAt = GeneratedColumn<int>(
    'sync_created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncUpdatedAtMeta = const VerificationMeta(
    'syncUpdatedAt',
  );
  @override
  late final GeneratedColumn<int> syncUpdatedAt = GeneratedColumn<int>(
    'sync_updated_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncDeletedAtMeta = const VerificationMeta(
    'syncDeletedAt',
  );
  @override
  late final GeneratedColumn<int> syncDeletedAt = GeneratedColumn<int>(
    'sync_deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncLastSyncedAtMeta = const VerificationMeta(
    'syncLastSyncedAt',
  );
  @override
  late final GeneratedColumn<int> syncLastSyncedAt = GeneratedColumn<int>(
    'sync_last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _syncVersionMeta = const VerificationMeta(
    'syncVersion',
  );
  @override
  late final GeneratedColumn<int> syncVersion = GeneratedColumn<int>(
    'sync_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _syncDeviceIdMeta = const VerificationMeta(
    'syncDeviceId',
  );
  @override
  late final GeneratedColumn<String> syncDeviceId = GeneratedColumn<String>(
    'sync_device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncIsDirtyMeta = const VerificationMeta(
    'syncIsDirty',
  );
  @override
  late final GeneratedColumn<bool> syncIsDirty = GeneratedColumn<bool>(
    'sync_is_dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sync_is_dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _conflictDataMeta = const VerificationMeta(
    'conflictData',
  );
  @override
  late final GeneratedColumn<String> conflictData = GeneratedColumn<String>(
    'conflict_data',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    clientId,
    profileId,
    entryDate,
    waterIntakeMl,
    waterIntakeNotes,
    hasBowelMovement,
    bowelCondition,
    bowelCustomCondition,
    bowelSize,
    bowelPhotoPath,
    hasUrineMovement,
    urineCondition,
    urineCustomCondition,
    urineSize,
    urinePhotoPath,
    menstruationFlow,
    basalBodyTemperature,
    bbtRecordedTime,
    otherFluidName,
    otherFluidAmount,
    otherFluidNotes,
    importSource,
    importExternalId,
    cloudStorageUrl,
    fileHash,
    fileSizeBytes,
    isFileUploaded,
    notes,
    photoIds,
    syncCreatedAt,
    syncUpdatedAt,
    syncDeletedAt,
    syncLastSyncedAt,
    syncStatus,
    syncVersion,
    syncDeviceId,
    syncIsDirty,
    conflictData,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fluids_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<FluidsEntryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('entry_date')) {
      context.handle(
        _entryDateMeta,
        entryDate.isAcceptableOrUnknown(data['entry_date']!, _entryDateMeta),
      );
    } else if (isInserting) {
      context.missing(_entryDateMeta);
    }
    if (data.containsKey('water_intake_ml')) {
      context.handle(
        _waterIntakeMlMeta,
        waterIntakeMl.isAcceptableOrUnknown(
          data['water_intake_ml']!,
          _waterIntakeMlMeta,
        ),
      );
    }
    if (data.containsKey('water_intake_notes')) {
      context.handle(
        _waterIntakeNotesMeta,
        waterIntakeNotes.isAcceptableOrUnknown(
          data['water_intake_notes']!,
          _waterIntakeNotesMeta,
        ),
      );
    }
    if (data.containsKey('has_bowel_movement')) {
      context.handle(
        _hasBowelMovementMeta,
        hasBowelMovement.isAcceptableOrUnknown(
          data['has_bowel_movement']!,
          _hasBowelMovementMeta,
        ),
      );
    }
    if (data.containsKey('bowel_condition')) {
      context.handle(
        _bowelConditionMeta,
        bowelCondition.isAcceptableOrUnknown(
          data['bowel_condition']!,
          _bowelConditionMeta,
        ),
      );
    }
    if (data.containsKey('bowel_custom_condition')) {
      context.handle(
        _bowelCustomConditionMeta,
        bowelCustomCondition.isAcceptableOrUnknown(
          data['bowel_custom_condition']!,
          _bowelCustomConditionMeta,
        ),
      );
    }
    if (data.containsKey('bowel_size')) {
      context.handle(
        _bowelSizeMeta,
        bowelSize.isAcceptableOrUnknown(data['bowel_size']!, _bowelSizeMeta),
      );
    }
    if (data.containsKey('bowel_photo_path')) {
      context.handle(
        _bowelPhotoPathMeta,
        bowelPhotoPath.isAcceptableOrUnknown(
          data['bowel_photo_path']!,
          _bowelPhotoPathMeta,
        ),
      );
    }
    if (data.containsKey('has_urine_movement')) {
      context.handle(
        _hasUrineMovementMeta,
        hasUrineMovement.isAcceptableOrUnknown(
          data['has_urine_movement']!,
          _hasUrineMovementMeta,
        ),
      );
    }
    if (data.containsKey('urine_condition')) {
      context.handle(
        _urineConditionMeta,
        urineCondition.isAcceptableOrUnknown(
          data['urine_condition']!,
          _urineConditionMeta,
        ),
      );
    }
    if (data.containsKey('urine_custom_condition')) {
      context.handle(
        _urineCustomConditionMeta,
        urineCustomCondition.isAcceptableOrUnknown(
          data['urine_custom_condition']!,
          _urineCustomConditionMeta,
        ),
      );
    }
    if (data.containsKey('urine_size')) {
      context.handle(
        _urineSizeMeta,
        urineSize.isAcceptableOrUnknown(data['urine_size']!, _urineSizeMeta),
      );
    }
    if (data.containsKey('urine_photo_path')) {
      context.handle(
        _urinePhotoPathMeta,
        urinePhotoPath.isAcceptableOrUnknown(
          data['urine_photo_path']!,
          _urinePhotoPathMeta,
        ),
      );
    }
    if (data.containsKey('menstruation_flow')) {
      context.handle(
        _menstruationFlowMeta,
        menstruationFlow.isAcceptableOrUnknown(
          data['menstruation_flow']!,
          _menstruationFlowMeta,
        ),
      );
    }
    if (data.containsKey('basal_body_temperature')) {
      context.handle(
        _basalBodyTemperatureMeta,
        basalBodyTemperature.isAcceptableOrUnknown(
          data['basal_body_temperature']!,
          _basalBodyTemperatureMeta,
        ),
      );
    }
    if (data.containsKey('bbt_recorded_time')) {
      context.handle(
        _bbtRecordedTimeMeta,
        bbtRecordedTime.isAcceptableOrUnknown(
          data['bbt_recorded_time']!,
          _bbtRecordedTimeMeta,
        ),
      );
    }
    if (data.containsKey('other_fluid_name')) {
      context.handle(
        _otherFluidNameMeta,
        otherFluidName.isAcceptableOrUnknown(
          data['other_fluid_name']!,
          _otherFluidNameMeta,
        ),
      );
    }
    if (data.containsKey('other_fluid_amount')) {
      context.handle(
        _otherFluidAmountMeta,
        otherFluidAmount.isAcceptableOrUnknown(
          data['other_fluid_amount']!,
          _otherFluidAmountMeta,
        ),
      );
    }
    if (data.containsKey('other_fluid_notes')) {
      context.handle(
        _otherFluidNotesMeta,
        otherFluidNotes.isAcceptableOrUnknown(
          data['other_fluid_notes']!,
          _otherFluidNotesMeta,
        ),
      );
    }
    if (data.containsKey('import_source')) {
      context.handle(
        _importSourceMeta,
        importSource.isAcceptableOrUnknown(
          data['import_source']!,
          _importSourceMeta,
        ),
      );
    }
    if (data.containsKey('import_external_id')) {
      context.handle(
        _importExternalIdMeta,
        importExternalId.isAcceptableOrUnknown(
          data['import_external_id']!,
          _importExternalIdMeta,
        ),
      );
    }
    if (data.containsKey('cloud_storage_url')) {
      context.handle(
        _cloudStorageUrlMeta,
        cloudStorageUrl.isAcceptableOrUnknown(
          data['cloud_storage_url']!,
          _cloudStorageUrlMeta,
        ),
      );
    }
    if (data.containsKey('file_hash')) {
      context.handle(
        _fileHashMeta,
        fileHash.isAcceptableOrUnknown(data['file_hash']!, _fileHashMeta),
      );
    }
    if (data.containsKey('file_size_bytes')) {
      context.handle(
        _fileSizeBytesMeta,
        fileSizeBytes.isAcceptableOrUnknown(
          data['file_size_bytes']!,
          _fileSizeBytesMeta,
        ),
      );
    }
    if (data.containsKey('is_file_uploaded')) {
      context.handle(
        _isFileUploadedMeta,
        isFileUploaded.isAcceptableOrUnknown(
          data['is_file_uploaded']!,
          _isFileUploadedMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('photo_ids')) {
      context.handle(
        _photoIdsMeta,
        photoIds.isAcceptableOrUnknown(data['photo_ids']!, _photoIdsMeta),
      );
    }
    if (data.containsKey('sync_created_at')) {
      context.handle(
        _syncCreatedAtMeta,
        syncCreatedAt.isAcceptableOrUnknown(
          data['sync_created_at']!,
          _syncCreatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_syncCreatedAtMeta);
    }
    if (data.containsKey('sync_updated_at')) {
      context.handle(
        _syncUpdatedAtMeta,
        syncUpdatedAt.isAcceptableOrUnknown(
          data['sync_updated_at']!,
          _syncUpdatedAtMeta,
        ),
      );
    }
    if (data.containsKey('sync_deleted_at')) {
      context.handle(
        _syncDeletedAtMeta,
        syncDeletedAt.isAcceptableOrUnknown(
          data['sync_deleted_at']!,
          _syncDeletedAtMeta,
        ),
      );
    }
    if (data.containsKey('sync_last_synced_at')) {
      context.handle(
        _syncLastSyncedAtMeta,
        syncLastSyncedAt.isAcceptableOrUnknown(
          data['sync_last_synced_at']!,
          _syncLastSyncedAtMeta,
        ),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('sync_version')) {
      context.handle(
        _syncVersionMeta,
        syncVersion.isAcceptableOrUnknown(
          data['sync_version']!,
          _syncVersionMeta,
        ),
      );
    }
    if (data.containsKey('sync_device_id')) {
      context.handle(
        _syncDeviceIdMeta,
        syncDeviceId.isAcceptableOrUnknown(
          data['sync_device_id']!,
          _syncDeviceIdMeta,
        ),
      );
    }
    if (data.containsKey('sync_is_dirty')) {
      context.handle(
        _syncIsDirtyMeta,
        syncIsDirty.isAcceptableOrUnknown(
          data['sync_is_dirty']!,
          _syncIsDirtyMeta,
        ),
      );
    }
    if (data.containsKey('conflict_data')) {
      context.handle(
        _conflictDataMeta,
        conflictData.isAcceptableOrUnknown(
          data['conflict_data']!,
          _conflictDataMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FluidsEntryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FluidsEntryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      entryDate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}entry_date'],
      )!,
      waterIntakeMl: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}water_intake_ml'],
      ),
      waterIntakeNotes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}water_intake_notes'],
      ),
      hasBowelMovement: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_bowel_movement'],
      )!,
      bowelCondition: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bowel_condition'],
      ),
      bowelCustomCondition: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bowel_custom_condition'],
      ),
      bowelSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bowel_size'],
      ),
      bowelPhotoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bowel_photo_path'],
      ),
      hasUrineMovement: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_urine_movement'],
      )!,
      urineCondition: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}urine_condition'],
      ),
      urineCustomCondition: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}urine_custom_condition'],
      ),
      urineSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}urine_size'],
      ),
      urinePhotoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}urine_photo_path'],
      ),
      menstruationFlow: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}menstruation_flow'],
      ),
      basalBodyTemperature: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}basal_body_temperature'],
      ),
      bbtRecordedTime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bbt_recorded_time'],
      ),
      otherFluidName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}other_fluid_name'],
      ),
      otherFluidAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}other_fluid_amount'],
      ),
      otherFluidNotes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}other_fluid_notes'],
      ),
      importSource: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}import_source'],
      ),
      importExternalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}import_external_id'],
      ),
      cloudStorageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cloud_storage_url'],
      ),
      fileHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_hash'],
      ),
      fileSizeBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}file_size_bytes'],
      ),
      isFileUploaded: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_file_uploaded'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      photoIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_ids'],
      )!,
      syncCreatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_created_at'],
      )!,
      syncUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_updated_at'],
      ),
      syncDeletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_deleted_at'],
      ),
      syncLastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_last_synced_at'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_status'],
      )!,
      syncVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_version'],
      )!,
      syncDeviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_device_id'],
      ),
      syncIsDirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sync_is_dirty'],
      )!,
      conflictData: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conflict_data'],
      ),
    );
  }

  @override
  $FluidsEntriesTable createAlias(String alias) {
    return $FluidsEntriesTable(attachedDatabase, alias);
  }
}

class FluidsEntryRow extends DataClass implements Insertable<FluidsEntryRow> {
  final String id;
  final String clientId;
  final String profileId;
  final int entryDate;
  final int? waterIntakeMl;
  final String? waterIntakeNotes;
  final bool hasBowelMovement;
  final int? bowelCondition;
  final String? bowelCustomCondition;
  final int? bowelSize;
  final String? bowelPhotoPath;
  final bool hasUrineMovement;
  final int? urineCondition;
  final String? urineCustomCondition;
  final int? urineSize;
  final String? urinePhotoPath;
  final int? menstruationFlow;
  final double? basalBodyTemperature;
  final int? bbtRecordedTime;
  final String? otherFluidName;
  final String? otherFluidAmount;
  final String? otherFluidNotes;
  final String? importSource;
  final String? importExternalId;
  final String? cloudStorageUrl;
  final String? fileHash;
  final int? fileSizeBytes;
  final bool isFileUploaded;
  final String notes;
  final String photoIds;
  final int syncCreatedAt;
  final int? syncUpdatedAt;
  final int? syncDeletedAt;
  final int? syncLastSyncedAt;
  final int syncStatus;
  final int syncVersion;
  final String? syncDeviceId;
  final bool syncIsDirty;
  final String? conflictData;
  const FluidsEntryRow({
    required this.id,
    required this.clientId,
    required this.profileId,
    required this.entryDate,
    this.waterIntakeMl,
    this.waterIntakeNotes,
    required this.hasBowelMovement,
    this.bowelCondition,
    this.bowelCustomCondition,
    this.bowelSize,
    this.bowelPhotoPath,
    required this.hasUrineMovement,
    this.urineCondition,
    this.urineCustomCondition,
    this.urineSize,
    this.urinePhotoPath,
    this.menstruationFlow,
    this.basalBodyTemperature,
    this.bbtRecordedTime,
    this.otherFluidName,
    this.otherFluidAmount,
    this.otherFluidNotes,
    this.importSource,
    this.importExternalId,
    this.cloudStorageUrl,
    this.fileHash,
    this.fileSizeBytes,
    required this.isFileUploaded,
    required this.notes,
    required this.photoIds,
    required this.syncCreatedAt,
    this.syncUpdatedAt,
    this.syncDeletedAt,
    this.syncLastSyncedAt,
    required this.syncStatus,
    required this.syncVersion,
    this.syncDeviceId,
    required this.syncIsDirty,
    this.conflictData,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['client_id'] = Variable<String>(clientId);
    map['profile_id'] = Variable<String>(profileId);
    map['entry_date'] = Variable<int>(entryDate);
    if (!nullToAbsent || waterIntakeMl != null) {
      map['water_intake_ml'] = Variable<int>(waterIntakeMl);
    }
    if (!nullToAbsent || waterIntakeNotes != null) {
      map['water_intake_notes'] = Variable<String>(waterIntakeNotes);
    }
    map['has_bowel_movement'] = Variable<bool>(hasBowelMovement);
    if (!nullToAbsent || bowelCondition != null) {
      map['bowel_condition'] = Variable<int>(bowelCondition);
    }
    if (!nullToAbsent || bowelCustomCondition != null) {
      map['bowel_custom_condition'] = Variable<String>(bowelCustomCondition);
    }
    if (!nullToAbsent || bowelSize != null) {
      map['bowel_size'] = Variable<int>(bowelSize);
    }
    if (!nullToAbsent || bowelPhotoPath != null) {
      map['bowel_photo_path'] = Variable<String>(bowelPhotoPath);
    }
    map['has_urine_movement'] = Variable<bool>(hasUrineMovement);
    if (!nullToAbsent || urineCondition != null) {
      map['urine_condition'] = Variable<int>(urineCondition);
    }
    if (!nullToAbsent || urineCustomCondition != null) {
      map['urine_custom_condition'] = Variable<String>(urineCustomCondition);
    }
    if (!nullToAbsent || urineSize != null) {
      map['urine_size'] = Variable<int>(urineSize);
    }
    if (!nullToAbsent || urinePhotoPath != null) {
      map['urine_photo_path'] = Variable<String>(urinePhotoPath);
    }
    if (!nullToAbsent || menstruationFlow != null) {
      map['menstruation_flow'] = Variable<int>(menstruationFlow);
    }
    if (!nullToAbsent || basalBodyTemperature != null) {
      map['basal_body_temperature'] = Variable<double>(basalBodyTemperature);
    }
    if (!nullToAbsent || bbtRecordedTime != null) {
      map['bbt_recorded_time'] = Variable<int>(bbtRecordedTime);
    }
    if (!nullToAbsent || otherFluidName != null) {
      map['other_fluid_name'] = Variable<String>(otherFluidName);
    }
    if (!nullToAbsent || otherFluidAmount != null) {
      map['other_fluid_amount'] = Variable<String>(otherFluidAmount);
    }
    if (!nullToAbsent || otherFluidNotes != null) {
      map['other_fluid_notes'] = Variable<String>(otherFluidNotes);
    }
    if (!nullToAbsent || importSource != null) {
      map['import_source'] = Variable<String>(importSource);
    }
    if (!nullToAbsent || importExternalId != null) {
      map['import_external_id'] = Variable<String>(importExternalId);
    }
    if (!nullToAbsent || cloudStorageUrl != null) {
      map['cloud_storage_url'] = Variable<String>(cloudStorageUrl);
    }
    if (!nullToAbsent || fileHash != null) {
      map['file_hash'] = Variable<String>(fileHash);
    }
    if (!nullToAbsent || fileSizeBytes != null) {
      map['file_size_bytes'] = Variable<int>(fileSizeBytes);
    }
    map['is_file_uploaded'] = Variable<bool>(isFileUploaded);
    map['notes'] = Variable<String>(notes);
    map['photo_ids'] = Variable<String>(photoIds);
    map['sync_created_at'] = Variable<int>(syncCreatedAt);
    if (!nullToAbsent || syncUpdatedAt != null) {
      map['sync_updated_at'] = Variable<int>(syncUpdatedAt);
    }
    if (!nullToAbsent || syncDeletedAt != null) {
      map['sync_deleted_at'] = Variable<int>(syncDeletedAt);
    }
    if (!nullToAbsent || syncLastSyncedAt != null) {
      map['sync_last_synced_at'] = Variable<int>(syncLastSyncedAt);
    }
    map['sync_status'] = Variable<int>(syncStatus);
    map['sync_version'] = Variable<int>(syncVersion);
    if (!nullToAbsent || syncDeviceId != null) {
      map['sync_device_id'] = Variable<String>(syncDeviceId);
    }
    map['sync_is_dirty'] = Variable<bool>(syncIsDirty);
    if (!nullToAbsent || conflictData != null) {
      map['conflict_data'] = Variable<String>(conflictData);
    }
    return map;
  }

  FluidsEntriesCompanion toCompanion(bool nullToAbsent) {
    return FluidsEntriesCompanion(
      id: Value(id),
      clientId: Value(clientId),
      profileId: Value(profileId),
      entryDate: Value(entryDate),
      waterIntakeMl: waterIntakeMl == null && nullToAbsent
          ? const Value.absent()
          : Value(waterIntakeMl),
      waterIntakeNotes: waterIntakeNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(waterIntakeNotes),
      hasBowelMovement: Value(hasBowelMovement),
      bowelCondition: bowelCondition == null && nullToAbsent
          ? const Value.absent()
          : Value(bowelCondition),
      bowelCustomCondition: bowelCustomCondition == null && nullToAbsent
          ? const Value.absent()
          : Value(bowelCustomCondition),
      bowelSize: bowelSize == null && nullToAbsent
          ? const Value.absent()
          : Value(bowelSize),
      bowelPhotoPath: bowelPhotoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(bowelPhotoPath),
      hasUrineMovement: Value(hasUrineMovement),
      urineCondition: urineCondition == null && nullToAbsent
          ? const Value.absent()
          : Value(urineCondition),
      urineCustomCondition: urineCustomCondition == null && nullToAbsent
          ? const Value.absent()
          : Value(urineCustomCondition),
      urineSize: urineSize == null && nullToAbsent
          ? const Value.absent()
          : Value(urineSize),
      urinePhotoPath: urinePhotoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(urinePhotoPath),
      menstruationFlow: menstruationFlow == null && nullToAbsent
          ? const Value.absent()
          : Value(menstruationFlow),
      basalBodyTemperature: basalBodyTemperature == null && nullToAbsent
          ? const Value.absent()
          : Value(basalBodyTemperature),
      bbtRecordedTime: bbtRecordedTime == null && nullToAbsent
          ? const Value.absent()
          : Value(bbtRecordedTime),
      otherFluidName: otherFluidName == null && nullToAbsent
          ? const Value.absent()
          : Value(otherFluidName),
      otherFluidAmount: otherFluidAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(otherFluidAmount),
      otherFluidNotes: otherFluidNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(otherFluidNotes),
      importSource: importSource == null && nullToAbsent
          ? const Value.absent()
          : Value(importSource),
      importExternalId: importExternalId == null && nullToAbsent
          ? const Value.absent()
          : Value(importExternalId),
      cloudStorageUrl: cloudStorageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(cloudStorageUrl),
      fileHash: fileHash == null && nullToAbsent
          ? const Value.absent()
          : Value(fileHash),
      fileSizeBytes: fileSizeBytes == null && nullToAbsent
          ? const Value.absent()
          : Value(fileSizeBytes),
      isFileUploaded: Value(isFileUploaded),
      notes: Value(notes),
      photoIds: Value(photoIds),
      syncCreatedAt: Value(syncCreatedAt),
      syncUpdatedAt: syncUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncUpdatedAt),
      syncDeletedAt: syncDeletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncDeletedAt),
      syncLastSyncedAt: syncLastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncLastSyncedAt),
      syncStatus: Value(syncStatus),
      syncVersion: Value(syncVersion),
      syncDeviceId: syncDeviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(syncDeviceId),
      syncIsDirty: Value(syncIsDirty),
      conflictData: conflictData == null && nullToAbsent
          ? const Value.absent()
          : Value(conflictData),
    );
  }

  factory FluidsEntryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FluidsEntryRow(
      id: serializer.fromJson<String>(json['id']),
      clientId: serializer.fromJson<String>(json['clientId']),
      profileId: serializer.fromJson<String>(json['profileId']),
      entryDate: serializer.fromJson<int>(json['entryDate']),
      waterIntakeMl: serializer.fromJson<int?>(json['waterIntakeMl']),
      waterIntakeNotes: serializer.fromJson<String?>(json['waterIntakeNotes']),
      hasBowelMovement: serializer.fromJson<bool>(json['hasBowelMovement']),
      bowelCondition: serializer.fromJson<int?>(json['bowelCondition']),
      bowelCustomCondition: serializer.fromJson<String?>(
        json['bowelCustomCondition'],
      ),
      bowelSize: serializer.fromJson<int?>(json['bowelSize']),
      bowelPhotoPath: serializer.fromJson<String?>(json['bowelPhotoPath']),
      hasUrineMovement: serializer.fromJson<bool>(json['hasUrineMovement']),
      urineCondition: serializer.fromJson<int?>(json['urineCondition']),
      urineCustomCondition: serializer.fromJson<String?>(
        json['urineCustomCondition'],
      ),
      urineSize: serializer.fromJson<int?>(json['urineSize']),
      urinePhotoPath: serializer.fromJson<String?>(json['urinePhotoPath']),
      menstruationFlow: serializer.fromJson<int?>(json['menstruationFlow']),
      basalBodyTemperature: serializer.fromJson<double?>(
        json['basalBodyTemperature'],
      ),
      bbtRecordedTime: serializer.fromJson<int?>(json['bbtRecordedTime']),
      otherFluidName: serializer.fromJson<String?>(json['otherFluidName']),
      otherFluidAmount: serializer.fromJson<String?>(json['otherFluidAmount']),
      otherFluidNotes: serializer.fromJson<String?>(json['otherFluidNotes']),
      importSource: serializer.fromJson<String?>(json['importSource']),
      importExternalId: serializer.fromJson<String?>(json['importExternalId']),
      cloudStorageUrl: serializer.fromJson<String?>(json['cloudStorageUrl']),
      fileHash: serializer.fromJson<String?>(json['fileHash']),
      fileSizeBytes: serializer.fromJson<int?>(json['fileSizeBytes']),
      isFileUploaded: serializer.fromJson<bool>(json['isFileUploaded']),
      notes: serializer.fromJson<String>(json['notes']),
      photoIds: serializer.fromJson<String>(json['photoIds']),
      syncCreatedAt: serializer.fromJson<int>(json['syncCreatedAt']),
      syncUpdatedAt: serializer.fromJson<int?>(json['syncUpdatedAt']),
      syncDeletedAt: serializer.fromJson<int?>(json['syncDeletedAt']),
      syncLastSyncedAt: serializer.fromJson<int?>(json['syncLastSyncedAt']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
      syncVersion: serializer.fromJson<int>(json['syncVersion']),
      syncDeviceId: serializer.fromJson<String?>(json['syncDeviceId']),
      syncIsDirty: serializer.fromJson<bool>(json['syncIsDirty']),
      conflictData: serializer.fromJson<String?>(json['conflictData']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'clientId': serializer.toJson<String>(clientId),
      'profileId': serializer.toJson<String>(profileId),
      'entryDate': serializer.toJson<int>(entryDate),
      'waterIntakeMl': serializer.toJson<int?>(waterIntakeMl),
      'waterIntakeNotes': serializer.toJson<String?>(waterIntakeNotes),
      'hasBowelMovement': serializer.toJson<bool>(hasBowelMovement),
      'bowelCondition': serializer.toJson<int?>(bowelCondition),
      'bowelCustomCondition': serializer.toJson<String?>(bowelCustomCondition),
      'bowelSize': serializer.toJson<int?>(bowelSize),
      'bowelPhotoPath': serializer.toJson<String?>(bowelPhotoPath),
      'hasUrineMovement': serializer.toJson<bool>(hasUrineMovement),
      'urineCondition': serializer.toJson<int?>(urineCondition),
      'urineCustomCondition': serializer.toJson<String?>(urineCustomCondition),
      'urineSize': serializer.toJson<int?>(urineSize),
      'urinePhotoPath': serializer.toJson<String?>(urinePhotoPath),
      'menstruationFlow': serializer.toJson<int?>(menstruationFlow),
      'basalBodyTemperature': serializer.toJson<double?>(basalBodyTemperature),
      'bbtRecordedTime': serializer.toJson<int?>(bbtRecordedTime),
      'otherFluidName': serializer.toJson<String?>(otherFluidName),
      'otherFluidAmount': serializer.toJson<String?>(otherFluidAmount),
      'otherFluidNotes': serializer.toJson<String?>(otherFluidNotes),
      'importSource': serializer.toJson<String?>(importSource),
      'importExternalId': serializer.toJson<String?>(importExternalId),
      'cloudStorageUrl': serializer.toJson<String?>(cloudStorageUrl),
      'fileHash': serializer.toJson<String?>(fileHash),
      'fileSizeBytes': serializer.toJson<int?>(fileSizeBytes),
      'isFileUploaded': serializer.toJson<bool>(isFileUploaded),
      'notes': serializer.toJson<String>(notes),
      'photoIds': serializer.toJson<String>(photoIds),
      'syncCreatedAt': serializer.toJson<int>(syncCreatedAt),
      'syncUpdatedAt': serializer.toJson<int?>(syncUpdatedAt),
      'syncDeletedAt': serializer.toJson<int?>(syncDeletedAt),
      'syncLastSyncedAt': serializer.toJson<int?>(syncLastSyncedAt),
      'syncStatus': serializer.toJson<int>(syncStatus),
      'syncVersion': serializer.toJson<int>(syncVersion),
      'syncDeviceId': serializer.toJson<String?>(syncDeviceId),
      'syncIsDirty': serializer.toJson<bool>(syncIsDirty),
      'conflictData': serializer.toJson<String?>(conflictData),
    };
  }

  FluidsEntryRow copyWith({
    String? id,
    String? clientId,
    String? profileId,
    int? entryDate,
    Value<int?> waterIntakeMl = const Value.absent(),
    Value<String?> waterIntakeNotes = const Value.absent(),
    bool? hasBowelMovement,
    Value<int?> bowelCondition = const Value.absent(),
    Value<String?> bowelCustomCondition = const Value.absent(),
    Value<int?> bowelSize = const Value.absent(),
    Value<String?> bowelPhotoPath = const Value.absent(),
    bool? hasUrineMovement,
    Value<int?> urineCondition = const Value.absent(),
    Value<String?> urineCustomCondition = const Value.absent(),
    Value<int?> urineSize = const Value.absent(),
    Value<String?> urinePhotoPath = const Value.absent(),
    Value<int?> menstruationFlow = const Value.absent(),
    Value<double?> basalBodyTemperature = const Value.absent(),
    Value<int?> bbtRecordedTime = const Value.absent(),
    Value<String?> otherFluidName = const Value.absent(),
    Value<String?> otherFluidAmount = const Value.absent(),
    Value<String?> otherFluidNotes = const Value.absent(),
    Value<String?> importSource = const Value.absent(),
    Value<String?> importExternalId = const Value.absent(),
    Value<String?> cloudStorageUrl = const Value.absent(),
    Value<String?> fileHash = const Value.absent(),
    Value<int?> fileSizeBytes = const Value.absent(),
    bool? isFileUploaded,
    String? notes,
    String? photoIds,
    int? syncCreatedAt,
    Value<int?> syncUpdatedAt = const Value.absent(),
    Value<int?> syncDeletedAt = const Value.absent(),
    Value<int?> syncLastSyncedAt = const Value.absent(),
    int? syncStatus,
    int? syncVersion,
    Value<String?> syncDeviceId = const Value.absent(),
    bool? syncIsDirty,
    Value<String?> conflictData = const Value.absent(),
  }) => FluidsEntryRow(
    id: id ?? this.id,
    clientId: clientId ?? this.clientId,
    profileId: profileId ?? this.profileId,
    entryDate: entryDate ?? this.entryDate,
    waterIntakeMl: waterIntakeMl.present
        ? waterIntakeMl.value
        : this.waterIntakeMl,
    waterIntakeNotes: waterIntakeNotes.present
        ? waterIntakeNotes.value
        : this.waterIntakeNotes,
    hasBowelMovement: hasBowelMovement ?? this.hasBowelMovement,
    bowelCondition: bowelCondition.present
        ? bowelCondition.value
        : this.bowelCondition,
    bowelCustomCondition: bowelCustomCondition.present
        ? bowelCustomCondition.value
        : this.bowelCustomCondition,
    bowelSize: bowelSize.present ? bowelSize.value : this.bowelSize,
    bowelPhotoPath: bowelPhotoPath.present
        ? bowelPhotoPath.value
        : this.bowelPhotoPath,
    hasUrineMovement: hasUrineMovement ?? this.hasUrineMovement,
    urineCondition: urineCondition.present
        ? urineCondition.value
        : this.urineCondition,
    urineCustomCondition: urineCustomCondition.present
        ? urineCustomCondition.value
        : this.urineCustomCondition,
    urineSize: urineSize.present ? urineSize.value : this.urineSize,
    urinePhotoPath: urinePhotoPath.present
        ? urinePhotoPath.value
        : this.urinePhotoPath,
    menstruationFlow: menstruationFlow.present
        ? menstruationFlow.value
        : this.menstruationFlow,
    basalBodyTemperature: basalBodyTemperature.present
        ? basalBodyTemperature.value
        : this.basalBodyTemperature,
    bbtRecordedTime: bbtRecordedTime.present
        ? bbtRecordedTime.value
        : this.bbtRecordedTime,
    otherFluidName: otherFluidName.present
        ? otherFluidName.value
        : this.otherFluidName,
    otherFluidAmount: otherFluidAmount.present
        ? otherFluidAmount.value
        : this.otherFluidAmount,
    otherFluidNotes: otherFluidNotes.present
        ? otherFluidNotes.value
        : this.otherFluidNotes,
    importSource: importSource.present ? importSource.value : this.importSource,
    importExternalId: importExternalId.present
        ? importExternalId.value
        : this.importExternalId,
    cloudStorageUrl: cloudStorageUrl.present
        ? cloudStorageUrl.value
        : this.cloudStorageUrl,
    fileHash: fileHash.present ? fileHash.value : this.fileHash,
    fileSizeBytes: fileSizeBytes.present
        ? fileSizeBytes.value
        : this.fileSizeBytes,
    isFileUploaded: isFileUploaded ?? this.isFileUploaded,
    notes: notes ?? this.notes,
    photoIds: photoIds ?? this.photoIds,
    syncCreatedAt: syncCreatedAt ?? this.syncCreatedAt,
    syncUpdatedAt: syncUpdatedAt.present
        ? syncUpdatedAt.value
        : this.syncUpdatedAt,
    syncDeletedAt: syncDeletedAt.present
        ? syncDeletedAt.value
        : this.syncDeletedAt,
    syncLastSyncedAt: syncLastSyncedAt.present
        ? syncLastSyncedAt.value
        : this.syncLastSyncedAt,
    syncStatus: syncStatus ?? this.syncStatus,
    syncVersion: syncVersion ?? this.syncVersion,
    syncDeviceId: syncDeviceId.present ? syncDeviceId.value : this.syncDeviceId,
    syncIsDirty: syncIsDirty ?? this.syncIsDirty,
    conflictData: conflictData.present ? conflictData.value : this.conflictData,
  );
  FluidsEntryRow copyWithCompanion(FluidsEntriesCompanion data) {
    return FluidsEntryRow(
      id: data.id.present ? data.id.value : this.id,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      entryDate: data.entryDate.present ? data.entryDate.value : this.entryDate,
      waterIntakeMl: data.waterIntakeMl.present
          ? data.waterIntakeMl.value
          : this.waterIntakeMl,
      waterIntakeNotes: data.waterIntakeNotes.present
          ? data.waterIntakeNotes.value
          : this.waterIntakeNotes,
      hasBowelMovement: data.hasBowelMovement.present
          ? data.hasBowelMovement.value
          : this.hasBowelMovement,
      bowelCondition: data.bowelCondition.present
          ? data.bowelCondition.value
          : this.bowelCondition,
      bowelCustomCondition: data.bowelCustomCondition.present
          ? data.bowelCustomCondition.value
          : this.bowelCustomCondition,
      bowelSize: data.bowelSize.present ? data.bowelSize.value : this.bowelSize,
      bowelPhotoPath: data.bowelPhotoPath.present
          ? data.bowelPhotoPath.value
          : this.bowelPhotoPath,
      hasUrineMovement: data.hasUrineMovement.present
          ? data.hasUrineMovement.value
          : this.hasUrineMovement,
      urineCondition: data.urineCondition.present
          ? data.urineCondition.value
          : this.urineCondition,
      urineCustomCondition: data.urineCustomCondition.present
          ? data.urineCustomCondition.value
          : this.urineCustomCondition,
      urineSize: data.urineSize.present ? data.urineSize.value : this.urineSize,
      urinePhotoPath: data.urinePhotoPath.present
          ? data.urinePhotoPath.value
          : this.urinePhotoPath,
      menstruationFlow: data.menstruationFlow.present
          ? data.menstruationFlow.value
          : this.menstruationFlow,
      basalBodyTemperature: data.basalBodyTemperature.present
          ? data.basalBodyTemperature.value
          : this.basalBodyTemperature,
      bbtRecordedTime: data.bbtRecordedTime.present
          ? data.bbtRecordedTime.value
          : this.bbtRecordedTime,
      otherFluidName: data.otherFluidName.present
          ? data.otherFluidName.value
          : this.otherFluidName,
      otherFluidAmount: data.otherFluidAmount.present
          ? data.otherFluidAmount.value
          : this.otherFluidAmount,
      otherFluidNotes: data.otherFluidNotes.present
          ? data.otherFluidNotes.value
          : this.otherFluidNotes,
      importSource: data.importSource.present
          ? data.importSource.value
          : this.importSource,
      importExternalId: data.importExternalId.present
          ? data.importExternalId.value
          : this.importExternalId,
      cloudStorageUrl: data.cloudStorageUrl.present
          ? data.cloudStorageUrl.value
          : this.cloudStorageUrl,
      fileHash: data.fileHash.present ? data.fileHash.value : this.fileHash,
      fileSizeBytes: data.fileSizeBytes.present
          ? data.fileSizeBytes.value
          : this.fileSizeBytes,
      isFileUploaded: data.isFileUploaded.present
          ? data.isFileUploaded.value
          : this.isFileUploaded,
      notes: data.notes.present ? data.notes.value : this.notes,
      photoIds: data.photoIds.present ? data.photoIds.value : this.photoIds,
      syncCreatedAt: data.syncCreatedAt.present
          ? data.syncCreatedAt.value
          : this.syncCreatedAt,
      syncUpdatedAt: data.syncUpdatedAt.present
          ? data.syncUpdatedAt.value
          : this.syncUpdatedAt,
      syncDeletedAt: data.syncDeletedAt.present
          ? data.syncDeletedAt.value
          : this.syncDeletedAt,
      syncLastSyncedAt: data.syncLastSyncedAt.present
          ? data.syncLastSyncedAt.value
          : this.syncLastSyncedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      syncVersion: data.syncVersion.present
          ? data.syncVersion.value
          : this.syncVersion,
      syncDeviceId: data.syncDeviceId.present
          ? data.syncDeviceId.value
          : this.syncDeviceId,
      syncIsDirty: data.syncIsDirty.present
          ? data.syncIsDirty.value
          : this.syncIsDirty,
      conflictData: data.conflictData.present
          ? data.conflictData.value
          : this.conflictData,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FluidsEntryRow(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('profileId: $profileId, ')
          ..write('entryDate: $entryDate, ')
          ..write('waterIntakeMl: $waterIntakeMl, ')
          ..write('waterIntakeNotes: $waterIntakeNotes, ')
          ..write('hasBowelMovement: $hasBowelMovement, ')
          ..write('bowelCondition: $bowelCondition, ')
          ..write('bowelCustomCondition: $bowelCustomCondition, ')
          ..write('bowelSize: $bowelSize, ')
          ..write('bowelPhotoPath: $bowelPhotoPath, ')
          ..write('hasUrineMovement: $hasUrineMovement, ')
          ..write('urineCondition: $urineCondition, ')
          ..write('urineCustomCondition: $urineCustomCondition, ')
          ..write('urineSize: $urineSize, ')
          ..write('urinePhotoPath: $urinePhotoPath, ')
          ..write('menstruationFlow: $menstruationFlow, ')
          ..write('basalBodyTemperature: $basalBodyTemperature, ')
          ..write('bbtRecordedTime: $bbtRecordedTime, ')
          ..write('otherFluidName: $otherFluidName, ')
          ..write('otherFluidAmount: $otherFluidAmount, ')
          ..write('otherFluidNotes: $otherFluidNotes, ')
          ..write('importSource: $importSource, ')
          ..write('importExternalId: $importExternalId, ')
          ..write('cloudStorageUrl: $cloudStorageUrl, ')
          ..write('fileHash: $fileHash, ')
          ..write('fileSizeBytes: $fileSizeBytes, ')
          ..write('isFileUploaded: $isFileUploaded, ')
          ..write('notes: $notes, ')
          ..write('photoIds: $photoIds, ')
          ..write('syncCreatedAt: $syncCreatedAt, ')
          ..write('syncUpdatedAt: $syncUpdatedAt, ')
          ..write('syncDeletedAt: $syncDeletedAt, ')
          ..write('syncLastSyncedAt: $syncLastSyncedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncVersion: $syncVersion, ')
          ..write('syncDeviceId: $syncDeviceId, ')
          ..write('syncIsDirty: $syncIsDirty, ')
          ..write('conflictData: $conflictData')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    clientId,
    profileId,
    entryDate,
    waterIntakeMl,
    waterIntakeNotes,
    hasBowelMovement,
    bowelCondition,
    bowelCustomCondition,
    bowelSize,
    bowelPhotoPath,
    hasUrineMovement,
    urineCondition,
    urineCustomCondition,
    urineSize,
    urinePhotoPath,
    menstruationFlow,
    basalBodyTemperature,
    bbtRecordedTime,
    otherFluidName,
    otherFluidAmount,
    otherFluidNotes,
    importSource,
    importExternalId,
    cloudStorageUrl,
    fileHash,
    fileSizeBytes,
    isFileUploaded,
    notes,
    photoIds,
    syncCreatedAt,
    syncUpdatedAt,
    syncDeletedAt,
    syncLastSyncedAt,
    syncStatus,
    syncVersion,
    syncDeviceId,
    syncIsDirty,
    conflictData,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FluidsEntryRow &&
          other.id == this.id &&
          other.clientId == this.clientId &&
          other.profileId == this.profileId &&
          other.entryDate == this.entryDate &&
          other.waterIntakeMl == this.waterIntakeMl &&
          other.waterIntakeNotes == this.waterIntakeNotes &&
          other.hasBowelMovement == this.hasBowelMovement &&
          other.bowelCondition == this.bowelCondition &&
          other.bowelCustomCondition == this.bowelCustomCondition &&
          other.bowelSize == this.bowelSize &&
          other.bowelPhotoPath == this.bowelPhotoPath &&
          other.hasUrineMovement == this.hasUrineMovement &&
          other.urineCondition == this.urineCondition &&
          other.urineCustomCondition == this.urineCustomCondition &&
          other.urineSize == this.urineSize &&
          other.urinePhotoPath == this.urinePhotoPath &&
          other.menstruationFlow == this.menstruationFlow &&
          other.basalBodyTemperature == this.basalBodyTemperature &&
          other.bbtRecordedTime == this.bbtRecordedTime &&
          other.otherFluidName == this.otherFluidName &&
          other.otherFluidAmount == this.otherFluidAmount &&
          other.otherFluidNotes == this.otherFluidNotes &&
          other.importSource == this.importSource &&
          other.importExternalId == this.importExternalId &&
          other.cloudStorageUrl == this.cloudStorageUrl &&
          other.fileHash == this.fileHash &&
          other.fileSizeBytes == this.fileSizeBytes &&
          other.isFileUploaded == this.isFileUploaded &&
          other.notes == this.notes &&
          other.photoIds == this.photoIds &&
          other.syncCreatedAt == this.syncCreatedAt &&
          other.syncUpdatedAt == this.syncUpdatedAt &&
          other.syncDeletedAt == this.syncDeletedAt &&
          other.syncLastSyncedAt == this.syncLastSyncedAt &&
          other.syncStatus == this.syncStatus &&
          other.syncVersion == this.syncVersion &&
          other.syncDeviceId == this.syncDeviceId &&
          other.syncIsDirty == this.syncIsDirty &&
          other.conflictData == this.conflictData);
}

class FluidsEntriesCompanion extends UpdateCompanion<FluidsEntryRow> {
  final Value<String> id;
  final Value<String> clientId;
  final Value<String> profileId;
  final Value<int> entryDate;
  final Value<int?> waterIntakeMl;
  final Value<String?> waterIntakeNotes;
  final Value<bool> hasBowelMovement;
  final Value<int?> bowelCondition;
  final Value<String?> bowelCustomCondition;
  final Value<int?> bowelSize;
  final Value<String?> bowelPhotoPath;
  final Value<bool> hasUrineMovement;
  final Value<int?> urineCondition;
  final Value<String?> urineCustomCondition;
  final Value<int?> urineSize;
  final Value<String?> urinePhotoPath;
  final Value<int?> menstruationFlow;
  final Value<double?> basalBodyTemperature;
  final Value<int?> bbtRecordedTime;
  final Value<String?> otherFluidName;
  final Value<String?> otherFluidAmount;
  final Value<String?> otherFluidNotes;
  final Value<String?> importSource;
  final Value<String?> importExternalId;
  final Value<String?> cloudStorageUrl;
  final Value<String?> fileHash;
  final Value<int?> fileSizeBytes;
  final Value<bool> isFileUploaded;
  final Value<String> notes;
  final Value<String> photoIds;
  final Value<int> syncCreatedAt;
  final Value<int?> syncUpdatedAt;
  final Value<int?> syncDeletedAt;
  final Value<int?> syncLastSyncedAt;
  final Value<int> syncStatus;
  final Value<int> syncVersion;
  final Value<String?> syncDeviceId;
  final Value<bool> syncIsDirty;
  final Value<String?> conflictData;
  final Value<int> rowid;
  const FluidsEntriesCompanion({
    this.id = const Value.absent(),
    this.clientId = const Value.absent(),
    this.profileId = const Value.absent(),
    this.entryDate = const Value.absent(),
    this.waterIntakeMl = const Value.absent(),
    this.waterIntakeNotes = const Value.absent(),
    this.hasBowelMovement = const Value.absent(),
    this.bowelCondition = const Value.absent(),
    this.bowelCustomCondition = const Value.absent(),
    this.bowelSize = const Value.absent(),
    this.bowelPhotoPath = const Value.absent(),
    this.hasUrineMovement = const Value.absent(),
    this.urineCondition = const Value.absent(),
    this.urineCustomCondition = const Value.absent(),
    this.urineSize = const Value.absent(),
    this.urinePhotoPath = const Value.absent(),
    this.menstruationFlow = const Value.absent(),
    this.basalBodyTemperature = const Value.absent(),
    this.bbtRecordedTime = const Value.absent(),
    this.otherFluidName = const Value.absent(),
    this.otherFluidAmount = const Value.absent(),
    this.otherFluidNotes = const Value.absent(),
    this.importSource = const Value.absent(),
    this.importExternalId = const Value.absent(),
    this.cloudStorageUrl = const Value.absent(),
    this.fileHash = const Value.absent(),
    this.fileSizeBytes = const Value.absent(),
    this.isFileUploaded = const Value.absent(),
    this.notes = const Value.absent(),
    this.photoIds = const Value.absent(),
    this.syncCreatedAt = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
    this.syncDeletedAt = const Value.absent(),
    this.syncLastSyncedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncVersion = const Value.absent(),
    this.syncDeviceId = const Value.absent(),
    this.syncIsDirty = const Value.absent(),
    this.conflictData = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FluidsEntriesCompanion.insert({
    required String id,
    required String clientId,
    required String profileId,
    required int entryDate,
    this.waterIntakeMl = const Value.absent(),
    this.waterIntakeNotes = const Value.absent(),
    this.hasBowelMovement = const Value.absent(),
    this.bowelCondition = const Value.absent(),
    this.bowelCustomCondition = const Value.absent(),
    this.bowelSize = const Value.absent(),
    this.bowelPhotoPath = const Value.absent(),
    this.hasUrineMovement = const Value.absent(),
    this.urineCondition = const Value.absent(),
    this.urineCustomCondition = const Value.absent(),
    this.urineSize = const Value.absent(),
    this.urinePhotoPath = const Value.absent(),
    this.menstruationFlow = const Value.absent(),
    this.basalBodyTemperature = const Value.absent(),
    this.bbtRecordedTime = const Value.absent(),
    this.otherFluidName = const Value.absent(),
    this.otherFluidAmount = const Value.absent(),
    this.otherFluidNotes = const Value.absent(),
    this.importSource = const Value.absent(),
    this.importExternalId = const Value.absent(),
    this.cloudStorageUrl = const Value.absent(),
    this.fileHash = const Value.absent(),
    this.fileSizeBytes = const Value.absent(),
    this.isFileUploaded = const Value.absent(),
    this.notes = const Value.absent(),
    this.photoIds = const Value.absent(),
    required int syncCreatedAt,
    this.syncUpdatedAt = const Value.absent(),
    this.syncDeletedAt = const Value.absent(),
    this.syncLastSyncedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncVersion = const Value.absent(),
    this.syncDeviceId = const Value.absent(),
    this.syncIsDirty = const Value.absent(),
    this.conflictData = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       clientId = Value(clientId),
       profileId = Value(profileId),
       entryDate = Value(entryDate),
       syncCreatedAt = Value(syncCreatedAt);
  static Insertable<FluidsEntryRow> custom({
    Expression<String>? id,
    Expression<String>? clientId,
    Expression<String>? profileId,
    Expression<int>? entryDate,
    Expression<int>? waterIntakeMl,
    Expression<String>? waterIntakeNotes,
    Expression<bool>? hasBowelMovement,
    Expression<int>? bowelCondition,
    Expression<String>? bowelCustomCondition,
    Expression<int>? bowelSize,
    Expression<String>? bowelPhotoPath,
    Expression<bool>? hasUrineMovement,
    Expression<int>? urineCondition,
    Expression<String>? urineCustomCondition,
    Expression<int>? urineSize,
    Expression<String>? urinePhotoPath,
    Expression<int>? menstruationFlow,
    Expression<double>? basalBodyTemperature,
    Expression<int>? bbtRecordedTime,
    Expression<String>? otherFluidName,
    Expression<String>? otherFluidAmount,
    Expression<String>? otherFluidNotes,
    Expression<String>? importSource,
    Expression<String>? importExternalId,
    Expression<String>? cloudStorageUrl,
    Expression<String>? fileHash,
    Expression<int>? fileSizeBytes,
    Expression<bool>? isFileUploaded,
    Expression<String>? notes,
    Expression<String>? photoIds,
    Expression<int>? syncCreatedAt,
    Expression<int>? syncUpdatedAt,
    Expression<int>? syncDeletedAt,
    Expression<int>? syncLastSyncedAt,
    Expression<int>? syncStatus,
    Expression<int>? syncVersion,
    Expression<String>? syncDeviceId,
    Expression<bool>? syncIsDirty,
    Expression<String>? conflictData,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clientId != null) 'client_id': clientId,
      if (profileId != null) 'profile_id': profileId,
      if (entryDate != null) 'entry_date': entryDate,
      if (waterIntakeMl != null) 'water_intake_ml': waterIntakeMl,
      if (waterIntakeNotes != null) 'water_intake_notes': waterIntakeNotes,
      if (hasBowelMovement != null) 'has_bowel_movement': hasBowelMovement,
      if (bowelCondition != null) 'bowel_condition': bowelCondition,
      if (bowelCustomCondition != null)
        'bowel_custom_condition': bowelCustomCondition,
      if (bowelSize != null) 'bowel_size': bowelSize,
      if (bowelPhotoPath != null) 'bowel_photo_path': bowelPhotoPath,
      if (hasUrineMovement != null) 'has_urine_movement': hasUrineMovement,
      if (urineCondition != null) 'urine_condition': urineCondition,
      if (urineCustomCondition != null)
        'urine_custom_condition': urineCustomCondition,
      if (urineSize != null) 'urine_size': urineSize,
      if (urinePhotoPath != null) 'urine_photo_path': urinePhotoPath,
      if (menstruationFlow != null) 'menstruation_flow': menstruationFlow,
      if (basalBodyTemperature != null)
        'basal_body_temperature': basalBodyTemperature,
      if (bbtRecordedTime != null) 'bbt_recorded_time': bbtRecordedTime,
      if (otherFluidName != null) 'other_fluid_name': otherFluidName,
      if (otherFluidAmount != null) 'other_fluid_amount': otherFluidAmount,
      if (otherFluidNotes != null) 'other_fluid_notes': otherFluidNotes,
      if (importSource != null) 'import_source': importSource,
      if (importExternalId != null) 'import_external_id': importExternalId,
      if (cloudStorageUrl != null) 'cloud_storage_url': cloudStorageUrl,
      if (fileHash != null) 'file_hash': fileHash,
      if (fileSizeBytes != null) 'file_size_bytes': fileSizeBytes,
      if (isFileUploaded != null) 'is_file_uploaded': isFileUploaded,
      if (notes != null) 'notes': notes,
      if (photoIds != null) 'photo_ids': photoIds,
      if (syncCreatedAt != null) 'sync_created_at': syncCreatedAt,
      if (syncUpdatedAt != null) 'sync_updated_at': syncUpdatedAt,
      if (syncDeletedAt != null) 'sync_deleted_at': syncDeletedAt,
      if (syncLastSyncedAt != null) 'sync_last_synced_at': syncLastSyncedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncVersion != null) 'sync_version': syncVersion,
      if (syncDeviceId != null) 'sync_device_id': syncDeviceId,
      if (syncIsDirty != null) 'sync_is_dirty': syncIsDirty,
      if (conflictData != null) 'conflict_data': conflictData,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FluidsEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? clientId,
    Value<String>? profileId,
    Value<int>? entryDate,
    Value<int?>? waterIntakeMl,
    Value<String?>? waterIntakeNotes,
    Value<bool>? hasBowelMovement,
    Value<int?>? bowelCondition,
    Value<String?>? bowelCustomCondition,
    Value<int?>? bowelSize,
    Value<String?>? bowelPhotoPath,
    Value<bool>? hasUrineMovement,
    Value<int?>? urineCondition,
    Value<String?>? urineCustomCondition,
    Value<int?>? urineSize,
    Value<String?>? urinePhotoPath,
    Value<int?>? menstruationFlow,
    Value<double?>? basalBodyTemperature,
    Value<int?>? bbtRecordedTime,
    Value<String?>? otherFluidName,
    Value<String?>? otherFluidAmount,
    Value<String?>? otherFluidNotes,
    Value<String?>? importSource,
    Value<String?>? importExternalId,
    Value<String?>? cloudStorageUrl,
    Value<String?>? fileHash,
    Value<int?>? fileSizeBytes,
    Value<bool>? isFileUploaded,
    Value<String>? notes,
    Value<String>? photoIds,
    Value<int>? syncCreatedAt,
    Value<int?>? syncUpdatedAt,
    Value<int?>? syncDeletedAt,
    Value<int?>? syncLastSyncedAt,
    Value<int>? syncStatus,
    Value<int>? syncVersion,
    Value<String?>? syncDeviceId,
    Value<bool>? syncIsDirty,
    Value<String?>? conflictData,
    Value<int>? rowid,
  }) {
    return FluidsEntriesCompanion(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      profileId: profileId ?? this.profileId,
      entryDate: entryDate ?? this.entryDate,
      waterIntakeMl: waterIntakeMl ?? this.waterIntakeMl,
      waterIntakeNotes: waterIntakeNotes ?? this.waterIntakeNotes,
      hasBowelMovement: hasBowelMovement ?? this.hasBowelMovement,
      bowelCondition: bowelCondition ?? this.bowelCondition,
      bowelCustomCondition: bowelCustomCondition ?? this.bowelCustomCondition,
      bowelSize: bowelSize ?? this.bowelSize,
      bowelPhotoPath: bowelPhotoPath ?? this.bowelPhotoPath,
      hasUrineMovement: hasUrineMovement ?? this.hasUrineMovement,
      urineCondition: urineCondition ?? this.urineCondition,
      urineCustomCondition: urineCustomCondition ?? this.urineCustomCondition,
      urineSize: urineSize ?? this.urineSize,
      urinePhotoPath: urinePhotoPath ?? this.urinePhotoPath,
      menstruationFlow: menstruationFlow ?? this.menstruationFlow,
      basalBodyTemperature: basalBodyTemperature ?? this.basalBodyTemperature,
      bbtRecordedTime: bbtRecordedTime ?? this.bbtRecordedTime,
      otherFluidName: otherFluidName ?? this.otherFluidName,
      otherFluidAmount: otherFluidAmount ?? this.otherFluidAmount,
      otherFluidNotes: otherFluidNotes ?? this.otherFluidNotes,
      importSource: importSource ?? this.importSource,
      importExternalId: importExternalId ?? this.importExternalId,
      cloudStorageUrl: cloudStorageUrl ?? this.cloudStorageUrl,
      fileHash: fileHash ?? this.fileHash,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
      isFileUploaded: isFileUploaded ?? this.isFileUploaded,
      notes: notes ?? this.notes,
      photoIds: photoIds ?? this.photoIds,
      syncCreatedAt: syncCreatedAt ?? this.syncCreatedAt,
      syncUpdatedAt: syncUpdatedAt ?? this.syncUpdatedAt,
      syncDeletedAt: syncDeletedAt ?? this.syncDeletedAt,
      syncLastSyncedAt: syncLastSyncedAt ?? this.syncLastSyncedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      syncVersion: syncVersion ?? this.syncVersion,
      syncDeviceId: syncDeviceId ?? this.syncDeviceId,
      syncIsDirty: syncIsDirty ?? this.syncIsDirty,
      conflictData: conflictData ?? this.conflictData,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (entryDate.present) {
      map['entry_date'] = Variable<int>(entryDate.value);
    }
    if (waterIntakeMl.present) {
      map['water_intake_ml'] = Variable<int>(waterIntakeMl.value);
    }
    if (waterIntakeNotes.present) {
      map['water_intake_notes'] = Variable<String>(waterIntakeNotes.value);
    }
    if (hasBowelMovement.present) {
      map['has_bowel_movement'] = Variable<bool>(hasBowelMovement.value);
    }
    if (bowelCondition.present) {
      map['bowel_condition'] = Variable<int>(bowelCondition.value);
    }
    if (bowelCustomCondition.present) {
      map['bowel_custom_condition'] = Variable<String>(
        bowelCustomCondition.value,
      );
    }
    if (bowelSize.present) {
      map['bowel_size'] = Variable<int>(bowelSize.value);
    }
    if (bowelPhotoPath.present) {
      map['bowel_photo_path'] = Variable<String>(bowelPhotoPath.value);
    }
    if (hasUrineMovement.present) {
      map['has_urine_movement'] = Variable<bool>(hasUrineMovement.value);
    }
    if (urineCondition.present) {
      map['urine_condition'] = Variable<int>(urineCondition.value);
    }
    if (urineCustomCondition.present) {
      map['urine_custom_condition'] = Variable<String>(
        urineCustomCondition.value,
      );
    }
    if (urineSize.present) {
      map['urine_size'] = Variable<int>(urineSize.value);
    }
    if (urinePhotoPath.present) {
      map['urine_photo_path'] = Variable<String>(urinePhotoPath.value);
    }
    if (menstruationFlow.present) {
      map['menstruation_flow'] = Variable<int>(menstruationFlow.value);
    }
    if (basalBodyTemperature.present) {
      map['basal_body_temperature'] = Variable<double>(
        basalBodyTemperature.value,
      );
    }
    if (bbtRecordedTime.present) {
      map['bbt_recorded_time'] = Variable<int>(bbtRecordedTime.value);
    }
    if (otherFluidName.present) {
      map['other_fluid_name'] = Variable<String>(otherFluidName.value);
    }
    if (otherFluidAmount.present) {
      map['other_fluid_amount'] = Variable<String>(otherFluidAmount.value);
    }
    if (otherFluidNotes.present) {
      map['other_fluid_notes'] = Variable<String>(otherFluidNotes.value);
    }
    if (importSource.present) {
      map['import_source'] = Variable<String>(importSource.value);
    }
    if (importExternalId.present) {
      map['import_external_id'] = Variable<String>(importExternalId.value);
    }
    if (cloudStorageUrl.present) {
      map['cloud_storage_url'] = Variable<String>(cloudStorageUrl.value);
    }
    if (fileHash.present) {
      map['file_hash'] = Variable<String>(fileHash.value);
    }
    if (fileSizeBytes.present) {
      map['file_size_bytes'] = Variable<int>(fileSizeBytes.value);
    }
    if (isFileUploaded.present) {
      map['is_file_uploaded'] = Variable<bool>(isFileUploaded.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (photoIds.present) {
      map['photo_ids'] = Variable<String>(photoIds.value);
    }
    if (syncCreatedAt.present) {
      map['sync_created_at'] = Variable<int>(syncCreatedAt.value);
    }
    if (syncUpdatedAt.present) {
      map['sync_updated_at'] = Variable<int>(syncUpdatedAt.value);
    }
    if (syncDeletedAt.present) {
      map['sync_deleted_at'] = Variable<int>(syncDeletedAt.value);
    }
    if (syncLastSyncedAt.present) {
      map['sync_last_synced_at'] = Variable<int>(syncLastSyncedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (syncVersion.present) {
      map['sync_version'] = Variable<int>(syncVersion.value);
    }
    if (syncDeviceId.present) {
      map['sync_device_id'] = Variable<String>(syncDeviceId.value);
    }
    if (syncIsDirty.present) {
      map['sync_is_dirty'] = Variable<bool>(syncIsDirty.value);
    }
    if (conflictData.present) {
      map['conflict_data'] = Variable<String>(conflictData.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FluidsEntriesCompanion(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('profileId: $profileId, ')
          ..write('entryDate: $entryDate, ')
          ..write('waterIntakeMl: $waterIntakeMl, ')
          ..write('waterIntakeNotes: $waterIntakeNotes, ')
          ..write('hasBowelMovement: $hasBowelMovement, ')
          ..write('bowelCondition: $bowelCondition, ')
          ..write('bowelCustomCondition: $bowelCustomCondition, ')
          ..write('bowelSize: $bowelSize, ')
          ..write('bowelPhotoPath: $bowelPhotoPath, ')
          ..write('hasUrineMovement: $hasUrineMovement, ')
          ..write('urineCondition: $urineCondition, ')
          ..write('urineCustomCondition: $urineCustomCondition, ')
          ..write('urineSize: $urineSize, ')
          ..write('urinePhotoPath: $urinePhotoPath, ')
          ..write('menstruationFlow: $menstruationFlow, ')
          ..write('basalBodyTemperature: $basalBodyTemperature, ')
          ..write('bbtRecordedTime: $bbtRecordedTime, ')
          ..write('otherFluidName: $otherFluidName, ')
          ..write('otherFluidAmount: $otherFluidAmount, ')
          ..write('otherFluidNotes: $otherFluidNotes, ')
          ..write('importSource: $importSource, ')
          ..write('importExternalId: $importExternalId, ')
          ..write('cloudStorageUrl: $cloudStorageUrl, ')
          ..write('fileHash: $fileHash, ')
          ..write('fileSizeBytes: $fileSizeBytes, ')
          ..write('isFileUploaded: $isFileUploaded, ')
          ..write('notes: $notes, ')
          ..write('photoIds: $photoIds, ')
          ..write('syncCreatedAt: $syncCreatedAt, ')
          ..write('syncUpdatedAt: $syncUpdatedAt, ')
          ..write('syncDeletedAt: $syncDeletedAt, ')
          ..write('syncLastSyncedAt: $syncLastSyncedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncVersion: $syncVersion, ')
          ..write('syncDeviceId: $syncDeviceId, ')
          ..write('syncIsDirty: $syncIsDirty, ')
          ..write('conflictData: $conflictData, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SleepEntriesTable extends SleepEntries
    with TableInfo<$SleepEntriesTable, SleepEntryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SleepEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
    'client_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bedTimeMeta = const VerificationMeta(
    'bedTime',
  );
  @override
  late final GeneratedColumn<int> bedTime = GeneratedColumn<int>(
    'bed_time',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wakeTimeMeta = const VerificationMeta(
    'wakeTime',
  );
  @override
  late final GeneratedColumn<int> wakeTime = GeneratedColumn<int>(
    'wake_time',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deepSleepMinutesMeta = const VerificationMeta(
    'deepSleepMinutes',
  );
  @override
  late final GeneratedColumn<int> deepSleepMinutes = GeneratedColumn<int>(
    'deep_sleep_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lightSleepMinutesMeta = const VerificationMeta(
    'lightSleepMinutes',
  );
  @override
  late final GeneratedColumn<int> lightSleepMinutes = GeneratedColumn<int>(
    'light_sleep_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _restlessSleepMinutesMeta =
      const VerificationMeta('restlessSleepMinutes');
  @override
  late final GeneratedColumn<int> restlessSleepMinutes = GeneratedColumn<int>(
    'restless_sleep_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _dreamTypeMeta = const VerificationMeta(
    'dreamType',
  );
  @override
  late final GeneratedColumn<int> dreamType = GeneratedColumn<int>(
    'dream_type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _wakingFeelingMeta = const VerificationMeta(
    'wakingFeeling',
  );
  @override
  late final GeneratedColumn<int> wakingFeeling = GeneratedColumn<int>(
    'waking_feeling',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _importSourceMeta = const VerificationMeta(
    'importSource',
  );
  @override
  late final GeneratedColumn<String> importSource = GeneratedColumn<String>(
    'import_source',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _importExternalIdMeta = const VerificationMeta(
    'importExternalId',
  );
  @override
  late final GeneratedColumn<String> importExternalId = GeneratedColumn<String>(
    'import_external_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncCreatedAtMeta = const VerificationMeta(
    'syncCreatedAt',
  );
  @override
  late final GeneratedColumn<int> syncCreatedAt = GeneratedColumn<int>(
    'sync_created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncUpdatedAtMeta = const VerificationMeta(
    'syncUpdatedAt',
  );
  @override
  late final GeneratedColumn<int> syncUpdatedAt = GeneratedColumn<int>(
    'sync_updated_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncDeletedAtMeta = const VerificationMeta(
    'syncDeletedAt',
  );
  @override
  late final GeneratedColumn<int> syncDeletedAt = GeneratedColumn<int>(
    'sync_deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncLastSyncedAtMeta = const VerificationMeta(
    'syncLastSyncedAt',
  );
  @override
  late final GeneratedColumn<int> syncLastSyncedAt = GeneratedColumn<int>(
    'sync_last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _syncVersionMeta = const VerificationMeta(
    'syncVersion',
  );
  @override
  late final GeneratedColumn<int> syncVersion = GeneratedColumn<int>(
    'sync_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _syncDeviceIdMeta = const VerificationMeta(
    'syncDeviceId',
  );
  @override
  late final GeneratedColumn<String> syncDeviceId = GeneratedColumn<String>(
    'sync_device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncIsDirtyMeta = const VerificationMeta(
    'syncIsDirty',
  );
  @override
  late final GeneratedColumn<bool> syncIsDirty = GeneratedColumn<bool>(
    'sync_is_dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sync_is_dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _conflictDataMeta = const VerificationMeta(
    'conflictData',
  );
  @override
  late final GeneratedColumn<String> conflictData = GeneratedColumn<String>(
    'conflict_data',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    clientId,
    profileId,
    bedTime,
    wakeTime,
    deepSleepMinutes,
    lightSleepMinutes,
    restlessSleepMinutes,
    dreamType,
    wakingFeeling,
    notes,
    importSource,
    importExternalId,
    syncCreatedAt,
    syncUpdatedAt,
    syncDeletedAt,
    syncLastSyncedAt,
    syncStatus,
    syncVersion,
    syncDeviceId,
    syncIsDirty,
    conflictData,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sleep_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<SleepEntryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('bed_time')) {
      context.handle(
        _bedTimeMeta,
        bedTime.isAcceptableOrUnknown(data['bed_time']!, _bedTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_bedTimeMeta);
    }
    if (data.containsKey('wake_time')) {
      context.handle(
        _wakeTimeMeta,
        wakeTime.isAcceptableOrUnknown(data['wake_time']!, _wakeTimeMeta),
      );
    }
    if (data.containsKey('deep_sleep_minutes')) {
      context.handle(
        _deepSleepMinutesMeta,
        deepSleepMinutes.isAcceptableOrUnknown(
          data['deep_sleep_minutes']!,
          _deepSleepMinutesMeta,
        ),
      );
    }
    if (data.containsKey('light_sleep_minutes')) {
      context.handle(
        _lightSleepMinutesMeta,
        lightSleepMinutes.isAcceptableOrUnknown(
          data['light_sleep_minutes']!,
          _lightSleepMinutesMeta,
        ),
      );
    }
    if (data.containsKey('restless_sleep_minutes')) {
      context.handle(
        _restlessSleepMinutesMeta,
        restlessSleepMinutes.isAcceptableOrUnknown(
          data['restless_sleep_minutes']!,
          _restlessSleepMinutesMeta,
        ),
      );
    }
    if (data.containsKey('dream_type')) {
      context.handle(
        _dreamTypeMeta,
        dreamType.isAcceptableOrUnknown(data['dream_type']!, _dreamTypeMeta),
      );
    }
    if (data.containsKey('waking_feeling')) {
      context.handle(
        _wakingFeelingMeta,
        wakingFeeling.isAcceptableOrUnknown(
          data['waking_feeling']!,
          _wakingFeelingMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('import_source')) {
      context.handle(
        _importSourceMeta,
        importSource.isAcceptableOrUnknown(
          data['import_source']!,
          _importSourceMeta,
        ),
      );
    }
    if (data.containsKey('import_external_id')) {
      context.handle(
        _importExternalIdMeta,
        importExternalId.isAcceptableOrUnknown(
          data['import_external_id']!,
          _importExternalIdMeta,
        ),
      );
    }
    if (data.containsKey('sync_created_at')) {
      context.handle(
        _syncCreatedAtMeta,
        syncCreatedAt.isAcceptableOrUnknown(
          data['sync_created_at']!,
          _syncCreatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_syncCreatedAtMeta);
    }
    if (data.containsKey('sync_updated_at')) {
      context.handle(
        _syncUpdatedAtMeta,
        syncUpdatedAt.isAcceptableOrUnknown(
          data['sync_updated_at']!,
          _syncUpdatedAtMeta,
        ),
      );
    }
    if (data.containsKey('sync_deleted_at')) {
      context.handle(
        _syncDeletedAtMeta,
        syncDeletedAt.isAcceptableOrUnknown(
          data['sync_deleted_at']!,
          _syncDeletedAtMeta,
        ),
      );
    }
    if (data.containsKey('sync_last_synced_at')) {
      context.handle(
        _syncLastSyncedAtMeta,
        syncLastSyncedAt.isAcceptableOrUnknown(
          data['sync_last_synced_at']!,
          _syncLastSyncedAtMeta,
        ),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('sync_version')) {
      context.handle(
        _syncVersionMeta,
        syncVersion.isAcceptableOrUnknown(
          data['sync_version']!,
          _syncVersionMeta,
        ),
      );
    }
    if (data.containsKey('sync_device_id')) {
      context.handle(
        _syncDeviceIdMeta,
        syncDeviceId.isAcceptableOrUnknown(
          data['sync_device_id']!,
          _syncDeviceIdMeta,
        ),
      );
    }
    if (data.containsKey('sync_is_dirty')) {
      context.handle(
        _syncIsDirtyMeta,
        syncIsDirty.isAcceptableOrUnknown(
          data['sync_is_dirty']!,
          _syncIsDirtyMeta,
        ),
      );
    }
    if (data.containsKey('conflict_data')) {
      context.handle(
        _conflictDataMeta,
        conflictData.isAcceptableOrUnknown(
          data['conflict_data']!,
          _conflictDataMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SleepEntryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SleepEntryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      bedTime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bed_time'],
      )!,
      wakeTime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wake_time'],
      ),
      deepSleepMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deep_sleep_minutes'],
      )!,
      lightSleepMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}light_sleep_minutes'],
      )!,
      restlessSleepMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}restless_sleep_minutes'],
      )!,
      dreamType: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dream_type'],
      )!,
      wakingFeeling: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}waking_feeling'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      importSource: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}import_source'],
      ),
      importExternalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}import_external_id'],
      ),
      syncCreatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_created_at'],
      )!,
      syncUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_updated_at'],
      ),
      syncDeletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_deleted_at'],
      ),
      syncLastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_last_synced_at'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_status'],
      )!,
      syncVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_version'],
      )!,
      syncDeviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_device_id'],
      ),
      syncIsDirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sync_is_dirty'],
      )!,
      conflictData: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conflict_data'],
      ),
    );
  }

  @override
  $SleepEntriesTable createAlias(String alias) {
    return $SleepEntriesTable(attachedDatabase, alias);
  }
}

class SleepEntryRow extends DataClass implements Insertable<SleepEntryRow> {
  final String id;
  final String clientId;
  final String profileId;
  final int bedTime;
  final int? wakeTime;
  final int deepSleepMinutes;
  final int lightSleepMinutes;
  final int restlessSleepMinutes;
  final int dreamType;
  final int wakingFeeling;
  final String? notes;
  final String? importSource;
  final String? importExternalId;
  final int syncCreatedAt;
  final int? syncUpdatedAt;
  final int? syncDeletedAt;
  final int? syncLastSyncedAt;
  final int syncStatus;
  final int syncVersion;
  final String? syncDeviceId;
  final bool syncIsDirty;
  final String? conflictData;
  const SleepEntryRow({
    required this.id,
    required this.clientId,
    required this.profileId,
    required this.bedTime,
    this.wakeTime,
    required this.deepSleepMinutes,
    required this.lightSleepMinutes,
    required this.restlessSleepMinutes,
    required this.dreamType,
    required this.wakingFeeling,
    this.notes,
    this.importSource,
    this.importExternalId,
    required this.syncCreatedAt,
    this.syncUpdatedAt,
    this.syncDeletedAt,
    this.syncLastSyncedAt,
    required this.syncStatus,
    required this.syncVersion,
    this.syncDeviceId,
    required this.syncIsDirty,
    this.conflictData,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['client_id'] = Variable<String>(clientId);
    map['profile_id'] = Variable<String>(profileId);
    map['bed_time'] = Variable<int>(bedTime);
    if (!nullToAbsent || wakeTime != null) {
      map['wake_time'] = Variable<int>(wakeTime);
    }
    map['deep_sleep_minutes'] = Variable<int>(deepSleepMinutes);
    map['light_sleep_minutes'] = Variable<int>(lightSleepMinutes);
    map['restless_sleep_minutes'] = Variable<int>(restlessSleepMinutes);
    map['dream_type'] = Variable<int>(dreamType);
    map['waking_feeling'] = Variable<int>(wakingFeeling);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || importSource != null) {
      map['import_source'] = Variable<String>(importSource);
    }
    if (!nullToAbsent || importExternalId != null) {
      map['import_external_id'] = Variable<String>(importExternalId);
    }
    map['sync_created_at'] = Variable<int>(syncCreatedAt);
    if (!nullToAbsent || syncUpdatedAt != null) {
      map['sync_updated_at'] = Variable<int>(syncUpdatedAt);
    }
    if (!nullToAbsent || syncDeletedAt != null) {
      map['sync_deleted_at'] = Variable<int>(syncDeletedAt);
    }
    if (!nullToAbsent || syncLastSyncedAt != null) {
      map['sync_last_synced_at'] = Variable<int>(syncLastSyncedAt);
    }
    map['sync_status'] = Variable<int>(syncStatus);
    map['sync_version'] = Variable<int>(syncVersion);
    if (!nullToAbsent || syncDeviceId != null) {
      map['sync_device_id'] = Variable<String>(syncDeviceId);
    }
    map['sync_is_dirty'] = Variable<bool>(syncIsDirty);
    if (!nullToAbsent || conflictData != null) {
      map['conflict_data'] = Variable<String>(conflictData);
    }
    return map;
  }

  SleepEntriesCompanion toCompanion(bool nullToAbsent) {
    return SleepEntriesCompanion(
      id: Value(id),
      clientId: Value(clientId),
      profileId: Value(profileId),
      bedTime: Value(bedTime),
      wakeTime: wakeTime == null && nullToAbsent
          ? const Value.absent()
          : Value(wakeTime),
      deepSleepMinutes: Value(deepSleepMinutes),
      lightSleepMinutes: Value(lightSleepMinutes),
      restlessSleepMinutes: Value(restlessSleepMinutes),
      dreamType: Value(dreamType),
      wakingFeeling: Value(wakingFeeling),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      importSource: importSource == null && nullToAbsent
          ? const Value.absent()
          : Value(importSource),
      importExternalId: importExternalId == null && nullToAbsent
          ? const Value.absent()
          : Value(importExternalId),
      syncCreatedAt: Value(syncCreatedAt),
      syncUpdatedAt: syncUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncUpdatedAt),
      syncDeletedAt: syncDeletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncDeletedAt),
      syncLastSyncedAt: syncLastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncLastSyncedAt),
      syncStatus: Value(syncStatus),
      syncVersion: Value(syncVersion),
      syncDeviceId: syncDeviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(syncDeviceId),
      syncIsDirty: Value(syncIsDirty),
      conflictData: conflictData == null && nullToAbsent
          ? const Value.absent()
          : Value(conflictData),
    );
  }

  factory SleepEntryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SleepEntryRow(
      id: serializer.fromJson<String>(json['id']),
      clientId: serializer.fromJson<String>(json['clientId']),
      profileId: serializer.fromJson<String>(json['profileId']),
      bedTime: serializer.fromJson<int>(json['bedTime']),
      wakeTime: serializer.fromJson<int?>(json['wakeTime']),
      deepSleepMinutes: serializer.fromJson<int>(json['deepSleepMinutes']),
      lightSleepMinutes: serializer.fromJson<int>(json['lightSleepMinutes']),
      restlessSleepMinutes: serializer.fromJson<int>(
        json['restlessSleepMinutes'],
      ),
      dreamType: serializer.fromJson<int>(json['dreamType']),
      wakingFeeling: serializer.fromJson<int>(json['wakingFeeling']),
      notes: serializer.fromJson<String?>(json['notes']),
      importSource: serializer.fromJson<String?>(json['importSource']),
      importExternalId: serializer.fromJson<String?>(json['importExternalId']),
      syncCreatedAt: serializer.fromJson<int>(json['syncCreatedAt']),
      syncUpdatedAt: serializer.fromJson<int?>(json['syncUpdatedAt']),
      syncDeletedAt: serializer.fromJson<int?>(json['syncDeletedAt']),
      syncLastSyncedAt: serializer.fromJson<int?>(json['syncLastSyncedAt']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
      syncVersion: serializer.fromJson<int>(json['syncVersion']),
      syncDeviceId: serializer.fromJson<String?>(json['syncDeviceId']),
      syncIsDirty: serializer.fromJson<bool>(json['syncIsDirty']),
      conflictData: serializer.fromJson<String?>(json['conflictData']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'clientId': serializer.toJson<String>(clientId),
      'profileId': serializer.toJson<String>(profileId),
      'bedTime': serializer.toJson<int>(bedTime),
      'wakeTime': serializer.toJson<int?>(wakeTime),
      'deepSleepMinutes': serializer.toJson<int>(deepSleepMinutes),
      'lightSleepMinutes': serializer.toJson<int>(lightSleepMinutes),
      'restlessSleepMinutes': serializer.toJson<int>(restlessSleepMinutes),
      'dreamType': serializer.toJson<int>(dreamType),
      'wakingFeeling': serializer.toJson<int>(wakingFeeling),
      'notes': serializer.toJson<String?>(notes),
      'importSource': serializer.toJson<String?>(importSource),
      'importExternalId': serializer.toJson<String?>(importExternalId),
      'syncCreatedAt': serializer.toJson<int>(syncCreatedAt),
      'syncUpdatedAt': serializer.toJson<int?>(syncUpdatedAt),
      'syncDeletedAt': serializer.toJson<int?>(syncDeletedAt),
      'syncLastSyncedAt': serializer.toJson<int?>(syncLastSyncedAt),
      'syncStatus': serializer.toJson<int>(syncStatus),
      'syncVersion': serializer.toJson<int>(syncVersion),
      'syncDeviceId': serializer.toJson<String?>(syncDeviceId),
      'syncIsDirty': serializer.toJson<bool>(syncIsDirty),
      'conflictData': serializer.toJson<String?>(conflictData),
    };
  }

  SleepEntryRow copyWith({
    String? id,
    String? clientId,
    String? profileId,
    int? bedTime,
    Value<int?> wakeTime = const Value.absent(),
    int? deepSleepMinutes,
    int? lightSleepMinutes,
    int? restlessSleepMinutes,
    int? dreamType,
    int? wakingFeeling,
    Value<String?> notes = const Value.absent(),
    Value<String?> importSource = const Value.absent(),
    Value<String?> importExternalId = const Value.absent(),
    int? syncCreatedAt,
    Value<int?> syncUpdatedAt = const Value.absent(),
    Value<int?> syncDeletedAt = const Value.absent(),
    Value<int?> syncLastSyncedAt = const Value.absent(),
    int? syncStatus,
    int? syncVersion,
    Value<String?> syncDeviceId = const Value.absent(),
    bool? syncIsDirty,
    Value<String?> conflictData = const Value.absent(),
  }) => SleepEntryRow(
    id: id ?? this.id,
    clientId: clientId ?? this.clientId,
    profileId: profileId ?? this.profileId,
    bedTime: bedTime ?? this.bedTime,
    wakeTime: wakeTime.present ? wakeTime.value : this.wakeTime,
    deepSleepMinutes: deepSleepMinutes ?? this.deepSleepMinutes,
    lightSleepMinutes: lightSleepMinutes ?? this.lightSleepMinutes,
    restlessSleepMinutes: restlessSleepMinutes ?? this.restlessSleepMinutes,
    dreamType: dreamType ?? this.dreamType,
    wakingFeeling: wakingFeeling ?? this.wakingFeeling,
    notes: notes.present ? notes.value : this.notes,
    importSource: importSource.present ? importSource.value : this.importSource,
    importExternalId: importExternalId.present
        ? importExternalId.value
        : this.importExternalId,
    syncCreatedAt: syncCreatedAt ?? this.syncCreatedAt,
    syncUpdatedAt: syncUpdatedAt.present
        ? syncUpdatedAt.value
        : this.syncUpdatedAt,
    syncDeletedAt: syncDeletedAt.present
        ? syncDeletedAt.value
        : this.syncDeletedAt,
    syncLastSyncedAt: syncLastSyncedAt.present
        ? syncLastSyncedAt.value
        : this.syncLastSyncedAt,
    syncStatus: syncStatus ?? this.syncStatus,
    syncVersion: syncVersion ?? this.syncVersion,
    syncDeviceId: syncDeviceId.present ? syncDeviceId.value : this.syncDeviceId,
    syncIsDirty: syncIsDirty ?? this.syncIsDirty,
    conflictData: conflictData.present ? conflictData.value : this.conflictData,
  );
  SleepEntryRow copyWithCompanion(SleepEntriesCompanion data) {
    return SleepEntryRow(
      id: data.id.present ? data.id.value : this.id,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      bedTime: data.bedTime.present ? data.bedTime.value : this.bedTime,
      wakeTime: data.wakeTime.present ? data.wakeTime.value : this.wakeTime,
      deepSleepMinutes: data.deepSleepMinutes.present
          ? data.deepSleepMinutes.value
          : this.deepSleepMinutes,
      lightSleepMinutes: data.lightSleepMinutes.present
          ? data.lightSleepMinutes.value
          : this.lightSleepMinutes,
      restlessSleepMinutes: data.restlessSleepMinutes.present
          ? data.restlessSleepMinutes.value
          : this.restlessSleepMinutes,
      dreamType: data.dreamType.present ? data.dreamType.value : this.dreamType,
      wakingFeeling: data.wakingFeeling.present
          ? data.wakingFeeling.value
          : this.wakingFeeling,
      notes: data.notes.present ? data.notes.value : this.notes,
      importSource: data.importSource.present
          ? data.importSource.value
          : this.importSource,
      importExternalId: data.importExternalId.present
          ? data.importExternalId.value
          : this.importExternalId,
      syncCreatedAt: data.syncCreatedAt.present
          ? data.syncCreatedAt.value
          : this.syncCreatedAt,
      syncUpdatedAt: data.syncUpdatedAt.present
          ? data.syncUpdatedAt.value
          : this.syncUpdatedAt,
      syncDeletedAt: data.syncDeletedAt.present
          ? data.syncDeletedAt.value
          : this.syncDeletedAt,
      syncLastSyncedAt: data.syncLastSyncedAt.present
          ? data.syncLastSyncedAt.value
          : this.syncLastSyncedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      syncVersion: data.syncVersion.present
          ? data.syncVersion.value
          : this.syncVersion,
      syncDeviceId: data.syncDeviceId.present
          ? data.syncDeviceId.value
          : this.syncDeviceId,
      syncIsDirty: data.syncIsDirty.present
          ? data.syncIsDirty.value
          : this.syncIsDirty,
      conflictData: data.conflictData.present
          ? data.conflictData.value
          : this.conflictData,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SleepEntryRow(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('profileId: $profileId, ')
          ..write('bedTime: $bedTime, ')
          ..write('wakeTime: $wakeTime, ')
          ..write('deepSleepMinutes: $deepSleepMinutes, ')
          ..write('lightSleepMinutes: $lightSleepMinutes, ')
          ..write('restlessSleepMinutes: $restlessSleepMinutes, ')
          ..write('dreamType: $dreamType, ')
          ..write('wakingFeeling: $wakingFeeling, ')
          ..write('notes: $notes, ')
          ..write('importSource: $importSource, ')
          ..write('importExternalId: $importExternalId, ')
          ..write('syncCreatedAt: $syncCreatedAt, ')
          ..write('syncUpdatedAt: $syncUpdatedAt, ')
          ..write('syncDeletedAt: $syncDeletedAt, ')
          ..write('syncLastSyncedAt: $syncLastSyncedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncVersion: $syncVersion, ')
          ..write('syncDeviceId: $syncDeviceId, ')
          ..write('syncIsDirty: $syncIsDirty, ')
          ..write('conflictData: $conflictData')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    clientId,
    profileId,
    bedTime,
    wakeTime,
    deepSleepMinutes,
    lightSleepMinutes,
    restlessSleepMinutes,
    dreamType,
    wakingFeeling,
    notes,
    importSource,
    importExternalId,
    syncCreatedAt,
    syncUpdatedAt,
    syncDeletedAt,
    syncLastSyncedAt,
    syncStatus,
    syncVersion,
    syncDeviceId,
    syncIsDirty,
    conflictData,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SleepEntryRow &&
          other.id == this.id &&
          other.clientId == this.clientId &&
          other.profileId == this.profileId &&
          other.bedTime == this.bedTime &&
          other.wakeTime == this.wakeTime &&
          other.deepSleepMinutes == this.deepSleepMinutes &&
          other.lightSleepMinutes == this.lightSleepMinutes &&
          other.restlessSleepMinutes == this.restlessSleepMinutes &&
          other.dreamType == this.dreamType &&
          other.wakingFeeling == this.wakingFeeling &&
          other.notes == this.notes &&
          other.importSource == this.importSource &&
          other.importExternalId == this.importExternalId &&
          other.syncCreatedAt == this.syncCreatedAt &&
          other.syncUpdatedAt == this.syncUpdatedAt &&
          other.syncDeletedAt == this.syncDeletedAt &&
          other.syncLastSyncedAt == this.syncLastSyncedAt &&
          other.syncStatus == this.syncStatus &&
          other.syncVersion == this.syncVersion &&
          other.syncDeviceId == this.syncDeviceId &&
          other.syncIsDirty == this.syncIsDirty &&
          other.conflictData == this.conflictData);
}

class SleepEntriesCompanion extends UpdateCompanion<SleepEntryRow> {
  final Value<String> id;
  final Value<String> clientId;
  final Value<String> profileId;
  final Value<int> bedTime;
  final Value<int?> wakeTime;
  final Value<int> deepSleepMinutes;
  final Value<int> lightSleepMinutes;
  final Value<int> restlessSleepMinutes;
  final Value<int> dreamType;
  final Value<int> wakingFeeling;
  final Value<String?> notes;
  final Value<String?> importSource;
  final Value<String?> importExternalId;
  final Value<int> syncCreatedAt;
  final Value<int?> syncUpdatedAt;
  final Value<int?> syncDeletedAt;
  final Value<int?> syncLastSyncedAt;
  final Value<int> syncStatus;
  final Value<int> syncVersion;
  final Value<String?> syncDeviceId;
  final Value<bool> syncIsDirty;
  final Value<String?> conflictData;
  final Value<int> rowid;
  const SleepEntriesCompanion({
    this.id = const Value.absent(),
    this.clientId = const Value.absent(),
    this.profileId = const Value.absent(),
    this.bedTime = const Value.absent(),
    this.wakeTime = const Value.absent(),
    this.deepSleepMinutes = const Value.absent(),
    this.lightSleepMinutes = const Value.absent(),
    this.restlessSleepMinutes = const Value.absent(),
    this.dreamType = const Value.absent(),
    this.wakingFeeling = const Value.absent(),
    this.notes = const Value.absent(),
    this.importSource = const Value.absent(),
    this.importExternalId = const Value.absent(),
    this.syncCreatedAt = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
    this.syncDeletedAt = const Value.absent(),
    this.syncLastSyncedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncVersion = const Value.absent(),
    this.syncDeviceId = const Value.absent(),
    this.syncIsDirty = const Value.absent(),
    this.conflictData = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SleepEntriesCompanion.insert({
    required String id,
    required String clientId,
    required String profileId,
    required int bedTime,
    this.wakeTime = const Value.absent(),
    this.deepSleepMinutes = const Value.absent(),
    this.lightSleepMinutes = const Value.absent(),
    this.restlessSleepMinutes = const Value.absent(),
    this.dreamType = const Value.absent(),
    this.wakingFeeling = const Value.absent(),
    this.notes = const Value.absent(),
    this.importSource = const Value.absent(),
    this.importExternalId = const Value.absent(),
    required int syncCreatedAt,
    this.syncUpdatedAt = const Value.absent(),
    this.syncDeletedAt = const Value.absent(),
    this.syncLastSyncedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncVersion = const Value.absent(),
    this.syncDeviceId = const Value.absent(),
    this.syncIsDirty = const Value.absent(),
    this.conflictData = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       clientId = Value(clientId),
       profileId = Value(profileId),
       bedTime = Value(bedTime),
       syncCreatedAt = Value(syncCreatedAt);
  static Insertable<SleepEntryRow> custom({
    Expression<String>? id,
    Expression<String>? clientId,
    Expression<String>? profileId,
    Expression<int>? bedTime,
    Expression<int>? wakeTime,
    Expression<int>? deepSleepMinutes,
    Expression<int>? lightSleepMinutes,
    Expression<int>? restlessSleepMinutes,
    Expression<int>? dreamType,
    Expression<int>? wakingFeeling,
    Expression<String>? notes,
    Expression<String>? importSource,
    Expression<String>? importExternalId,
    Expression<int>? syncCreatedAt,
    Expression<int>? syncUpdatedAt,
    Expression<int>? syncDeletedAt,
    Expression<int>? syncLastSyncedAt,
    Expression<int>? syncStatus,
    Expression<int>? syncVersion,
    Expression<String>? syncDeviceId,
    Expression<bool>? syncIsDirty,
    Expression<String>? conflictData,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clientId != null) 'client_id': clientId,
      if (profileId != null) 'profile_id': profileId,
      if (bedTime != null) 'bed_time': bedTime,
      if (wakeTime != null) 'wake_time': wakeTime,
      if (deepSleepMinutes != null) 'deep_sleep_minutes': deepSleepMinutes,
      if (lightSleepMinutes != null) 'light_sleep_minutes': lightSleepMinutes,
      if (restlessSleepMinutes != null)
        'restless_sleep_minutes': restlessSleepMinutes,
      if (dreamType != null) 'dream_type': dreamType,
      if (wakingFeeling != null) 'waking_feeling': wakingFeeling,
      if (notes != null) 'notes': notes,
      if (importSource != null) 'import_source': importSource,
      if (importExternalId != null) 'import_external_id': importExternalId,
      if (syncCreatedAt != null) 'sync_created_at': syncCreatedAt,
      if (syncUpdatedAt != null) 'sync_updated_at': syncUpdatedAt,
      if (syncDeletedAt != null) 'sync_deleted_at': syncDeletedAt,
      if (syncLastSyncedAt != null) 'sync_last_synced_at': syncLastSyncedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncVersion != null) 'sync_version': syncVersion,
      if (syncDeviceId != null) 'sync_device_id': syncDeviceId,
      if (syncIsDirty != null) 'sync_is_dirty': syncIsDirty,
      if (conflictData != null) 'conflict_data': conflictData,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SleepEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? clientId,
    Value<String>? profileId,
    Value<int>? bedTime,
    Value<int?>? wakeTime,
    Value<int>? deepSleepMinutes,
    Value<int>? lightSleepMinutes,
    Value<int>? restlessSleepMinutes,
    Value<int>? dreamType,
    Value<int>? wakingFeeling,
    Value<String?>? notes,
    Value<String?>? importSource,
    Value<String?>? importExternalId,
    Value<int>? syncCreatedAt,
    Value<int?>? syncUpdatedAt,
    Value<int?>? syncDeletedAt,
    Value<int?>? syncLastSyncedAt,
    Value<int>? syncStatus,
    Value<int>? syncVersion,
    Value<String?>? syncDeviceId,
    Value<bool>? syncIsDirty,
    Value<String?>? conflictData,
    Value<int>? rowid,
  }) {
    return SleepEntriesCompanion(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      profileId: profileId ?? this.profileId,
      bedTime: bedTime ?? this.bedTime,
      wakeTime: wakeTime ?? this.wakeTime,
      deepSleepMinutes: deepSleepMinutes ?? this.deepSleepMinutes,
      lightSleepMinutes: lightSleepMinutes ?? this.lightSleepMinutes,
      restlessSleepMinutes: restlessSleepMinutes ?? this.restlessSleepMinutes,
      dreamType: dreamType ?? this.dreamType,
      wakingFeeling: wakingFeeling ?? this.wakingFeeling,
      notes: notes ?? this.notes,
      importSource: importSource ?? this.importSource,
      importExternalId: importExternalId ?? this.importExternalId,
      syncCreatedAt: syncCreatedAt ?? this.syncCreatedAt,
      syncUpdatedAt: syncUpdatedAt ?? this.syncUpdatedAt,
      syncDeletedAt: syncDeletedAt ?? this.syncDeletedAt,
      syncLastSyncedAt: syncLastSyncedAt ?? this.syncLastSyncedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      syncVersion: syncVersion ?? this.syncVersion,
      syncDeviceId: syncDeviceId ?? this.syncDeviceId,
      syncIsDirty: syncIsDirty ?? this.syncIsDirty,
      conflictData: conflictData ?? this.conflictData,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (bedTime.present) {
      map['bed_time'] = Variable<int>(bedTime.value);
    }
    if (wakeTime.present) {
      map['wake_time'] = Variable<int>(wakeTime.value);
    }
    if (deepSleepMinutes.present) {
      map['deep_sleep_minutes'] = Variable<int>(deepSleepMinutes.value);
    }
    if (lightSleepMinutes.present) {
      map['light_sleep_minutes'] = Variable<int>(lightSleepMinutes.value);
    }
    if (restlessSleepMinutes.present) {
      map['restless_sleep_minutes'] = Variable<int>(restlessSleepMinutes.value);
    }
    if (dreamType.present) {
      map['dream_type'] = Variable<int>(dreamType.value);
    }
    if (wakingFeeling.present) {
      map['waking_feeling'] = Variable<int>(wakingFeeling.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (importSource.present) {
      map['import_source'] = Variable<String>(importSource.value);
    }
    if (importExternalId.present) {
      map['import_external_id'] = Variable<String>(importExternalId.value);
    }
    if (syncCreatedAt.present) {
      map['sync_created_at'] = Variable<int>(syncCreatedAt.value);
    }
    if (syncUpdatedAt.present) {
      map['sync_updated_at'] = Variable<int>(syncUpdatedAt.value);
    }
    if (syncDeletedAt.present) {
      map['sync_deleted_at'] = Variable<int>(syncDeletedAt.value);
    }
    if (syncLastSyncedAt.present) {
      map['sync_last_synced_at'] = Variable<int>(syncLastSyncedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (syncVersion.present) {
      map['sync_version'] = Variable<int>(syncVersion.value);
    }
    if (syncDeviceId.present) {
      map['sync_device_id'] = Variable<String>(syncDeviceId.value);
    }
    if (syncIsDirty.present) {
      map['sync_is_dirty'] = Variable<bool>(syncIsDirty.value);
    }
    if (conflictData.present) {
      map['conflict_data'] = Variable<String>(conflictData.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SleepEntriesCompanion(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('profileId: $profileId, ')
          ..write('bedTime: $bedTime, ')
          ..write('wakeTime: $wakeTime, ')
          ..write('deepSleepMinutes: $deepSleepMinutes, ')
          ..write('lightSleepMinutes: $lightSleepMinutes, ')
          ..write('restlessSleepMinutes: $restlessSleepMinutes, ')
          ..write('dreamType: $dreamType, ')
          ..write('wakingFeeling: $wakingFeeling, ')
          ..write('notes: $notes, ')
          ..write('importSource: $importSource, ')
          ..write('importExternalId: $importExternalId, ')
          ..write('syncCreatedAt: $syncCreatedAt, ')
          ..write('syncUpdatedAt: $syncUpdatedAt, ')
          ..write('syncDeletedAt: $syncDeletedAt, ')
          ..write('syncLastSyncedAt: $syncLastSyncedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncVersion: $syncVersion, ')
          ..write('syncDeviceId: $syncDeviceId, ')
          ..write('syncIsDirty: $syncIsDirty, ')
          ..write('conflictData: $conflictData, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActivitiesTable extends Activities
    with TableInfo<$ActivitiesTable, ActivityRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
    'client_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _triggersMeta = const VerificationMeta(
    'triggers',
  );
  @override
  late final GeneratedColumn<String> triggers = GeneratedColumn<String>(
    'triggers',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMinutesMeta = const VerificationMeta(
    'durationMinutes',
  );
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
    'duration_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncCreatedAtMeta = const VerificationMeta(
    'syncCreatedAt',
  );
  @override
  late final GeneratedColumn<int> syncCreatedAt = GeneratedColumn<int>(
    'sync_created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncUpdatedAtMeta = const VerificationMeta(
    'syncUpdatedAt',
  );
  @override
  late final GeneratedColumn<int> syncUpdatedAt = GeneratedColumn<int>(
    'sync_updated_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncDeletedAtMeta = const VerificationMeta(
    'syncDeletedAt',
  );
  @override
  late final GeneratedColumn<int> syncDeletedAt = GeneratedColumn<int>(
    'sync_deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncLastSyncedAtMeta = const VerificationMeta(
    'syncLastSyncedAt',
  );
  @override
  late final GeneratedColumn<int> syncLastSyncedAt = GeneratedColumn<int>(
    'sync_last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _syncVersionMeta = const VerificationMeta(
    'syncVersion',
  );
  @override
  late final GeneratedColumn<int> syncVersion = GeneratedColumn<int>(
    'sync_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _syncDeviceIdMeta = const VerificationMeta(
    'syncDeviceId',
  );
  @override
  late final GeneratedColumn<String> syncDeviceId = GeneratedColumn<String>(
    'sync_device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncIsDirtyMeta = const VerificationMeta(
    'syncIsDirty',
  );
  @override
  late final GeneratedColumn<bool> syncIsDirty = GeneratedColumn<bool>(
    'sync_is_dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sync_is_dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _conflictDataMeta = const VerificationMeta(
    'conflictData',
  );
  @override
  late final GeneratedColumn<String> conflictData = GeneratedColumn<String>(
    'conflict_data',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    clientId,
    profileId,
    name,
    description,
    location,
    triggers,
    durationMinutes,
    isArchived,
    syncCreatedAt,
    syncUpdatedAt,
    syncDeletedAt,
    syncLastSyncedAt,
    syncStatus,
    syncVersion,
    syncDeviceId,
    syncIsDirty,
    conflictData,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activities';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActivityRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    }
    if (data.containsKey('triggers')) {
      context.handle(
        _triggersMeta,
        triggers.isAcceptableOrUnknown(data['triggers']!, _triggersMeta),
      );
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
        _durationMinutesMeta,
        durationMinutes.isAcceptableOrUnknown(
          data['duration_minutes']!,
          _durationMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationMinutesMeta);
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('sync_created_at')) {
      context.handle(
        _syncCreatedAtMeta,
        syncCreatedAt.isAcceptableOrUnknown(
          data['sync_created_at']!,
          _syncCreatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_syncCreatedAtMeta);
    }
    if (data.containsKey('sync_updated_at')) {
      context.handle(
        _syncUpdatedAtMeta,
        syncUpdatedAt.isAcceptableOrUnknown(
          data['sync_updated_at']!,
          _syncUpdatedAtMeta,
        ),
      );
    }
    if (data.containsKey('sync_deleted_at')) {
      context.handle(
        _syncDeletedAtMeta,
        syncDeletedAt.isAcceptableOrUnknown(
          data['sync_deleted_at']!,
          _syncDeletedAtMeta,
        ),
      );
    }
    if (data.containsKey('sync_last_synced_at')) {
      context.handle(
        _syncLastSyncedAtMeta,
        syncLastSyncedAt.isAcceptableOrUnknown(
          data['sync_last_synced_at']!,
          _syncLastSyncedAtMeta,
        ),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('sync_version')) {
      context.handle(
        _syncVersionMeta,
        syncVersion.isAcceptableOrUnknown(
          data['sync_version']!,
          _syncVersionMeta,
        ),
      );
    }
    if (data.containsKey('sync_device_id')) {
      context.handle(
        _syncDeviceIdMeta,
        syncDeviceId.isAcceptableOrUnknown(
          data['sync_device_id']!,
          _syncDeviceIdMeta,
        ),
      );
    }
    if (data.containsKey('sync_is_dirty')) {
      context.handle(
        _syncIsDirtyMeta,
        syncIsDirty.isAcceptableOrUnknown(
          data['sync_is_dirty']!,
          _syncIsDirtyMeta,
        ),
      );
    }
    if (data.containsKey('conflict_data')) {
      context.handle(
        _conflictDataMeta,
        conflictData.isAcceptableOrUnknown(
          data['conflict_data']!,
          _conflictDataMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActivityRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivityRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      ),
      triggers: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}triggers'],
      ),
      durationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_minutes'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      syncCreatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_created_at'],
      )!,
      syncUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_updated_at'],
      ),
      syncDeletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_deleted_at'],
      ),
      syncLastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_last_synced_at'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_status'],
      )!,
      syncVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_version'],
      )!,
      syncDeviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_device_id'],
      ),
      syncIsDirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sync_is_dirty'],
      )!,
      conflictData: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conflict_data'],
      ),
    );
  }

  @override
  $ActivitiesTable createAlias(String alias) {
    return $ActivitiesTable(attachedDatabase, alias);
  }
}

class ActivityRow extends DataClass implements Insertable<ActivityRow> {
  final String id;
  final String clientId;
  final String profileId;
  final String name;
  final String? description;
  final String? location;
  final String? triggers;
  final int durationMinutes;
  final bool isArchived;
  final int syncCreatedAt;
  final int? syncUpdatedAt;
  final int? syncDeletedAt;
  final int? syncLastSyncedAt;
  final int syncStatus;
  final int syncVersion;
  final String? syncDeviceId;
  final bool syncIsDirty;
  final String? conflictData;
  const ActivityRow({
    required this.id,
    required this.clientId,
    required this.profileId,
    required this.name,
    this.description,
    this.location,
    this.triggers,
    required this.durationMinutes,
    required this.isArchived,
    required this.syncCreatedAt,
    this.syncUpdatedAt,
    this.syncDeletedAt,
    this.syncLastSyncedAt,
    required this.syncStatus,
    required this.syncVersion,
    this.syncDeviceId,
    required this.syncIsDirty,
    this.conflictData,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['client_id'] = Variable<String>(clientId);
    map['profile_id'] = Variable<String>(profileId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    if (!nullToAbsent || triggers != null) {
      map['triggers'] = Variable<String>(triggers);
    }
    map['duration_minutes'] = Variable<int>(durationMinutes);
    map['is_archived'] = Variable<bool>(isArchived);
    map['sync_created_at'] = Variable<int>(syncCreatedAt);
    if (!nullToAbsent || syncUpdatedAt != null) {
      map['sync_updated_at'] = Variable<int>(syncUpdatedAt);
    }
    if (!nullToAbsent || syncDeletedAt != null) {
      map['sync_deleted_at'] = Variable<int>(syncDeletedAt);
    }
    if (!nullToAbsent || syncLastSyncedAt != null) {
      map['sync_last_synced_at'] = Variable<int>(syncLastSyncedAt);
    }
    map['sync_status'] = Variable<int>(syncStatus);
    map['sync_version'] = Variable<int>(syncVersion);
    if (!nullToAbsent || syncDeviceId != null) {
      map['sync_device_id'] = Variable<String>(syncDeviceId);
    }
    map['sync_is_dirty'] = Variable<bool>(syncIsDirty);
    if (!nullToAbsent || conflictData != null) {
      map['conflict_data'] = Variable<String>(conflictData);
    }
    return map;
  }

  ActivitiesCompanion toCompanion(bool nullToAbsent) {
    return ActivitiesCompanion(
      id: Value(id),
      clientId: Value(clientId),
      profileId: Value(profileId),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      location: location == null && nullToAbsent
          ? const Value.absent()
          : Value(location),
      triggers: triggers == null && nullToAbsent
          ? const Value.absent()
          : Value(triggers),
      durationMinutes: Value(durationMinutes),
      isArchived: Value(isArchived),
      syncCreatedAt: Value(syncCreatedAt),
      syncUpdatedAt: syncUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncUpdatedAt),
      syncDeletedAt: syncDeletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncDeletedAt),
      syncLastSyncedAt: syncLastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncLastSyncedAt),
      syncStatus: Value(syncStatus),
      syncVersion: Value(syncVersion),
      syncDeviceId: syncDeviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(syncDeviceId),
      syncIsDirty: Value(syncIsDirty),
      conflictData: conflictData == null && nullToAbsent
          ? const Value.absent()
          : Value(conflictData),
    );
  }

  factory ActivityRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivityRow(
      id: serializer.fromJson<String>(json['id']),
      clientId: serializer.fromJson<String>(json['clientId']),
      profileId: serializer.fromJson<String>(json['profileId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      location: serializer.fromJson<String?>(json['location']),
      triggers: serializer.fromJson<String?>(json['triggers']),
      durationMinutes: serializer.fromJson<int>(json['durationMinutes']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      syncCreatedAt: serializer.fromJson<int>(json['syncCreatedAt']),
      syncUpdatedAt: serializer.fromJson<int?>(json['syncUpdatedAt']),
      syncDeletedAt: serializer.fromJson<int?>(json['syncDeletedAt']),
      syncLastSyncedAt: serializer.fromJson<int?>(json['syncLastSyncedAt']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
      syncVersion: serializer.fromJson<int>(json['syncVersion']),
      syncDeviceId: serializer.fromJson<String?>(json['syncDeviceId']),
      syncIsDirty: serializer.fromJson<bool>(json['syncIsDirty']),
      conflictData: serializer.fromJson<String?>(json['conflictData']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'clientId': serializer.toJson<String>(clientId),
      'profileId': serializer.toJson<String>(profileId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'location': serializer.toJson<String?>(location),
      'triggers': serializer.toJson<String?>(triggers),
      'durationMinutes': serializer.toJson<int>(durationMinutes),
      'isArchived': serializer.toJson<bool>(isArchived),
      'syncCreatedAt': serializer.toJson<int>(syncCreatedAt),
      'syncUpdatedAt': serializer.toJson<int?>(syncUpdatedAt),
      'syncDeletedAt': serializer.toJson<int?>(syncDeletedAt),
      'syncLastSyncedAt': serializer.toJson<int?>(syncLastSyncedAt),
      'syncStatus': serializer.toJson<int>(syncStatus),
      'syncVersion': serializer.toJson<int>(syncVersion),
      'syncDeviceId': serializer.toJson<String?>(syncDeviceId),
      'syncIsDirty': serializer.toJson<bool>(syncIsDirty),
      'conflictData': serializer.toJson<String?>(conflictData),
    };
  }

  ActivityRow copyWith({
    String? id,
    String? clientId,
    String? profileId,
    String? name,
    Value<String?> description = const Value.absent(),
    Value<String?> location = const Value.absent(),
    Value<String?> triggers = const Value.absent(),
    int? durationMinutes,
    bool? isArchived,
    int? syncCreatedAt,
    Value<int?> syncUpdatedAt = const Value.absent(),
    Value<int?> syncDeletedAt = const Value.absent(),
    Value<int?> syncLastSyncedAt = const Value.absent(),
    int? syncStatus,
    int? syncVersion,
    Value<String?> syncDeviceId = const Value.absent(),
    bool? syncIsDirty,
    Value<String?> conflictData = const Value.absent(),
  }) => ActivityRow(
    id: id ?? this.id,
    clientId: clientId ?? this.clientId,
    profileId: profileId ?? this.profileId,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    location: location.present ? location.value : this.location,
    triggers: triggers.present ? triggers.value : this.triggers,
    durationMinutes: durationMinutes ?? this.durationMinutes,
    isArchived: isArchived ?? this.isArchived,
    syncCreatedAt: syncCreatedAt ?? this.syncCreatedAt,
    syncUpdatedAt: syncUpdatedAt.present
        ? syncUpdatedAt.value
        : this.syncUpdatedAt,
    syncDeletedAt: syncDeletedAt.present
        ? syncDeletedAt.value
        : this.syncDeletedAt,
    syncLastSyncedAt: syncLastSyncedAt.present
        ? syncLastSyncedAt.value
        : this.syncLastSyncedAt,
    syncStatus: syncStatus ?? this.syncStatus,
    syncVersion: syncVersion ?? this.syncVersion,
    syncDeviceId: syncDeviceId.present ? syncDeviceId.value : this.syncDeviceId,
    syncIsDirty: syncIsDirty ?? this.syncIsDirty,
    conflictData: conflictData.present ? conflictData.value : this.conflictData,
  );
  ActivityRow copyWithCompanion(ActivitiesCompanion data) {
    return ActivityRow(
      id: data.id.present ? data.id.value : this.id,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      location: data.location.present ? data.location.value : this.location,
      triggers: data.triggers.present ? data.triggers.value : this.triggers,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      syncCreatedAt: data.syncCreatedAt.present
          ? data.syncCreatedAt.value
          : this.syncCreatedAt,
      syncUpdatedAt: data.syncUpdatedAt.present
          ? data.syncUpdatedAt.value
          : this.syncUpdatedAt,
      syncDeletedAt: data.syncDeletedAt.present
          ? data.syncDeletedAt.value
          : this.syncDeletedAt,
      syncLastSyncedAt: data.syncLastSyncedAt.present
          ? data.syncLastSyncedAt.value
          : this.syncLastSyncedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      syncVersion: data.syncVersion.present
          ? data.syncVersion.value
          : this.syncVersion,
      syncDeviceId: data.syncDeviceId.present
          ? data.syncDeviceId.value
          : this.syncDeviceId,
      syncIsDirty: data.syncIsDirty.present
          ? data.syncIsDirty.value
          : this.syncIsDirty,
      conflictData: data.conflictData.present
          ? data.conflictData.value
          : this.conflictData,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActivityRow(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('profileId: $profileId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('location: $location, ')
          ..write('triggers: $triggers, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('isArchived: $isArchived, ')
          ..write('syncCreatedAt: $syncCreatedAt, ')
          ..write('syncUpdatedAt: $syncUpdatedAt, ')
          ..write('syncDeletedAt: $syncDeletedAt, ')
          ..write('syncLastSyncedAt: $syncLastSyncedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncVersion: $syncVersion, ')
          ..write('syncDeviceId: $syncDeviceId, ')
          ..write('syncIsDirty: $syncIsDirty, ')
          ..write('conflictData: $conflictData')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    clientId,
    profileId,
    name,
    description,
    location,
    triggers,
    durationMinutes,
    isArchived,
    syncCreatedAt,
    syncUpdatedAt,
    syncDeletedAt,
    syncLastSyncedAt,
    syncStatus,
    syncVersion,
    syncDeviceId,
    syncIsDirty,
    conflictData,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivityRow &&
          other.id == this.id &&
          other.clientId == this.clientId &&
          other.profileId == this.profileId &&
          other.name == this.name &&
          other.description == this.description &&
          other.location == this.location &&
          other.triggers == this.triggers &&
          other.durationMinutes == this.durationMinutes &&
          other.isArchived == this.isArchived &&
          other.syncCreatedAt == this.syncCreatedAt &&
          other.syncUpdatedAt == this.syncUpdatedAt &&
          other.syncDeletedAt == this.syncDeletedAt &&
          other.syncLastSyncedAt == this.syncLastSyncedAt &&
          other.syncStatus == this.syncStatus &&
          other.syncVersion == this.syncVersion &&
          other.syncDeviceId == this.syncDeviceId &&
          other.syncIsDirty == this.syncIsDirty &&
          other.conflictData == this.conflictData);
}

class ActivitiesCompanion extends UpdateCompanion<ActivityRow> {
  final Value<String> id;
  final Value<String> clientId;
  final Value<String> profileId;
  final Value<String> name;
  final Value<String?> description;
  final Value<String?> location;
  final Value<String?> triggers;
  final Value<int> durationMinutes;
  final Value<bool> isArchived;
  final Value<int> syncCreatedAt;
  final Value<int?> syncUpdatedAt;
  final Value<int?> syncDeletedAt;
  final Value<int?> syncLastSyncedAt;
  final Value<int> syncStatus;
  final Value<int> syncVersion;
  final Value<String?> syncDeviceId;
  final Value<bool> syncIsDirty;
  final Value<String?> conflictData;
  final Value<int> rowid;
  const ActivitiesCompanion({
    this.id = const Value.absent(),
    this.clientId = const Value.absent(),
    this.profileId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.location = const Value.absent(),
    this.triggers = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.syncCreatedAt = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
    this.syncDeletedAt = const Value.absent(),
    this.syncLastSyncedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncVersion = const Value.absent(),
    this.syncDeviceId = const Value.absent(),
    this.syncIsDirty = const Value.absent(),
    this.conflictData = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActivitiesCompanion.insert({
    required String id,
    required String clientId,
    required String profileId,
    required String name,
    this.description = const Value.absent(),
    this.location = const Value.absent(),
    this.triggers = const Value.absent(),
    required int durationMinutes,
    this.isArchived = const Value.absent(),
    required int syncCreatedAt,
    this.syncUpdatedAt = const Value.absent(),
    this.syncDeletedAt = const Value.absent(),
    this.syncLastSyncedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncVersion = const Value.absent(),
    this.syncDeviceId = const Value.absent(),
    this.syncIsDirty = const Value.absent(),
    this.conflictData = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       clientId = Value(clientId),
       profileId = Value(profileId),
       name = Value(name),
       durationMinutes = Value(durationMinutes),
       syncCreatedAt = Value(syncCreatedAt);
  static Insertable<ActivityRow> custom({
    Expression<String>? id,
    Expression<String>? clientId,
    Expression<String>? profileId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? location,
    Expression<String>? triggers,
    Expression<int>? durationMinutes,
    Expression<bool>? isArchived,
    Expression<int>? syncCreatedAt,
    Expression<int>? syncUpdatedAt,
    Expression<int>? syncDeletedAt,
    Expression<int>? syncLastSyncedAt,
    Expression<int>? syncStatus,
    Expression<int>? syncVersion,
    Expression<String>? syncDeviceId,
    Expression<bool>? syncIsDirty,
    Expression<String>? conflictData,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clientId != null) 'client_id': clientId,
      if (profileId != null) 'profile_id': profileId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (location != null) 'location': location,
      if (triggers != null) 'triggers': triggers,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (isArchived != null) 'is_archived': isArchived,
      if (syncCreatedAt != null) 'sync_created_at': syncCreatedAt,
      if (syncUpdatedAt != null) 'sync_updated_at': syncUpdatedAt,
      if (syncDeletedAt != null) 'sync_deleted_at': syncDeletedAt,
      if (syncLastSyncedAt != null) 'sync_last_synced_at': syncLastSyncedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncVersion != null) 'sync_version': syncVersion,
      if (syncDeviceId != null) 'sync_device_id': syncDeviceId,
      if (syncIsDirty != null) 'sync_is_dirty': syncIsDirty,
      if (conflictData != null) 'conflict_data': conflictData,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActivitiesCompanion copyWith({
    Value<String>? id,
    Value<String>? clientId,
    Value<String>? profileId,
    Value<String>? name,
    Value<String?>? description,
    Value<String?>? location,
    Value<String?>? triggers,
    Value<int>? durationMinutes,
    Value<bool>? isArchived,
    Value<int>? syncCreatedAt,
    Value<int?>? syncUpdatedAt,
    Value<int?>? syncDeletedAt,
    Value<int?>? syncLastSyncedAt,
    Value<int>? syncStatus,
    Value<int>? syncVersion,
    Value<String?>? syncDeviceId,
    Value<bool>? syncIsDirty,
    Value<String?>? conflictData,
    Value<int>? rowid,
  }) {
    return ActivitiesCompanion(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      profileId: profileId ?? this.profileId,
      name: name ?? this.name,
      description: description ?? this.description,
      location: location ?? this.location,
      triggers: triggers ?? this.triggers,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      isArchived: isArchived ?? this.isArchived,
      syncCreatedAt: syncCreatedAt ?? this.syncCreatedAt,
      syncUpdatedAt: syncUpdatedAt ?? this.syncUpdatedAt,
      syncDeletedAt: syncDeletedAt ?? this.syncDeletedAt,
      syncLastSyncedAt: syncLastSyncedAt ?? this.syncLastSyncedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      syncVersion: syncVersion ?? this.syncVersion,
      syncDeviceId: syncDeviceId ?? this.syncDeviceId,
      syncIsDirty: syncIsDirty ?? this.syncIsDirty,
      conflictData: conflictData ?? this.conflictData,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (triggers.present) {
      map['triggers'] = Variable<String>(triggers.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (syncCreatedAt.present) {
      map['sync_created_at'] = Variable<int>(syncCreatedAt.value);
    }
    if (syncUpdatedAt.present) {
      map['sync_updated_at'] = Variable<int>(syncUpdatedAt.value);
    }
    if (syncDeletedAt.present) {
      map['sync_deleted_at'] = Variable<int>(syncDeletedAt.value);
    }
    if (syncLastSyncedAt.present) {
      map['sync_last_synced_at'] = Variable<int>(syncLastSyncedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (syncVersion.present) {
      map['sync_version'] = Variable<int>(syncVersion.value);
    }
    if (syncDeviceId.present) {
      map['sync_device_id'] = Variable<String>(syncDeviceId.value);
    }
    if (syncIsDirty.present) {
      map['sync_is_dirty'] = Variable<bool>(syncIsDirty.value);
    }
    if (conflictData.present) {
      map['conflict_data'] = Variable<String>(conflictData.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivitiesCompanion(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('profileId: $profileId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('location: $location, ')
          ..write('triggers: $triggers, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('isArchived: $isArchived, ')
          ..write('syncCreatedAt: $syncCreatedAt, ')
          ..write('syncUpdatedAt: $syncUpdatedAt, ')
          ..write('syncDeletedAt: $syncDeletedAt, ')
          ..write('syncLastSyncedAt: $syncLastSyncedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncVersion: $syncVersion, ')
          ..write('syncDeviceId: $syncDeviceId, ')
          ..write('syncIsDirty: $syncIsDirty, ')
          ..write('conflictData: $conflictData, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActivityLogsTable extends ActivityLogs
    with TableInfo<$ActivityLogsTable, ActivityLogRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivityLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
    'client_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<int> timestamp = GeneratedColumn<int>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activityIdsMeta = const VerificationMeta(
    'activityIds',
  );
  @override
  late final GeneratedColumn<String> activityIds = GeneratedColumn<String>(
    'activity_ids',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _adHocActivitiesMeta = const VerificationMeta(
    'adHocActivities',
  );
  @override
  late final GeneratedColumn<String> adHocActivities = GeneratedColumn<String>(
    'ad_hoc_activities',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMeta = const VerificationMeta(
    'duration',
  );
  @override
  late final GeneratedColumn<int> duration = GeneratedColumn<int>(
    'duration',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _importSourceMeta = const VerificationMeta(
    'importSource',
  );
  @override
  late final GeneratedColumn<String> importSource = GeneratedColumn<String>(
    'import_source',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _importExternalIdMeta = const VerificationMeta(
    'importExternalId',
  );
  @override
  late final GeneratedColumn<String> importExternalId = GeneratedColumn<String>(
    'import_external_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncCreatedAtMeta = const VerificationMeta(
    'syncCreatedAt',
  );
  @override
  late final GeneratedColumn<int> syncCreatedAt = GeneratedColumn<int>(
    'sync_created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncUpdatedAtMeta = const VerificationMeta(
    'syncUpdatedAt',
  );
  @override
  late final GeneratedColumn<int> syncUpdatedAt = GeneratedColumn<int>(
    'sync_updated_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncDeletedAtMeta = const VerificationMeta(
    'syncDeletedAt',
  );
  @override
  late final GeneratedColumn<int> syncDeletedAt = GeneratedColumn<int>(
    'sync_deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncLastSyncedAtMeta = const VerificationMeta(
    'syncLastSyncedAt',
  );
  @override
  late final GeneratedColumn<int> syncLastSyncedAt = GeneratedColumn<int>(
    'sync_last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _syncVersionMeta = const VerificationMeta(
    'syncVersion',
  );
  @override
  late final GeneratedColumn<int> syncVersion = GeneratedColumn<int>(
    'sync_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _syncDeviceIdMeta = const VerificationMeta(
    'syncDeviceId',
  );
  @override
  late final GeneratedColumn<String> syncDeviceId = GeneratedColumn<String>(
    'sync_device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncIsDirtyMeta = const VerificationMeta(
    'syncIsDirty',
  );
  @override
  late final GeneratedColumn<bool> syncIsDirty = GeneratedColumn<bool>(
    'sync_is_dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sync_is_dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _conflictDataMeta = const VerificationMeta(
    'conflictData',
  );
  @override
  late final GeneratedColumn<String> conflictData = GeneratedColumn<String>(
    'conflict_data',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    clientId,
    profileId,
    timestamp,
    activityIds,
    adHocActivities,
    duration,
    notes,
    importSource,
    importExternalId,
    syncCreatedAt,
    syncUpdatedAt,
    syncDeletedAt,
    syncLastSyncedAt,
    syncStatus,
    syncVersion,
    syncDeviceId,
    syncIsDirty,
    conflictData,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activity_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActivityLogRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('activity_ids')) {
      context.handle(
        _activityIdsMeta,
        activityIds.isAcceptableOrUnknown(
          data['activity_ids']!,
          _activityIdsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_activityIdsMeta);
    }
    if (data.containsKey('ad_hoc_activities')) {
      context.handle(
        _adHocActivitiesMeta,
        adHocActivities.isAcceptableOrUnknown(
          data['ad_hoc_activities']!,
          _adHocActivitiesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_adHocActivitiesMeta);
    }
    if (data.containsKey('duration')) {
      context.handle(
        _durationMeta,
        duration.isAcceptableOrUnknown(data['duration']!, _durationMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('import_source')) {
      context.handle(
        _importSourceMeta,
        importSource.isAcceptableOrUnknown(
          data['import_source']!,
          _importSourceMeta,
        ),
      );
    }
    if (data.containsKey('import_external_id')) {
      context.handle(
        _importExternalIdMeta,
        importExternalId.isAcceptableOrUnknown(
          data['import_external_id']!,
          _importExternalIdMeta,
        ),
      );
    }
    if (data.containsKey('sync_created_at')) {
      context.handle(
        _syncCreatedAtMeta,
        syncCreatedAt.isAcceptableOrUnknown(
          data['sync_created_at']!,
          _syncCreatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_syncCreatedAtMeta);
    }
    if (data.containsKey('sync_updated_at')) {
      context.handle(
        _syncUpdatedAtMeta,
        syncUpdatedAt.isAcceptableOrUnknown(
          data['sync_updated_at']!,
          _syncUpdatedAtMeta,
        ),
      );
    }
    if (data.containsKey('sync_deleted_at')) {
      context.handle(
        _syncDeletedAtMeta,
        syncDeletedAt.isAcceptableOrUnknown(
          data['sync_deleted_at']!,
          _syncDeletedAtMeta,
        ),
      );
    }
    if (data.containsKey('sync_last_synced_at')) {
      context.handle(
        _syncLastSyncedAtMeta,
        syncLastSyncedAt.isAcceptableOrUnknown(
          data['sync_last_synced_at']!,
          _syncLastSyncedAtMeta,
        ),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('sync_version')) {
      context.handle(
        _syncVersionMeta,
        syncVersion.isAcceptableOrUnknown(
          data['sync_version']!,
          _syncVersionMeta,
        ),
      );
    }
    if (data.containsKey('sync_device_id')) {
      context.handle(
        _syncDeviceIdMeta,
        syncDeviceId.isAcceptableOrUnknown(
          data['sync_device_id']!,
          _syncDeviceIdMeta,
        ),
      );
    }
    if (data.containsKey('sync_is_dirty')) {
      context.handle(
        _syncIsDirtyMeta,
        syncIsDirty.isAcceptableOrUnknown(
          data['sync_is_dirty']!,
          _syncIsDirtyMeta,
        ),
      );
    }
    if (data.containsKey('conflict_data')) {
      context.handle(
        _conflictDataMeta,
        conflictData.isAcceptableOrUnknown(
          data['conflict_data']!,
          _conflictDataMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActivityLogRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivityLogRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}timestamp'],
      )!,
      activityIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_ids'],
      )!,
      adHocActivities: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ad_hoc_activities'],
      )!,
      duration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      importSource: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}import_source'],
      ),
      importExternalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}import_external_id'],
      ),
      syncCreatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_created_at'],
      )!,
      syncUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_updated_at'],
      ),
      syncDeletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_deleted_at'],
      ),
      syncLastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_last_synced_at'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_status'],
      )!,
      syncVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_version'],
      )!,
      syncDeviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_device_id'],
      ),
      syncIsDirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sync_is_dirty'],
      )!,
      conflictData: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conflict_data'],
      ),
    );
  }

  @override
  $ActivityLogsTable createAlias(String alias) {
    return $ActivityLogsTable(attachedDatabase, alias);
  }
}

class ActivityLogRow extends DataClass implements Insertable<ActivityLogRow> {
  final String id;
  final String clientId;
  final String profileId;
  final int timestamp;
  final String activityIds;
  final String adHocActivities;
  final int? duration;
  final String? notes;
  final String? importSource;
  final String? importExternalId;
  final int syncCreatedAt;
  final int? syncUpdatedAt;
  final int? syncDeletedAt;
  final int? syncLastSyncedAt;
  final int syncStatus;
  final int syncVersion;
  final String? syncDeviceId;
  final bool syncIsDirty;
  final String? conflictData;
  const ActivityLogRow({
    required this.id,
    required this.clientId,
    required this.profileId,
    required this.timestamp,
    required this.activityIds,
    required this.adHocActivities,
    this.duration,
    this.notes,
    this.importSource,
    this.importExternalId,
    required this.syncCreatedAt,
    this.syncUpdatedAt,
    this.syncDeletedAt,
    this.syncLastSyncedAt,
    required this.syncStatus,
    required this.syncVersion,
    this.syncDeviceId,
    required this.syncIsDirty,
    this.conflictData,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['client_id'] = Variable<String>(clientId);
    map['profile_id'] = Variable<String>(profileId);
    map['timestamp'] = Variable<int>(timestamp);
    map['activity_ids'] = Variable<String>(activityIds);
    map['ad_hoc_activities'] = Variable<String>(adHocActivities);
    if (!nullToAbsent || duration != null) {
      map['duration'] = Variable<int>(duration);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || importSource != null) {
      map['import_source'] = Variable<String>(importSource);
    }
    if (!nullToAbsent || importExternalId != null) {
      map['import_external_id'] = Variable<String>(importExternalId);
    }
    map['sync_created_at'] = Variable<int>(syncCreatedAt);
    if (!nullToAbsent || syncUpdatedAt != null) {
      map['sync_updated_at'] = Variable<int>(syncUpdatedAt);
    }
    if (!nullToAbsent || syncDeletedAt != null) {
      map['sync_deleted_at'] = Variable<int>(syncDeletedAt);
    }
    if (!nullToAbsent || syncLastSyncedAt != null) {
      map['sync_last_synced_at'] = Variable<int>(syncLastSyncedAt);
    }
    map['sync_status'] = Variable<int>(syncStatus);
    map['sync_version'] = Variable<int>(syncVersion);
    if (!nullToAbsent || syncDeviceId != null) {
      map['sync_device_id'] = Variable<String>(syncDeviceId);
    }
    map['sync_is_dirty'] = Variable<bool>(syncIsDirty);
    if (!nullToAbsent || conflictData != null) {
      map['conflict_data'] = Variable<String>(conflictData);
    }
    return map;
  }

  ActivityLogsCompanion toCompanion(bool nullToAbsent) {
    return ActivityLogsCompanion(
      id: Value(id),
      clientId: Value(clientId),
      profileId: Value(profileId),
      timestamp: Value(timestamp),
      activityIds: Value(activityIds),
      adHocActivities: Value(adHocActivities),
      duration: duration == null && nullToAbsent
          ? const Value.absent()
          : Value(duration),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      importSource: importSource == null && nullToAbsent
          ? const Value.absent()
          : Value(importSource),
      importExternalId: importExternalId == null && nullToAbsent
          ? const Value.absent()
          : Value(importExternalId),
      syncCreatedAt: Value(syncCreatedAt),
      syncUpdatedAt: syncUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncUpdatedAt),
      syncDeletedAt: syncDeletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncDeletedAt),
      syncLastSyncedAt: syncLastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncLastSyncedAt),
      syncStatus: Value(syncStatus),
      syncVersion: Value(syncVersion),
      syncDeviceId: syncDeviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(syncDeviceId),
      syncIsDirty: Value(syncIsDirty),
      conflictData: conflictData == null && nullToAbsent
          ? const Value.absent()
          : Value(conflictData),
    );
  }

  factory ActivityLogRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivityLogRow(
      id: serializer.fromJson<String>(json['id']),
      clientId: serializer.fromJson<String>(json['clientId']),
      profileId: serializer.fromJson<String>(json['profileId']),
      timestamp: serializer.fromJson<int>(json['timestamp']),
      activityIds: serializer.fromJson<String>(json['activityIds']),
      adHocActivities: serializer.fromJson<String>(json['adHocActivities']),
      duration: serializer.fromJson<int?>(json['duration']),
      notes: serializer.fromJson<String?>(json['notes']),
      importSource: serializer.fromJson<String?>(json['importSource']),
      importExternalId: serializer.fromJson<String?>(json['importExternalId']),
      syncCreatedAt: serializer.fromJson<int>(json['syncCreatedAt']),
      syncUpdatedAt: serializer.fromJson<int?>(json['syncUpdatedAt']),
      syncDeletedAt: serializer.fromJson<int?>(json['syncDeletedAt']),
      syncLastSyncedAt: serializer.fromJson<int?>(json['syncLastSyncedAt']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
      syncVersion: serializer.fromJson<int>(json['syncVersion']),
      syncDeviceId: serializer.fromJson<String?>(json['syncDeviceId']),
      syncIsDirty: serializer.fromJson<bool>(json['syncIsDirty']),
      conflictData: serializer.fromJson<String?>(json['conflictData']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'clientId': serializer.toJson<String>(clientId),
      'profileId': serializer.toJson<String>(profileId),
      'timestamp': serializer.toJson<int>(timestamp),
      'activityIds': serializer.toJson<String>(activityIds),
      'adHocActivities': serializer.toJson<String>(adHocActivities),
      'duration': serializer.toJson<int?>(duration),
      'notes': serializer.toJson<String?>(notes),
      'importSource': serializer.toJson<String?>(importSource),
      'importExternalId': serializer.toJson<String?>(importExternalId),
      'syncCreatedAt': serializer.toJson<int>(syncCreatedAt),
      'syncUpdatedAt': serializer.toJson<int?>(syncUpdatedAt),
      'syncDeletedAt': serializer.toJson<int?>(syncDeletedAt),
      'syncLastSyncedAt': serializer.toJson<int?>(syncLastSyncedAt),
      'syncStatus': serializer.toJson<int>(syncStatus),
      'syncVersion': serializer.toJson<int>(syncVersion),
      'syncDeviceId': serializer.toJson<String?>(syncDeviceId),
      'syncIsDirty': serializer.toJson<bool>(syncIsDirty),
      'conflictData': serializer.toJson<String?>(conflictData),
    };
  }

  ActivityLogRow copyWith({
    String? id,
    String? clientId,
    String? profileId,
    int? timestamp,
    String? activityIds,
    String? adHocActivities,
    Value<int?> duration = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<String?> importSource = const Value.absent(),
    Value<String?> importExternalId = const Value.absent(),
    int? syncCreatedAt,
    Value<int?> syncUpdatedAt = const Value.absent(),
    Value<int?> syncDeletedAt = const Value.absent(),
    Value<int?> syncLastSyncedAt = const Value.absent(),
    int? syncStatus,
    int? syncVersion,
    Value<String?> syncDeviceId = const Value.absent(),
    bool? syncIsDirty,
    Value<String?> conflictData = const Value.absent(),
  }) => ActivityLogRow(
    id: id ?? this.id,
    clientId: clientId ?? this.clientId,
    profileId: profileId ?? this.profileId,
    timestamp: timestamp ?? this.timestamp,
    activityIds: activityIds ?? this.activityIds,
    adHocActivities: adHocActivities ?? this.adHocActivities,
    duration: duration.present ? duration.value : this.duration,
    notes: notes.present ? notes.value : this.notes,
    importSource: importSource.present ? importSource.value : this.importSource,
    importExternalId: importExternalId.present
        ? importExternalId.value
        : this.importExternalId,
    syncCreatedAt: syncCreatedAt ?? this.syncCreatedAt,
    syncUpdatedAt: syncUpdatedAt.present
        ? syncUpdatedAt.value
        : this.syncUpdatedAt,
    syncDeletedAt: syncDeletedAt.present
        ? syncDeletedAt.value
        : this.syncDeletedAt,
    syncLastSyncedAt: syncLastSyncedAt.present
        ? syncLastSyncedAt.value
        : this.syncLastSyncedAt,
    syncStatus: syncStatus ?? this.syncStatus,
    syncVersion: syncVersion ?? this.syncVersion,
    syncDeviceId: syncDeviceId.present ? syncDeviceId.value : this.syncDeviceId,
    syncIsDirty: syncIsDirty ?? this.syncIsDirty,
    conflictData: conflictData.present ? conflictData.value : this.conflictData,
  );
  ActivityLogRow copyWithCompanion(ActivityLogsCompanion data) {
    return ActivityLogRow(
      id: data.id.present ? data.id.value : this.id,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      activityIds: data.activityIds.present
          ? data.activityIds.value
          : this.activityIds,
      adHocActivities: data.adHocActivities.present
          ? data.adHocActivities.value
          : this.adHocActivities,
      duration: data.duration.present ? data.duration.value : this.duration,
      notes: data.notes.present ? data.notes.value : this.notes,
      importSource: data.importSource.present
          ? data.importSource.value
          : this.importSource,
      importExternalId: data.importExternalId.present
          ? data.importExternalId.value
          : this.importExternalId,
      syncCreatedAt: data.syncCreatedAt.present
          ? data.syncCreatedAt.value
          : this.syncCreatedAt,
      syncUpdatedAt: data.syncUpdatedAt.present
          ? data.syncUpdatedAt.value
          : this.syncUpdatedAt,
      syncDeletedAt: data.syncDeletedAt.present
          ? data.syncDeletedAt.value
          : this.syncDeletedAt,
      syncLastSyncedAt: data.syncLastSyncedAt.present
          ? data.syncLastSyncedAt.value
          : this.syncLastSyncedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      syncVersion: data.syncVersion.present
          ? data.syncVersion.value
          : this.syncVersion,
      syncDeviceId: data.syncDeviceId.present
          ? data.syncDeviceId.value
          : this.syncDeviceId,
      syncIsDirty: data.syncIsDirty.present
          ? data.syncIsDirty.value
          : this.syncIsDirty,
      conflictData: data.conflictData.present
          ? data.conflictData.value
          : this.conflictData,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActivityLogRow(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('profileId: $profileId, ')
          ..write('timestamp: $timestamp, ')
          ..write('activityIds: $activityIds, ')
          ..write('adHocActivities: $adHocActivities, ')
          ..write('duration: $duration, ')
          ..write('notes: $notes, ')
          ..write('importSource: $importSource, ')
          ..write('importExternalId: $importExternalId, ')
          ..write('syncCreatedAt: $syncCreatedAt, ')
          ..write('syncUpdatedAt: $syncUpdatedAt, ')
          ..write('syncDeletedAt: $syncDeletedAt, ')
          ..write('syncLastSyncedAt: $syncLastSyncedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncVersion: $syncVersion, ')
          ..write('syncDeviceId: $syncDeviceId, ')
          ..write('syncIsDirty: $syncIsDirty, ')
          ..write('conflictData: $conflictData')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    clientId,
    profileId,
    timestamp,
    activityIds,
    adHocActivities,
    duration,
    notes,
    importSource,
    importExternalId,
    syncCreatedAt,
    syncUpdatedAt,
    syncDeletedAt,
    syncLastSyncedAt,
    syncStatus,
    syncVersion,
    syncDeviceId,
    syncIsDirty,
    conflictData,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivityLogRow &&
          other.id == this.id &&
          other.clientId == this.clientId &&
          other.profileId == this.profileId &&
          other.timestamp == this.timestamp &&
          other.activityIds == this.activityIds &&
          other.adHocActivities == this.adHocActivities &&
          other.duration == this.duration &&
          other.notes == this.notes &&
          other.importSource == this.importSource &&
          other.importExternalId == this.importExternalId &&
          other.syncCreatedAt == this.syncCreatedAt &&
          other.syncUpdatedAt == this.syncUpdatedAt &&
          other.syncDeletedAt == this.syncDeletedAt &&
          other.syncLastSyncedAt == this.syncLastSyncedAt &&
          other.syncStatus == this.syncStatus &&
          other.syncVersion == this.syncVersion &&
          other.syncDeviceId == this.syncDeviceId &&
          other.syncIsDirty == this.syncIsDirty &&
          other.conflictData == this.conflictData);
}

class ActivityLogsCompanion extends UpdateCompanion<ActivityLogRow> {
  final Value<String> id;
  final Value<String> clientId;
  final Value<String> profileId;
  final Value<int> timestamp;
  final Value<String> activityIds;
  final Value<String> adHocActivities;
  final Value<int?> duration;
  final Value<String?> notes;
  final Value<String?> importSource;
  final Value<String?> importExternalId;
  final Value<int> syncCreatedAt;
  final Value<int?> syncUpdatedAt;
  final Value<int?> syncDeletedAt;
  final Value<int?> syncLastSyncedAt;
  final Value<int> syncStatus;
  final Value<int> syncVersion;
  final Value<String?> syncDeviceId;
  final Value<bool> syncIsDirty;
  final Value<String?> conflictData;
  final Value<int> rowid;
  const ActivityLogsCompanion({
    this.id = const Value.absent(),
    this.clientId = const Value.absent(),
    this.profileId = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.activityIds = const Value.absent(),
    this.adHocActivities = const Value.absent(),
    this.duration = const Value.absent(),
    this.notes = const Value.absent(),
    this.importSource = const Value.absent(),
    this.importExternalId = const Value.absent(),
    this.syncCreatedAt = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
    this.syncDeletedAt = const Value.absent(),
    this.syncLastSyncedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncVersion = const Value.absent(),
    this.syncDeviceId = const Value.absent(),
    this.syncIsDirty = const Value.absent(),
    this.conflictData = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActivityLogsCompanion.insert({
    required String id,
    required String clientId,
    required String profileId,
    required int timestamp,
    required String activityIds,
    required String adHocActivities,
    this.duration = const Value.absent(),
    this.notes = const Value.absent(),
    this.importSource = const Value.absent(),
    this.importExternalId = const Value.absent(),
    required int syncCreatedAt,
    this.syncUpdatedAt = const Value.absent(),
    this.syncDeletedAt = const Value.absent(),
    this.syncLastSyncedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncVersion = const Value.absent(),
    this.syncDeviceId = const Value.absent(),
    this.syncIsDirty = const Value.absent(),
    this.conflictData = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       clientId = Value(clientId),
       profileId = Value(profileId),
       timestamp = Value(timestamp),
       activityIds = Value(activityIds),
       adHocActivities = Value(adHocActivities),
       syncCreatedAt = Value(syncCreatedAt);
  static Insertable<ActivityLogRow> custom({
    Expression<String>? id,
    Expression<String>? clientId,
    Expression<String>? profileId,
    Expression<int>? timestamp,
    Expression<String>? activityIds,
    Expression<String>? adHocActivities,
    Expression<int>? duration,
    Expression<String>? notes,
    Expression<String>? importSource,
    Expression<String>? importExternalId,
    Expression<int>? syncCreatedAt,
    Expression<int>? syncUpdatedAt,
    Expression<int>? syncDeletedAt,
    Expression<int>? syncLastSyncedAt,
    Expression<int>? syncStatus,
    Expression<int>? syncVersion,
    Expression<String>? syncDeviceId,
    Expression<bool>? syncIsDirty,
    Expression<String>? conflictData,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clientId != null) 'client_id': clientId,
      if (profileId != null) 'profile_id': profileId,
      if (timestamp != null) 'timestamp': timestamp,
      if (activityIds != null) 'activity_ids': activityIds,
      if (adHocActivities != null) 'ad_hoc_activities': adHocActivities,
      if (duration != null) 'duration': duration,
      if (notes != null) 'notes': notes,
      if (importSource != null) 'import_source': importSource,
      if (importExternalId != null) 'import_external_id': importExternalId,
      if (syncCreatedAt != null) 'sync_created_at': syncCreatedAt,
      if (syncUpdatedAt != null) 'sync_updated_at': syncUpdatedAt,
      if (syncDeletedAt != null) 'sync_deleted_at': syncDeletedAt,
      if (syncLastSyncedAt != null) 'sync_last_synced_at': syncLastSyncedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncVersion != null) 'sync_version': syncVersion,
      if (syncDeviceId != null) 'sync_device_id': syncDeviceId,
      if (syncIsDirty != null) 'sync_is_dirty': syncIsDirty,
      if (conflictData != null) 'conflict_data': conflictData,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActivityLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? clientId,
    Value<String>? profileId,
    Value<int>? timestamp,
    Value<String>? activityIds,
    Value<String>? adHocActivities,
    Value<int?>? duration,
    Value<String?>? notes,
    Value<String?>? importSource,
    Value<String?>? importExternalId,
    Value<int>? syncCreatedAt,
    Value<int?>? syncUpdatedAt,
    Value<int?>? syncDeletedAt,
    Value<int?>? syncLastSyncedAt,
    Value<int>? syncStatus,
    Value<int>? syncVersion,
    Value<String?>? syncDeviceId,
    Value<bool>? syncIsDirty,
    Value<String?>? conflictData,
    Value<int>? rowid,
  }) {
    return ActivityLogsCompanion(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      profileId: profileId ?? this.profileId,
      timestamp: timestamp ?? this.timestamp,
      activityIds: activityIds ?? this.activityIds,
      adHocActivities: adHocActivities ?? this.adHocActivities,
      duration: duration ?? this.duration,
      notes: notes ?? this.notes,
      importSource: importSource ?? this.importSource,
      importExternalId: importExternalId ?? this.importExternalId,
      syncCreatedAt: syncCreatedAt ?? this.syncCreatedAt,
      syncUpdatedAt: syncUpdatedAt ?? this.syncUpdatedAt,
      syncDeletedAt: syncDeletedAt ?? this.syncDeletedAt,
      syncLastSyncedAt: syncLastSyncedAt ?? this.syncLastSyncedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      syncVersion: syncVersion ?? this.syncVersion,
      syncDeviceId: syncDeviceId ?? this.syncDeviceId,
      syncIsDirty: syncIsDirty ?? this.syncIsDirty,
      conflictData: conflictData ?? this.conflictData,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<int>(timestamp.value);
    }
    if (activityIds.present) {
      map['activity_ids'] = Variable<String>(activityIds.value);
    }
    if (adHocActivities.present) {
      map['ad_hoc_activities'] = Variable<String>(adHocActivities.value);
    }
    if (duration.present) {
      map['duration'] = Variable<int>(duration.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (importSource.present) {
      map['import_source'] = Variable<String>(importSource.value);
    }
    if (importExternalId.present) {
      map['import_external_id'] = Variable<String>(importExternalId.value);
    }
    if (syncCreatedAt.present) {
      map['sync_created_at'] = Variable<int>(syncCreatedAt.value);
    }
    if (syncUpdatedAt.present) {
      map['sync_updated_at'] = Variable<int>(syncUpdatedAt.value);
    }
    if (syncDeletedAt.present) {
      map['sync_deleted_at'] = Variable<int>(syncDeletedAt.value);
    }
    if (syncLastSyncedAt.present) {
      map['sync_last_synced_at'] = Variable<int>(syncLastSyncedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (syncVersion.present) {
      map['sync_version'] = Variable<int>(syncVersion.value);
    }
    if (syncDeviceId.present) {
      map['sync_device_id'] = Variable<String>(syncDeviceId.value);
    }
    if (syncIsDirty.present) {
      map['sync_is_dirty'] = Variable<bool>(syncIsDirty.value);
    }
    if (conflictData.present) {
      map['conflict_data'] = Variable<String>(conflictData.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivityLogsCompanion(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('profileId: $profileId, ')
          ..write('timestamp: $timestamp, ')
          ..write('activityIds: $activityIds, ')
          ..write('adHocActivities: $adHocActivities, ')
          ..write('duration: $duration, ')
          ..write('notes: $notes, ')
          ..write('importSource: $importSource, ')
          ..write('importExternalId: $importExternalId, ')
          ..write('syncCreatedAt: $syncCreatedAt, ')
          ..write('syncUpdatedAt: $syncUpdatedAt, ')
          ..write('syncDeletedAt: $syncDeletedAt, ')
          ..write('syncLastSyncedAt: $syncLastSyncedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncVersion: $syncVersion, ')
          ..write('syncDeviceId: $syncDeviceId, ')
          ..write('syncIsDirty: $syncIsDirty, ')
          ..write('conflictData: $conflictData, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FoodItemsTable extends FoodItems
    with TableInfo<$FoodItemsTable, FoodItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoodItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
    'client_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<int> type = GeneratedColumn<int>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _simpleItemIdsMeta = const VerificationMeta(
    'simpleItemIds',
  );
  @override
  late final GeneratedColumn<String> simpleItemIds = GeneratedColumn<String>(
    'simple_item_ids',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isUserCreatedMeta = const VerificationMeta(
    'isUserCreated',
  );
  @override
  late final GeneratedColumn<bool> isUserCreated = GeneratedColumn<bool>(
    'is_user_created',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_user_created" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _servingSizeMeta = const VerificationMeta(
    'servingSize',
  );
  @override
  late final GeneratedColumn<double> servingSize = GeneratedColumn<double>(
    'serving_size',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _servingUnitMeta = const VerificationMeta(
    'servingUnit',
  );
  @override
  late final GeneratedColumn<String> servingUnit = GeneratedColumn<String>(
    'serving_unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _caloriesMeta = const VerificationMeta(
    'calories',
  );
  @override
  late final GeneratedColumn<double> calories = GeneratedColumn<double>(
    'calories',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _carbsGramsMeta = const VerificationMeta(
    'carbsGrams',
  );
  @override
  late final GeneratedColumn<double> carbsGrams = GeneratedColumn<double>(
    'carbs_grams',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fatGramsMeta = const VerificationMeta(
    'fatGrams',
  );
  @override
  late final GeneratedColumn<double> fatGrams = GeneratedColumn<double>(
    'fat_grams',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _proteinGramsMeta = const VerificationMeta(
    'proteinGrams',
  );
  @override
  late final GeneratedColumn<double> proteinGrams = GeneratedColumn<double>(
    'protein_grams',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fiberGramsMeta = const VerificationMeta(
    'fiberGrams',
  );
  @override
  late final GeneratedColumn<double> fiberGrams = GeneratedColumn<double>(
    'fiber_grams',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sugarGramsMeta = const VerificationMeta(
    'sugarGrams',
  );
  @override
  late final GeneratedColumn<double> sugarGrams = GeneratedColumn<double>(
    'sugar_grams',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncCreatedAtMeta = const VerificationMeta(
    'syncCreatedAt',
  );
  @override
  late final GeneratedColumn<int> syncCreatedAt = GeneratedColumn<int>(
    'sync_created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncUpdatedAtMeta = const VerificationMeta(
    'syncUpdatedAt',
  );
  @override
  late final GeneratedColumn<int> syncUpdatedAt = GeneratedColumn<int>(
    'sync_updated_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncDeletedAtMeta = const VerificationMeta(
    'syncDeletedAt',
  );
  @override
  late final GeneratedColumn<int> syncDeletedAt = GeneratedColumn<int>(
    'sync_deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncLastSyncedAtMeta = const VerificationMeta(
    'syncLastSyncedAt',
  );
  @override
  late final GeneratedColumn<int> syncLastSyncedAt = GeneratedColumn<int>(
    'sync_last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _syncVersionMeta = const VerificationMeta(
    'syncVersion',
  );
  @override
  late final GeneratedColumn<int> syncVersion = GeneratedColumn<int>(
    'sync_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _syncDeviceIdMeta = const VerificationMeta(
    'syncDeviceId',
  );
  @override
  late final GeneratedColumn<String> syncDeviceId = GeneratedColumn<String>(
    'sync_device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncIsDirtyMeta = const VerificationMeta(
    'syncIsDirty',
  );
  @override
  late final GeneratedColumn<bool> syncIsDirty = GeneratedColumn<bool>(
    'sync_is_dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sync_is_dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _conflictDataMeta = const VerificationMeta(
    'conflictData',
  );
  @override
  late final GeneratedColumn<String> conflictData = GeneratedColumn<String>(
    'conflict_data',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    clientId,
    profileId,
    name,
    type,
    simpleItemIds,
    isUserCreated,
    isArchived,
    servingSize,
    servingUnit,
    calories,
    carbsGrams,
    fatGrams,
    proteinGrams,
    fiberGrams,
    sugarGrams,
    syncCreatedAt,
    syncUpdatedAt,
    syncDeletedAt,
    syncLastSyncedAt,
    syncStatus,
    syncVersion,
    syncDeviceId,
    syncIsDirty,
    conflictData,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'food_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<FoodItemRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('simple_item_ids')) {
      context.handle(
        _simpleItemIdsMeta,
        simpleItemIds.isAcceptableOrUnknown(
          data['simple_item_ids']!,
          _simpleItemIdsMeta,
        ),
      );
    }
    if (data.containsKey('is_user_created')) {
      context.handle(
        _isUserCreatedMeta,
        isUserCreated.isAcceptableOrUnknown(
          data['is_user_created']!,
          _isUserCreatedMeta,
        ),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('serving_size')) {
      context.handle(
        _servingSizeMeta,
        servingSize.isAcceptableOrUnknown(
          data['serving_size']!,
          _servingSizeMeta,
        ),
      );
    }
    if (data.containsKey('serving_unit')) {
      context.handle(
        _servingUnitMeta,
        servingUnit.isAcceptableOrUnknown(
          data['serving_unit']!,
          _servingUnitMeta,
        ),
      );
    }
    if (data.containsKey('calories')) {
      context.handle(
        _caloriesMeta,
        calories.isAcceptableOrUnknown(data['calories']!, _caloriesMeta),
      );
    }
    if (data.containsKey('carbs_grams')) {
      context.handle(
        _carbsGramsMeta,
        carbsGrams.isAcceptableOrUnknown(data['carbs_grams']!, _carbsGramsMeta),
      );
    }
    if (data.containsKey('fat_grams')) {
      context.handle(
        _fatGramsMeta,
        fatGrams.isAcceptableOrUnknown(data['fat_grams']!, _fatGramsMeta),
      );
    }
    if (data.containsKey('protein_grams')) {
      context.handle(
        _proteinGramsMeta,
        proteinGrams.isAcceptableOrUnknown(
          data['protein_grams']!,
          _proteinGramsMeta,
        ),
      );
    }
    if (data.containsKey('fiber_grams')) {
      context.handle(
        _fiberGramsMeta,
        fiberGrams.isAcceptableOrUnknown(data['fiber_grams']!, _fiberGramsMeta),
      );
    }
    if (data.containsKey('sugar_grams')) {
      context.handle(
        _sugarGramsMeta,
        sugarGrams.isAcceptableOrUnknown(data['sugar_grams']!, _sugarGramsMeta),
      );
    }
    if (data.containsKey('sync_created_at')) {
      context.handle(
        _syncCreatedAtMeta,
        syncCreatedAt.isAcceptableOrUnknown(
          data['sync_created_at']!,
          _syncCreatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_syncCreatedAtMeta);
    }
    if (data.containsKey('sync_updated_at')) {
      context.handle(
        _syncUpdatedAtMeta,
        syncUpdatedAt.isAcceptableOrUnknown(
          data['sync_updated_at']!,
          _syncUpdatedAtMeta,
        ),
      );
    }
    if (data.containsKey('sync_deleted_at')) {
      context.handle(
        _syncDeletedAtMeta,
        syncDeletedAt.isAcceptableOrUnknown(
          data['sync_deleted_at']!,
          _syncDeletedAtMeta,
        ),
      );
    }
    if (data.containsKey('sync_last_synced_at')) {
      context.handle(
        _syncLastSyncedAtMeta,
        syncLastSyncedAt.isAcceptableOrUnknown(
          data['sync_last_synced_at']!,
          _syncLastSyncedAtMeta,
        ),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('sync_version')) {
      context.handle(
        _syncVersionMeta,
        syncVersion.isAcceptableOrUnknown(
          data['sync_version']!,
          _syncVersionMeta,
        ),
      );
    }
    if (data.containsKey('sync_device_id')) {
      context.handle(
        _syncDeviceIdMeta,
        syncDeviceId.isAcceptableOrUnknown(
          data['sync_device_id']!,
          _syncDeviceIdMeta,
        ),
      );
    }
    if (data.containsKey('sync_is_dirty')) {
      context.handle(
        _syncIsDirtyMeta,
        syncIsDirty.isAcceptableOrUnknown(
          data['sync_is_dirty']!,
          _syncIsDirtyMeta,
        ),
      );
    }
    if (data.containsKey('conflict_data')) {
      context.handle(
        _conflictDataMeta,
        conflictData.isAcceptableOrUnknown(
          data['conflict_data']!,
          _conflictDataMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FoodItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FoodItemRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}type'],
      )!,
      simpleItemIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}simple_item_ids'],
      ),
      isUserCreated: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_user_created'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      servingSize: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}serving_size'],
      ),
      servingUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}serving_unit'],
      ),
      calories: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}calories'],
      ),
      carbsGrams: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carbs_grams'],
      ),
      fatGrams: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat_grams'],
      ),
      proteinGrams: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein_grams'],
      ),
      fiberGrams: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fiber_grams'],
      ),
      sugarGrams: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sugar_grams'],
      ),
      syncCreatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_created_at'],
      )!,
      syncUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_updated_at'],
      ),
      syncDeletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_deleted_at'],
      ),
      syncLastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_last_synced_at'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_status'],
      )!,
      syncVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_version'],
      )!,
      syncDeviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_device_id'],
      ),
      syncIsDirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sync_is_dirty'],
      )!,
      conflictData: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conflict_data'],
      ),
    );
  }

  @override
  $FoodItemsTable createAlias(String alias) {
    return $FoodItemsTable(attachedDatabase, alias);
  }
}

class FoodItemRow extends DataClass implements Insertable<FoodItemRow> {
  final String id;
  final String clientId;
  final String profileId;
  final String name;
  final int type;
  final String? simpleItemIds;
  final bool isUserCreated;
  final bool isArchived;
  final double? servingSize;
  final String? servingUnit;
  final double? calories;
  final double? carbsGrams;
  final double? fatGrams;
  final double? proteinGrams;
  final double? fiberGrams;
  final double? sugarGrams;
  final int syncCreatedAt;
  final int? syncUpdatedAt;
  final int? syncDeletedAt;
  final int? syncLastSyncedAt;
  final int syncStatus;
  final int syncVersion;
  final String? syncDeviceId;
  final bool syncIsDirty;
  final String? conflictData;
  const FoodItemRow({
    required this.id,
    required this.clientId,
    required this.profileId,
    required this.name,
    required this.type,
    this.simpleItemIds,
    required this.isUserCreated,
    required this.isArchived,
    this.servingSize,
    this.servingUnit,
    this.calories,
    this.carbsGrams,
    this.fatGrams,
    this.proteinGrams,
    this.fiberGrams,
    this.sugarGrams,
    required this.syncCreatedAt,
    this.syncUpdatedAt,
    this.syncDeletedAt,
    this.syncLastSyncedAt,
    required this.syncStatus,
    required this.syncVersion,
    this.syncDeviceId,
    required this.syncIsDirty,
    this.conflictData,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['client_id'] = Variable<String>(clientId);
    map['profile_id'] = Variable<String>(profileId);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<int>(type);
    if (!nullToAbsent || simpleItemIds != null) {
      map['simple_item_ids'] = Variable<String>(simpleItemIds);
    }
    map['is_user_created'] = Variable<bool>(isUserCreated);
    map['is_archived'] = Variable<bool>(isArchived);
    if (!nullToAbsent || servingSize != null) {
      map['serving_size'] = Variable<double>(servingSize);
    }
    if (!nullToAbsent || servingUnit != null) {
      map['serving_unit'] = Variable<String>(servingUnit);
    }
    if (!nullToAbsent || calories != null) {
      map['calories'] = Variable<double>(calories);
    }
    if (!nullToAbsent || carbsGrams != null) {
      map['carbs_grams'] = Variable<double>(carbsGrams);
    }
    if (!nullToAbsent || fatGrams != null) {
      map['fat_grams'] = Variable<double>(fatGrams);
    }
    if (!nullToAbsent || proteinGrams != null) {
      map['protein_grams'] = Variable<double>(proteinGrams);
    }
    if (!nullToAbsent || fiberGrams != null) {
      map['fiber_grams'] = Variable<double>(fiberGrams);
    }
    if (!nullToAbsent || sugarGrams != null) {
      map['sugar_grams'] = Variable<double>(sugarGrams);
    }
    map['sync_created_at'] = Variable<int>(syncCreatedAt);
    if (!nullToAbsent || syncUpdatedAt != null) {
      map['sync_updated_at'] = Variable<int>(syncUpdatedAt);
    }
    if (!nullToAbsent || syncDeletedAt != null) {
      map['sync_deleted_at'] = Variable<int>(syncDeletedAt);
    }
    if (!nullToAbsent || syncLastSyncedAt != null) {
      map['sync_last_synced_at'] = Variable<int>(syncLastSyncedAt);
    }
    map['sync_status'] = Variable<int>(syncStatus);
    map['sync_version'] = Variable<int>(syncVersion);
    if (!nullToAbsent || syncDeviceId != null) {
      map['sync_device_id'] = Variable<String>(syncDeviceId);
    }
    map['sync_is_dirty'] = Variable<bool>(syncIsDirty);
    if (!nullToAbsent || conflictData != null) {
      map['conflict_data'] = Variable<String>(conflictData);
    }
    return map;
  }

  FoodItemsCompanion toCompanion(bool nullToAbsent) {
    return FoodItemsCompanion(
      id: Value(id),
      clientId: Value(clientId),
      profileId: Value(profileId),
      name: Value(name),
      type: Value(type),
      simpleItemIds: simpleItemIds == null && nullToAbsent
          ? const Value.absent()
          : Value(simpleItemIds),
      isUserCreated: Value(isUserCreated),
      isArchived: Value(isArchived),
      servingSize: servingSize == null && nullToAbsent
          ? const Value.absent()
          : Value(servingSize),
      servingUnit: servingUnit == null && nullToAbsent
          ? const Value.absent()
          : Value(servingUnit),
      calories: calories == null && nullToAbsent
          ? const Value.absent()
          : Value(calories),
      carbsGrams: carbsGrams == null && nullToAbsent
          ? const Value.absent()
          : Value(carbsGrams),
      fatGrams: fatGrams == null && nullToAbsent
          ? const Value.absent()
          : Value(fatGrams),
      proteinGrams: proteinGrams == null && nullToAbsent
          ? const Value.absent()
          : Value(proteinGrams),
      fiberGrams: fiberGrams == null && nullToAbsent
          ? const Value.absent()
          : Value(fiberGrams),
      sugarGrams: sugarGrams == null && nullToAbsent
          ? const Value.absent()
          : Value(sugarGrams),
      syncCreatedAt: Value(syncCreatedAt),
      syncUpdatedAt: syncUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncUpdatedAt),
      syncDeletedAt: syncDeletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncDeletedAt),
      syncLastSyncedAt: syncLastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncLastSyncedAt),
      syncStatus: Value(syncStatus),
      syncVersion: Value(syncVersion),
      syncDeviceId: syncDeviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(syncDeviceId),
      syncIsDirty: Value(syncIsDirty),
      conflictData: conflictData == null && nullToAbsent
          ? const Value.absent()
          : Value(conflictData),
    );
  }

  factory FoodItemRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FoodItemRow(
      id: serializer.fromJson<String>(json['id']),
      clientId: serializer.fromJson<String>(json['clientId']),
      profileId: serializer.fromJson<String>(json['profileId']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<int>(json['type']),
      simpleItemIds: serializer.fromJson<String?>(json['simpleItemIds']),
      isUserCreated: serializer.fromJson<bool>(json['isUserCreated']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      servingSize: serializer.fromJson<double?>(json['servingSize']),
      servingUnit: serializer.fromJson<String?>(json['servingUnit']),
      calories: serializer.fromJson<double?>(json['calories']),
      carbsGrams: serializer.fromJson<double?>(json['carbsGrams']),
      fatGrams: serializer.fromJson<double?>(json['fatGrams']),
      proteinGrams: serializer.fromJson<double?>(json['proteinGrams']),
      fiberGrams: serializer.fromJson<double?>(json['fiberGrams']),
      sugarGrams: serializer.fromJson<double?>(json['sugarGrams']),
      syncCreatedAt: serializer.fromJson<int>(json['syncCreatedAt']),
      syncUpdatedAt: serializer.fromJson<int?>(json['syncUpdatedAt']),
      syncDeletedAt: serializer.fromJson<int?>(json['syncDeletedAt']),
      syncLastSyncedAt: serializer.fromJson<int?>(json['syncLastSyncedAt']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
      syncVersion: serializer.fromJson<int>(json['syncVersion']),
      syncDeviceId: serializer.fromJson<String?>(json['syncDeviceId']),
      syncIsDirty: serializer.fromJson<bool>(json['syncIsDirty']),
      conflictData: serializer.fromJson<String?>(json['conflictData']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'clientId': serializer.toJson<String>(clientId),
      'profileId': serializer.toJson<String>(profileId),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<int>(type),
      'simpleItemIds': serializer.toJson<String?>(simpleItemIds),
      'isUserCreated': serializer.toJson<bool>(isUserCreated),
      'isArchived': serializer.toJson<bool>(isArchived),
      'servingSize': serializer.toJson<double?>(servingSize),
      'servingUnit': serializer.toJson<String?>(servingUnit),
      'calories': serializer.toJson<double?>(calories),
      'carbsGrams': serializer.toJson<double?>(carbsGrams),
      'fatGrams': serializer.toJson<double?>(fatGrams),
      'proteinGrams': serializer.toJson<double?>(proteinGrams),
      'fiberGrams': serializer.toJson<double?>(fiberGrams),
      'sugarGrams': serializer.toJson<double?>(sugarGrams),
      'syncCreatedAt': serializer.toJson<int>(syncCreatedAt),
      'syncUpdatedAt': serializer.toJson<int?>(syncUpdatedAt),
      'syncDeletedAt': serializer.toJson<int?>(syncDeletedAt),
      'syncLastSyncedAt': serializer.toJson<int?>(syncLastSyncedAt),
      'syncStatus': serializer.toJson<int>(syncStatus),
      'syncVersion': serializer.toJson<int>(syncVersion),
      'syncDeviceId': serializer.toJson<String?>(syncDeviceId),
      'syncIsDirty': serializer.toJson<bool>(syncIsDirty),
      'conflictData': serializer.toJson<String?>(conflictData),
    };
  }

  FoodItemRow copyWith({
    String? id,
    String? clientId,
    String? profileId,
    String? name,
    int? type,
    Value<String?> simpleItemIds = const Value.absent(),
    bool? isUserCreated,
    bool? isArchived,
    Value<double?> servingSize = const Value.absent(),
    Value<String?> servingUnit = const Value.absent(),
    Value<double?> calories = const Value.absent(),
    Value<double?> carbsGrams = const Value.absent(),
    Value<double?> fatGrams = const Value.absent(),
    Value<double?> proteinGrams = const Value.absent(),
    Value<double?> fiberGrams = const Value.absent(),
    Value<double?> sugarGrams = const Value.absent(),
    int? syncCreatedAt,
    Value<int?> syncUpdatedAt = const Value.absent(),
    Value<int?> syncDeletedAt = const Value.absent(),
    Value<int?> syncLastSyncedAt = const Value.absent(),
    int? syncStatus,
    int? syncVersion,
    Value<String?> syncDeviceId = const Value.absent(),
    bool? syncIsDirty,
    Value<String?> conflictData = const Value.absent(),
  }) => FoodItemRow(
    id: id ?? this.id,
    clientId: clientId ?? this.clientId,
    profileId: profileId ?? this.profileId,
    name: name ?? this.name,
    type: type ?? this.type,
    simpleItemIds: simpleItemIds.present
        ? simpleItemIds.value
        : this.simpleItemIds,
    isUserCreated: isUserCreated ?? this.isUserCreated,
    isArchived: isArchived ?? this.isArchived,
    servingSize: servingSize.present ? servingSize.value : this.servingSize,
    servingUnit: servingUnit.present ? servingUnit.value : this.servingUnit,
    calories: calories.present ? calories.value : this.calories,
    carbsGrams: carbsGrams.present ? carbsGrams.value : this.carbsGrams,
    fatGrams: fatGrams.present ? fatGrams.value : this.fatGrams,
    proteinGrams: proteinGrams.present ? proteinGrams.value : this.proteinGrams,
    fiberGrams: fiberGrams.present ? fiberGrams.value : this.fiberGrams,
    sugarGrams: sugarGrams.present ? sugarGrams.value : this.sugarGrams,
    syncCreatedAt: syncCreatedAt ?? this.syncCreatedAt,
    syncUpdatedAt: syncUpdatedAt.present
        ? syncUpdatedAt.value
        : this.syncUpdatedAt,
    syncDeletedAt: syncDeletedAt.present
        ? syncDeletedAt.value
        : this.syncDeletedAt,
    syncLastSyncedAt: syncLastSyncedAt.present
        ? syncLastSyncedAt.value
        : this.syncLastSyncedAt,
    syncStatus: syncStatus ?? this.syncStatus,
    syncVersion: syncVersion ?? this.syncVersion,
    syncDeviceId: syncDeviceId.present ? syncDeviceId.value : this.syncDeviceId,
    syncIsDirty: syncIsDirty ?? this.syncIsDirty,
    conflictData: conflictData.present ? conflictData.value : this.conflictData,
  );
  FoodItemRow copyWithCompanion(FoodItemsCompanion data) {
    return FoodItemRow(
      id: data.id.present ? data.id.value : this.id,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      simpleItemIds: data.simpleItemIds.present
          ? data.simpleItemIds.value
          : this.simpleItemIds,
      isUserCreated: data.isUserCreated.present
          ? data.isUserCreated.value
          : this.isUserCreated,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      servingSize: data.servingSize.present
          ? data.servingSize.value
          : this.servingSize,
      servingUnit: data.servingUnit.present
          ? data.servingUnit.value
          : this.servingUnit,
      calories: data.calories.present ? data.calories.value : this.calories,
      carbsGrams: data.carbsGrams.present
          ? data.carbsGrams.value
          : this.carbsGrams,
      fatGrams: data.fatGrams.present ? data.fatGrams.value : this.fatGrams,
      proteinGrams: data.proteinGrams.present
          ? data.proteinGrams.value
          : this.proteinGrams,
      fiberGrams: data.fiberGrams.present
          ? data.fiberGrams.value
          : this.fiberGrams,
      sugarGrams: data.sugarGrams.present
          ? data.sugarGrams.value
          : this.sugarGrams,
      syncCreatedAt: data.syncCreatedAt.present
          ? data.syncCreatedAt.value
          : this.syncCreatedAt,
      syncUpdatedAt: data.syncUpdatedAt.present
          ? data.syncUpdatedAt.value
          : this.syncUpdatedAt,
      syncDeletedAt: data.syncDeletedAt.present
          ? data.syncDeletedAt.value
          : this.syncDeletedAt,
      syncLastSyncedAt: data.syncLastSyncedAt.present
          ? data.syncLastSyncedAt.value
          : this.syncLastSyncedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      syncVersion: data.syncVersion.present
          ? data.syncVersion.value
          : this.syncVersion,
      syncDeviceId: data.syncDeviceId.present
          ? data.syncDeviceId.value
          : this.syncDeviceId,
      syncIsDirty: data.syncIsDirty.present
          ? data.syncIsDirty.value
          : this.syncIsDirty,
      conflictData: data.conflictData.present
          ? data.conflictData.value
          : this.conflictData,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FoodItemRow(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('profileId: $profileId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('simpleItemIds: $simpleItemIds, ')
          ..write('isUserCreated: $isUserCreated, ')
          ..write('isArchived: $isArchived, ')
          ..write('servingSize: $servingSize, ')
          ..write('servingUnit: $servingUnit, ')
          ..write('calories: $calories, ')
          ..write('carbsGrams: $carbsGrams, ')
          ..write('fatGrams: $fatGrams, ')
          ..write('proteinGrams: $proteinGrams, ')
          ..write('fiberGrams: $fiberGrams, ')
          ..write('sugarGrams: $sugarGrams, ')
          ..write('syncCreatedAt: $syncCreatedAt, ')
          ..write('syncUpdatedAt: $syncUpdatedAt, ')
          ..write('syncDeletedAt: $syncDeletedAt, ')
          ..write('syncLastSyncedAt: $syncLastSyncedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncVersion: $syncVersion, ')
          ..write('syncDeviceId: $syncDeviceId, ')
          ..write('syncIsDirty: $syncIsDirty, ')
          ..write('conflictData: $conflictData')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    clientId,
    profileId,
    name,
    type,
    simpleItemIds,
    isUserCreated,
    isArchived,
    servingSize,
    servingUnit,
    calories,
    carbsGrams,
    fatGrams,
    proteinGrams,
    fiberGrams,
    sugarGrams,
    syncCreatedAt,
    syncUpdatedAt,
    syncDeletedAt,
    syncLastSyncedAt,
    syncStatus,
    syncVersion,
    syncDeviceId,
    syncIsDirty,
    conflictData,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FoodItemRow &&
          other.id == this.id &&
          other.clientId == this.clientId &&
          other.profileId == this.profileId &&
          other.name == this.name &&
          other.type == this.type &&
          other.simpleItemIds == this.simpleItemIds &&
          other.isUserCreated == this.isUserCreated &&
          other.isArchived == this.isArchived &&
          other.servingSize == this.servingSize &&
          other.servingUnit == this.servingUnit &&
          other.calories == this.calories &&
          other.carbsGrams == this.carbsGrams &&
          other.fatGrams == this.fatGrams &&
          other.proteinGrams == this.proteinGrams &&
          other.fiberGrams == this.fiberGrams &&
          other.sugarGrams == this.sugarGrams &&
          other.syncCreatedAt == this.syncCreatedAt &&
          other.syncUpdatedAt == this.syncUpdatedAt &&
          other.syncDeletedAt == this.syncDeletedAt &&
          other.syncLastSyncedAt == this.syncLastSyncedAt &&
          other.syncStatus == this.syncStatus &&
          other.syncVersion == this.syncVersion &&
          other.syncDeviceId == this.syncDeviceId &&
          other.syncIsDirty == this.syncIsDirty &&
          other.conflictData == this.conflictData);
}

class FoodItemsCompanion extends UpdateCompanion<FoodItemRow> {
  final Value<String> id;
  final Value<String> clientId;
  final Value<String> profileId;
  final Value<String> name;
  final Value<int> type;
  final Value<String?> simpleItemIds;
  final Value<bool> isUserCreated;
  final Value<bool> isArchived;
  final Value<double?> servingSize;
  final Value<String?> servingUnit;
  final Value<double?> calories;
  final Value<double?> carbsGrams;
  final Value<double?> fatGrams;
  final Value<double?> proteinGrams;
  final Value<double?> fiberGrams;
  final Value<double?> sugarGrams;
  final Value<int> syncCreatedAt;
  final Value<int?> syncUpdatedAt;
  final Value<int?> syncDeletedAt;
  final Value<int?> syncLastSyncedAt;
  final Value<int> syncStatus;
  final Value<int> syncVersion;
  final Value<String?> syncDeviceId;
  final Value<bool> syncIsDirty;
  final Value<String?> conflictData;
  final Value<int> rowid;
  const FoodItemsCompanion({
    this.id = const Value.absent(),
    this.clientId = const Value.absent(),
    this.profileId = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.simpleItemIds = const Value.absent(),
    this.isUserCreated = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.servingSize = const Value.absent(),
    this.servingUnit = const Value.absent(),
    this.calories = const Value.absent(),
    this.carbsGrams = const Value.absent(),
    this.fatGrams = const Value.absent(),
    this.proteinGrams = const Value.absent(),
    this.fiberGrams = const Value.absent(),
    this.sugarGrams = const Value.absent(),
    this.syncCreatedAt = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
    this.syncDeletedAt = const Value.absent(),
    this.syncLastSyncedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncVersion = const Value.absent(),
    this.syncDeviceId = const Value.absent(),
    this.syncIsDirty = const Value.absent(),
    this.conflictData = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FoodItemsCompanion.insert({
    required String id,
    required String clientId,
    required String profileId,
    required String name,
    this.type = const Value.absent(),
    this.simpleItemIds = const Value.absent(),
    this.isUserCreated = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.servingSize = const Value.absent(),
    this.servingUnit = const Value.absent(),
    this.calories = const Value.absent(),
    this.carbsGrams = const Value.absent(),
    this.fatGrams = const Value.absent(),
    this.proteinGrams = const Value.absent(),
    this.fiberGrams = const Value.absent(),
    this.sugarGrams = const Value.absent(),
    required int syncCreatedAt,
    this.syncUpdatedAt = const Value.absent(),
    this.syncDeletedAt = const Value.absent(),
    this.syncLastSyncedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncVersion = const Value.absent(),
    this.syncDeviceId = const Value.absent(),
    this.syncIsDirty = const Value.absent(),
    this.conflictData = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       clientId = Value(clientId),
       profileId = Value(profileId),
       name = Value(name),
       syncCreatedAt = Value(syncCreatedAt);
  static Insertable<FoodItemRow> custom({
    Expression<String>? id,
    Expression<String>? clientId,
    Expression<String>? profileId,
    Expression<String>? name,
    Expression<int>? type,
    Expression<String>? simpleItemIds,
    Expression<bool>? isUserCreated,
    Expression<bool>? isArchived,
    Expression<double>? servingSize,
    Expression<String>? servingUnit,
    Expression<double>? calories,
    Expression<double>? carbsGrams,
    Expression<double>? fatGrams,
    Expression<double>? proteinGrams,
    Expression<double>? fiberGrams,
    Expression<double>? sugarGrams,
    Expression<int>? syncCreatedAt,
    Expression<int>? syncUpdatedAt,
    Expression<int>? syncDeletedAt,
    Expression<int>? syncLastSyncedAt,
    Expression<int>? syncStatus,
    Expression<int>? syncVersion,
    Expression<String>? syncDeviceId,
    Expression<bool>? syncIsDirty,
    Expression<String>? conflictData,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clientId != null) 'client_id': clientId,
      if (profileId != null) 'profile_id': profileId,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (simpleItemIds != null) 'simple_item_ids': simpleItemIds,
      if (isUserCreated != null) 'is_user_created': isUserCreated,
      if (isArchived != null) 'is_archived': isArchived,
      if (servingSize != null) 'serving_size': servingSize,
      if (servingUnit != null) 'serving_unit': servingUnit,
      if (calories != null) 'calories': calories,
      if (carbsGrams != null) 'carbs_grams': carbsGrams,
      if (fatGrams != null) 'fat_grams': fatGrams,
      if (proteinGrams != null) 'protein_grams': proteinGrams,
      if (fiberGrams != null) 'fiber_grams': fiberGrams,
      if (sugarGrams != null) 'sugar_grams': sugarGrams,
      if (syncCreatedAt != null) 'sync_created_at': syncCreatedAt,
      if (syncUpdatedAt != null) 'sync_updated_at': syncUpdatedAt,
      if (syncDeletedAt != null) 'sync_deleted_at': syncDeletedAt,
      if (syncLastSyncedAt != null) 'sync_last_synced_at': syncLastSyncedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncVersion != null) 'sync_version': syncVersion,
      if (syncDeviceId != null) 'sync_device_id': syncDeviceId,
      if (syncIsDirty != null) 'sync_is_dirty': syncIsDirty,
      if (conflictData != null) 'conflict_data': conflictData,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FoodItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? clientId,
    Value<String>? profileId,
    Value<String>? name,
    Value<int>? type,
    Value<String?>? simpleItemIds,
    Value<bool>? isUserCreated,
    Value<bool>? isArchived,
    Value<double?>? servingSize,
    Value<String?>? servingUnit,
    Value<double?>? calories,
    Value<double?>? carbsGrams,
    Value<double?>? fatGrams,
    Value<double?>? proteinGrams,
    Value<double?>? fiberGrams,
    Value<double?>? sugarGrams,
    Value<int>? syncCreatedAt,
    Value<int?>? syncUpdatedAt,
    Value<int?>? syncDeletedAt,
    Value<int?>? syncLastSyncedAt,
    Value<int>? syncStatus,
    Value<int>? syncVersion,
    Value<String?>? syncDeviceId,
    Value<bool>? syncIsDirty,
    Value<String?>? conflictData,
    Value<int>? rowid,
  }) {
    return FoodItemsCompanion(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      profileId: profileId ?? this.profileId,
      name: name ?? this.name,
      type: type ?? this.type,
      simpleItemIds: simpleItemIds ?? this.simpleItemIds,
      isUserCreated: isUserCreated ?? this.isUserCreated,
      isArchived: isArchived ?? this.isArchived,
      servingSize: servingSize ?? this.servingSize,
      servingUnit: servingUnit ?? this.servingUnit,
      calories: calories ?? this.calories,
      carbsGrams: carbsGrams ?? this.carbsGrams,
      fatGrams: fatGrams ?? this.fatGrams,
      proteinGrams: proteinGrams ?? this.proteinGrams,
      fiberGrams: fiberGrams ?? this.fiberGrams,
      sugarGrams: sugarGrams ?? this.sugarGrams,
      syncCreatedAt: syncCreatedAt ?? this.syncCreatedAt,
      syncUpdatedAt: syncUpdatedAt ?? this.syncUpdatedAt,
      syncDeletedAt: syncDeletedAt ?? this.syncDeletedAt,
      syncLastSyncedAt: syncLastSyncedAt ?? this.syncLastSyncedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      syncVersion: syncVersion ?? this.syncVersion,
      syncDeviceId: syncDeviceId ?? this.syncDeviceId,
      syncIsDirty: syncIsDirty ?? this.syncIsDirty,
      conflictData: conflictData ?? this.conflictData,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    if (simpleItemIds.present) {
      map['simple_item_ids'] = Variable<String>(simpleItemIds.value);
    }
    if (isUserCreated.present) {
      map['is_user_created'] = Variable<bool>(isUserCreated.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (servingSize.present) {
      map['serving_size'] = Variable<double>(servingSize.value);
    }
    if (servingUnit.present) {
      map['serving_unit'] = Variable<String>(servingUnit.value);
    }
    if (calories.present) {
      map['calories'] = Variable<double>(calories.value);
    }
    if (carbsGrams.present) {
      map['carbs_grams'] = Variable<double>(carbsGrams.value);
    }
    if (fatGrams.present) {
      map['fat_grams'] = Variable<double>(fatGrams.value);
    }
    if (proteinGrams.present) {
      map['protein_grams'] = Variable<double>(proteinGrams.value);
    }
    if (fiberGrams.present) {
      map['fiber_grams'] = Variable<double>(fiberGrams.value);
    }
    if (sugarGrams.present) {
      map['sugar_grams'] = Variable<double>(sugarGrams.value);
    }
    if (syncCreatedAt.present) {
      map['sync_created_at'] = Variable<int>(syncCreatedAt.value);
    }
    if (syncUpdatedAt.present) {
      map['sync_updated_at'] = Variable<int>(syncUpdatedAt.value);
    }
    if (syncDeletedAt.present) {
      map['sync_deleted_at'] = Variable<int>(syncDeletedAt.value);
    }
    if (syncLastSyncedAt.present) {
      map['sync_last_synced_at'] = Variable<int>(syncLastSyncedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (syncVersion.present) {
      map['sync_version'] = Variable<int>(syncVersion.value);
    }
    if (syncDeviceId.present) {
      map['sync_device_id'] = Variable<String>(syncDeviceId.value);
    }
    if (syncIsDirty.present) {
      map['sync_is_dirty'] = Variable<bool>(syncIsDirty.value);
    }
    if (conflictData.present) {
      map['conflict_data'] = Variable<String>(conflictData.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoodItemsCompanion(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('profileId: $profileId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('simpleItemIds: $simpleItemIds, ')
          ..write('isUserCreated: $isUserCreated, ')
          ..write('isArchived: $isArchived, ')
          ..write('servingSize: $servingSize, ')
          ..write('servingUnit: $servingUnit, ')
          ..write('calories: $calories, ')
          ..write('carbsGrams: $carbsGrams, ')
          ..write('fatGrams: $fatGrams, ')
          ..write('proteinGrams: $proteinGrams, ')
          ..write('fiberGrams: $fiberGrams, ')
          ..write('sugarGrams: $sugarGrams, ')
          ..write('syncCreatedAt: $syncCreatedAt, ')
          ..write('syncUpdatedAt: $syncUpdatedAt, ')
          ..write('syncDeletedAt: $syncDeletedAt, ')
          ..write('syncLastSyncedAt: $syncLastSyncedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncVersion: $syncVersion, ')
          ..write('syncDeviceId: $syncDeviceId, ')
          ..write('syncIsDirty: $syncIsDirty, ')
          ..write('conflictData: $conflictData, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FoodLogsTable extends FoodLogs
    with TableInfo<$FoodLogsTable, FoodLogRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoodLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
    'client_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<int> timestamp = GeneratedColumn<int>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _foodItemIdsMeta = const VerificationMeta(
    'foodItemIds',
  );
  @override
  late final GeneratedColumn<String> foodItemIds = GeneratedColumn<String>(
    'food_item_ids',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _adHocItemsMeta = const VerificationMeta(
    'adHocItems',
  );
  @override
  late final GeneratedColumn<String> adHocItems = GeneratedColumn<String>(
    'ad_hoc_items',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncCreatedAtMeta = const VerificationMeta(
    'syncCreatedAt',
  );
  @override
  late final GeneratedColumn<int> syncCreatedAt = GeneratedColumn<int>(
    'sync_created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncUpdatedAtMeta = const VerificationMeta(
    'syncUpdatedAt',
  );
  @override
  late final GeneratedColumn<int> syncUpdatedAt = GeneratedColumn<int>(
    'sync_updated_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncDeletedAtMeta = const VerificationMeta(
    'syncDeletedAt',
  );
  @override
  late final GeneratedColumn<int> syncDeletedAt = GeneratedColumn<int>(
    'sync_deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncLastSyncedAtMeta = const VerificationMeta(
    'syncLastSyncedAt',
  );
  @override
  late final GeneratedColumn<int> syncLastSyncedAt = GeneratedColumn<int>(
    'sync_last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _syncVersionMeta = const VerificationMeta(
    'syncVersion',
  );
  @override
  late final GeneratedColumn<int> syncVersion = GeneratedColumn<int>(
    'sync_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _syncDeviceIdMeta = const VerificationMeta(
    'syncDeviceId',
  );
  @override
  late final GeneratedColumn<String> syncDeviceId = GeneratedColumn<String>(
    'sync_device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncIsDirtyMeta = const VerificationMeta(
    'syncIsDirty',
  );
  @override
  late final GeneratedColumn<bool> syncIsDirty = GeneratedColumn<bool>(
    'sync_is_dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sync_is_dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _conflictDataMeta = const VerificationMeta(
    'conflictData',
  );
  @override
  late final GeneratedColumn<String> conflictData = GeneratedColumn<String>(
    'conflict_data',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    clientId,
    profileId,
    timestamp,
    foodItemIds,
    adHocItems,
    notes,
    syncCreatedAt,
    syncUpdatedAt,
    syncDeletedAt,
    syncLastSyncedAt,
    syncStatus,
    syncVersion,
    syncDeviceId,
    syncIsDirty,
    conflictData,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'food_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<FoodLogRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('food_item_ids')) {
      context.handle(
        _foodItemIdsMeta,
        foodItemIds.isAcceptableOrUnknown(
          data['food_item_ids']!,
          _foodItemIdsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_foodItemIdsMeta);
    }
    if (data.containsKey('ad_hoc_items')) {
      context.handle(
        _adHocItemsMeta,
        adHocItems.isAcceptableOrUnknown(
          data['ad_hoc_items']!,
          _adHocItemsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_adHocItemsMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('sync_created_at')) {
      context.handle(
        _syncCreatedAtMeta,
        syncCreatedAt.isAcceptableOrUnknown(
          data['sync_created_at']!,
          _syncCreatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_syncCreatedAtMeta);
    }
    if (data.containsKey('sync_updated_at')) {
      context.handle(
        _syncUpdatedAtMeta,
        syncUpdatedAt.isAcceptableOrUnknown(
          data['sync_updated_at']!,
          _syncUpdatedAtMeta,
        ),
      );
    }
    if (data.containsKey('sync_deleted_at')) {
      context.handle(
        _syncDeletedAtMeta,
        syncDeletedAt.isAcceptableOrUnknown(
          data['sync_deleted_at']!,
          _syncDeletedAtMeta,
        ),
      );
    }
    if (data.containsKey('sync_last_synced_at')) {
      context.handle(
        _syncLastSyncedAtMeta,
        syncLastSyncedAt.isAcceptableOrUnknown(
          data['sync_last_synced_at']!,
          _syncLastSyncedAtMeta,
        ),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('sync_version')) {
      context.handle(
        _syncVersionMeta,
        syncVersion.isAcceptableOrUnknown(
          data['sync_version']!,
          _syncVersionMeta,
        ),
      );
    }
    if (data.containsKey('sync_device_id')) {
      context.handle(
        _syncDeviceIdMeta,
        syncDeviceId.isAcceptableOrUnknown(
          data['sync_device_id']!,
          _syncDeviceIdMeta,
        ),
      );
    }
    if (data.containsKey('sync_is_dirty')) {
      context.handle(
        _syncIsDirtyMeta,
        syncIsDirty.isAcceptableOrUnknown(
          data['sync_is_dirty']!,
          _syncIsDirtyMeta,
        ),
      );
    }
    if (data.containsKey('conflict_data')) {
      context.handle(
        _conflictDataMeta,
        conflictData.isAcceptableOrUnknown(
          data['conflict_data']!,
          _conflictDataMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FoodLogRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FoodLogRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}timestamp'],
      )!,
      foodItemIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}food_item_ids'],
      )!,
      adHocItems: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ad_hoc_items'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      syncCreatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_created_at'],
      )!,
      syncUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_updated_at'],
      ),
      syncDeletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_deleted_at'],
      ),
      syncLastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_last_synced_at'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_status'],
      )!,
      syncVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_version'],
      )!,
      syncDeviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_device_id'],
      ),
      syncIsDirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sync_is_dirty'],
      )!,
      conflictData: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conflict_data'],
      ),
    );
  }

  @override
  $FoodLogsTable createAlias(String alias) {
    return $FoodLogsTable(attachedDatabase, alias);
  }
}

class FoodLogRow extends DataClass implements Insertable<FoodLogRow> {
  final String id;
  final String clientId;
  final String profileId;
  final int timestamp;
  final String foodItemIds;
  final String adHocItems;
  final String? notes;
  final int syncCreatedAt;
  final int? syncUpdatedAt;
  final int? syncDeletedAt;
  final int? syncLastSyncedAt;
  final int syncStatus;
  final int syncVersion;
  final String? syncDeviceId;
  final bool syncIsDirty;
  final String? conflictData;
  const FoodLogRow({
    required this.id,
    required this.clientId,
    required this.profileId,
    required this.timestamp,
    required this.foodItemIds,
    required this.adHocItems,
    this.notes,
    required this.syncCreatedAt,
    this.syncUpdatedAt,
    this.syncDeletedAt,
    this.syncLastSyncedAt,
    required this.syncStatus,
    required this.syncVersion,
    this.syncDeviceId,
    required this.syncIsDirty,
    this.conflictData,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['client_id'] = Variable<String>(clientId);
    map['profile_id'] = Variable<String>(profileId);
    map['timestamp'] = Variable<int>(timestamp);
    map['food_item_ids'] = Variable<String>(foodItemIds);
    map['ad_hoc_items'] = Variable<String>(adHocItems);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['sync_created_at'] = Variable<int>(syncCreatedAt);
    if (!nullToAbsent || syncUpdatedAt != null) {
      map['sync_updated_at'] = Variable<int>(syncUpdatedAt);
    }
    if (!nullToAbsent || syncDeletedAt != null) {
      map['sync_deleted_at'] = Variable<int>(syncDeletedAt);
    }
    if (!nullToAbsent || syncLastSyncedAt != null) {
      map['sync_last_synced_at'] = Variable<int>(syncLastSyncedAt);
    }
    map['sync_status'] = Variable<int>(syncStatus);
    map['sync_version'] = Variable<int>(syncVersion);
    if (!nullToAbsent || syncDeviceId != null) {
      map['sync_device_id'] = Variable<String>(syncDeviceId);
    }
    map['sync_is_dirty'] = Variable<bool>(syncIsDirty);
    if (!nullToAbsent || conflictData != null) {
      map['conflict_data'] = Variable<String>(conflictData);
    }
    return map;
  }

  FoodLogsCompanion toCompanion(bool nullToAbsent) {
    return FoodLogsCompanion(
      id: Value(id),
      clientId: Value(clientId),
      profileId: Value(profileId),
      timestamp: Value(timestamp),
      foodItemIds: Value(foodItemIds),
      adHocItems: Value(adHocItems),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      syncCreatedAt: Value(syncCreatedAt),
      syncUpdatedAt: syncUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncUpdatedAt),
      syncDeletedAt: syncDeletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncDeletedAt),
      syncLastSyncedAt: syncLastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncLastSyncedAt),
      syncStatus: Value(syncStatus),
      syncVersion: Value(syncVersion),
      syncDeviceId: syncDeviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(syncDeviceId),
      syncIsDirty: Value(syncIsDirty),
      conflictData: conflictData == null && nullToAbsent
          ? const Value.absent()
          : Value(conflictData),
    );
  }

  factory FoodLogRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FoodLogRow(
      id: serializer.fromJson<String>(json['id']),
      clientId: serializer.fromJson<String>(json['clientId']),
      profileId: serializer.fromJson<String>(json['profileId']),
      timestamp: serializer.fromJson<int>(json['timestamp']),
      foodItemIds: serializer.fromJson<String>(json['foodItemIds']),
      adHocItems: serializer.fromJson<String>(json['adHocItems']),
      notes: serializer.fromJson<String?>(json['notes']),
      syncCreatedAt: serializer.fromJson<int>(json['syncCreatedAt']),
      syncUpdatedAt: serializer.fromJson<int?>(json['syncUpdatedAt']),
      syncDeletedAt: serializer.fromJson<int?>(json['syncDeletedAt']),
      syncLastSyncedAt: serializer.fromJson<int?>(json['syncLastSyncedAt']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
      syncVersion: serializer.fromJson<int>(json['syncVersion']),
      syncDeviceId: serializer.fromJson<String?>(json['syncDeviceId']),
      syncIsDirty: serializer.fromJson<bool>(json['syncIsDirty']),
      conflictData: serializer.fromJson<String?>(json['conflictData']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'clientId': serializer.toJson<String>(clientId),
      'profileId': serializer.toJson<String>(profileId),
      'timestamp': serializer.toJson<int>(timestamp),
      'foodItemIds': serializer.toJson<String>(foodItemIds),
      'adHocItems': serializer.toJson<String>(adHocItems),
      'notes': serializer.toJson<String?>(notes),
      'syncCreatedAt': serializer.toJson<int>(syncCreatedAt),
      'syncUpdatedAt': serializer.toJson<int?>(syncUpdatedAt),
      'syncDeletedAt': serializer.toJson<int?>(syncDeletedAt),
      'syncLastSyncedAt': serializer.toJson<int?>(syncLastSyncedAt),
      'syncStatus': serializer.toJson<int>(syncStatus),
      'syncVersion': serializer.toJson<int>(syncVersion),
      'syncDeviceId': serializer.toJson<String?>(syncDeviceId),
      'syncIsDirty': serializer.toJson<bool>(syncIsDirty),
      'conflictData': serializer.toJson<String?>(conflictData),
    };
  }

  FoodLogRow copyWith({
    String? id,
    String? clientId,
    String? profileId,
    int? timestamp,
    String? foodItemIds,
    String? adHocItems,
    Value<String?> notes = const Value.absent(),
    int? syncCreatedAt,
    Value<int?> syncUpdatedAt = const Value.absent(),
    Value<int?> syncDeletedAt = const Value.absent(),
    Value<int?> syncLastSyncedAt = const Value.absent(),
    int? syncStatus,
    int? syncVersion,
    Value<String?> syncDeviceId = const Value.absent(),
    bool? syncIsDirty,
    Value<String?> conflictData = const Value.absent(),
  }) => FoodLogRow(
    id: id ?? this.id,
    clientId: clientId ?? this.clientId,
    profileId: profileId ?? this.profileId,
    timestamp: timestamp ?? this.timestamp,
    foodItemIds: foodItemIds ?? this.foodItemIds,
    adHocItems: adHocItems ?? this.adHocItems,
    notes: notes.present ? notes.value : this.notes,
    syncCreatedAt: syncCreatedAt ?? this.syncCreatedAt,
    syncUpdatedAt: syncUpdatedAt.present
        ? syncUpdatedAt.value
        : this.syncUpdatedAt,
    syncDeletedAt: syncDeletedAt.present
        ? syncDeletedAt.value
        : this.syncDeletedAt,
    syncLastSyncedAt: syncLastSyncedAt.present
        ? syncLastSyncedAt.value
        : this.syncLastSyncedAt,
    syncStatus: syncStatus ?? this.syncStatus,
    syncVersion: syncVersion ?? this.syncVersion,
    syncDeviceId: syncDeviceId.present ? syncDeviceId.value : this.syncDeviceId,
    syncIsDirty: syncIsDirty ?? this.syncIsDirty,
    conflictData: conflictData.present ? conflictData.value : this.conflictData,
  );
  FoodLogRow copyWithCompanion(FoodLogsCompanion data) {
    return FoodLogRow(
      id: data.id.present ? data.id.value : this.id,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      foodItemIds: data.foodItemIds.present
          ? data.foodItemIds.value
          : this.foodItemIds,
      adHocItems: data.adHocItems.present
          ? data.adHocItems.value
          : this.adHocItems,
      notes: data.notes.present ? data.notes.value : this.notes,
      syncCreatedAt: data.syncCreatedAt.present
          ? data.syncCreatedAt.value
          : this.syncCreatedAt,
      syncUpdatedAt: data.syncUpdatedAt.present
          ? data.syncUpdatedAt.value
          : this.syncUpdatedAt,
      syncDeletedAt: data.syncDeletedAt.present
          ? data.syncDeletedAt.value
          : this.syncDeletedAt,
      syncLastSyncedAt: data.syncLastSyncedAt.present
          ? data.syncLastSyncedAt.value
          : this.syncLastSyncedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      syncVersion: data.syncVersion.present
          ? data.syncVersion.value
          : this.syncVersion,
      syncDeviceId: data.syncDeviceId.present
          ? data.syncDeviceId.value
          : this.syncDeviceId,
      syncIsDirty: data.syncIsDirty.present
          ? data.syncIsDirty.value
          : this.syncIsDirty,
      conflictData: data.conflictData.present
          ? data.conflictData.value
          : this.conflictData,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FoodLogRow(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('profileId: $profileId, ')
          ..write('timestamp: $timestamp, ')
          ..write('foodItemIds: $foodItemIds, ')
          ..write('adHocItems: $adHocItems, ')
          ..write('notes: $notes, ')
          ..write('syncCreatedAt: $syncCreatedAt, ')
          ..write('syncUpdatedAt: $syncUpdatedAt, ')
          ..write('syncDeletedAt: $syncDeletedAt, ')
          ..write('syncLastSyncedAt: $syncLastSyncedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncVersion: $syncVersion, ')
          ..write('syncDeviceId: $syncDeviceId, ')
          ..write('syncIsDirty: $syncIsDirty, ')
          ..write('conflictData: $conflictData')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    clientId,
    profileId,
    timestamp,
    foodItemIds,
    adHocItems,
    notes,
    syncCreatedAt,
    syncUpdatedAt,
    syncDeletedAt,
    syncLastSyncedAt,
    syncStatus,
    syncVersion,
    syncDeviceId,
    syncIsDirty,
    conflictData,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FoodLogRow &&
          other.id == this.id &&
          other.clientId == this.clientId &&
          other.profileId == this.profileId &&
          other.timestamp == this.timestamp &&
          other.foodItemIds == this.foodItemIds &&
          other.adHocItems == this.adHocItems &&
          other.notes == this.notes &&
          other.syncCreatedAt == this.syncCreatedAt &&
          other.syncUpdatedAt == this.syncUpdatedAt &&
          other.syncDeletedAt == this.syncDeletedAt &&
          other.syncLastSyncedAt == this.syncLastSyncedAt &&
          other.syncStatus == this.syncStatus &&
          other.syncVersion == this.syncVersion &&
          other.syncDeviceId == this.syncDeviceId &&
          other.syncIsDirty == this.syncIsDirty &&
          other.conflictData == this.conflictData);
}

class FoodLogsCompanion extends UpdateCompanion<FoodLogRow> {
  final Value<String> id;
  final Value<String> clientId;
  final Value<String> profileId;
  final Value<int> timestamp;
  final Value<String> foodItemIds;
  final Value<String> adHocItems;
  final Value<String?> notes;
  final Value<int> syncCreatedAt;
  final Value<int?> syncUpdatedAt;
  final Value<int?> syncDeletedAt;
  final Value<int?> syncLastSyncedAt;
  final Value<int> syncStatus;
  final Value<int> syncVersion;
  final Value<String?> syncDeviceId;
  final Value<bool> syncIsDirty;
  final Value<String?> conflictData;
  final Value<int> rowid;
  const FoodLogsCompanion({
    this.id = const Value.absent(),
    this.clientId = const Value.absent(),
    this.profileId = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.foodItemIds = const Value.absent(),
    this.adHocItems = const Value.absent(),
    this.notes = const Value.absent(),
    this.syncCreatedAt = const Value.absent(),
    this.syncUpdatedAt = const Value.absent(),
    this.syncDeletedAt = const Value.absent(),
    this.syncLastSyncedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncVersion = const Value.absent(),
    this.syncDeviceId = const Value.absent(),
    this.syncIsDirty = const Value.absent(),
    this.conflictData = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FoodLogsCompanion.insert({
    required String id,
    required String clientId,
    required String profileId,
    required int timestamp,
    required String foodItemIds,
    required String adHocItems,
    this.notes = const Value.absent(),
    required int syncCreatedAt,
    this.syncUpdatedAt = const Value.absent(),
    this.syncDeletedAt = const Value.absent(),
    this.syncLastSyncedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncVersion = const Value.absent(),
    this.syncDeviceId = const Value.absent(),
    this.syncIsDirty = const Value.absent(),
    this.conflictData = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       clientId = Value(clientId),
       profileId = Value(profileId),
       timestamp = Value(timestamp),
       foodItemIds = Value(foodItemIds),
       adHocItems = Value(adHocItems),
       syncCreatedAt = Value(syncCreatedAt);
  static Insertable<FoodLogRow> custom({
    Expression<String>? id,
    Expression<String>? clientId,
    Expression<String>? profileId,
    Expression<int>? timestamp,
    Expression<String>? foodItemIds,
    Expression<String>? adHocItems,
    Expression<String>? notes,
    Expression<int>? syncCreatedAt,
    Expression<int>? syncUpdatedAt,
    Expression<int>? syncDeletedAt,
    Expression<int>? syncLastSyncedAt,
    Expression<int>? syncStatus,
    Expression<int>? syncVersion,
    Expression<String>? syncDeviceId,
    Expression<bool>? syncIsDirty,
    Expression<String>? conflictData,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clientId != null) 'client_id': clientId,
      if (profileId != null) 'profile_id': profileId,
      if (timestamp != null) 'timestamp': timestamp,
      if (foodItemIds != null) 'food_item_ids': foodItemIds,
      if (adHocItems != null) 'ad_hoc_items': adHocItems,
      if (notes != null) 'notes': notes,
      if (syncCreatedAt != null) 'sync_created_at': syncCreatedAt,
      if (syncUpdatedAt != null) 'sync_updated_at': syncUpdatedAt,
      if (syncDeletedAt != null) 'sync_deleted_at': syncDeletedAt,
      if (syncLastSyncedAt != null) 'sync_last_synced_at': syncLastSyncedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncVersion != null) 'sync_version': syncVersion,
      if (syncDeviceId != null) 'sync_device_id': syncDeviceId,
      if (syncIsDirty != null) 'sync_is_dirty': syncIsDirty,
      if (conflictData != null) 'conflict_data': conflictData,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FoodLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? clientId,
    Value<String>? profileId,
    Value<int>? timestamp,
    Value<String>? foodItemIds,
    Value<String>? adHocItems,
    Value<String?>? notes,
    Value<int>? syncCreatedAt,
    Value<int?>? syncUpdatedAt,
    Value<int?>? syncDeletedAt,
    Value<int?>? syncLastSyncedAt,
    Value<int>? syncStatus,
    Value<int>? syncVersion,
    Value<String?>? syncDeviceId,
    Value<bool>? syncIsDirty,
    Value<String?>? conflictData,
    Value<int>? rowid,
  }) {
    return FoodLogsCompanion(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      profileId: profileId ?? this.profileId,
      timestamp: timestamp ?? this.timestamp,
      foodItemIds: foodItemIds ?? this.foodItemIds,
      adHocItems: adHocItems ?? this.adHocItems,
      notes: notes ?? this.notes,
      syncCreatedAt: syncCreatedAt ?? this.syncCreatedAt,
      syncUpdatedAt: syncUpdatedAt ?? this.syncUpdatedAt,
      syncDeletedAt: syncDeletedAt ?? this.syncDeletedAt,
      syncLastSyncedAt: syncLastSyncedAt ?? this.syncLastSyncedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      syncVersion: syncVersion ?? this.syncVersion,
      syncDeviceId: syncDeviceId ?? this.syncDeviceId,
      syncIsDirty: syncIsDirty ?? this.syncIsDirty,
      conflictData: conflictData ?? this.conflictData,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<int>(timestamp.value);
    }
    if (foodItemIds.present) {
      map['food_item_ids'] = Variable<String>(foodItemIds.value);
    }
    if (adHocItems.present) {
      map['ad_hoc_items'] = Variable<String>(adHocItems.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (syncCreatedAt.present) {
      map['sync_created_at'] = Variable<int>(syncCreatedAt.value);
    }
    if (syncUpdatedAt.present) {
      map['sync_updated_at'] = Variable<int>(syncUpdatedAt.value);
    }
    if (syncDeletedAt.present) {
      map['sync_deleted_at'] = Variable<int>(syncDeletedAt.value);
    }
    if (syncLastSyncedAt.present) {
      map['sync_last_synced_at'] = Variable<int>(syncLastSyncedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (syncVersion.present) {
      map['sync_version'] = Variable<int>(syncVersion.value);
    }
    if (syncDeviceId.present) {
      map['sync_device_id'] = Variable<String>(syncDeviceId.value);
    }
    if (syncIsDirty.present) {
      map['sync_is_dirty'] = Variable<bool>(syncIsDirty.value);
    }
    if (conflictData.present) {
      map['conflict_data'] = Variable<String>(conflictData.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoodLogsCompanion(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('profileId: $profileId, ')
          ..write('timestamp: $timestamp, ')
          ..write('foodItemIds: $foodItemIds, ')
          ..write('adHocItems: $adHocItems, ')
          ..write('notes: $notes, ')
          ..write('syncCreatedAt: $syncCreatedAt, ')
          ..write('syncUpdatedAt: $syncUpdatedAt, ')
          ..write('syncDeletedAt: $syncDeletedAt, ')
          ..write('syncLastSyncedAt: $syncLastSyncedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncVersion: $syncVersion, ')
          ..write('syncDeviceId: $syncDeviceId, ')
          ..write('syncIsDirty: $syncIsDirty, ')
          ..write('conflictData: $conflictData, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SupplementsTable supplements = $SupplementsTable(this);
  late final $IntakeLogsTable intakeLogs = $IntakeLogsTable(this);
  late final $ConditionsTable conditions = $ConditionsTable(this);
  late final $ConditionLogsTable conditionLogs = $ConditionLogsTable(this);
  late final $FluidsEntriesTable fluidsEntries = $FluidsEntriesTable(this);
  late final $SleepEntriesTable sleepEntries = $SleepEntriesTable(this);
  late final $ActivitiesTable activities = $ActivitiesTable(this);
  late final $ActivityLogsTable activityLogs = $ActivityLogsTable(this);
  late final $FoodItemsTable foodItems = $FoodItemsTable(this);
  late final $FoodLogsTable foodLogs = $FoodLogsTable(this);
  late final SupplementDao supplementDao = SupplementDao(this as AppDatabase);
  late final IntakeLogDao intakeLogDao = IntakeLogDao(this as AppDatabase);
  late final ConditionDao conditionDao = ConditionDao(this as AppDatabase);
  late final ConditionLogDao conditionLogDao = ConditionLogDao(
    this as AppDatabase,
  );
  late final FluidsEntryDao fluidsEntryDao = FluidsEntryDao(
    this as AppDatabase,
  );
  late final SleepEntryDao sleepEntryDao = SleepEntryDao(this as AppDatabase);
  late final ActivityDao activityDao = ActivityDao(this as AppDatabase);
  late final ActivityLogDao activityLogDao = ActivityLogDao(
    this as AppDatabase,
  );
  late final FoodItemDao foodItemDao = FoodItemDao(this as AppDatabase);
  late final FoodLogDao foodLogDao = FoodLogDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    supplements,
    intakeLogs,
    conditions,
    conditionLogs,
    fluidsEntries,
    sleepEntries,
    activities,
    activityLogs,
    foodItems,
    foodLogs,
  ];
}

typedef $$SupplementsTableCreateCompanionBuilder =
    SupplementsCompanion Function({
      required String id,
      required String clientId,
      required String profileId,
      required String name,
      required int form,
      required int dosageQuantity,
      required int dosageUnit,
      Value<String?> customForm,
      Value<String> brand,
      Value<String> notes,
      Value<String> ingredients,
      Value<String> schedules,
      Value<int?> startDate,
      Value<int?> endDate,
      Value<bool> isArchived,
      required int syncCreatedAt,
      Value<int?> syncUpdatedAt,
      Value<int?> syncDeletedAt,
      Value<int?> syncLastSyncedAt,
      Value<int> syncStatus,
      Value<int> syncVersion,
      Value<String?> syncDeviceId,
      Value<bool> syncIsDirty,
      Value<String?> conflictData,
      Value<int> rowid,
    });
typedef $$SupplementsTableUpdateCompanionBuilder =
    SupplementsCompanion Function({
      Value<String> id,
      Value<String> clientId,
      Value<String> profileId,
      Value<String> name,
      Value<int> form,
      Value<int> dosageQuantity,
      Value<int> dosageUnit,
      Value<String?> customForm,
      Value<String> brand,
      Value<String> notes,
      Value<String> ingredients,
      Value<String> schedules,
      Value<int?> startDate,
      Value<int?> endDate,
      Value<bool> isArchived,
      Value<int> syncCreatedAt,
      Value<int?> syncUpdatedAt,
      Value<int?> syncDeletedAt,
      Value<int?> syncLastSyncedAt,
      Value<int> syncStatus,
      Value<int> syncVersion,
      Value<String?> syncDeviceId,
      Value<bool> syncIsDirty,
      Value<String?> conflictData,
      Value<int> rowid,
    });

class $$SupplementsTableFilterComposer
    extends Composer<_$AppDatabase, $SupplementsTable> {
  $$SupplementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get form => $composableBuilder(
    column: $table.form,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dosageQuantity => $composableBuilder(
    column: $table.dosageQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dosageUnit => $composableBuilder(
    column: $table.dosageUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customForm => $composableBuilder(
    column: $table.customForm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ingredients => $composableBuilder(
    column: $table.ingredients,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get schedules => $composableBuilder(
    column: $table.schedules,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncCreatedAt => $composableBuilder(
    column: $table.syncCreatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncDeletedAt => $composableBuilder(
    column: $table.syncDeletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncLastSyncedAt => $composableBuilder(
    column: $table.syncLastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncDeviceId => $composableBuilder(
    column: $table.syncDeviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get syncIsDirty => $composableBuilder(
    column: $table.syncIsDirty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conflictData => $composableBuilder(
    column: $table.conflictData,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SupplementsTableOrderingComposer
    extends Composer<_$AppDatabase, $SupplementsTable> {
  $$SupplementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get form => $composableBuilder(
    column: $table.form,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dosageQuantity => $composableBuilder(
    column: $table.dosageQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dosageUnit => $composableBuilder(
    column: $table.dosageUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customForm => $composableBuilder(
    column: $table.customForm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ingredients => $composableBuilder(
    column: $table.ingredients,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get schedules => $composableBuilder(
    column: $table.schedules,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncCreatedAt => $composableBuilder(
    column: $table.syncCreatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncDeletedAt => $composableBuilder(
    column: $table.syncDeletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncLastSyncedAt => $composableBuilder(
    column: $table.syncLastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncDeviceId => $composableBuilder(
    column: $table.syncDeviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get syncIsDirty => $composableBuilder(
    column: $table.syncIsDirty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conflictData => $composableBuilder(
    column: $table.conflictData,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SupplementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SupplementsTable> {
  $$SupplementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get form =>
      $composableBuilder(column: $table.form, builder: (column) => column);

  GeneratedColumn<int> get dosageQuantity => $composableBuilder(
    column: $table.dosageQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dosageUnit => $composableBuilder(
    column: $table.dosageUnit,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customForm => $composableBuilder(
    column: $table.customForm,
    builder: (column) => column,
  );

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get ingredients => $composableBuilder(
    column: $table.ingredients,
    builder: (column) => column,
  );

  GeneratedColumn<String> get schedules =>
      $composableBuilder(column: $table.schedules, builder: (column) => column);

  GeneratedColumn<int> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<int> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncCreatedAt => $composableBuilder(
    column: $table.syncCreatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncDeletedAt => $composableBuilder(
    column: $table.syncDeletedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncLastSyncedAt => $composableBuilder(
    column: $table.syncLastSyncedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncDeviceId => $composableBuilder(
    column: $table.syncDeviceId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get syncIsDirty => $composableBuilder(
    column: $table.syncIsDirty,
    builder: (column) => column,
  );

  GeneratedColumn<String> get conflictData => $composableBuilder(
    column: $table.conflictData,
    builder: (column) => column,
  );
}

class $$SupplementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SupplementsTable,
          SupplementRow,
          $$SupplementsTableFilterComposer,
          $$SupplementsTableOrderingComposer,
          $$SupplementsTableAnnotationComposer,
          $$SupplementsTableCreateCompanionBuilder,
          $$SupplementsTableUpdateCompanionBuilder,
          (
            SupplementRow,
            BaseReferences<_$AppDatabase, $SupplementsTable, SupplementRow>,
          ),
          SupplementRow,
          PrefetchHooks Function()
        > {
  $$SupplementsTableTableManager(_$AppDatabase db, $SupplementsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SupplementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SupplementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SupplementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> clientId = const Value.absent(),
                Value<String> profileId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> form = const Value.absent(),
                Value<int> dosageQuantity = const Value.absent(),
                Value<int> dosageUnit = const Value.absent(),
                Value<String?> customForm = const Value.absent(),
                Value<String> brand = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<String> ingredients = const Value.absent(),
                Value<String> schedules = const Value.absent(),
                Value<int?> startDate = const Value.absent(),
                Value<int?> endDate = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<int> syncCreatedAt = const Value.absent(),
                Value<int?> syncUpdatedAt = const Value.absent(),
                Value<int?> syncDeletedAt = const Value.absent(),
                Value<int?> syncLastSyncedAt = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> syncVersion = const Value.absent(),
                Value<String?> syncDeviceId = const Value.absent(),
                Value<bool> syncIsDirty = const Value.absent(),
                Value<String?> conflictData = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SupplementsCompanion(
                id: id,
                clientId: clientId,
                profileId: profileId,
                name: name,
                form: form,
                dosageQuantity: dosageQuantity,
                dosageUnit: dosageUnit,
                customForm: customForm,
                brand: brand,
                notes: notes,
                ingredients: ingredients,
                schedules: schedules,
                startDate: startDate,
                endDate: endDate,
                isArchived: isArchived,
                syncCreatedAt: syncCreatedAt,
                syncUpdatedAt: syncUpdatedAt,
                syncDeletedAt: syncDeletedAt,
                syncLastSyncedAt: syncLastSyncedAt,
                syncStatus: syncStatus,
                syncVersion: syncVersion,
                syncDeviceId: syncDeviceId,
                syncIsDirty: syncIsDirty,
                conflictData: conflictData,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String clientId,
                required String profileId,
                required String name,
                required int form,
                required int dosageQuantity,
                required int dosageUnit,
                Value<String?> customForm = const Value.absent(),
                Value<String> brand = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<String> ingredients = const Value.absent(),
                Value<String> schedules = const Value.absent(),
                Value<int?> startDate = const Value.absent(),
                Value<int?> endDate = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                required int syncCreatedAt,
                Value<int?> syncUpdatedAt = const Value.absent(),
                Value<int?> syncDeletedAt = const Value.absent(),
                Value<int?> syncLastSyncedAt = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> syncVersion = const Value.absent(),
                Value<String?> syncDeviceId = const Value.absent(),
                Value<bool> syncIsDirty = const Value.absent(),
                Value<String?> conflictData = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SupplementsCompanion.insert(
                id: id,
                clientId: clientId,
                profileId: profileId,
                name: name,
                form: form,
                dosageQuantity: dosageQuantity,
                dosageUnit: dosageUnit,
                customForm: customForm,
                brand: brand,
                notes: notes,
                ingredients: ingredients,
                schedules: schedules,
                startDate: startDate,
                endDate: endDate,
                isArchived: isArchived,
                syncCreatedAt: syncCreatedAt,
                syncUpdatedAt: syncUpdatedAt,
                syncDeletedAt: syncDeletedAt,
                syncLastSyncedAt: syncLastSyncedAt,
                syncStatus: syncStatus,
                syncVersion: syncVersion,
                syncDeviceId: syncDeviceId,
                syncIsDirty: syncIsDirty,
                conflictData: conflictData,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SupplementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SupplementsTable,
      SupplementRow,
      $$SupplementsTableFilterComposer,
      $$SupplementsTableOrderingComposer,
      $$SupplementsTableAnnotationComposer,
      $$SupplementsTableCreateCompanionBuilder,
      $$SupplementsTableUpdateCompanionBuilder,
      (
        SupplementRow,
        BaseReferences<_$AppDatabase, $SupplementsTable, SupplementRow>,
      ),
      SupplementRow,
      PrefetchHooks Function()
    >;
typedef $$IntakeLogsTableCreateCompanionBuilder =
    IntakeLogsCompanion Function({
      required String id,
      required String clientId,
      required String profileId,
      required String supplementId,
      required int scheduledTime,
      required int status,
      Value<int?> actualTime,
      Value<String?> reason,
      Value<String?> note,
      required int syncCreatedAt,
      Value<int?> syncUpdatedAt,
      Value<int?> syncDeletedAt,
      Value<int?> syncLastSyncedAt,
      Value<int> syncStatus,
      Value<int> syncVersion,
      Value<String?> syncDeviceId,
      Value<bool> syncIsDirty,
      Value<String?> conflictData,
      Value<int> rowid,
    });
typedef $$IntakeLogsTableUpdateCompanionBuilder =
    IntakeLogsCompanion Function({
      Value<String> id,
      Value<String> clientId,
      Value<String> profileId,
      Value<String> supplementId,
      Value<int> scheduledTime,
      Value<int> status,
      Value<int?> actualTime,
      Value<String?> reason,
      Value<String?> note,
      Value<int> syncCreatedAt,
      Value<int?> syncUpdatedAt,
      Value<int?> syncDeletedAt,
      Value<int?> syncLastSyncedAt,
      Value<int> syncStatus,
      Value<int> syncVersion,
      Value<String?> syncDeviceId,
      Value<bool> syncIsDirty,
      Value<String?> conflictData,
      Value<int> rowid,
    });

class $$IntakeLogsTableFilterComposer
    extends Composer<_$AppDatabase, $IntakeLogsTable> {
  $$IntakeLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get supplementId => $composableBuilder(
    column: $table.supplementId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get scheduledTime => $composableBuilder(
    column: $table.scheduledTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get actualTime => $composableBuilder(
    column: $table.actualTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncCreatedAt => $composableBuilder(
    column: $table.syncCreatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncDeletedAt => $composableBuilder(
    column: $table.syncDeletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncLastSyncedAt => $composableBuilder(
    column: $table.syncLastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncDeviceId => $composableBuilder(
    column: $table.syncDeviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get syncIsDirty => $composableBuilder(
    column: $table.syncIsDirty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conflictData => $composableBuilder(
    column: $table.conflictData,
    builder: (column) => ColumnFilters(column),
  );
}

class $$IntakeLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $IntakeLogsTable> {
  $$IntakeLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get supplementId => $composableBuilder(
    column: $table.supplementId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get scheduledTime => $composableBuilder(
    column: $table.scheduledTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get actualTime => $composableBuilder(
    column: $table.actualTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncCreatedAt => $composableBuilder(
    column: $table.syncCreatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncDeletedAt => $composableBuilder(
    column: $table.syncDeletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncLastSyncedAt => $composableBuilder(
    column: $table.syncLastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncDeviceId => $composableBuilder(
    column: $table.syncDeviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get syncIsDirty => $composableBuilder(
    column: $table.syncIsDirty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conflictData => $composableBuilder(
    column: $table.conflictData,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$IntakeLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $IntakeLogsTable> {
  $$IntakeLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get supplementId => $composableBuilder(
    column: $table.supplementId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get scheduledTime => $composableBuilder(
    column: $table.scheduledTime,
    builder: (column) => column,
  );

  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get actualTime => $composableBuilder(
    column: $table.actualTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<int> get syncCreatedAt => $composableBuilder(
    column: $table.syncCreatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncDeletedAt => $composableBuilder(
    column: $table.syncDeletedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncLastSyncedAt => $composableBuilder(
    column: $table.syncLastSyncedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncDeviceId => $composableBuilder(
    column: $table.syncDeviceId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get syncIsDirty => $composableBuilder(
    column: $table.syncIsDirty,
    builder: (column) => column,
  );

  GeneratedColumn<String> get conflictData => $composableBuilder(
    column: $table.conflictData,
    builder: (column) => column,
  );
}

class $$IntakeLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IntakeLogsTable,
          IntakeLogRow,
          $$IntakeLogsTableFilterComposer,
          $$IntakeLogsTableOrderingComposer,
          $$IntakeLogsTableAnnotationComposer,
          $$IntakeLogsTableCreateCompanionBuilder,
          $$IntakeLogsTableUpdateCompanionBuilder,
          (
            IntakeLogRow,
            BaseReferences<_$AppDatabase, $IntakeLogsTable, IntakeLogRow>,
          ),
          IntakeLogRow,
          PrefetchHooks Function()
        > {
  $$IntakeLogsTableTableManager(_$AppDatabase db, $IntakeLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IntakeLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IntakeLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IntakeLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> clientId = const Value.absent(),
                Value<String> profileId = const Value.absent(),
                Value<String> supplementId = const Value.absent(),
                Value<int> scheduledTime = const Value.absent(),
                Value<int> status = const Value.absent(),
                Value<int?> actualTime = const Value.absent(),
                Value<String?> reason = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> syncCreatedAt = const Value.absent(),
                Value<int?> syncUpdatedAt = const Value.absent(),
                Value<int?> syncDeletedAt = const Value.absent(),
                Value<int?> syncLastSyncedAt = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> syncVersion = const Value.absent(),
                Value<String?> syncDeviceId = const Value.absent(),
                Value<bool> syncIsDirty = const Value.absent(),
                Value<String?> conflictData = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IntakeLogsCompanion(
                id: id,
                clientId: clientId,
                profileId: profileId,
                supplementId: supplementId,
                scheduledTime: scheduledTime,
                status: status,
                actualTime: actualTime,
                reason: reason,
                note: note,
                syncCreatedAt: syncCreatedAt,
                syncUpdatedAt: syncUpdatedAt,
                syncDeletedAt: syncDeletedAt,
                syncLastSyncedAt: syncLastSyncedAt,
                syncStatus: syncStatus,
                syncVersion: syncVersion,
                syncDeviceId: syncDeviceId,
                syncIsDirty: syncIsDirty,
                conflictData: conflictData,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String clientId,
                required String profileId,
                required String supplementId,
                required int scheduledTime,
                required int status,
                Value<int?> actualTime = const Value.absent(),
                Value<String?> reason = const Value.absent(),
                Value<String?> note = const Value.absent(),
                required int syncCreatedAt,
                Value<int?> syncUpdatedAt = const Value.absent(),
                Value<int?> syncDeletedAt = const Value.absent(),
                Value<int?> syncLastSyncedAt = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> syncVersion = const Value.absent(),
                Value<String?> syncDeviceId = const Value.absent(),
                Value<bool> syncIsDirty = const Value.absent(),
                Value<String?> conflictData = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IntakeLogsCompanion.insert(
                id: id,
                clientId: clientId,
                profileId: profileId,
                supplementId: supplementId,
                scheduledTime: scheduledTime,
                status: status,
                actualTime: actualTime,
                reason: reason,
                note: note,
                syncCreatedAt: syncCreatedAt,
                syncUpdatedAt: syncUpdatedAt,
                syncDeletedAt: syncDeletedAt,
                syncLastSyncedAt: syncLastSyncedAt,
                syncStatus: syncStatus,
                syncVersion: syncVersion,
                syncDeviceId: syncDeviceId,
                syncIsDirty: syncIsDirty,
                conflictData: conflictData,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$IntakeLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IntakeLogsTable,
      IntakeLogRow,
      $$IntakeLogsTableFilterComposer,
      $$IntakeLogsTableOrderingComposer,
      $$IntakeLogsTableAnnotationComposer,
      $$IntakeLogsTableCreateCompanionBuilder,
      $$IntakeLogsTableUpdateCompanionBuilder,
      (
        IntakeLogRow,
        BaseReferences<_$AppDatabase, $IntakeLogsTable, IntakeLogRow>,
      ),
      IntakeLogRow,
      PrefetchHooks Function()
    >;
typedef $$ConditionsTableCreateCompanionBuilder =
    ConditionsCompanion Function({
      required String id,
      required String clientId,
      required String profileId,
      required String name,
      required String category,
      Value<String> bodyLocations,
      required int startTimeframe,
      required int status,
      Value<String?> description,
      Value<String?> baselinePhotoPath,
      Value<int?> endDate,
      Value<bool> isArchived,
      Value<String?> activityId,
      Value<String?> cloudStorageUrl,
      Value<String?> fileHash,
      Value<int?> fileSizeBytes,
      Value<bool> isFileUploaded,
      required int syncCreatedAt,
      Value<int?> syncUpdatedAt,
      Value<int?> syncDeletedAt,
      Value<int?> syncLastSyncedAt,
      Value<int> syncStatus,
      Value<int> syncVersion,
      Value<String?> syncDeviceId,
      Value<bool> syncIsDirty,
      Value<String?> conflictData,
      Value<int> rowid,
    });
typedef $$ConditionsTableUpdateCompanionBuilder =
    ConditionsCompanion Function({
      Value<String> id,
      Value<String> clientId,
      Value<String> profileId,
      Value<String> name,
      Value<String> category,
      Value<String> bodyLocations,
      Value<int> startTimeframe,
      Value<int> status,
      Value<String?> description,
      Value<String?> baselinePhotoPath,
      Value<int?> endDate,
      Value<bool> isArchived,
      Value<String?> activityId,
      Value<String?> cloudStorageUrl,
      Value<String?> fileHash,
      Value<int?> fileSizeBytes,
      Value<bool> isFileUploaded,
      Value<int> syncCreatedAt,
      Value<int?> syncUpdatedAt,
      Value<int?> syncDeletedAt,
      Value<int?> syncLastSyncedAt,
      Value<int> syncStatus,
      Value<int> syncVersion,
      Value<String?> syncDeviceId,
      Value<bool> syncIsDirty,
      Value<String?> conflictData,
      Value<int> rowid,
    });

class $$ConditionsTableFilterComposer
    extends Composer<_$AppDatabase, $ConditionsTable> {
  $$ConditionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bodyLocations => $composableBuilder(
    column: $table.bodyLocations,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startTimeframe => $composableBuilder(
    column: $table.startTimeframe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get baselinePhotoPath => $composableBuilder(
    column: $table.baselinePhotoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activityId => $composableBuilder(
    column: $table.activityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cloudStorageUrl => $composableBuilder(
    column: $table.cloudStorageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileHash => $composableBuilder(
    column: $table.fileHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fileSizeBytes => $composableBuilder(
    column: $table.fileSizeBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFileUploaded => $composableBuilder(
    column: $table.isFileUploaded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncCreatedAt => $composableBuilder(
    column: $table.syncCreatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncDeletedAt => $composableBuilder(
    column: $table.syncDeletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncLastSyncedAt => $composableBuilder(
    column: $table.syncLastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncDeviceId => $composableBuilder(
    column: $table.syncDeviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get syncIsDirty => $composableBuilder(
    column: $table.syncIsDirty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conflictData => $composableBuilder(
    column: $table.conflictData,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ConditionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ConditionsTable> {
  $$ConditionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bodyLocations => $composableBuilder(
    column: $table.bodyLocations,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startTimeframe => $composableBuilder(
    column: $table.startTimeframe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get baselinePhotoPath => $composableBuilder(
    column: $table.baselinePhotoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activityId => $composableBuilder(
    column: $table.activityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cloudStorageUrl => $composableBuilder(
    column: $table.cloudStorageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileHash => $composableBuilder(
    column: $table.fileHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fileSizeBytes => $composableBuilder(
    column: $table.fileSizeBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFileUploaded => $composableBuilder(
    column: $table.isFileUploaded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncCreatedAt => $composableBuilder(
    column: $table.syncCreatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncDeletedAt => $composableBuilder(
    column: $table.syncDeletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncLastSyncedAt => $composableBuilder(
    column: $table.syncLastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncDeviceId => $composableBuilder(
    column: $table.syncDeviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get syncIsDirty => $composableBuilder(
    column: $table.syncIsDirty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conflictData => $composableBuilder(
    column: $table.conflictData,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ConditionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConditionsTable> {
  $$ConditionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get bodyLocations => $composableBuilder(
    column: $table.bodyLocations,
    builder: (column) => column,
  );

  GeneratedColumn<int> get startTimeframe => $composableBuilder(
    column: $table.startTimeframe,
    builder: (column) => column,
  );

  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get baselinePhotoPath => $composableBuilder(
    column: $table.baselinePhotoPath,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<String> get activityId => $composableBuilder(
    column: $table.activityId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cloudStorageUrl => $composableBuilder(
    column: $table.cloudStorageUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fileHash =>
      $composableBuilder(column: $table.fileHash, builder: (column) => column);

  GeneratedColumn<int> get fileSizeBytes => $composableBuilder(
    column: $table.fileSizeBytes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isFileUploaded => $composableBuilder(
    column: $table.isFileUploaded,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncCreatedAt => $composableBuilder(
    column: $table.syncCreatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncDeletedAt => $composableBuilder(
    column: $table.syncDeletedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncLastSyncedAt => $composableBuilder(
    column: $table.syncLastSyncedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncDeviceId => $composableBuilder(
    column: $table.syncDeviceId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get syncIsDirty => $composableBuilder(
    column: $table.syncIsDirty,
    builder: (column) => column,
  );

  GeneratedColumn<String> get conflictData => $composableBuilder(
    column: $table.conflictData,
    builder: (column) => column,
  );
}

class $$ConditionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ConditionsTable,
          ConditionRow,
          $$ConditionsTableFilterComposer,
          $$ConditionsTableOrderingComposer,
          $$ConditionsTableAnnotationComposer,
          $$ConditionsTableCreateCompanionBuilder,
          $$ConditionsTableUpdateCompanionBuilder,
          (
            ConditionRow,
            BaseReferences<_$AppDatabase, $ConditionsTable, ConditionRow>,
          ),
          ConditionRow,
          PrefetchHooks Function()
        > {
  $$ConditionsTableTableManager(_$AppDatabase db, $ConditionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConditionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConditionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConditionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> clientId = const Value.absent(),
                Value<String> profileId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> bodyLocations = const Value.absent(),
                Value<int> startTimeframe = const Value.absent(),
                Value<int> status = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> baselinePhotoPath = const Value.absent(),
                Value<int?> endDate = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<String?> activityId = const Value.absent(),
                Value<String?> cloudStorageUrl = const Value.absent(),
                Value<String?> fileHash = const Value.absent(),
                Value<int?> fileSizeBytes = const Value.absent(),
                Value<bool> isFileUploaded = const Value.absent(),
                Value<int> syncCreatedAt = const Value.absent(),
                Value<int?> syncUpdatedAt = const Value.absent(),
                Value<int?> syncDeletedAt = const Value.absent(),
                Value<int?> syncLastSyncedAt = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> syncVersion = const Value.absent(),
                Value<String?> syncDeviceId = const Value.absent(),
                Value<bool> syncIsDirty = const Value.absent(),
                Value<String?> conflictData = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ConditionsCompanion(
                id: id,
                clientId: clientId,
                profileId: profileId,
                name: name,
                category: category,
                bodyLocations: bodyLocations,
                startTimeframe: startTimeframe,
                status: status,
                description: description,
                baselinePhotoPath: baselinePhotoPath,
                endDate: endDate,
                isArchived: isArchived,
                activityId: activityId,
                cloudStorageUrl: cloudStorageUrl,
                fileHash: fileHash,
                fileSizeBytes: fileSizeBytes,
                isFileUploaded: isFileUploaded,
                syncCreatedAt: syncCreatedAt,
                syncUpdatedAt: syncUpdatedAt,
                syncDeletedAt: syncDeletedAt,
                syncLastSyncedAt: syncLastSyncedAt,
                syncStatus: syncStatus,
                syncVersion: syncVersion,
                syncDeviceId: syncDeviceId,
                syncIsDirty: syncIsDirty,
                conflictData: conflictData,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String clientId,
                required String profileId,
                required String name,
                required String category,
                Value<String> bodyLocations = const Value.absent(),
                required int startTimeframe,
                required int status,
                Value<String?> description = const Value.absent(),
                Value<String?> baselinePhotoPath = const Value.absent(),
                Value<int?> endDate = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<String?> activityId = const Value.absent(),
                Value<String?> cloudStorageUrl = const Value.absent(),
                Value<String?> fileHash = const Value.absent(),
                Value<int?> fileSizeBytes = const Value.absent(),
                Value<bool> isFileUploaded = const Value.absent(),
                required int syncCreatedAt,
                Value<int?> syncUpdatedAt = const Value.absent(),
                Value<int?> syncDeletedAt = const Value.absent(),
                Value<int?> syncLastSyncedAt = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> syncVersion = const Value.absent(),
                Value<String?> syncDeviceId = const Value.absent(),
                Value<bool> syncIsDirty = const Value.absent(),
                Value<String?> conflictData = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ConditionsCompanion.insert(
                id: id,
                clientId: clientId,
                profileId: profileId,
                name: name,
                category: category,
                bodyLocations: bodyLocations,
                startTimeframe: startTimeframe,
                status: status,
                description: description,
                baselinePhotoPath: baselinePhotoPath,
                endDate: endDate,
                isArchived: isArchived,
                activityId: activityId,
                cloudStorageUrl: cloudStorageUrl,
                fileHash: fileHash,
                fileSizeBytes: fileSizeBytes,
                isFileUploaded: isFileUploaded,
                syncCreatedAt: syncCreatedAt,
                syncUpdatedAt: syncUpdatedAt,
                syncDeletedAt: syncDeletedAt,
                syncLastSyncedAt: syncLastSyncedAt,
                syncStatus: syncStatus,
                syncVersion: syncVersion,
                syncDeviceId: syncDeviceId,
                syncIsDirty: syncIsDirty,
                conflictData: conflictData,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ConditionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ConditionsTable,
      ConditionRow,
      $$ConditionsTableFilterComposer,
      $$ConditionsTableOrderingComposer,
      $$ConditionsTableAnnotationComposer,
      $$ConditionsTableCreateCompanionBuilder,
      $$ConditionsTableUpdateCompanionBuilder,
      (
        ConditionRow,
        BaseReferences<_$AppDatabase, $ConditionsTable, ConditionRow>,
      ),
      ConditionRow,
      PrefetchHooks Function()
    >;
typedef $$ConditionLogsTableCreateCompanionBuilder =
    ConditionLogsCompanion Function({
      required String id,
      required String clientId,
      required String profileId,
      required String conditionId,
      required int timestamp,
      required int severity,
      required bool isFlare,
      Value<String> flarePhotoIds,
      Value<String?> notes,
      Value<String?> photoPath,
      Value<String?> activityId,
      Value<String?> triggers,
      Value<String?> cloudStorageUrl,
      Value<String?> fileHash,
      Value<int?> fileSizeBytes,
      Value<bool> isFileUploaded,
      required int syncCreatedAt,
      Value<int?> syncUpdatedAt,
      Value<int?> syncDeletedAt,
      Value<int?> syncLastSyncedAt,
      Value<int> syncStatus,
      Value<int> syncVersion,
      Value<String?> syncDeviceId,
      Value<bool> syncIsDirty,
      Value<String?> conflictData,
      Value<int> rowid,
    });
typedef $$ConditionLogsTableUpdateCompanionBuilder =
    ConditionLogsCompanion Function({
      Value<String> id,
      Value<String> clientId,
      Value<String> profileId,
      Value<String> conditionId,
      Value<int> timestamp,
      Value<int> severity,
      Value<bool> isFlare,
      Value<String> flarePhotoIds,
      Value<String?> notes,
      Value<String?> photoPath,
      Value<String?> activityId,
      Value<String?> triggers,
      Value<String?> cloudStorageUrl,
      Value<String?> fileHash,
      Value<int?> fileSizeBytes,
      Value<bool> isFileUploaded,
      Value<int> syncCreatedAt,
      Value<int?> syncUpdatedAt,
      Value<int?> syncDeletedAt,
      Value<int?> syncLastSyncedAt,
      Value<int> syncStatus,
      Value<int> syncVersion,
      Value<String?> syncDeviceId,
      Value<bool> syncIsDirty,
      Value<String?> conflictData,
      Value<int> rowid,
    });

class $$ConditionLogsTableFilterComposer
    extends Composer<_$AppDatabase, $ConditionLogsTable> {
  $$ConditionLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conditionId => $composableBuilder(
    column: $table.conditionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFlare => $composableBuilder(
    column: $table.isFlare,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get flarePhotoIds => $composableBuilder(
    column: $table.flarePhotoIds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activityId => $composableBuilder(
    column: $table.activityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get triggers => $composableBuilder(
    column: $table.triggers,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cloudStorageUrl => $composableBuilder(
    column: $table.cloudStorageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileHash => $composableBuilder(
    column: $table.fileHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fileSizeBytes => $composableBuilder(
    column: $table.fileSizeBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFileUploaded => $composableBuilder(
    column: $table.isFileUploaded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncCreatedAt => $composableBuilder(
    column: $table.syncCreatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncDeletedAt => $composableBuilder(
    column: $table.syncDeletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncLastSyncedAt => $composableBuilder(
    column: $table.syncLastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncDeviceId => $composableBuilder(
    column: $table.syncDeviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get syncIsDirty => $composableBuilder(
    column: $table.syncIsDirty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conflictData => $composableBuilder(
    column: $table.conflictData,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ConditionLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $ConditionLogsTable> {
  $$ConditionLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conditionId => $composableBuilder(
    column: $table.conditionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFlare => $composableBuilder(
    column: $table.isFlare,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get flarePhotoIds => $composableBuilder(
    column: $table.flarePhotoIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activityId => $composableBuilder(
    column: $table.activityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get triggers => $composableBuilder(
    column: $table.triggers,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cloudStorageUrl => $composableBuilder(
    column: $table.cloudStorageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileHash => $composableBuilder(
    column: $table.fileHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fileSizeBytes => $composableBuilder(
    column: $table.fileSizeBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFileUploaded => $composableBuilder(
    column: $table.isFileUploaded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncCreatedAt => $composableBuilder(
    column: $table.syncCreatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncDeletedAt => $composableBuilder(
    column: $table.syncDeletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncLastSyncedAt => $composableBuilder(
    column: $table.syncLastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncDeviceId => $composableBuilder(
    column: $table.syncDeviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get syncIsDirty => $composableBuilder(
    column: $table.syncIsDirty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conflictData => $composableBuilder(
    column: $table.conflictData,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ConditionLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConditionLogsTable> {
  $$ConditionLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get conditionId => $composableBuilder(
    column: $table.conditionId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<int> get severity =>
      $composableBuilder(column: $table.severity, builder: (column) => column);

  GeneratedColumn<bool> get isFlare =>
      $composableBuilder(column: $table.isFlare, builder: (column) => column);

  GeneratedColumn<String> get flarePhotoIds => $composableBuilder(
    column: $table.flarePhotoIds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<String> get activityId => $composableBuilder(
    column: $table.activityId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get triggers =>
      $composableBuilder(column: $table.triggers, builder: (column) => column);

  GeneratedColumn<String> get cloudStorageUrl => $composableBuilder(
    column: $table.cloudStorageUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fileHash =>
      $composableBuilder(column: $table.fileHash, builder: (column) => column);

  GeneratedColumn<int> get fileSizeBytes => $composableBuilder(
    column: $table.fileSizeBytes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isFileUploaded => $composableBuilder(
    column: $table.isFileUploaded,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncCreatedAt => $composableBuilder(
    column: $table.syncCreatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncDeletedAt => $composableBuilder(
    column: $table.syncDeletedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncLastSyncedAt => $composableBuilder(
    column: $table.syncLastSyncedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncDeviceId => $composableBuilder(
    column: $table.syncDeviceId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get syncIsDirty => $composableBuilder(
    column: $table.syncIsDirty,
    builder: (column) => column,
  );

  GeneratedColumn<String> get conflictData => $composableBuilder(
    column: $table.conflictData,
    builder: (column) => column,
  );
}

class $$ConditionLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ConditionLogsTable,
          ConditionLogRow,
          $$ConditionLogsTableFilterComposer,
          $$ConditionLogsTableOrderingComposer,
          $$ConditionLogsTableAnnotationComposer,
          $$ConditionLogsTableCreateCompanionBuilder,
          $$ConditionLogsTableUpdateCompanionBuilder,
          (
            ConditionLogRow,
            BaseReferences<_$AppDatabase, $ConditionLogsTable, ConditionLogRow>,
          ),
          ConditionLogRow,
          PrefetchHooks Function()
        > {
  $$ConditionLogsTableTableManager(_$AppDatabase db, $ConditionLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConditionLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConditionLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConditionLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> clientId = const Value.absent(),
                Value<String> profileId = const Value.absent(),
                Value<String> conditionId = const Value.absent(),
                Value<int> timestamp = const Value.absent(),
                Value<int> severity = const Value.absent(),
                Value<bool> isFlare = const Value.absent(),
                Value<String> flarePhotoIds = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<String?> activityId = const Value.absent(),
                Value<String?> triggers = const Value.absent(),
                Value<String?> cloudStorageUrl = const Value.absent(),
                Value<String?> fileHash = const Value.absent(),
                Value<int?> fileSizeBytes = const Value.absent(),
                Value<bool> isFileUploaded = const Value.absent(),
                Value<int> syncCreatedAt = const Value.absent(),
                Value<int?> syncUpdatedAt = const Value.absent(),
                Value<int?> syncDeletedAt = const Value.absent(),
                Value<int?> syncLastSyncedAt = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> syncVersion = const Value.absent(),
                Value<String?> syncDeviceId = const Value.absent(),
                Value<bool> syncIsDirty = const Value.absent(),
                Value<String?> conflictData = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ConditionLogsCompanion(
                id: id,
                clientId: clientId,
                profileId: profileId,
                conditionId: conditionId,
                timestamp: timestamp,
                severity: severity,
                isFlare: isFlare,
                flarePhotoIds: flarePhotoIds,
                notes: notes,
                photoPath: photoPath,
                activityId: activityId,
                triggers: triggers,
                cloudStorageUrl: cloudStorageUrl,
                fileHash: fileHash,
                fileSizeBytes: fileSizeBytes,
                isFileUploaded: isFileUploaded,
                syncCreatedAt: syncCreatedAt,
                syncUpdatedAt: syncUpdatedAt,
                syncDeletedAt: syncDeletedAt,
                syncLastSyncedAt: syncLastSyncedAt,
                syncStatus: syncStatus,
                syncVersion: syncVersion,
                syncDeviceId: syncDeviceId,
                syncIsDirty: syncIsDirty,
                conflictData: conflictData,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String clientId,
                required String profileId,
                required String conditionId,
                required int timestamp,
                required int severity,
                required bool isFlare,
                Value<String> flarePhotoIds = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<String?> activityId = const Value.absent(),
                Value<String?> triggers = const Value.absent(),
                Value<String?> cloudStorageUrl = const Value.absent(),
                Value<String?> fileHash = const Value.absent(),
                Value<int?> fileSizeBytes = const Value.absent(),
                Value<bool> isFileUploaded = const Value.absent(),
                required int syncCreatedAt,
                Value<int?> syncUpdatedAt = const Value.absent(),
                Value<int?> syncDeletedAt = const Value.absent(),
                Value<int?> syncLastSyncedAt = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> syncVersion = const Value.absent(),
                Value<String?> syncDeviceId = const Value.absent(),
                Value<bool> syncIsDirty = const Value.absent(),
                Value<String?> conflictData = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ConditionLogsCompanion.insert(
                id: id,
                clientId: clientId,
                profileId: profileId,
                conditionId: conditionId,
                timestamp: timestamp,
                severity: severity,
                isFlare: isFlare,
                flarePhotoIds: flarePhotoIds,
                notes: notes,
                photoPath: photoPath,
                activityId: activityId,
                triggers: triggers,
                cloudStorageUrl: cloudStorageUrl,
                fileHash: fileHash,
                fileSizeBytes: fileSizeBytes,
                isFileUploaded: isFileUploaded,
                syncCreatedAt: syncCreatedAt,
                syncUpdatedAt: syncUpdatedAt,
                syncDeletedAt: syncDeletedAt,
                syncLastSyncedAt: syncLastSyncedAt,
                syncStatus: syncStatus,
                syncVersion: syncVersion,
                syncDeviceId: syncDeviceId,
                syncIsDirty: syncIsDirty,
                conflictData: conflictData,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ConditionLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ConditionLogsTable,
      ConditionLogRow,
      $$ConditionLogsTableFilterComposer,
      $$ConditionLogsTableOrderingComposer,
      $$ConditionLogsTableAnnotationComposer,
      $$ConditionLogsTableCreateCompanionBuilder,
      $$ConditionLogsTableUpdateCompanionBuilder,
      (
        ConditionLogRow,
        BaseReferences<_$AppDatabase, $ConditionLogsTable, ConditionLogRow>,
      ),
      ConditionLogRow,
      PrefetchHooks Function()
    >;
typedef $$FluidsEntriesTableCreateCompanionBuilder =
    FluidsEntriesCompanion Function({
      required String id,
      required String clientId,
      required String profileId,
      required int entryDate,
      Value<int?> waterIntakeMl,
      Value<String?> waterIntakeNotes,
      Value<bool> hasBowelMovement,
      Value<int?> bowelCondition,
      Value<String?> bowelCustomCondition,
      Value<int?> bowelSize,
      Value<String?> bowelPhotoPath,
      Value<bool> hasUrineMovement,
      Value<int?> urineCondition,
      Value<String?> urineCustomCondition,
      Value<int?> urineSize,
      Value<String?> urinePhotoPath,
      Value<int?> menstruationFlow,
      Value<double?> basalBodyTemperature,
      Value<int?> bbtRecordedTime,
      Value<String?> otherFluidName,
      Value<String?> otherFluidAmount,
      Value<String?> otherFluidNotes,
      Value<String?> importSource,
      Value<String?> importExternalId,
      Value<String?> cloudStorageUrl,
      Value<String?> fileHash,
      Value<int?> fileSizeBytes,
      Value<bool> isFileUploaded,
      Value<String> notes,
      Value<String> photoIds,
      required int syncCreatedAt,
      Value<int?> syncUpdatedAt,
      Value<int?> syncDeletedAt,
      Value<int?> syncLastSyncedAt,
      Value<int> syncStatus,
      Value<int> syncVersion,
      Value<String?> syncDeviceId,
      Value<bool> syncIsDirty,
      Value<String?> conflictData,
      Value<int> rowid,
    });
typedef $$FluidsEntriesTableUpdateCompanionBuilder =
    FluidsEntriesCompanion Function({
      Value<String> id,
      Value<String> clientId,
      Value<String> profileId,
      Value<int> entryDate,
      Value<int?> waterIntakeMl,
      Value<String?> waterIntakeNotes,
      Value<bool> hasBowelMovement,
      Value<int?> bowelCondition,
      Value<String?> bowelCustomCondition,
      Value<int?> bowelSize,
      Value<String?> bowelPhotoPath,
      Value<bool> hasUrineMovement,
      Value<int?> urineCondition,
      Value<String?> urineCustomCondition,
      Value<int?> urineSize,
      Value<String?> urinePhotoPath,
      Value<int?> menstruationFlow,
      Value<double?> basalBodyTemperature,
      Value<int?> bbtRecordedTime,
      Value<String?> otherFluidName,
      Value<String?> otherFluidAmount,
      Value<String?> otherFluidNotes,
      Value<String?> importSource,
      Value<String?> importExternalId,
      Value<String?> cloudStorageUrl,
      Value<String?> fileHash,
      Value<int?> fileSizeBytes,
      Value<bool> isFileUploaded,
      Value<String> notes,
      Value<String> photoIds,
      Value<int> syncCreatedAt,
      Value<int?> syncUpdatedAt,
      Value<int?> syncDeletedAt,
      Value<int?> syncLastSyncedAt,
      Value<int> syncStatus,
      Value<int> syncVersion,
      Value<String?> syncDeviceId,
      Value<bool> syncIsDirty,
      Value<String?> conflictData,
      Value<int> rowid,
    });

class $$FluidsEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $FluidsEntriesTable> {
  $$FluidsEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get entryDate => $composableBuilder(
    column: $table.entryDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get waterIntakeMl => $composableBuilder(
    column: $table.waterIntakeMl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get waterIntakeNotes => $composableBuilder(
    column: $table.waterIntakeNotes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasBowelMovement => $composableBuilder(
    column: $table.hasBowelMovement,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bowelCondition => $composableBuilder(
    column: $table.bowelCondition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bowelCustomCondition => $composableBuilder(
    column: $table.bowelCustomCondition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bowelSize => $composableBuilder(
    column: $table.bowelSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bowelPhotoPath => $composableBuilder(
    column: $table.bowelPhotoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasUrineMovement => $composableBuilder(
    column: $table.hasUrineMovement,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get urineCondition => $composableBuilder(
    column: $table.urineCondition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get urineCustomCondition => $composableBuilder(
    column: $table.urineCustomCondition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get urineSize => $composableBuilder(
    column: $table.urineSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get urinePhotoPath => $composableBuilder(
    column: $table.urinePhotoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get menstruationFlow => $composableBuilder(
    column: $table.menstruationFlow,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get basalBodyTemperature => $composableBuilder(
    column: $table.basalBodyTemperature,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bbtRecordedTime => $composableBuilder(
    column: $table.bbtRecordedTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get otherFluidName => $composableBuilder(
    column: $table.otherFluidName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get otherFluidAmount => $composableBuilder(
    column: $table.otherFluidAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get otherFluidNotes => $composableBuilder(
    column: $table.otherFluidNotes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get importSource => $composableBuilder(
    column: $table.importSource,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get importExternalId => $composableBuilder(
    column: $table.importExternalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cloudStorageUrl => $composableBuilder(
    column: $table.cloudStorageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileHash => $composableBuilder(
    column: $table.fileHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fileSizeBytes => $composableBuilder(
    column: $table.fileSizeBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFileUploaded => $composableBuilder(
    column: $table.isFileUploaded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoIds => $composableBuilder(
    column: $table.photoIds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncCreatedAt => $composableBuilder(
    column: $table.syncCreatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncDeletedAt => $composableBuilder(
    column: $table.syncDeletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncLastSyncedAt => $composableBuilder(
    column: $table.syncLastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncDeviceId => $composableBuilder(
    column: $table.syncDeviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get syncIsDirty => $composableBuilder(
    column: $table.syncIsDirty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conflictData => $composableBuilder(
    column: $table.conflictData,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FluidsEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $FluidsEntriesTable> {
  $$FluidsEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get entryDate => $composableBuilder(
    column: $table.entryDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get waterIntakeMl => $composableBuilder(
    column: $table.waterIntakeMl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get waterIntakeNotes => $composableBuilder(
    column: $table.waterIntakeNotes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasBowelMovement => $composableBuilder(
    column: $table.hasBowelMovement,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bowelCondition => $composableBuilder(
    column: $table.bowelCondition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bowelCustomCondition => $composableBuilder(
    column: $table.bowelCustomCondition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bowelSize => $composableBuilder(
    column: $table.bowelSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bowelPhotoPath => $composableBuilder(
    column: $table.bowelPhotoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasUrineMovement => $composableBuilder(
    column: $table.hasUrineMovement,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get urineCondition => $composableBuilder(
    column: $table.urineCondition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get urineCustomCondition => $composableBuilder(
    column: $table.urineCustomCondition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get urineSize => $composableBuilder(
    column: $table.urineSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get urinePhotoPath => $composableBuilder(
    column: $table.urinePhotoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get menstruationFlow => $composableBuilder(
    column: $table.menstruationFlow,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get basalBodyTemperature => $composableBuilder(
    column: $table.basalBodyTemperature,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bbtRecordedTime => $composableBuilder(
    column: $table.bbtRecordedTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get otherFluidName => $composableBuilder(
    column: $table.otherFluidName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get otherFluidAmount => $composableBuilder(
    column: $table.otherFluidAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get otherFluidNotes => $composableBuilder(
    column: $table.otherFluidNotes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get importSource => $composableBuilder(
    column: $table.importSource,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get importExternalId => $composableBuilder(
    column: $table.importExternalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cloudStorageUrl => $composableBuilder(
    column: $table.cloudStorageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileHash => $composableBuilder(
    column: $table.fileHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fileSizeBytes => $composableBuilder(
    column: $table.fileSizeBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFileUploaded => $composableBuilder(
    column: $table.isFileUploaded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoIds => $composableBuilder(
    column: $table.photoIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncCreatedAt => $composableBuilder(
    column: $table.syncCreatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncDeletedAt => $composableBuilder(
    column: $table.syncDeletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncLastSyncedAt => $composableBuilder(
    column: $table.syncLastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncDeviceId => $composableBuilder(
    column: $table.syncDeviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get syncIsDirty => $composableBuilder(
    column: $table.syncIsDirty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conflictData => $composableBuilder(
    column: $table.conflictData,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FluidsEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FluidsEntriesTable> {
  $$FluidsEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<int> get entryDate =>
      $composableBuilder(column: $table.entryDate, builder: (column) => column);

  GeneratedColumn<int> get waterIntakeMl => $composableBuilder(
    column: $table.waterIntakeMl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get waterIntakeNotes => $composableBuilder(
    column: $table.waterIntakeNotes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hasBowelMovement => $composableBuilder(
    column: $table.hasBowelMovement,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bowelCondition => $composableBuilder(
    column: $table.bowelCondition,
    builder: (column) => column,
  );

  GeneratedColumn<String> get bowelCustomCondition => $composableBuilder(
    column: $table.bowelCustomCondition,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bowelSize =>
      $composableBuilder(column: $table.bowelSize, builder: (column) => column);

  GeneratedColumn<String> get bowelPhotoPath => $composableBuilder(
    column: $table.bowelPhotoPath,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hasUrineMovement => $composableBuilder(
    column: $table.hasUrineMovement,
    builder: (column) => column,
  );

  GeneratedColumn<int> get urineCondition => $composableBuilder(
    column: $table.urineCondition,
    builder: (column) => column,
  );

  GeneratedColumn<String> get urineCustomCondition => $composableBuilder(
    column: $table.urineCustomCondition,
    builder: (column) => column,
  );

  GeneratedColumn<int> get urineSize =>
      $composableBuilder(column: $table.urineSize, builder: (column) => column);

  GeneratedColumn<String> get urinePhotoPath => $composableBuilder(
    column: $table.urinePhotoPath,
    builder: (column) => column,
  );

  GeneratedColumn<int> get menstruationFlow => $composableBuilder(
    column: $table.menstruationFlow,
    builder: (column) => column,
  );

  GeneratedColumn<double> get basalBodyTemperature => $composableBuilder(
    column: $table.basalBodyTemperature,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bbtRecordedTime => $composableBuilder(
    column: $table.bbtRecordedTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get otherFluidName => $composableBuilder(
    column: $table.otherFluidName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get otherFluidAmount => $composableBuilder(
    column: $table.otherFluidAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get otherFluidNotes => $composableBuilder(
    column: $table.otherFluidNotes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get importSource => $composableBuilder(
    column: $table.importSource,
    builder: (column) => column,
  );

  GeneratedColumn<String> get importExternalId => $composableBuilder(
    column: $table.importExternalId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cloudStorageUrl => $composableBuilder(
    column: $table.cloudStorageUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fileHash =>
      $composableBuilder(column: $table.fileHash, builder: (column) => column);

  GeneratedColumn<int> get fileSizeBytes => $composableBuilder(
    column: $table.fileSizeBytes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isFileUploaded => $composableBuilder(
    column: $table.isFileUploaded,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get photoIds =>
      $composableBuilder(column: $table.photoIds, builder: (column) => column);

  GeneratedColumn<int> get syncCreatedAt => $composableBuilder(
    column: $table.syncCreatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncDeletedAt => $composableBuilder(
    column: $table.syncDeletedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncLastSyncedAt => $composableBuilder(
    column: $table.syncLastSyncedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncDeviceId => $composableBuilder(
    column: $table.syncDeviceId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get syncIsDirty => $composableBuilder(
    column: $table.syncIsDirty,
    builder: (column) => column,
  );

  GeneratedColumn<String> get conflictData => $composableBuilder(
    column: $table.conflictData,
    builder: (column) => column,
  );
}

class $$FluidsEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FluidsEntriesTable,
          FluidsEntryRow,
          $$FluidsEntriesTableFilterComposer,
          $$FluidsEntriesTableOrderingComposer,
          $$FluidsEntriesTableAnnotationComposer,
          $$FluidsEntriesTableCreateCompanionBuilder,
          $$FluidsEntriesTableUpdateCompanionBuilder,
          (
            FluidsEntryRow,
            BaseReferences<_$AppDatabase, $FluidsEntriesTable, FluidsEntryRow>,
          ),
          FluidsEntryRow,
          PrefetchHooks Function()
        > {
  $$FluidsEntriesTableTableManager(_$AppDatabase db, $FluidsEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FluidsEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FluidsEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FluidsEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> clientId = const Value.absent(),
                Value<String> profileId = const Value.absent(),
                Value<int> entryDate = const Value.absent(),
                Value<int?> waterIntakeMl = const Value.absent(),
                Value<String?> waterIntakeNotes = const Value.absent(),
                Value<bool> hasBowelMovement = const Value.absent(),
                Value<int?> bowelCondition = const Value.absent(),
                Value<String?> bowelCustomCondition = const Value.absent(),
                Value<int?> bowelSize = const Value.absent(),
                Value<String?> bowelPhotoPath = const Value.absent(),
                Value<bool> hasUrineMovement = const Value.absent(),
                Value<int?> urineCondition = const Value.absent(),
                Value<String?> urineCustomCondition = const Value.absent(),
                Value<int?> urineSize = const Value.absent(),
                Value<String?> urinePhotoPath = const Value.absent(),
                Value<int?> menstruationFlow = const Value.absent(),
                Value<double?> basalBodyTemperature = const Value.absent(),
                Value<int?> bbtRecordedTime = const Value.absent(),
                Value<String?> otherFluidName = const Value.absent(),
                Value<String?> otherFluidAmount = const Value.absent(),
                Value<String?> otherFluidNotes = const Value.absent(),
                Value<String?> importSource = const Value.absent(),
                Value<String?> importExternalId = const Value.absent(),
                Value<String?> cloudStorageUrl = const Value.absent(),
                Value<String?> fileHash = const Value.absent(),
                Value<int?> fileSizeBytes = const Value.absent(),
                Value<bool> isFileUploaded = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<String> photoIds = const Value.absent(),
                Value<int> syncCreatedAt = const Value.absent(),
                Value<int?> syncUpdatedAt = const Value.absent(),
                Value<int?> syncDeletedAt = const Value.absent(),
                Value<int?> syncLastSyncedAt = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> syncVersion = const Value.absent(),
                Value<String?> syncDeviceId = const Value.absent(),
                Value<bool> syncIsDirty = const Value.absent(),
                Value<String?> conflictData = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FluidsEntriesCompanion(
                id: id,
                clientId: clientId,
                profileId: profileId,
                entryDate: entryDate,
                waterIntakeMl: waterIntakeMl,
                waterIntakeNotes: waterIntakeNotes,
                hasBowelMovement: hasBowelMovement,
                bowelCondition: bowelCondition,
                bowelCustomCondition: bowelCustomCondition,
                bowelSize: bowelSize,
                bowelPhotoPath: bowelPhotoPath,
                hasUrineMovement: hasUrineMovement,
                urineCondition: urineCondition,
                urineCustomCondition: urineCustomCondition,
                urineSize: urineSize,
                urinePhotoPath: urinePhotoPath,
                menstruationFlow: menstruationFlow,
                basalBodyTemperature: basalBodyTemperature,
                bbtRecordedTime: bbtRecordedTime,
                otherFluidName: otherFluidName,
                otherFluidAmount: otherFluidAmount,
                otherFluidNotes: otherFluidNotes,
                importSource: importSource,
                importExternalId: importExternalId,
                cloudStorageUrl: cloudStorageUrl,
                fileHash: fileHash,
                fileSizeBytes: fileSizeBytes,
                isFileUploaded: isFileUploaded,
                notes: notes,
                photoIds: photoIds,
                syncCreatedAt: syncCreatedAt,
                syncUpdatedAt: syncUpdatedAt,
                syncDeletedAt: syncDeletedAt,
                syncLastSyncedAt: syncLastSyncedAt,
                syncStatus: syncStatus,
                syncVersion: syncVersion,
                syncDeviceId: syncDeviceId,
                syncIsDirty: syncIsDirty,
                conflictData: conflictData,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String clientId,
                required String profileId,
                required int entryDate,
                Value<int?> waterIntakeMl = const Value.absent(),
                Value<String?> waterIntakeNotes = const Value.absent(),
                Value<bool> hasBowelMovement = const Value.absent(),
                Value<int?> bowelCondition = const Value.absent(),
                Value<String?> bowelCustomCondition = const Value.absent(),
                Value<int?> bowelSize = const Value.absent(),
                Value<String?> bowelPhotoPath = const Value.absent(),
                Value<bool> hasUrineMovement = const Value.absent(),
                Value<int?> urineCondition = const Value.absent(),
                Value<String?> urineCustomCondition = const Value.absent(),
                Value<int?> urineSize = const Value.absent(),
                Value<String?> urinePhotoPath = const Value.absent(),
                Value<int?> menstruationFlow = const Value.absent(),
                Value<double?> basalBodyTemperature = const Value.absent(),
                Value<int?> bbtRecordedTime = const Value.absent(),
                Value<String?> otherFluidName = const Value.absent(),
                Value<String?> otherFluidAmount = const Value.absent(),
                Value<String?> otherFluidNotes = const Value.absent(),
                Value<String?> importSource = const Value.absent(),
                Value<String?> importExternalId = const Value.absent(),
                Value<String?> cloudStorageUrl = const Value.absent(),
                Value<String?> fileHash = const Value.absent(),
                Value<int?> fileSizeBytes = const Value.absent(),
                Value<bool> isFileUploaded = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<String> photoIds = const Value.absent(),
                required int syncCreatedAt,
                Value<int?> syncUpdatedAt = const Value.absent(),
                Value<int?> syncDeletedAt = const Value.absent(),
                Value<int?> syncLastSyncedAt = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> syncVersion = const Value.absent(),
                Value<String?> syncDeviceId = const Value.absent(),
                Value<bool> syncIsDirty = const Value.absent(),
                Value<String?> conflictData = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FluidsEntriesCompanion.insert(
                id: id,
                clientId: clientId,
                profileId: profileId,
                entryDate: entryDate,
                waterIntakeMl: waterIntakeMl,
                waterIntakeNotes: waterIntakeNotes,
                hasBowelMovement: hasBowelMovement,
                bowelCondition: bowelCondition,
                bowelCustomCondition: bowelCustomCondition,
                bowelSize: bowelSize,
                bowelPhotoPath: bowelPhotoPath,
                hasUrineMovement: hasUrineMovement,
                urineCondition: urineCondition,
                urineCustomCondition: urineCustomCondition,
                urineSize: urineSize,
                urinePhotoPath: urinePhotoPath,
                menstruationFlow: menstruationFlow,
                basalBodyTemperature: basalBodyTemperature,
                bbtRecordedTime: bbtRecordedTime,
                otherFluidName: otherFluidName,
                otherFluidAmount: otherFluidAmount,
                otherFluidNotes: otherFluidNotes,
                importSource: importSource,
                importExternalId: importExternalId,
                cloudStorageUrl: cloudStorageUrl,
                fileHash: fileHash,
                fileSizeBytes: fileSizeBytes,
                isFileUploaded: isFileUploaded,
                notes: notes,
                photoIds: photoIds,
                syncCreatedAt: syncCreatedAt,
                syncUpdatedAt: syncUpdatedAt,
                syncDeletedAt: syncDeletedAt,
                syncLastSyncedAt: syncLastSyncedAt,
                syncStatus: syncStatus,
                syncVersion: syncVersion,
                syncDeviceId: syncDeviceId,
                syncIsDirty: syncIsDirty,
                conflictData: conflictData,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FluidsEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FluidsEntriesTable,
      FluidsEntryRow,
      $$FluidsEntriesTableFilterComposer,
      $$FluidsEntriesTableOrderingComposer,
      $$FluidsEntriesTableAnnotationComposer,
      $$FluidsEntriesTableCreateCompanionBuilder,
      $$FluidsEntriesTableUpdateCompanionBuilder,
      (
        FluidsEntryRow,
        BaseReferences<_$AppDatabase, $FluidsEntriesTable, FluidsEntryRow>,
      ),
      FluidsEntryRow,
      PrefetchHooks Function()
    >;
typedef $$SleepEntriesTableCreateCompanionBuilder =
    SleepEntriesCompanion Function({
      required String id,
      required String clientId,
      required String profileId,
      required int bedTime,
      Value<int?> wakeTime,
      Value<int> deepSleepMinutes,
      Value<int> lightSleepMinutes,
      Value<int> restlessSleepMinutes,
      Value<int> dreamType,
      Value<int> wakingFeeling,
      Value<String?> notes,
      Value<String?> importSource,
      Value<String?> importExternalId,
      required int syncCreatedAt,
      Value<int?> syncUpdatedAt,
      Value<int?> syncDeletedAt,
      Value<int?> syncLastSyncedAt,
      Value<int> syncStatus,
      Value<int> syncVersion,
      Value<String?> syncDeviceId,
      Value<bool> syncIsDirty,
      Value<String?> conflictData,
      Value<int> rowid,
    });
typedef $$SleepEntriesTableUpdateCompanionBuilder =
    SleepEntriesCompanion Function({
      Value<String> id,
      Value<String> clientId,
      Value<String> profileId,
      Value<int> bedTime,
      Value<int?> wakeTime,
      Value<int> deepSleepMinutes,
      Value<int> lightSleepMinutes,
      Value<int> restlessSleepMinutes,
      Value<int> dreamType,
      Value<int> wakingFeeling,
      Value<String?> notes,
      Value<String?> importSource,
      Value<String?> importExternalId,
      Value<int> syncCreatedAt,
      Value<int?> syncUpdatedAt,
      Value<int?> syncDeletedAt,
      Value<int?> syncLastSyncedAt,
      Value<int> syncStatus,
      Value<int> syncVersion,
      Value<String?> syncDeviceId,
      Value<bool> syncIsDirty,
      Value<String?> conflictData,
      Value<int> rowid,
    });

class $$SleepEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $SleepEntriesTable> {
  $$SleepEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bedTime => $composableBuilder(
    column: $table.bedTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wakeTime => $composableBuilder(
    column: $table.wakeTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deepSleepMinutes => $composableBuilder(
    column: $table.deepSleepMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lightSleepMinutes => $composableBuilder(
    column: $table.lightSleepMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get restlessSleepMinutes => $composableBuilder(
    column: $table.restlessSleepMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dreamType => $composableBuilder(
    column: $table.dreamType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wakingFeeling => $composableBuilder(
    column: $table.wakingFeeling,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get importSource => $composableBuilder(
    column: $table.importSource,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get importExternalId => $composableBuilder(
    column: $table.importExternalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncCreatedAt => $composableBuilder(
    column: $table.syncCreatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncDeletedAt => $composableBuilder(
    column: $table.syncDeletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncLastSyncedAt => $composableBuilder(
    column: $table.syncLastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncDeviceId => $composableBuilder(
    column: $table.syncDeviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get syncIsDirty => $composableBuilder(
    column: $table.syncIsDirty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conflictData => $composableBuilder(
    column: $table.conflictData,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SleepEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $SleepEntriesTable> {
  $$SleepEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bedTime => $composableBuilder(
    column: $table.bedTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wakeTime => $composableBuilder(
    column: $table.wakeTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deepSleepMinutes => $composableBuilder(
    column: $table.deepSleepMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lightSleepMinutes => $composableBuilder(
    column: $table.lightSleepMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get restlessSleepMinutes => $composableBuilder(
    column: $table.restlessSleepMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dreamType => $composableBuilder(
    column: $table.dreamType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wakingFeeling => $composableBuilder(
    column: $table.wakingFeeling,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get importSource => $composableBuilder(
    column: $table.importSource,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get importExternalId => $composableBuilder(
    column: $table.importExternalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncCreatedAt => $composableBuilder(
    column: $table.syncCreatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncDeletedAt => $composableBuilder(
    column: $table.syncDeletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncLastSyncedAt => $composableBuilder(
    column: $table.syncLastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncDeviceId => $composableBuilder(
    column: $table.syncDeviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get syncIsDirty => $composableBuilder(
    column: $table.syncIsDirty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conflictData => $composableBuilder(
    column: $table.conflictData,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SleepEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SleepEntriesTable> {
  $$SleepEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<int> get bedTime =>
      $composableBuilder(column: $table.bedTime, builder: (column) => column);

  GeneratedColumn<int> get wakeTime =>
      $composableBuilder(column: $table.wakeTime, builder: (column) => column);

  GeneratedColumn<int> get deepSleepMinutes => $composableBuilder(
    column: $table.deepSleepMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lightSleepMinutes => $composableBuilder(
    column: $table.lightSleepMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get restlessSleepMinutes => $composableBuilder(
    column: $table.restlessSleepMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dreamType =>
      $composableBuilder(column: $table.dreamType, builder: (column) => column);

  GeneratedColumn<int> get wakingFeeling => $composableBuilder(
    column: $table.wakingFeeling,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get importSource => $composableBuilder(
    column: $table.importSource,
    builder: (column) => column,
  );

  GeneratedColumn<String> get importExternalId => $composableBuilder(
    column: $table.importExternalId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncCreatedAt => $composableBuilder(
    column: $table.syncCreatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncDeletedAt => $composableBuilder(
    column: $table.syncDeletedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncLastSyncedAt => $composableBuilder(
    column: $table.syncLastSyncedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncDeviceId => $composableBuilder(
    column: $table.syncDeviceId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get syncIsDirty => $composableBuilder(
    column: $table.syncIsDirty,
    builder: (column) => column,
  );

  GeneratedColumn<String> get conflictData => $composableBuilder(
    column: $table.conflictData,
    builder: (column) => column,
  );
}

class $$SleepEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SleepEntriesTable,
          SleepEntryRow,
          $$SleepEntriesTableFilterComposer,
          $$SleepEntriesTableOrderingComposer,
          $$SleepEntriesTableAnnotationComposer,
          $$SleepEntriesTableCreateCompanionBuilder,
          $$SleepEntriesTableUpdateCompanionBuilder,
          (
            SleepEntryRow,
            BaseReferences<_$AppDatabase, $SleepEntriesTable, SleepEntryRow>,
          ),
          SleepEntryRow,
          PrefetchHooks Function()
        > {
  $$SleepEntriesTableTableManager(_$AppDatabase db, $SleepEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SleepEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SleepEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SleepEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> clientId = const Value.absent(),
                Value<String> profileId = const Value.absent(),
                Value<int> bedTime = const Value.absent(),
                Value<int?> wakeTime = const Value.absent(),
                Value<int> deepSleepMinutes = const Value.absent(),
                Value<int> lightSleepMinutes = const Value.absent(),
                Value<int> restlessSleepMinutes = const Value.absent(),
                Value<int> dreamType = const Value.absent(),
                Value<int> wakingFeeling = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> importSource = const Value.absent(),
                Value<String?> importExternalId = const Value.absent(),
                Value<int> syncCreatedAt = const Value.absent(),
                Value<int?> syncUpdatedAt = const Value.absent(),
                Value<int?> syncDeletedAt = const Value.absent(),
                Value<int?> syncLastSyncedAt = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> syncVersion = const Value.absent(),
                Value<String?> syncDeviceId = const Value.absent(),
                Value<bool> syncIsDirty = const Value.absent(),
                Value<String?> conflictData = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SleepEntriesCompanion(
                id: id,
                clientId: clientId,
                profileId: profileId,
                bedTime: bedTime,
                wakeTime: wakeTime,
                deepSleepMinutes: deepSleepMinutes,
                lightSleepMinutes: lightSleepMinutes,
                restlessSleepMinutes: restlessSleepMinutes,
                dreamType: dreamType,
                wakingFeeling: wakingFeeling,
                notes: notes,
                importSource: importSource,
                importExternalId: importExternalId,
                syncCreatedAt: syncCreatedAt,
                syncUpdatedAt: syncUpdatedAt,
                syncDeletedAt: syncDeletedAt,
                syncLastSyncedAt: syncLastSyncedAt,
                syncStatus: syncStatus,
                syncVersion: syncVersion,
                syncDeviceId: syncDeviceId,
                syncIsDirty: syncIsDirty,
                conflictData: conflictData,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String clientId,
                required String profileId,
                required int bedTime,
                Value<int?> wakeTime = const Value.absent(),
                Value<int> deepSleepMinutes = const Value.absent(),
                Value<int> lightSleepMinutes = const Value.absent(),
                Value<int> restlessSleepMinutes = const Value.absent(),
                Value<int> dreamType = const Value.absent(),
                Value<int> wakingFeeling = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> importSource = const Value.absent(),
                Value<String?> importExternalId = const Value.absent(),
                required int syncCreatedAt,
                Value<int?> syncUpdatedAt = const Value.absent(),
                Value<int?> syncDeletedAt = const Value.absent(),
                Value<int?> syncLastSyncedAt = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> syncVersion = const Value.absent(),
                Value<String?> syncDeviceId = const Value.absent(),
                Value<bool> syncIsDirty = const Value.absent(),
                Value<String?> conflictData = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SleepEntriesCompanion.insert(
                id: id,
                clientId: clientId,
                profileId: profileId,
                bedTime: bedTime,
                wakeTime: wakeTime,
                deepSleepMinutes: deepSleepMinutes,
                lightSleepMinutes: lightSleepMinutes,
                restlessSleepMinutes: restlessSleepMinutes,
                dreamType: dreamType,
                wakingFeeling: wakingFeeling,
                notes: notes,
                importSource: importSource,
                importExternalId: importExternalId,
                syncCreatedAt: syncCreatedAt,
                syncUpdatedAt: syncUpdatedAt,
                syncDeletedAt: syncDeletedAt,
                syncLastSyncedAt: syncLastSyncedAt,
                syncStatus: syncStatus,
                syncVersion: syncVersion,
                syncDeviceId: syncDeviceId,
                syncIsDirty: syncIsDirty,
                conflictData: conflictData,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SleepEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SleepEntriesTable,
      SleepEntryRow,
      $$SleepEntriesTableFilterComposer,
      $$SleepEntriesTableOrderingComposer,
      $$SleepEntriesTableAnnotationComposer,
      $$SleepEntriesTableCreateCompanionBuilder,
      $$SleepEntriesTableUpdateCompanionBuilder,
      (
        SleepEntryRow,
        BaseReferences<_$AppDatabase, $SleepEntriesTable, SleepEntryRow>,
      ),
      SleepEntryRow,
      PrefetchHooks Function()
    >;
typedef $$ActivitiesTableCreateCompanionBuilder =
    ActivitiesCompanion Function({
      required String id,
      required String clientId,
      required String profileId,
      required String name,
      Value<String?> description,
      Value<String?> location,
      Value<String?> triggers,
      required int durationMinutes,
      Value<bool> isArchived,
      required int syncCreatedAt,
      Value<int?> syncUpdatedAt,
      Value<int?> syncDeletedAt,
      Value<int?> syncLastSyncedAt,
      Value<int> syncStatus,
      Value<int> syncVersion,
      Value<String?> syncDeviceId,
      Value<bool> syncIsDirty,
      Value<String?> conflictData,
      Value<int> rowid,
    });
typedef $$ActivitiesTableUpdateCompanionBuilder =
    ActivitiesCompanion Function({
      Value<String> id,
      Value<String> clientId,
      Value<String> profileId,
      Value<String> name,
      Value<String?> description,
      Value<String?> location,
      Value<String?> triggers,
      Value<int> durationMinutes,
      Value<bool> isArchived,
      Value<int> syncCreatedAt,
      Value<int?> syncUpdatedAt,
      Value<int?> syncDeletedAt,
      Value<int?> syncLastSyncedAt,
      Value<int> syncStatus,
      Value<int> syncVersion,
      Value<String?> syncDeviceId,
      Value<bool> syncIsDirty,
      Value<String?> conflictData,
      Value<int> rowid,
    });

class $$ActivitiesTableFilterComposer
    extends Composer<_$AppDatabase, $ActivitiesTable> {
  $$ActivitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get triggers => $composableBuilder(
    column: $table.triggers,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncCreatedAt => $composableBuilder(
    column: $table.syncCreatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncDeletedAt => $composableBuilder(
    column: $table.syncDeletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncLastSyncedAt => $composableBuilder(
    column: $table.syncLastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncDeviceId => $composableBuilder(
    column: $table.syncDeviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get syncIsDirty => $composableBuilder(
    column: $table.syncIsDirty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conflictData => $composableBuilder(
    column: $table.conflictData,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ActivitiesTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivitiesTable> {
  $$ActivitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get triggers => $composableBuilder(
    column: $table.triggers,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncCreatedAt => $composableBuilder(
    column: $table.syncCreatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncDeletedAt => $composableBuilder(
    column: $table.syncDeletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncLastSyncedAt => $composableBuilder(
    column: $table.syncLastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncDeviceId => $composableBuilder(
    column: $table.syncDeviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get syncIsDirty => $composableBuilder(
    column: $table.syncIsDirty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conflictData => $composableBuilder(
    column: $table.conflictData,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActivitiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivitiesTable> {
  $$ActivitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<String> get triggers =>
      $composableBuilder(column: $table.triggers, builder: (column) => column);

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncCreatedAt => $composableBuilder(
    column: $table.syncCreatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncDeletedAt => $composableBuilder(
    column: $table.syncDeletedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncLastSyncedAt => $composableBuilder(
    column: $table.syncLastSyncedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncDeviceId => $composableBuilder(
    column: $table.syncDeviceId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get syncIsDirty => $composableBuilder(
    column: $table.syncIsDirty,
    builder: (column) => column,
  );

  GeneratedColumn<String> get conflictData => $composableBuilder(
    column: $table.conflictData,
    builder: (column) => column,
  );
}

class $$ActivitiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActivitiesTable,
          ActivityRow,
          $$ActivitiesTableFilterComposer,
          $$ActivitiesTableOrderingComposer,
          $$ActivitiesTableAnnotationComposer,
          $$ActivitiesTableCreateCompanionBuilder,
          $$ActivitiesTableUpdateCompanionBuilder,
          (
            ActivityRow,
            BaseReferences<_$AppDatabase, $ActivitiesTable, ActivityRow>,
          ),
          ActivityRow,
          PrefetchHooks Function()
        > {
  $$ActivitiesTableTableManager(_$AppDatabase db, $ActivitiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActivitiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActivitiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> clientId = const Value.absent(),
                Value<String> profileId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<String?> triggers = const Value.absent(),
                Value<int> durationMinutes = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<int> syncCreatedAt = const Value.absent(),
                Value<int?> syncUpdatedAt = const Value.absent(),
                Value<int?> syncDeletedAt = const Value.absent(),
                Value<int?> syncLastSyncedAt = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> syncVersion = const Value.absent(),
                Value<String?> syncDeviceId = const Value.absent(),
                Value<bool> syncIsDirty = const Value.absent(),
                Value<String?> conflictData = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivitiesCompanion(
                id: id,
                clientId: clientId,
                profileId: profileId,
                name: name,
                description: description,
                location: location,
                triggers: triggers,
                durationMinutes: durationMinutes,
                isArchived: isArchived,
                syncCreatedAt: syncCreatedAt,
                syncUpdatedAt: syncUpdatedAt,
                syncDeletedAt: syncDeletedAt,
                syncLastSyncedAt: syncLastSyncedAt,
                syncStatus: syncStatus,
                syncVersion: syncVersion,
                syncDeviceId: syncDeviceId,
                syncIsDirty: syncIsDirty,
                conflictData: conflictData,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String clientId,
                required String profileId,
                required String name,
                Value<String?> description = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<String?> triggers = const Value.absent(),
                required int durationMinutes,
                Value<bool> isArchived = const Value.absent(),
                required int syncCreatedAt,
                Value<int?> syncUpdatedAt = const Value.absent(),
                Value<int?> syncDeletedAt = const Value.absent(),
                Value<int?> syncLastSyncedAt = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> syncVersion = const Value.absent(),
                Value<String?> syncDeviceId = const Value.absent(),
                Value<bool> syncIsDirty = const Value.absent(),
                Value<String?> conflictData = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivitiesCompanion.insert(
                id: id,
                clientId: clientId,
                profileId: profileId,
                name: name,
                description: description,
                location: location,
                triggers: triggers,
                durationMinutes: durationMinutes,
                isArchived: isArchived,
                syncCreatedAt: syncCreatedAt,
                syncUpdatedAt: syncUpdatedAt,
                syncDeletedAt: syncDeletedAt,
                syncLastSyncedAt: syncLastSyncedAt,
                syncStatus: syncStatus,
                syncVersion: syncVersion,
                syncDeviceId: syncDeviceId,
                syncIsDirty: syncIsDirty,
                conflictData: conflictData,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ActivitiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActivitiesTable,
      ActivityRow,
      $$ActivitiesTableFilterComposer,
      $$ActivitiesTableOrderingComposer,
      $$ActivitiesTableAnnotationComposer,
      $$ActivitiesTableCreateCompanionBuilder,
      $$ActivitiesTableUpdateCompanionBuilder,
      (
        ActivityRow,
        BaseReferences<_$AppDatabase, $ActivitiesTable, ActivityRow>,
      ),
      ActivityRow,
      PrefetchHooks Function()
    >;
typedef $$ActivityLogsTableCreateCompanionBuilder =
    ActivityLogsCompanion Function({
      required String id,
      required String clientId,
      required String profileId,
      required int timestamp,
      required String activityIds,
      required String adHocActivities,
      Value<int?> duration,
      Value<String?> notes,
      Value<String?> importSource,
      Value<String?> importExternalId,
      required int syncCreatedAt,
      Value<int?> syncUpdatedAt,
      Value<int?> syncDeletedAt,
      Value<int?> syncLastSyncedAt,
      Value<int> syncStatus,
      Value<int> syncVersion,
      Value<String?> syncDeviceId,
      Value<bool> syncIsDirty,
      Value<String?> conflictData,
      Value<int> rowid,
    });
typedef $$ActivityLogsTableUpdateCompanionBuilder =
    ActivityLogsCompanion Function({
      Value<String> id,
      Value<String> clientId,
      Value<String> profileId,
      Value<int> timestamp,
      Value<String> activityIds,
      Value<String> adHocActivities,
      Value<int?> duration,
      Value<String?> notes,
      Value<String?> importSource,
      Value<String?> importExternalId,
      Value<int> syncCreatedAt,
      Value<int?> syncUpdatedAt,
      Value<int?> syncDeletedAt,
      Value<int?> syncLastSyncedAt,
      Value<int> syncStatus,
      Value<int> syncVersion,
      Value<String?> syncDeviceId,
      Value<bool> syncIsDirty,
      Value<String?> conflictData,
      Value<int> rowid,
    });

class $$ActivityLogsTableFilterComposer
    extends Composer<_$AppDatabase, $ActivityLogsTable> {
  $$ActivityLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activityIds => $composableBuilder(
    column: $table.activityIds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get adHocActivities => $composableBuilder(
    column: $table.adHocActivities,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get importSource => $composableBuilder(
    column: $table.importSource,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get importExternalId => $composableBuilder(
    column: $table.importExternalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncCreatedAt => $composableBuilder(
    column: $table.syncCreatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncDeletedAt => $composableBuilder(
    column: $table.syncDeletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncLastSyncedAt => $composableBuilder(
    column: $table.syncLastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncDeviceId => $composableBuilder(
    column: $table.syncDeviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get syncIsDirty => $composableBuilder(
    column: $table.syncIsDirty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conflictData => $composableBuilder(
    column: $table.conflictData,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ActivityLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivityLogsTable> {
  $$ActivityLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activityIds => $composableBuilder(
    column: $table.activityIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get adHocActivities => $composableBuilder(
    column: $table.adHocActivities,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get importSource => $composableBuilder(
    column: $table.importSource,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get importExternalId => $composableBuilder(
    column: $table.importExternalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncCreatedAt => $composableBuilder(
    column: $table.syncCreatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncDeletedAt => $composableBuilder(
    column: $table.syncDeletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncLastSyncedAt => $composableBuilder(
    column: $table.syncLastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncDeviceId => $composableBuilder(
    column: $table.syncDeviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get syncIsDirty => $composableBuilder(
    column: $table.syncIsDirty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conflictData => $composableBuilder(
    column: $table.conflictData,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActivityLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivityLogsTable> {
  $$ActivityLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<int> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get activityIds => $composableBuilder(
    column: $table.activityIds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get adHocActivities => $composableBuilder(
    column: $table.adHocActivities,
    builder: (column) => column,
  );

  GeneratedColumn<int> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get importSource => $composableBuilder(
    column: $table.importSource,
    builder: (column) => column,
  );

  GeneratedColumn<String> get importExternalId => $composableBuilder(
    column: $table.importExternalId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncCreatedAt => $composableBuilder(
    column: $table.syncCreatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncDeletedAt => $composableBuilder(
    column: $table.syncDeletedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncLastSyncedAt => $composableBuilder(
    column: $table.syncLastSyncedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncDeviceId => $composableBuilder(
    column: $table.syncDeviceId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get syncIsDirty => $composableBuilder(
    column: $table.syncIsDirty,
    builder: (column) => column,
  );

  GeneratedColumn<String> get conflictData => $composableBuilder(
    column: $table.conflictData,
    builder: (column) => column,
  );
}

class $$ActivityLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActivityLogsTable,
          ActivityLogRow,
          $$ActivityLogsTableFilterComposer,
          $$ActivityLogsTableOrderingComposer,
          $$ActivityLogsTableAnnotationComposer,
          $$ActivityLogsTableCreateCompanionBuilder,
          $$ActivityLogsTableUpdateCompanionBuilder,
          (
            ActivityLogRow,
            BaseReferences<_$AppDatabase, $ActivityLogsTable, ActivityLogRow>,
          ),
          ActivityLogRow,
          PrefetchHooks Function()
        > {
  $$ActivityLogsTableTableManager(_$AppDatabase db, $ActivityLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivityLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActivityLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActivityLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> clientId = const Value.absent(),
                Value<String> profileId = const Value.absent(),
                Value<int> timestamp = const Value.absent(),
                Value<String> activityIds = const Value.absent(),
                Value<String> adHocActivities = const Value.absent(),
                Value<int?> duration = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> importSource = const Value.absent(),
                Value<String?> importExternalId = const Value.absent(),
                Value<int> syncCreatedAt = const Value.absent(),
                Value<int?> syncUpdatedAt = const Value.absent(),
                Value<int?> syncDeletedAt = const Value.absent(),
                Value<int?> syncLastSyncedAt = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> syncVersion = const Value.absent(),
                Value<String?> syncDeviceId = const Value.absent(),
                Value<bool> syncIsDirty = const Value.absent(),
                Value<String?> conflictData = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivityLogsCompanion(
                id: id,
                clientId: clientId,
                profileId: profileId,
                timestamp: timestamp,
                activityIds: activityIds,
                adHocActivities: adHocActivities,
                duration: duration,
                notes: notes,
                importSource: importSource,
                importExternalId: importExternalId,
                syncCreatedAt: syncCreatedAt,
                syncUpdatedAt: syncUpdatedAt,
                syncDeletedAt: syncDeletedAt,
                syncLastSyncedAt: syncLastSyncedAt,
                syncStatus: syncStatus,
                syncVersion: syncVersion,
                syncDeviceId: syncDeviceId,
                syncIsDirty: syncIsDirty,
                conflictData: conflictData,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String clientId,
                required String profileId,
                required int timestamp,
                required String activityIds,
                required String adHocActivities,
                Value<int?> duration = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> importSource = const Value.absent(),
                Value<String?> importExternalId = const Value.absent(),
                required int syncCreatedAt,
                Value<int?> syncUpdatedAt = const Value.absent(),
                Value<int?> syncDeletedAt = const Value.absent(),
                Value<int?> syncLastSyncedAt = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> syncVersion = const Value.absent(),
                Value<String?> syncDeviceId = const Value.absent(),
                Value<bool> syncIsDirty = const Value.absent(),
                Value<String?> conflictData = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivityLogsCompanion.insert(
                id: id,
                clientId: clientId,
                profileId: profileId,
                timestamp: timestamp,
                activityIds: activityIds,
                adHocActivities: adHocActivities,
                duration: duration,
                notes: notes,
                importSource: importSource,
                importExternalId: importExternalId,
                syncCreatedAt: syncCreatedAt,
                syncUpdatedAt: syncUpdatedAt,
                syncDeletedAt: syncDeletedAt,
                syncLastSyncedAt: syncLastSyncedAt,
                syncStatus: syncStatus,
                syncVersion: syncVersion,
                syncDeviceId: syncDeviceId,
                syncIsDirty: syncIsDirty,
                conflictData: conflictData,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ActivityLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActivityLogsTable,
      ActivityLogRow,
      $$ActivityLogsTableFilterComposer,
      $$ActivityLogsTableOrderingComposer,
      $$ActivityLogsTableAnnotationComposer,
      $$ActivityLogsTableCreateCompanionBuilder,
      $$ActivityLogsTableUpdateCompanionBuilder,
      (
        ActivityLogRow,
        BaseReferences<_$AppDatabase, $ActivityLogsTable, ActivityLogRow>,
      ),
      ActivityLogRow,
      PrefetchHooks Function()
    >;
typedef $$FoodItemsTableCreateCompanionBuilder =
    FoodItemsCompanion Function({
      required String id,
      required String clientId,
      required String profileId,
      required String name,
      Value<int> type,
      Value<String?> simpleItemIds,
      Value<bool> isUserCreated,
      Value<bool> isArchived,
      Value<double?> servingSize,
      Value<String?> servingUnit,
      Value<double?> calories,
      Value<double?> carbsGrams,
      Value<double?> fatGrams,
      Value<double?> proteinGrams,
      Value<double?> fiberGrams,
      Value<double?> sugarGrams,
      required int syncCreatedAt,
      Value<int?> syncUpdatedAt,
      Value<int?> syncDeletedAt,
      Value<int?> syncLastSyncedAt,
      Value<int> syncStatus,
      Value<int> syncVersion,
      Value<String?> syncDeviceId,
      Value<bool> syncIsDirty,
      Value<String?> conflictData,
      Value<int> rowid,
    });
typedef $$FoodItemsTableUpdateCompanionBuilder =
    FoodItemsCompanion Function({
      Value<String> id,
      Value<String> clientId,
      Value<String> profileId,
      Value<String> name,
      Value<int> type,
      Value<String?> simpleItemIds,
      Value<bool> isUserCreated,
      Value<bool> isArchived,
      Value<double?> servingSize,
      Value<String?> servingUnit,
      Value<double?> calories,
      Value<double?> carbsGrams,
      Value<double?> fatGrams,
      Value<double?> proteinGrams,
      Value<double?> fiberGrams,
      Value<double?> sugarGrams,
      Value<int> syncCreatedAt,
      Value<int?> syncUpdatedAt,
      Value<int?> syncDeletedAt,
      Value<int?> syncLastSyncedAt,
      Value<int> syncStatus,
      Value<int> syncVersion,
      Value<String?> syncDeviceId,
      Value<bool> syncIsDirty,
      Value<String?> conflictData,
      Value<int> rowid,
    });

class $$FoodItemsTableFilterComposer
    extends Composer<_$AppDatabase, $FoodItemsTable> {
  $$FoodItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get simpleItemIds => $composableBuilder(
    column: $table.simpleItemIds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isUserCreated => $composableBuilder(
    column: $table.isUserCreated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get servingSize => $composableBuilder(
    column: $table.servingSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get servingUnit => $composableBuilder(
    column: $table.servingUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbsGrams => $composableBuilder(
    column: $table.carbsGrams,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fatGrams => $composableBuilder(
    column: $table.fatGrams,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get proteinGrams => $composableBuilder(
    column: $table.proteinGrams,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fiberGrams => $composableBuilder(
    column: $table.fiberGrams,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get sugarGrams => $composableBuilder(
    column: $table.sugarGrams,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncCreatedAt => $composableBuilder(
    column: $table.syncCreatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncDeletedAt => $composableBuilder(
    column: $table.syncDeletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncLastSyncedAt => $composableBuilder(
    column: $table.syncLastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncDeviceId => $composableBuilder(
    column: $table.syncDeviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get syncIsDirty => $composableBuilder(
    column: $table.syncIsDirty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conflictData => $composableBuilder(
    column: $table.conflictData,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FoodItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $FoodItemsTable> {
  $$FoodItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get simpleItemIds => $composableBuilder(
    column: $table.simpleItemIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isUserCreated => $composableBuilder(
    column: $table.isUserCreated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get servingSize => $composableBuilder(
    column: $table.servingSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get servingUnit => $composableBuilder(
    column: $table.servingUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbsGrams => $composableBuilder(
    column: $table.carbsGrams,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fatGrams => $composableBuilder(
    column: $table.fatGrams,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get proteinGrams => $composableBuilder(
    column: $table.proteinGrams,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fiberGrams => $composableBuilder(
    column: $table.fiberGrams,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get sugarGrams => $composableBuilder(
    column: $table.sugarGrams,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncCreatedAt => $composableBuilder(
    column: $table.syncCreatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncDeletedAt => $composableBuilder(
    column: $table.syncDeletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncLastSyncedAt => $composableBuilder(
    column: $table.syncLastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncDeviceId => $composableBuilder(
    column: $table.syncDeviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get syncIsDirty => $composableBuilder(
    column: $table.syncIsDirty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conflictData => $composableBuilder(
    column: $table.conflictData,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FoodItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FoodItemsTable> {
  $$FoodItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get simpleItemIds => $composableBuilder(
    column: $table.simpleItemIds,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isUserCreated => $composableBuilder(
    column: $table.isUserCreated,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<double> get servingSize => $composableBuilder(
    column: $table.servingSize,
    builder: (column) => column,
  );

  GeneratedColumn<String> get servingUnit => $composableBuilder(
    column: $table.servingUnit,
    builder: (column) => column,
  );

  GeneratedColumn<double> get calories =>
      $composableBuilder(column: $table.calories, builder: (column) => column);

  GeneratedColumn<double> get carbsGrams => $composableBuilder(
    column: $table.carbsGrams,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fatGrams =>
      $composableBuilder(column: $table.fatGrams, builder: (column) => column);

  GeneratedColumn<double> get proteinGrams => $composableBuilder(
    column: $table.proteinGrams,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fiberGrams => $composableBuilder(
    column: $table.fiberGrams,
    builder: (column) => column,
  );

  GeneratedColumn<double> get sugarGrams => $composableBuilder(
    column: $table.sugarGrams,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncCreatedAt => $composableBuilder(
    column: $table.syncCreatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncDeletedAt => $composableBuilder(
    column: $table.syncDeletedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncLastSyncedAt => $composableBuilder(
    column: $table.syncLastSyncedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncDeviceId => $composableBuilder(
    column: $table.syncDeviceId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get syncIsDirty => $composableBuilder(
    column: $table.syncIsDirty,
    builder: (column) => column,
  );

  GeneratedColumn<String> get conflictData => $composableBuilder(
    column: $table.conflictData,
    builder: (column) => column,
  );
}

class $$FoodItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FoodItemsTable,
          FoodItemRow,
          $$FoodItemsTableFilterComposer,
          $$FoodItemsTableOrderingComposer,
          $$FoodItemsTableAnnotationComposer,
          $$FoodItemsTableCreateCompanionBuilder,
          $$FoodItemsTableUpdateCompanionBuilder,
          (
            FoodItemRow,
            BaseReferences<_$AppDatabase, $FoodItemsTable, FoodItemRow>,
          ),
          FoodItemRow,
          PrefetchHooks Function()
        > {
  $$FoodItemsTableTableManager(_$AppDatabase db, $FoodItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FoodItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FoodItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FoodItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> clientId = const Value.absent(),
                Value<String> profileId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> type = const Value.absent(),
                Value<String?> simpleItemIds = const Value.absent(),
                Value<bool> isUserCreated = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<double?> servingSize = const Value.absent(),
                Value<String?> servingUnit = const Value.absent(),
                Value<double?> calories = const Value.absent(),
                Value<double?> carbsGrams = const Value.absent(),
                Value<double?> fatGrams = const Value.absent(),
                Value<double?> proteinGrams = const Value.absent(),
                Value<double?> fiberGrams = const Value.absent(),
                Value<double?> sugarGrams = const Value.absent(),
                Value<int> syncCreatedAt = const Value.absent(),
                Value<int?> syncUpdatedAt = const Value.absent(),
                Value<int?> syncDeletedAt = const Value.absent(),
                Value<int?> syncLastSyncedAt = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> syncVersion = const Value.absent(),
                Value<String?> syncDeviceId = const Value.absent(),
                Value<bool> syncIsDirty = const Value.absent(),
                Value<String?> conflictData = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FoodItemsCompanion(
                id: id,
                clientId: clientId,
                profileId: profileId,
                name: name,
                type: type,
                simpleItemIds: simpleItemIds,
                isUserCreated: isUserCreated,
                isArchived: isArchived,
                servingSize: servingSize,
                servingUnit: servingUnit,
                calories: calories,
                carbsGrams: carbsGrams,
                fatGrams: fatGrams,
                proteinGrams: proteinGrams,
                fiberGrams: fiberGrams,
                sugarGrams: sugarGrams,
                syncCreatedAt: syncCreatedAt,
                syncUpdatedAt: syncUpdatedAt,
                syncDeletedAt: syncDeletedAt,
                syncLastSyncedAt: syncLastSyncedAt,
                syncStatus: syncStatus,
                syncVersion: syncVersion,
                syncDeviceId: syncDeviceId,
                syncIsDirty: syncIsDirty,
                conflictData: conflictData,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String clientId,
                required String profileId,
                required String name,
                Value<int> type = const Value.absent(),
                Value<String?> simpleItemIds = const Value.absent(),
                Value<bool> isUserCreated = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<double?> servingSize = const Value.absent(),
                Value<String?> servingUnit = const Value.absent(),
                Value<double?> calories = const Value.absent(),
                Value<double?> carbsGrams = const Value.absent(),
                Value<double?> fatGrams = const Value.absent(),
                Value<double?> proteinGrams = const Value.absent(),
                Value<double?> fiberGrams = const Value.absent(),
                Value<double?> sugarGrams = const Value.absent(),
                required int syncCreatedAt,
                Value<int?> syncUpdatedAt = const Value.absent(),
                Value<int?> syncDeletedAt = const Value.absent(),
                Value<int?> syncLastSyncedAt = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> syncVersion = const Value.absent(),
                Value<String?> syncDeviceId = const Value.absent(),
                Value<bool> syncIsDirty = const Value.absent(),
                Value<String?> conflictData = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FoodItemsCompanion.insert(
                id: id,
                clientId: clientId,
                profileId: profileId,
                name: name,
                type: type,
                simpleItemIds: simpleItemIds,
                isUserCreated: isUserCreated,
                isArchived: isArchived,
                servingSize: servingSize,
                servingUnit: servingUnit,
                calories: calories,
                carbsGrams: carbsGrams,
                fatGrams: fatGrams,
                proteinGrams: proteinGrams,
                fiberGrams: fiberGrams,
                sugarGrams: sugarGrams,
                syncCreatedAt: syncCreatedAt,
                syncUpdatedAt: syncUpdatedAt,
                syncDeletedAt: syncDeletedAt,
                syncLastSyncedAt: syncLastSyncedAt,
                syncStatus: syncStatus,
                syncVersion: syncVersion,
                syncDeviceId: syncDeviceId,
                syncIsDirty: syncIsDirty,
                conflictData: conflictData,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FoodItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FoodItemsTable,
      FoodItemRow,
      $$FoodItemsTableFilterComposer,
      $$FoodItemsTableOrderingComposer,
      $$FoodItemsTableAnnotationComposer,
      $$FoodItemsTableCreateCompanionBuilder,
      $$FoodItemsTableUpdateCompanionBuilder,
      (
        FoodItemRow,
        BaseReferences<_$AppDatabase, $FoodItemsTable, FoodItemRow>,
      ),
      FoodItemRow,
      PrefetchHooks Function()
    >;
typedef $$FoodLogsTableCreateCompanionBuilder =
    FoodLogsCompanion Function({
      required String id,
      required String clientId,
      required String profileId,
      required int timestamp,
      required String foodItemIds,
      required String adHocItems,
      Value<String?> notes,
      required int syncCreatedAt,
      Value<int?> syncUpdatedAt,
      Value<int?> syncDeletedAt,
      Value<int?> syncLastSyncedAt,
      Value<int> syncStatus,
      Value<int> syncVersion,
      Value<String?> syncDeviceId,
      Value<bool> syncIsDirty,
      Value<String?> conflictData,
      Value<int> rowid,
    });
typedef $$FoodLogsTableUpdateCompanionBuilder =
    FoodLogsCompanion Function({
      Value<String> id,
      Value<String> clientId,
      Value<String> profileId,
      Value<int> timestamp,
      Value<String> foodItemIds,
      Value<String> adHocItems,
      Value<String?> notes,
      Value<int> syncCreatedAt,
      Value<int?> syncUpdatedAt,
      Value<int?> syncDeletedAt,
      Value<int?> syncLastSyncedAt,
      Value<int> syncStatus,
      Value<int> syncVersion,
      Value<String?> syncDeviceId,
      Value<bool> syncIsDirty,
      Value<String?> conflictData,
      Value<int> rowid,
    });

class $$FoodLogsTableFilterComposer
    extends Composer<_$AppDatabase, $FoodLogsTable> {
  $$FoodLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get foodItemIds => $composableBuilder(
    column: $table.foodItemIds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get adHocItems => $composableBuilder(
    column: $table.adHocItems,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncCreatedAt => $composableBuilder(
    column: $table.syncCreatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncDeletedAt => $composableBuilder(
    column: $table.syncDeletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncLastSyncedAt => $composableBuilder(
    column: $table.syncLastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncDeviceId => $composableBuilder(
    column: $table.syncDeviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get syncIsDirty => $composableBuilder(
    column: $table.syncIsDirty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conflictData => $composableBuilder(
    column: $table.conflictData,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FoodLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $FoodLogsTable> {
  $$FoodLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get foodItemIds => $composableBuilder(
    column: $table.foodItemIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get adHocItems => $composableBuilder(
    column: $table.adHocItems,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncCreatedAt => $composableBuilder(
    column: $table.syncCreatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncDeletedAt => $composableBuilder(
    column: $table.syncDeletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncLastSyncedAt => $composableBuilder(
    column: $table.syncLastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncDeviceId => $composableBuilder(
    column: $table.syncDeviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get syncIsDirty => $composableBuilder(
    column: $table.syncIsDirty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conflictData => $composableBuilder(
    column: $table.conflictData,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FoodLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FoodLogsTable> {
  $$FoodLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<int> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get foodItemIds => $composableBuilder(
    column: $table.foodItemIds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get adHocItems => $composableBuilder(
    column: $table.adHocItems,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get syncCreatedAt => $composableBuilder(
    column: $table.syncCreatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncUpdatedAt => $composableBuilder(
    column: $table.syncUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncDeletedAt => $composableBuilder(
    column: $table.syncDeletedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncLastSyncedAt => $composableBuilder(
    column: $table.syncLastSyncedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncDeviceId => $composableBuilder(
    column: $table.syncDeviceId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get syncIsDirty => $composableBuilder(
    column: $table.syncIsDirty,
    builder: (column) => column,
  );

  GeneratedColumn<String> get conflictData => $composableBuilder(
    column: $table.conflictData,
    builder: (column) => column,
  );
}

class $$FoodLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FoodLogsTable,
          FoodLogRow,
          $$FoodLogsTableFilterComposer,
          $$FoodLogsTableOrderingComposer,
          $$FoodLogsTableAnnotationComposer,
          $$FoodLogsTableCreateCompanionBuilder,
          $$FoodLogsTableUpdateCompanionBuilder,
          (
            FoodLogRow,
            BaseReferences<_$AppDatabase, $FoodLogsTable, FoodLogRow>,
          ),
          FoodLogRow,
          PrefetchHooks Function()
        > {
  $$FoodLogsTableTableManager(_$AppDatabase db, $FoodLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FoodLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FoodLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FoodLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> clientId = const Value.absent(),
                Value<String> profileId = const Value.absent(),
                Value<int> timestamp = const Value.absent(),
                Value<String> foodItemIds = const Value.absent(),
                Value<String> adHocItems = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> syncCreatedAt = const Value.absent(),
                Value<int?> syncUpdatedAt = const Value.absent(),
                Value<int?> syncDeletedAt = const Value.absent(),
                Value<int?> syncLastSyncedAt = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> syncVersion = const Value.absent(),
                Value<String?> syncDeviceId = const Value.absent(),
                Value<bool> syncIsDirty = const Value.absent(),
                Value<String?> conflictData = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FoodLogsCompanion(
                id: id,
                clientId: clientId,
                profileId: profileId,
                timestamp: timestamp,
                foodItemIds: foodItemIds,
                adHocItems: adHocItems,
                notes: notes,
                syncCreatedAt: syncCreatedAt,
                syncUpdatedAt: syncUpdatedAt,
                syncDeletedAt: syncDeletedAt,
                syncLastSyncedAt: syncLastSyncedAt,
                syncStatus: syncStatus,
                syncVersion: syncVersion,
                syncDeviceId: syncDeviceId,
                syncIsDirty: syncIsDirty,
                conflictData: conflictData,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String clientId,
                required String profileId,
                required int timestamp,
                required String foodItemIds,
                required String adHocItems,
                Value<String?> notes = const Value.absent(),
                required int syncCreatedAt,
                Value<int?> syncUpdatedAt = const Value.absent(),
                Value<int?> syncDeletedAt = const Value.absent(),
                Value<int?> syncLastSyncedAt = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> syncVersion = const Value.absent(),
                Value<String?> syncDeviceId = const Value.absent(),
                Value<bool> syncIsDirty = const Value.absent(),
                Value<String?> conflictData = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FoodLogsCompanion.insert(
                id: id,
                clientId: clientId,
                profileId: profileId,
                timestamp: timestamp,
                foodItemIds: foodItemIds,
                adHocItems: adHocItems,
                notes: notes,
                syncCreatedAt: syncCreatedAt,
                syncUpdatedAt: syncUpdatedAt,
                syncDeletedAt: syncDeletedAt,
                syncLastSyncedAt: syncLastSyncedAt,
                syncStatus: syncStatus,
                syncVersion: syncVersion,
                syncDeviceId: syncDeviceId,
                syncIsDirty: syncIsDirty,
                conflictData: conflictData,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FoodLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FoodLogsTable,
      FoodLogRow,
      $$FoodLogsTableFilterComposer,
      $$FoodLogsTableOrderingComposer,
      $$FoodLogsTableAnnotationComposer,
      $$FoodLogsTableCreateCompanionBuilder,
      $$FoodLogsTableUpdateCompanionBuilder,
      (FoodLogRow, BaseReferences<_$AppDatabase, $FoodLogsTable, FoodLogRow>),
      FoodLogRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SupplementsTableTableManager get supplements =>
      $$SupplementsTableTableManager(_db, _db.supplements);
  $$IntakeLogsTableTableManager get intakeLogs =>
      $$IntakeLogsTableTableManager(_db, _db.intakeLogs);
  $$ConditionsTableTableManager get conditions =>
      $$ConditionsTableTableManager(_db, _db.conditions);
  $$ConditionLogsTableTableManager get conditionLogs =>
      $$ConditionLogsTableTableManager(_db, _db.conditionLogs);
  $$FluidsEntriesTableTableManager get fluidsEntries =>
      $$FluidsEntriesTableTableManager(_db, _db.fluidsEntries);
  $$SleepEntriesTableTableManager get sleepEntries =>
      $$SleepEntriesTableTableManager(_db, _db.sleepEntries);
  $$ActivitiesTableTableManager get activities =>
      $$ActivitiesTableTableManager(_db, _db.activities);
  $$ActivityLogsTableTableManager get activityLogs =>
      $$ActivityLogsTableTableManager(_db, _db.activityLogs);
  $$FoodItemsTableTableManager get foodItems =>
      $$FoodItemsTableTableManager(_db, _db.foodItems);
  $$FoodLogsTableTableManager get foodLogs =>
      $$FoodLogsTableTableManager(_db, _db.foodLogs);
}
