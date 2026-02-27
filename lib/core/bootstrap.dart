// lib/core/bootstrap.dart
// App initialization: creates database, repositories, and services.

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:health/health.dart' as hp;
import 'package:http/http.dart' as http;
import 'package:shadow_app/core/services/anthropic_api_client.dart';
import 'package:shadow_app/core/services/deep_link_service.dart';
import 'package:shadow_app/core/services/device_info_service.dart';
import 'package:shadow_app/core/services/encryption_service.dart';
import 'package:shadow_app/core/services/notification_permission_service.dart';
import 'package:shadow_app/core/services/notification_tap_handler.dart';
import 'package:shadow_app/core/services/security_settings_service.dart';
import 'package:shadow_app/data/cloud/google_drive_provider.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/data/notifications/notification_scheduler_impl.dart';
import 'package:shadow_app/data/repositories/activity_log_repository_impl.dart';
import 'package:shadow_app/data/repositories/activity_repository_impl.dart';
import 'package:shadow_app/data/repositories/anchor_event_time_repository_impl.dart';
import 'package:shadow_app/data/repositories/condition_log_repository_impl.dart';
import 'package:shadow_app/data/repositories/condition_repository_impl.dart';
import 'package:shadow_app/data/repositories/diet_repository_impl.dart';
import 'package:shadow_app/data/repositories/diet_violation_repository_impl.dart';
import 'package:shadow_app/data/repositories/fasting_repository_impl.dart';
import 'package:shadow_app/data/repositories/flare_up_repository_impl.dart';
import 'package:shadow_app/data/repositories/fluids_entry_repository_impl.dart';
import 'package:shadow_app/data/repositories/food_item_repository_impl.dart';
import 'package:shadow_app/data/repositories/food_log_repository_impl.dart';
import 'package:shadow_app/data/repositories/guest_invite_repository_impl.dart';
import 'package:shadow_app/data/repositories/health_sync_settings_repository_impl.dart';
import 'package:shadow_app/data/repositories/health_sync_status_repository_impl.dart';
import 'package:shadow_app/data/repositories/imported_vital_repository_impl.dart';
import 'package:shadow_app/data/repositories/intake_log_repository_impl.dart';
import 'package:shadow_app/data/repositories/journal_entry_repository_impl.dart';
import 'package:shadow_app/data/repositories/notification_category_settings_repository_impl.dart';
import 'package:shadow_app/data/repositories/photo_area_repository_impl.dart';
import 'package:shadow_app/data/repositories/photo_entry_repository_impl.dart';
import 'package:shadow_app/data/repositories/profile_repository_impl.dart';
import 'package:shadow_app/data/repositories/sleep_entry_repository_impl.dart';
import 'package:shadow_app/data/repositories/supplement_label_photo_repository_impl.dart';
import 'package:shadow_app/data/repositories/supplement_repository_impl.dart';
import 'package:shadow_app/data/repositories/user_settings_repository_impl.dart';
import 'package:shadow_app/data/services/diet_compliance_service_impl.dart';
import 'package:shadow_app/data/services/food_barcode_service_impl.dart';
import 'package:shadow_app/data/services/health_platform_service_impl.dart';
import 'package:shadow_app/data/services/report_query_service_impl.dart';
import 'package:shadow_app/data/services/supplement_barcode_service_impl.dart';
import 'package:shadow_app/data/services/sync_service_impl.dart';
import 'package:shadow_app/domain/entities/entities.dart';
import 'package:shadow_app/domain/services/guest_sync_validator.dart';
import 'package:shadow_app/domain/services/guest_token_service.dart';
import 'package:shadow_app/domain/services/local_profile_authorization_service.dart';
import 'package:shadow_app/domain/services/notification_seed_service.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:uuid/uuid.dart';

/// Initializes the app and returns provider overrides for [ProviderScope].
///
/// Creates the encrypted database, shared services, all 14 repository
/// implementations, encryption service, cloud provider, sync service, and
/// platform notification scheduler.
Future<List<Override>> bootstrap() async {
  // 1. Initialize timezone data (required for zonedSchedule)
  tz_data.initializeTimeZones();

  // 2. Create database with encrypted connection
  final database = AppDatabase(DatabaseConnection.openConnection());

  // 3. Create shared services
  const uuid = Uuid();
  final deviceInfoService = DeviceInfoService(DeviceInfoPlugin());

  // 4. Create local auth service (allows all access for local profiles)
  final authService = LocalProfileAuthorizationService();

  // 5. Create all 14 repository implementations
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
    database.foodItemComponentDao,
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
  final guestInviteRepo = GuestInviteRepositoryImpl(database.guestInviteDao);
  final anchorEventTimeRepo = AnchorEventTimeRepositoryImpl(
    database.anchorEventTimeDao,
  );
  final notificationSettingsRepo = NotificationCategorySettingsRepositoryImpl(
    database.notificationCategorySettingsDao,
  );
  final userSettingsRepo = UserSettingsRepositoryImpl(database.userSettingsDao);

  // 5b. Create Phase 15a services and repositories
  final httpClient = http.Client();
  const secureStorage = FlutterSecureStorage(
    mOptions: MacOsOptions(useDataProtectionKeyChain: false),
  );
  final foodBarcodeService = FoodBarcodeServiceImpl(
    database.foodBarcodeCacheDao,
    httpClient,
  );
  final supplementBarcodeService = SupplementBarcodeServiceImpl(
    database.supplementBarcodeCacheDao,
    httpClient,
  );
  final anthropicClient = AnthropicApiClientImpl(secureStorage, httpClient);
  final supplementLabelPhotoRepo = SupplementLabelPhotoRepositoryImpl(
    database.supplementLabelPhotoDao,
  );

  // 5c. Create Phase 16a health platform repositories (local-only, no uuid/device)
  final importedVitalRepo = ImportedVitalRepositoryImpl(
    database.importedVitalDao,
  );
  final healthSyncSettingsRepo = HealthSyncSettingsRepositoryImpl(
    database.healthSyncSettingsDao,
  );
  final healthSyncStatusRepo = HealthSyncStatusRepositoryImpl(
    database.healthSyncStatusDao,
  );

  // 5c-ii. Create Phase 16c HealthPlatformServiceImpl
  final healthPlatformService = HealthPlatformServiceImpl(hp.Health());

  // 5e. Create Phase 24 ReportQueryService
  final reportQueryService = ReportQueryServiceImpl(
    foodLogRepo: foodLogRepo,
    intakeLogRepo: intakeLogRepo,
    fluidsEntryRepo: fluidsEntryRepo,
    sleepEntryRepo: sleepEntryRepo,
    conditionLogRepo: conditionLogRepo,
    flareUpRepo: flareUpRepo,
    journalEntryRepo: journalEntryRepo,
    photoEntryRepo: photoEntryRepo,
    foodItemRepo: foodItemRepo,
    supplementRepo: supplementRepo,
    conditionRepo: conditionRepo,
  );

  // 5d. Create Phase 15b diet tracking repositories and services
  final dietRepo = DietRepositoryImpl(
    database.dietDao,
    database.dietRuleDao,
    database.dietExceptionDao,
    uuid,
    deviceInfoService,
  );
  final fastingRepo = FastingRepositoryImpl(
    database.fastingSessionDao,
    uuid,
    deviceInfoService,
  );
  final dietViolationRepo = DietViolationRepositoryImpl(
    database.dietViolationDao,
    uuid,
    deviceInfoService,
  );
  const dietComplianceService = DietComplianceServiceImpl();

  // 6. Create encryption service and initialize key
  final encryptionService = EncryptionService(
    const FlutterSecureStorage(
      mOptions: MacOsOptions(useDataProtectionKeyChain: false),
    ),
  );
  await encryptionService.initialize();

  // 7. Create cloud storage provider (shared instance for auth + sync)
  final googleDriveProvider = GoogleDriveProvider();

  // 8. Get SharedPreferences for sync timestamp/version storage
  final prefs = await SharedPreferences.getInstance();

  // 9. Build sync entity adapters for all 14 entity types
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
      // Phase 16b: ImportedVital sync adapter added when SyncFromHealthPlatformUseCase
      // is implemented with health plugin integration.
    ],
    encryptionService: encryptionService,
    cloudProvider: googleDriveProvider,
    prefs: prefs,
    conflictDao: database.syncConflictDao,
  );

  // 10. Seed notification defaults (safe to call every run — skips existing rows)
  final seedService = NotificationSeedService(
    anchorRepository: anchorEventTimeRepo,
    settingsRepository: notificationSettingsRepo,
  );
  await seedService.seedDefaults();

  // 11. Create security service
  final securityService = SecuritySettingsService();

  // 13. Create guest access services
  final deepLinkService = DeepLinkService();
  final guestTokenService = GuestTokenService(guestInviteRepo);
  final guestSyncValidator = GuestSyncValidator(guestTokenService);

  // 14. Initialize platform notification plugin, tap handler, and scheduler
  final tapHandler = NotificationTapHandler();
  final plugin = FlutterLocalNotificationsPlugin();
  await plugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
      macOS: DarwinInitializationSettings(),
    ),
    onDidReceiveNotificationResponse: tapHandler.handleTap,
  );
  await NotificationSchedulerImpl.createAndroidChannels(plugin);
  final scheduler = NotificationSchedulerImpl(plugin);
  final permissionService = NotificationPermissionService(plugin);

  // 15. Return provider overrides for all repos + services
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
    guestInviteRepositoryProvider.overrideWithValue(guestInviteRepo),
    anchorEventTimeRepositoryProvider.overrideWithValue(anchorEventTimeRepo),
    notificationCategorySettingsRepositoryProvider.overrideWithValue(
      notificationSettingsRepo,
    ),
    userSettingsRepositoryProvider.overrideWithValue(userSettingsRepo),
    // Services
    profileAuthorizationServiceProvider.overrideWithValue(authService),
    encryptionServiceProvider.overrideWithValue(encryptionService),
    googleDriveProviderProvider.overrideWithValue(googleDriveProvider),
    syncServiceProvider.overrideWithValue(syncService),
    securityServiceProvider.overrideWithValue(securityService),
    // Guest access services
    deepLinkServiceProvider.overrideWithValue(deepLinkService),
    guestTokenServiceProvider.overrideWithValue(guestTokenService),
    guestSyncValidatorProvider.overrideWithValue(guestSyncValidator),
    // Notification services
    notificationSchedulerProvider.overrideWithValue(scheduler),
    notificationTapHandlerProvider.overrideWithValue(tapHandler),
    notificationPermissionServiceProvider.overrideWithValue(permissionService),
    // Phase 15a services + repositories
    foodBarcodeServiceProvider.overrideWithValue(foodBarcodeService),
    supplementBarcodeServiceProvider.overrideWithValue(
      supplementBarcodeService,
    ),
    anthropicApiClientProvider.overrideWithValue(anthropicClient),
    supplementLabelPhotoRepositoryProvider.overrideWithValue(
      supplementLabelPhotoRepo,
    ),
    // Phase 15b diet tracking repositories + service
    dietRepositoryProvider.overrideWithValue(dietRepo),
    fastingRepositoryProvider.overrideWithValue(fastingRepo),
    dietViolationRepositoryProvider.overrideWithValue(dietViolationRepo),
    dietComplianceServiceProvider.overrideWithValue(dietComplianceService),
    // Phase 16a health platform repositories
    importedVitalRepositoryProvider.overrideWithValue(importedVitalRepo),
    healthSyncSettingsRepositoryProvider.overrideWithValue(
      healthSyncSettingsRepo,
    ),
    healthSyncStatusRepositoryProvider.overrideWithValue(healthSyncStatusRepo),
    // Phase 16c health platform service
    healthPlatformServiceProvider.overrideWithValue(healthPlatformService),
    // Phase 24 report query service
    reportQueryServiceProvider.overrideWithValue(reportQueryService),
  ];
}
