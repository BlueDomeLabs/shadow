// lib/core/bootstrap.dart
// App initialization: creates database, repositories, and services.

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/core/services/device_info_service.dart';
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
import 'package:shadow_app/data/repositories/sleep_entry_repository_impl.dart';
import 'package:shadow_app/data/repositories/supplement_repository_impl.dart';
import 'package:shadow_app/domain/services/local_profile_authorization_service.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';
import 'package:uuid/uuid.dart';

/// Initializes the app and returns provider overrides for [ProviderScope].
///
/// Creates the encrypted database, shared services, and all 14 repository
/// implementations plus the local authorization service.
Future<List<Override>> bootstrap() async {
  // 1. Create database with encrypted connection
  final database = AppDatabase(DatabaseConnection.openConnection());

  // 2. Create shared services
  const uuid = Uuid();
  final deviceInfoService = DeviceInfoService(DeviceInfoPlugin());

  // 3. Create local auth service (allows all access for local profiles)
  final authService = LocalProfileAuthorizationService();

  // 4. Return provider overrides for all 14 repos + auth service
  return [
    supplementRepositoryProvider.overrideWithValue(
      SupplementRepositoryImpl(database.supplementDao, uuid, deviceInfoService),
    ),
    intakeLogRepositoryProvider.overrideWithValue(
      IntakeLogRepositoryImpl(database.intakeLogDao, uuid, deviceInfoService),
    ),
    conditionRepositoryProvider.overrideWithValue(
      ConditionRepositoryImpl(database.conditionDao, uuid, deviceInfoService),
    ),
    conditionLogRepositoryProvider.overrideWithValue(
      ConditionLogRepositoryImpl(
        database.conditionLogDao,
        uuid,
        deviceInfoService,
      ),
    ),
    flareUpRepositoryProvider.overrideWithValue(
      FlareUpRepositoryImpl(database.flareUpDao, uuid, deviceInfoService),
    ),
    fluidsEntryRepositoryProvider.overrideWithValue(
      FluidsEntryRepositoryImpl(
        database.fluidsEntryDao,
        uuid,
        deviceInfoService,
      ),
    ),
    sleepEntryRepositoryProvider.overrideWithValue(
      SleepEntryRepositoryImpl(database.sleepEntryDao, uuid, deviceInfoService),
    ),
    activityRepositoryProvider.overrideWithValue(
      ActivityRepositoryImpl(database.activityDao, uuid, deviceInfoService),
    ),
    activityLogRepositoryProvider.overrideWithValue(
      ActivityLogRepositoryImpl(
        database.activityLogDao,
        uuid,
        deviceInfoService,
      ),
    ),
    foodItemRepositoryProvider.overrideWithValue(
      FoodItemRepositoryImpl(database.foodItemDao, uuid, deviceInfoService),
    ),
    foodLogRepositoryProvider.overrideWithValue(
      FoodLogRepositoryImpl(database.foodLogDao, uuid, deviceInfoService),
    ),
    journalEntryRepositoryProvider.overrideWithValue(
      JournalEntryRepositoryImpl(
        database.journalEntryDao,
        uuid,
        deviceInfoService,
      ),
    ),
    photoAreaRepositoryProvider.overrideWithValue(
      PhotoAreaRepositoryImpl(database.photoAreaDao, uuid, deviceInfoService),
    ),
    photoEntryRepositoryProvider.overrideWithValue(
      PhotoEntryRepositoryImpl(database.photoEntryDao, uuid, deviceInfoService),
    ),
    profileAuthorizationServiceProvider.overrideWithValue(authService),
  ];
}
