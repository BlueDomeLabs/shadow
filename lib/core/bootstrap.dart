// lib/core/bootstrap.dart
// App initialization: creates database, repositories, and services.

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shadow_app/core/services/device_info_service.dart';
import 'package:shadow_app/core/services/encryption_service.dart';
import 'package:shadow_app/data/cloud/google_drive_provider.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/data/repositories/activity_log_repository_impl.dart';
import 'package:shadow_app/data/repositories/activity_repository_impl.dart';
import 'package:shadow_app/data/repositories/condition_log_repository_impl.dart';
import 'package:shadow_app/data/repositories/condition_repository_impl.dart';
import 'package:shadow_app/data/repositories/flare_up_repository_impl.dart';
import 'package:shadow_app/data/repositories/fluids_entry_repository_impl.dart';
import 'package:shadow_app/data/repositories/food_item_repository_impl.dart';
import 'package:shadow_app/data/repositories/food_log_repository_impl.dart';
import 'package:shadow_app/data/repositories/intake_log_repository_impl.dart';
import 'package:shadow_app/data/repositories/journal_entry_repository_impl.dart';
import 'package:shadow_app/data/repositories/photo_area_repository_impl.dart';
import 'package:shadow_app/data/repositories/photo_entry_repository_impl.dart';
import 'package:shadow_app/data/repositories/profile_repository_impl.dart';
import 'package:shadow_app/data/repositories/sleep_entry_repository_impl.dart';
import 'package:shadow_app/data/repositories/supplement_repository_impl.dart';
import 'package:shadow_app/data/services/sync_service_impl.dart';
import 'package:shadow_app/domain/entities/entities.dart';
import 'package:shadow_app/domain/services/local_profile_authorization_service.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

/// Initializes the app and returns provider overrides for [ProviderScope].
///
/// Creates the encrypted database, shared services, all 14 repository
/// implementations, encryption service, cloud provider, and sync service.
Future<List<Override>> bootstrap() async {
  // 1. Create database with encrypted connection
  final database = AppDatabase(DatabaseConnection.openConnection());

  // 2. Create shared services
  const uuid = Uuid();
  final deviceInfoService = DeviceInfoService(DeviceInfoPlugin());

  // 3. Create local auth service (allows all access for local profiles)
  final authService = LocalProfileAuthorizationService();

  // 4. Create all 14 repository implementations
  final supplementRepo = SupplementRepositoryImpl(
    database.supplementDao,
    uuid,
    deviceInfoService,
  );
  final intakeLogRepo = IntakeLogRepositoryImpl(
    database.intakeLogDao,
    uuid,
    deviceInfoService,
  );
  final conditionRepo = ConditionRepositoryImpl(
    database.conditionDao,
    uuid,
    deviceInfoService,
  );
  final conditionLogRepo = ConditionLogRepositoryImpl(
    database.conditionLogDao,
    uuid,
    deviceInfoService,
  );
  final flareUpRepo = FlareUpRepositoryImpl(
    database.flareUpDao,
    uuid,
    deviceInfoService,
  );
  final fluidsEntryRepo = FluidsEntryRepositoryImpl(
    database.fluidsEntryDao,
    uuid,
    deviceInfoService,
  );
  final sleepEntryRepo = SleepEntryRepositoryImpl(
    database.sleepEntryDao,
    uuid,
    deviceInfoService,
  );
  final activityRepo = ActivityRepositoryImpl(
    database.activityDao,
    uuid,
    deviceInfoService,
  );
  final activityLogRepo = ActivityLogRepositoryImpl(
    database.activityLogDao,
    uuid,
    deviceInfoService,
  );
  final foodItemRepo = FoodItemRepositoryImpl(
    database.foodItemDao,
    uuid,
    deviceInfoService,
  );
  final foodLogRepo = FoodLogRepositoryImpl(
    database.foodLogDao,
    uuid,
    deviceInfoService,
  );
  final journalEntryRepo = JournalEntryRepositoryImpl(
    database.journalEntryDao,
    uuid,
    deviceInfoService,
  );
  final photoAreaRepo = PhotoAreaRepositoryImpl(
    database.photoAreaDao,
    uuid,
    deviceInfoService,
  );
  final photoEntryRepo = PhotoEntryRepositoryImpl(
    database.photoEntryDao,
    uuid,
    deviceInfoService,
  );
  final profileRepo = ProfileRepositoryImpl(
    database.profileDao,
    uuid,
    deviceInfoService,
  );

  // 5. Create encryption service and initialize key
  final encryptionService = EncryptionService(
    const FlutterSecureStorage(
      mOptions: MacOsOptions(useDataProtectionKeyChain: false),
    ),
  );
  await encryptionService.initialize();

  // 6. Create cloud storage provider (shared instance for auth + sync)
  final googleDriveProvider = GoogleDriveProvider();

  // 7. Get SharedPreferences for sync timestamp/version storage
  final prefs = await SharedPreferences.getInstance();

  // 8. Build sync entity adapters for all 14 entity types
  final syncService = SyncServiceImpl(
    adapters: [
      SyncEntityAdapter<Supplement>(
        entityType: 'supplements',
        repository: supplementRepo,
        withSyncMetadata: (e, m) => e.copyWith(syncMetadata: m),
        fromJson: Supplement.fromJson,
      ),
      SyncEntityAdapter<IntakeLog>(
        entityType: 'intake_logs',
        repository: intakeLogRepo,
        withSyncMetadata: (e, m) => e.copyWith(syncMetadata: m),
        fromJson: IntakeLog.fromJson,
      ),
      SyncEntityAdapter<Condition>(
        entityType: 'conditions',
        repository: conditionRepo,
        withSyncMetadata: (e, m) => e.copyWith(syncMetadata: m),
        fromJson: Condition.fromJson,
      ),
      SyncEntityAdapter<ConditionLog>(
        entityType: 'condition_logs',
        repository: conditionLogRepo,
        withSyncMetadata: (e, m) => e.copyWith(syncMetadata: m),
        fromJson: ConditionLog.fromJson,
      ),
      SyncEntityAdapter<FlareUp>(
        entityType: 'flare_ups',
        repository: flareUpRepo,
        withSyncMetadata: (e, m) => e.copyWith(syncMetadata: m),
        fromJson: FlareUp.fromJson,
      ),
      SyncEntityAdapter<FluidsEntry>(
        entityType: 'fluids_entries',
        repository: fluidsEntryRepo,
        withSyncMetadata: (e, m) => e.copyWith(syncMetadata: m),
        fromJson: FluidsEntry.fromJson,
      ),
      SyncEntityAdapter<SleepEntry>(
        entityType: 'sleep_entries',
        repository: sleepEntryRepo,
        withSyncMetadata: (e, m) => e.copyWith(syncMetadata: m),
        fromJson: SleepEntry.fromJson,
      ),
      SyncEntityAdapter<Activity>(
        entityType: 'activities',
        repository: activityRepo,
        withSyncMetadata: (e, m) => e.copyWith(syncMetadata: m),
        fromJson: Activity.fromJson,
      ),
      SyncEntityAdapter<ActivityLog>(
        entityType: 'activity_logs',
        repository: activityLogRepo,
        withSyncMetadata: (e, m) => e.copyWith(syncMetadata: m),
        fromJson: ActivityLog.fromJson,
      ),
      SyncEntityAdapter<FoodItem>(
        entityType: 'food_items',
        repository: foodItemRepo,
        withSyncMetadata: (e, m) => e.copyWith(syncMetadata: m),
        fromJson: FoodItem.fromJson,
      ),
      SyncEntityAdapter<FoodLog>(
        entityType: 'food_logs',
        repository: foodLogRepo,
        withSyncMetadata: (e, m) => e.copyWith(syncMetadata: m),
        fromJson: FoodLog.fromJson,
      ),
      SyncEntityAdapter<JournalEntry>(
        entityType: 'journal_entries',
        repository: journalEntryRepo,
        withSyncMetadata: (e, m) => e.copyWith(syncMetadata: m),
        fromJson: JournalEntry.fromJson,
      ),
      SyncEntityAdapter<PhotoArea>(
        entityType: 'photo_areas',
        repository: photoAreaRepo,
        withSyncMetadata: (e, m) => e.copyWith(syncMetadata: m),
        fromJson: PhotoArea.fromJson,
      ),
      SyncEntityAdapter<PhotoEntry>(
        entityType: 'photo_entries',
        repository: photoEntryRepo,
        withSyncMetadata: (e, m) => e.copyWith(syncMetadata: m),
        fromJson: PhotoEntry.fromJson,
      ),
      SyncEntityAdapter<Profile>(
        entityType: 'profiles',
        repository: profileRepo,
        withSyncMetadata: (e, m) => e.copyWith(syncMetadata: m),
        fromJson: Profile.fromJson,
      ),
    ],
    encryptionService: encryptionService,
    cloudProvider: googleDriveProvider,
    prefs: prefs,
    conflictDao: database.syncConflictDao,
  );

  // 9. Return provider overrides for all repos + services
  return [
    // Repositories
    supplementRepositoryProvider.overrideWithValue(supplementRepo),
    intakeLogRepositoryProvider.overrideWithValue(intakeLogRepo),
    conditionRepositoryProvider.overrideWithValue(conditionRepo),
    conditionLogRepositoryProvider.overrideWithValue(conditionLogRepo),
    flareUpRepositoryProvider.overrideWithValue(flareUpRepo),
    fluidsEntryRepositoryProvider.overrideWithValue(fluidsEntryRepo),
    sleepEntryRepositoryProvider.overrideWithValue(sleepEntryRepo),
    activityRepositoryProvider.overrideWithValue(activityRepo),
    activityLogRepositoryProvider.overrideWithValue(activityLogRepo),
    foodItemRepositoryProvider.overrideWithValue(foodItemRepo),
    foodLogRepositoryProvider.overrideWithValue(foodLogRepo),
    journalEntryRepositoryProvider.overrideWithValue(journalEntryRepo),
    photoAreaRepositoryProvider.overrideWithValue(photoAreaRepo),
    photoEntryRepositoryProvider.overrideWithValue(photoEntryRepo),
    profileRepositoryProvider.overrideWithValue(profileRepo),
    // Services
    profileAuthorizationServiceProvider.overrideWithValue(authService),
    encryptionServiceProvider.overrideWithValue(encryptionService),
    googleDriveProviderProvider.overrideWithValue(googleDriveProvider),
    syncServiceProvider.overrideWithValue(syncService),
  ];
}
