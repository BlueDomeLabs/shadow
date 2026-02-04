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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SupplementsTable supplements = $SupplementsTable(this);
  late final SupplementDao supplementDao = SupplementDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [supplements];
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

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SupplementsTableTableManager get supplements =>
      $$SupplementsTableTableManager(_db, _db.supplements);
}
