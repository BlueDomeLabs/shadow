// lib/presentation/providers/di/di_providers.dart
// Dependency Injection providers for UseCases and Repositories
// Implements 02_CODING_STANDARDS.md Section 6

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
// Services
import 'package:shadow_app/core/services/encryption_service.dart';
// Cloud
import 'package:shadow_app/data/cloud/google_drive_provider.dart';
// Repositories
import 'package:shadow_app/domain/repositories/repositories.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/services/sync_service.dart';
// Use Cases - Activities
import 'package:shadow_app/domain/usecases/activities/activities_usecases.dart';
// Use Cases - Activity Logs
import 'package:shadow_app/domain/usecases/activity_logs/activity_logs_usecases.dart';
// Use Cases - Condition Logs
import 'package:shadow_app/domain/usecases/condition_logs/condition_logs_usecases.dart';
// Use Cases - Conditions
import 'package:shadow_app/domain/usecases/conditions/conditions_usecases.dart';
// Use Cases - Flare Ups
import 'package:shadow_app/domain/usecases/flare_ups/flare_ups_usecases.dart';
// Use Cases - Fluids Entries
import 'package:shadow_app/domain/usecases/fluids_entries/fluids_entries_usecases.dart';
// Use Cases - Food Items
import 'package:shadow_app/domain/usecases/food_items/food_items_usecases.dart';
// Use Cases - Food Logs
import 'package:shadow_app/domain/usecases/food_logs/food_logs_usecases.dart';
// Use Cases - Guest Invites
import 'package:shadow_app/domain/usecases/guest_invites/create_guest_invite_use_case.dart';
import 'package:shadow_app/domain/usecases/guest_invites/list_guest_invites_use_case.dart';
import 'package:shadow_app/domain/usecases/guest_invites/remove_guest_device_use_case.dart';
import 'package:shadow_app/domain/usecases/guest_invites/revoke_guest_invite_use_case.dart';
import 'package:shadow_app/domain/usecases/guest_invites/validate_guest_token_use_case.dart';
// Use Cases - Intake Logs
import 'package:shadow_app/domain/usecases/intake_logs/intake_logs_usecases.dart';
// Use Cases - Journal Entries
import 'package:shadow_app/domain/usecases/journal_entries/journal_entries_usecases.dart';
// Use Cases - Photo Areas
import 'package:shadow_app/domain/usecases/photo_areas/photo_areas_usecases.dart';
// Use Cases - Photo Entries
import 'package:shadow_app/domain/usecases/photo_entries/photo_entries_usecases.dart';
// Use Cases - Sleep Entries
import 'package:shadow_app/domain/usecases/sleep_entries/sleep_entries_usecases.dart';
// Use Cases - Supplements
import 'package:shadow_app/domain/usecases/supplements/supplements_usecases.dart';

part 'di_providers.g.dart';

// =============================================================================
// REPOSITORIES (keepAlive for singleton behavior)
// =============================================================================

/// Supplement repository provider - override in ProviderScope with implementation.
@Riverpod(keepAlive: true)
SupplementRepository supplementRepository(Ref ref) {
  throw UnimplementedError(
    'Override supplementRepositoryProvider in ProviderScope',
  );
}

/// Intake log repository provider - override in ProviderScope with implementation.
@Riverpod(keepAlive: true)
IntakeLogRepository intakeLogRepository(Ref ref) {
  throw UnimplementedError(
    'Override intakeLogRepositoryProvider in ProviderScope',
  );
}

/// Condition repository provider - override in ProviderScope with implementation.
@Riverpod(keepAlive: true)
ConditionRepository conditionRepository(Ref ref) {
  throw UnimplementedError(
    'Override conditionRepositoryProvider in ProviderScope',
  );
}

/// Condition log repository provider - override in ProviderScope with implementation.
@Riverpod(keepAlive: true)
ConditionLogRepository conditionLogRepository(Ref ref) {
  throw UnimplementedError(
    'Override conditionLogRepositoryProvider in ProviderScope',
  );
}

/// Flare up repository provider - override in ProviderScope with implementation.
@Riverpod(keepAlive: true)
FlareUpRepository flareUpRepository(Ref ref) {
  throw UnimplementedError(
    'Override flareUpRepositoryProvider in ProviderScope',
  );
}

/// Fluids entry repository provider - override in ProviderScope with implementation.
@Riverpod(keepAlive: true)
FluidsEntryRepository fluidsEntryRepository(Ref ref) {
  throw UnimplementedError(
    'Override fluidsEntryRepositoryProvider in ProviderScope',
  );
}

/// Sleep entry repository provider - override in ProviderScope with implementation.
@Riverpod(keepAlive: true)
SleepEntryRepository sleepEntryRepository(Ref ref) {
  throw UnimplementedError(
    'Override sleepEntryRepositoryProvider in ProviderScope',
  );
}

/// Activity repository provider - override in ProviderScope with implementation.
@Riverpod(keepAlive: true)
ActivityRepository activityRepository(Ref ref) {
  throw UnimplementedError(
    'Override activityRepositoryProvider in ProviderScope',
  );
}

/// Activity log repository provider - override in ProviderScope with implementation.
@Riverpod(keepAlive: true)
ActivityLogRepository activityLogRepository(Ref ref) {
  throw UnimplementedError(
    'Override activityLogRepositoryProvider in ProviderScope',
  );
}

/// Food item repository provider - override in ProviderScope with implementation.
@Riverpod(keepAlive: true)
FoodItemRepository foodItemRepository(Ref ref) {
  throw UnimplementedError(
    'Override foodItemRepositoryProvider in ProviderScope',
  );
}

/// Food log repository provider - override in ProviderScope with implementation.
@Riverpod(keepAlive: true)
FoodLogRepository foodLogRepository(Ref ref) {
  throw UnimplementedError(
    'Override foodLogRepositoryProvider in ProviderScope',
  );
}

/// Journal entry repository provider - override in ProviderScope with implementation.
@Riverpod(keepAlive: true)
JournalEntryRepository journalEntryRepository(Ref ref) {
  throw UnimplementedError(
    'Override journalEntryRepositoryProvider in ProviderScope',
  );
}

/// Photo area repository provider - override in ProviderScope with implementation.
@Riverpod(keepAlive: true)
PhotoAreaRepository photoAreaRepository(Ref ref) {
  throw UnimplementedError(
    'Override photoAreaRepositoryProvider in ProviderScope',
  );
}

/// Photo entry repository provider - override in ProviderScope with implementation.
@Riverpod(keepAlive: true)
PhotoEntryRepository photoEntryRepository(Ref ref) {
  throw UnimplementedError(
    'Override photoEntryRepositoryProvider in ProviderScope',
  );
}

/// Profile repository provider - override in ProviderScope with implementation.
@Riverpod(keepAlive: true)
ProfileRepository profileRepository(Ref ref) {
  throw UnimplementedError(
    'Override profileRepositoryProvider in ProviderScope',
  );
}

/// Guest invite repository provider - override in ProviderScope with implementation.
@Riverpod(keepAlive: true)
GuestInviteRepository guestInviteRepository(Ref ref) {
  throw UnimplementedError(
    'Override guestInviteRepositoryProvider in ProviderScope',
  );
}

// =============================================================================
// SERVICES
// =============================================================================

/// Profile authorization service provider - override in ProviderScope with implementation.
@Riverpod(keepAlive: true)
ProfileAuthorizationService profileAuthorizationService(Ref ref) {
  throw UnimplementedError(
    'Override profileAuthorizationServiceProvider in ProviderScope',
  );
}

/// Encryption service provider - override in ProviderScope with implementation.
@Riverpod(keepAlive: true)
EncryptionService encryptionService(Ref ref) {
  throw UnimplementedError(
    'Override encryptionServiceProvider in ProviderScope',
  );
}

/// Google Drive provider - override in ProviderScope with implementation.
@Riverpod(keepAlive: true)
GoogleDriveProvider googleDriveProvider(Ref ref) {
  throw UnimplementedError(
    'Override googleDriveProviderProvider in ProviderScope',
  );
}

/// Sync service provider - override in ProviderScope with implementation.
@Riverpod(keepAlive: true)
SyncService syncService(Ref ref) {
  throw UnimplementedError('Override syncServiceProvider in ProviderScope');
}

// =============================================================================
// USE CASES - SUPPLEMENTS (4)
// =============================================================================

/// GetSupplementsUseCase provider.
@riverpod
GetSupplementsUseCase getSupplementsUseCase(Ref ref) => GetSupplementsUseCase(
  ref.read(supplementRepositoryProvider),
  ref.read(profileAuthorizationServiceProvider),
);

/// CreateSupplementUseCase provider.
@riverpod
CreateSupplementUseCase createSupplementUseCase(Ref ref) =>
    CreateSupplementUseCase(
      ref.read(supplementRepositoryProvider),
      ref.read(profileAuthorizationServiceProvider),
    );

/// UpdateSupplementUseCase provider.
@riverpod
UpdateSupplementUseCase updateSupplementUseCase(Ref ref) =>
    UpdateSupplementUseCase(
      ref.read(supplementRepositoryProvider),
      ref.read(profileAuthorizationServiceProvider),
    );

/// ArchiveSupplementUseCase provider.
@riverpod
ArchiveSupplementUseCase archiveSupplementUseCase(Ref ref) =>
    ArchiveSupplementUseCase(
      ref.read(supplementRepositoryProvider),
      ref.read(profileAuthorizationServiceProvider),
    );

// =============================================================================
// USE CASES - INTAKE LOGS (4)
// =============================================================================

/// GetIntakeLogsUseCase provider.
@riverpod
GetIntakeLogsUseCase getIntakeLogsUseCase(Ref ref) => GetIntakeLogsUseCase(
  ref.read(intakeLogRepositoryProvider),
  ref.read(profileAuthorizationServiceProvider),
);

/// MarkTakenUseCase provider.
@riverpod
MarkTakenUseCase markTakenUseCase(Ref ref) => MarkTakenUseCase(
  ref.read(intakeLogRepositoryProvider),
  ref.read(profileAuthorizationServiceProvider),
);

/// MarkSkippedUseCase provider.
@riverpod
MarkSkippedUseCase markSkippedUseCase(Ref ref) => MarkSkippedUseCase(
  ref.read(intakeLogRepositoryProvider),
  ref.read(profileAuthorizationServiceProvider),
);

/// MarkSnoozedUseCase provider.
@riverpod
MarkSnoozedUseCase markSnoozedUseCase(Ref ref) => MarkSnoozedUseCase(
  ref.read(intakeLogRepositoryProvider),
  ref.read(profileAuthorizationServiceProvider),
);

// =============================================================================
// USE CASES - CONDITIONS (3)
// =============================================================================

/// GetConditionsUseCase provider.
@riverpod
GetConditionsUseCase getConditionsUseCase(Ref ref) => GetConditionsUseCase(
  ref.read(conditionRepositoryProvider),
  ref.read(profileAuthorizationServiceProvider),
);

/// CreateConditionUseCase provider.
@riverpod
CreateConditionUseCase createConditionUseCase(Ref ref) =>
    CreateConditionUseCase(
      ref.read(conditionRepositoryProvider),
      ref.read(profileAuthorizationServiceProvider),
    );

/// ArchiveConditionUseCase provider.
@riverpod
ArchiveConditionUseCase archiveConditionUseCase(Ref ref) =>
    ArchiveConditionUseCase(
      ref.read(conditionRepositoryProvider),
      ref.read(profileAuthorizationServiceProvider),
    );

// =============================================================================
// USE CASES - CONDITION LOGS (2)
// =============================================================================

/// GetConditionLogsUseCase provider.
@riverpod
GetConditionLogsUseCase getConditionLogsUseCase(Ref ref) =>
    GetConditionLogsUseCase(
      ref.read(conditionLogRepositoryProvider),
      ref.read(profileAuthorizationServiceProvider),
    );

/// LogConditionUseCase provider.
@riverpod
LogConditionUseCase logConditionUseCase(Ref ref) => LogConditionUseCase(
  ref.read(conditionLogRepositoryProvider),
  ref.read(conditionRepositoryProvider),
  ref.read(profileAuthorizationServiceProvider),
);

// =============================================================================
// USE CASES - FLARE UPS (5)
// =============================================================================

/// GetFlareUpsUseCase provider.
@riverpod
GetFlareUpsUseCase getFlareUpsUseCase(Ref ref) => GetFlareUpsUseCase(
  ref.read(flareUpRepositoryProvider),
  ref.read(profileAuthorizationServiceProvider),
);

/// LogFlareUpUseCase provider.
@riverpod
LogFlareUpUseCase logFlareUpUseCase(Ref ref) => LogFlareUpUseCase(
  ref.read(flareUpRepositoryProvider),
  ref.read(conditionRepositoryProvider),
  ref.read(profileAuthorizationServiceProvider),
);

/// UpdateFlareUpUseCase provider.
@riverpod
UpdateFlareUpUseCase updateFlareUpUseCase(Ref ref) => UpdateFlareUpUseCase(
  ref.read(flareUpRepositoryProvider),
  ref.read(profileAuthorizationServiceProvider),
);

/// EndFlareUpUseCase provider.
@riverpod
EndFlareUpUseCase endFlareUpUseCase(Ref ref) => EndFlareUpUseCase(
  ref.read(flareUpRepositoryProvider),
  ref.read(profileAuthorizationServiceProvider),
);

/// DeleteFlareUpUseCase provider.
@riverpod
DeleteFlareUpUseCase deleteFlareUpUseCase(Ref ref) => DeleteFlareUpUseCase(
  ref.read(flareUpRepositoryProvider),
  ref.read(profileAuthorizationServiceProvider),
);

// =============================================================================
// USE CASES - FLUIDS ENTRIES (4)
// =============================================================================

/// GetFluidsEntriesUseCase provider.
@riverpod
GetFluidsEntriesUseCase getFluidsEntriesUseCase(Ref ref) =>
    GetFluidsEntriesUseCase(
      ref.read(fluidsEntryRepositoryProvider),
      ref.read(profileAuthorizationServiceProvider),
    );

/// LogFluidsEntryUseCase provider.
@riverpod
LogFluidsEntryUseCase logFluidsEntryUseCase(Ref ref) => LogFluidsEntryUseCase(
  ref.read(fluidsEntryRepositoryProvider),
  ref.read(profileAuthorizationServiceProvider),
);

/// UpdateFluidsEntryUseCase provider.
@riverpod
UpdateFluidsEntryUseCase updateFluidsEntryUseCase(Ref ref) =>
    UpdateFluidsEntryUseCase(
      ref.read(fluidsEntryRepositoryProvider),
      ref.read(profileAuthorizationServiceProvider),
    );

/// DeleteFluidsEntryUseCase provider.
@riverpod
DeleteFluidsEntryUseCase deleteFluidsEntryUseCase(Ref ref) =>
    DeleteFluidsEntryUseCase(
      ref.read(fluidsEntryRepositoryProvider),
      ref.read(profileAuthorizationServiceProvider),
    );

// =============================================================================
// USE CASES - SLEEP ENTRIES (4)
// =============================================================================

/// GetSleepEntriesUseCase provider.
@riverpod
GetSleepEntriesUseCase getSleepEntriesUseCase(Ref ref) =>
    GetSleepEntriesUseCase(
      ref.read(sleepEntryRepositoryProvider),
      ref.read(profileAuthorizationServiceProvider),
    );

/// LogSleepEntryUseCase provider.
@riverpod
LogSleepEntryUseCase logSleepEntryUseCase(Ref ref) => LogSleepEntryUseCase(
  ref.read(sleepEntryRepositoryProvider),
  ref.read(profileAuthorizationServiceProvider),
);

/// UpdateSleepEntryUseCase provider.
@riverpod
UpdateSleepEntryUseCase updateSleepEntryUseCase(Ref ref) =>
    UpdateSleepEntryUseCase(
      ref.read(sleepEntryRepositoryProvider),
      ref.read(profileAuthorizationServiceProvider),
    );

/// DeleteSleepEntryUseCase provider.
@riverpod
DeleteSleepEntryUseCase deleteSleepEntryUseCase(Ref ref) =>
    DeleteSleepEntryUseCase(
      ref.read(sleepEntryRepositoryProvider),
      ref.read(profileAuthorizationServiceProvider),
    );

// =============================================================================
// USE CASES - ACTIVITIES (4)
// =============================================================================

/// GetActivitiesUseCase provider.
@riverpod
GetActivitiesUseCase getActivitiesUseCase(Ref ref) => GetActivitiesUseCase(
  ref.read(activityRepositoryProvider),
  ref.read(profileAuthorizationServiceProvider),
);

/// CreateActivityUseCase provider.
@riverpod
CreateActivityUseCase createActivityUseCase(Ref ref) => CreateActivityUseCase(
  ref.read(activityRepositoryProvider),
  ref.read(profileAuthorizationServiceProvider),
);

/// UpdateActivityUseCase provider.
@riverpod
UpdateActivityUseCase updateActivityUseCase(Ref ref) => UpdateActivityUseCase(
  ref.read(activityRepositoryProvider),
  ref.read(profileAuthorizationServiceProvider),
);

/// ArchiveActivityUseCase provider.
@riverpod
ArchiveActivityUseCase archiveActivityUseCase(Ref ref) =>
    ArchiveActivityUseCase(
      ref.read(activityRepositoryProvider),
      ref.read(profileAuthorizationServiceProvider),
    );

// =============================================================================
// USE CASES - ACTIVITY LOGS (4)
// =============================================================================

/// GetActivityLogsUseCase provider.
@riverpod
GetActivityLogsUseCase getActivityLogsUseCase(Ref ref) =>
    GetActivityLogsUseCase(
      ref.read(activityLogRepositoryProvider),
      ref.read(profileAuthorizationServiceProvider),
    );

/// LogActivityUseCase provider.
@riverpod
LogActivityUseCase logActivityUseCase(Ref ref) => LogActivityUseCase(
  ref.read(activityLogRepositoryProvider),
  ref.read(activityRepositoryProvider),
  ref.read(profileAuthorizationServiceProvider),
);

/// UpdateActivityLogUseCase provider.
@riverpod
UpdateActivityLogUseCase updateActivityLogUseCase(Ref ref) =>
    UpdateActivityLogUseCase(
      ref.read(activityLogRepositoryProvider),
      ref.read(activityRepositoryProvider),
      ref.read(profileAuthorizationServiceProvider),
    );

/// DeleteActivityLogUseCase provider.
@riverpod
DeleteActivityLogUseCase deleteActivityLogUseCase(Ref ref) =>
    DeleteActivityLogUseCase(
      ref.read(activityLogRepositoryProvider),
      ref.read(profileAuthorizationServiceProvider),
    );

// =============================================================================
// USE CASES - FOOD ITEMS (5)
// =============================================================================

/// GetFoodItemsUseCase provider.
@riverpod
GetFoodItemsUseCase getFoodItemsUseCase(Ref ref) => GetFoodItemsUseCase(
  ref.read(foodItemRepositoryProvider),
  ref.read(profileAuthorizationServiceProvider),
);

/// CreateFoodItemUseCase provider.
@riverpod
CreateFoodItemUseCase createFoodItemUseCase(Ref ref) => CreateFoodItemUseCase(
  ref.read(foodItemRepositoryProvider),
  ref.read(profileAuthorizationServiceProvider),
);

/// UpdateFoodItemUseCase provider.
@riverpod
UpdateFoodItemUseCase updateFoodItemUseCase(Ref ref) => UpdateFoodItemUseCase(
  ref.read(foodItemRepositoryProvider),
  ref.read(profileAuthorizationServiceProvider),
);

/// SearchFoodItemsUseCase provider.
@riverpod
SearchFoodItemsUseCase searchFoodItemsUseCase(Ref ref) =>
    SearchFoodItemsUseCase(
      ref.read(foodItemRepositoryProvider),
      ref.read(profileAuthorizationServiceProvider),
    );

/// ArchiveFoodItemUseCase provider.
@riverpod
ArchiveFoodItemUseCase archiveFoodItemUseCase(Ref ref) =>
    ArchiveFoodItemUseCase(
      ref.read(foodItemRepositoryProvider),
      ref.read(profileAuthorizationServiceProvider),
    );

// =============================================================================
// USE CASES - FOOD LOGS (4)
// =============================================================================

/// GetFoodLogsUseCase provider.
@riverpod
GetFoodLogsUseCase getFoodLogsUseCase(Ref ref) => GetFoodLogsUseCase(
  ref.read(foodLogRepositoryProvider),
  ref.read(profileAuthorizationServiceProvider),
);

/// LogFoodUseCase provider.
@riverpod
LogFoodUseCase logFoodUseCase(Ref ref) => LogFoodUseCase(
  ref.read(foodLogRepositoryProvider),
  ref.read(foodItemRepositoryProvider),
  ref.read(profileAuthorizationServiceProvider),
);

/// UpdateFoodLogUseCase provider.
@riverpod
UpdateFoodLogUseCase updateFoodLogUseCase(Ref ref) => UpdateFoodLogUseCase(
  ref.read(foodLogRepositoryProvider),
  ref.read(foodItemRepositoryProvider),
  ref.read(profileAuthorizationServiceProvider),
);

/// DeleteFoodLogUseCase provider.
@riverpod
DeleteFoodLogUseCase deleteFoodLogUseCase(Ref ref) => DeleteFoodLogUseCase(
  ref.read(foodLogRepositoryProvider),
  ref.read(profileAuthorizationServiceProvider),
);

// =============================================================================
// USE CASES - JOURNAL ENTRIES (5)
// =============================================================================

/// GetJournalEntriesUseCase provider.
@riverpod
GetJournalEntriesUseCase getJournalEntriesUseCase(Ref ref) =>
    GetJournalEntriesUseCase(
      ref.read(journalEntryRepositoryProvider),
      ref.read(profileAuthorizationServiceProvider),
    );

/// CreateJournalEntryUseCase provider.
@riverpod
CreateJournalEntryUseCase createJournalEntryUseCase(Ref ref) =>
    CreateJournalEntryUseCase(
      ref.read(journalEntryRepositoryProvider),
      ref.read(profileAuthorizationServiceProvider),
    );

/// UpdateJournalEntryUseCase provider.
@riverpod
UpdateJournalEntryUseCase updateJournalEntryUseCase(Ref ref) =>
    UpdateJournalEntryUseCase(
      ref.read(journalEntryRepositoryProvider),
      ref.read(profileAuthorizationServiceProvider),
    );

/// SearchJournalEntriesUseCase provider.
@riverpod
SearchJournalEntriesUseCase searchJournalEntriesUseCase(Ref ref) =>
    SearchJournalEntriesUseCase(
      ref.read(journalEntryRepositoryProvider),
      ref.read(profileAuthorizationServiceProvider),
    );

/// DeleteJournalEntryUseCase provider.
@riverpod
DeleteJournalEntryUseCase deleteJournalEntryUseCase(Ref ref) =>
    DeleteJournalEntryUseCase(
      ref.read(journalEntryRepositoryProvider),
      ref.read(profileAuthorizationServiceProvider),
    );

// =============================================================================
// USE CASES - PHOTO AREAS (4)
// =============================================================================

/// GetPhotoAreasUseCase provider.
@riverpod
GetPhotoAreasUseCase getPhotoAreasUseCase(Ref ref) => GetPhotoAreasUseCase(
  ref.read(photoAreaRepositoryProvider),
  ref.read(profileAuthorizationServiceProvider),
);

/// CreatePhotoAreaUseCase provider.
@riverpod
CreatePhotoAreaUseCase createPhotoAreaUseCase(Ref ref) =>
    CreatePhotoAreaUseCase(
      ref.read(photoAreaRepositoryProvider),
      ref.read(profileAuthorizationServiceProvider),
    );

/// UpdatePhotoAreaUseCase provider.
@riverpod
UpdatePhotoAreaUseCase updatePhotoAreaUseCase(Ref ref) =>
    UpdatePhotoAreaUseCase(
      ref.read(photoAreaRepositoryProvider),
      ref.read(profileAuthorizationServiceProvider),
    );

/// ArchivePhotoAreaUseCase provider.
@riverpod
ArchivePhotoAreaUseCase archivePhotoAreaUseCase(Ref ref) =>
    ArchivePhotoAreaUseCase(
      ref.read(photoAreaRepositoryProvider),
      ref.read(profileAuthorizationServiceProvider),
    );

// =============================================================================
// USE CASES - PHOTO ENTRIES (4)
// =============================================================================

/// GetPhotoEntriesUseCase provider.
@riverpod
GetPhotoEntriesUseCase getPhotoEntriesUseCase(Ref ref) =>
    GetPhotoEntriesUseCase(
      ref.read(photoEntryRepositoryProvider),
      ref.read(profileAuthorizationServiceProvider),
    );

/// GetPhotoEntriesByAreaUseCase provider.
@riverpod
GetPhotoEntriesByAreaUseCase getPhotoEntriesByAreaUseCase(Ref ref) =>
    GetPhotoEntriesByAreaUseCase(
      ref.read(photoEntryRepositoryProvider),
      ref.read(profileAuthorizationServiceProvider),
    );

/// CreatePhotoEntryUseCase provider.
@riverpod
CreatePhotoEntryUseCase createPhotoEntryUseCase(Ref ref) =>
    CreatePhotoEntryUseCase(
      ref.read(photoEntryRepositoryProvider),
      ref.read(photoAreaRepositoryProvider),
      ref.read(profileAuthorizationServiceProvider),
    );

/// DeletePhotoEntryUseCase provider.
@riverpod
DeletePhotoEntryUseCase deletePhotoEntryUseCase(Ref ref) =>
    DeletePhotoEntryUseCase(
      ref.read(photoEntryRepositoryProvider),
      ref.read(profileAuthorizationServiceProvider),
    );

// =============================================================================
// USE CASES - GUEST INVITES (5)
// =============================================================================

/// CreateGuestInviteUseCase provider.
@riverpod
CreateGuestInviteUseCase createGuestInviteUseCase(Ref ref) =>
    CreateGuestInviteUseCase(ref.read(guestInviteRepositoryProvider));

/// RevokeGuestInviteUseCase provider.
@riverpod
RevokeGuestInviteUseCase revokeGuestInviteUseCase(Ref ref) =>
    RevokeGuestInviteUseCase(ref.read(guestInviteRepositoryProvider));

/// ListGuestInvitesUseCase provider.
@riverpod
ListGuestInvitesUseCase listGuestInvitesUseCase(Ref ref) =>
    ListGuestInvitesUseCase(ref.read(guestInviteRepositoryProvider));

/// ValidateGuestTokenUseCase provider.
@riverpod
ValidateGuestTokenUseCase validateGuestTokenUseCase(Ref ref) =>
    ValidateGuestTokenUseCase(ref.read(guestInviteRepositoryProvider));

/// RemoveGuestDeviceUseCase provider.
@riverpod
RemoveGuestDeviceUseCase removeGuestDeviceUseCase(Ref ref) =>
    RemoveGuestDeviceUseCase(ref.read(guestInviteRepositoryProvider));
