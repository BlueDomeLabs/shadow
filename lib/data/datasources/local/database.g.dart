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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SupplementsTable supplements = $SupplementsTable(this);
  late final $IntakeLogsTable intakeLogs = $IntakeLogsTable(this);
  late final $ConditionsTable conditions = $ConditionsTable(this);
  late final $ConditionLogsTable conditionLogs = $ConditionLogsTable(this);
  late final SupplementDao supplementDao = SupplementDao(this as AppDatabase);
  late final IntakeLogDao intakeLogDao = IntakeLogDao(this as AppDatabase);
  late final ConditionDao conditionDao = ConditionDao(this as AppDatabase);
  late final ConditionLogDao conditionLogDao = ConditionLogDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    supplements,
    intakeLogs,
    conditions,
    conditionLogs,
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
}
