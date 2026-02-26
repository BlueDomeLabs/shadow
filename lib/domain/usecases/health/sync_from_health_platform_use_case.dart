// lib/domain/usecases/health/sync_from_health_platform_use_case.dart
// Phase 16b — Orchestrates the full health platform import flow
// Per 61_HEALTH_PLATFORM_INTEGRATION.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/health_sync_settings.dart';
import 'package:shadow_app/domain/entities/health_sync_status.dart';
import 'package:shadow_app/domain/entities/imported_vital.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/repositories/health_platform_service.dart';
import 'package:shadow_app/domain/repositories/health_sync_settings_repository.dart';
import 'package:shadow_app/domain/repositories/health_sync_status_repository.dart';
import 'package:shadow_app/domain/repositories/imported_vital_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/health/health_types.dart';
import 'package:uuid/uuid.dart';

/// Orchestrates the full import flow from Apple HealthKit or Google Health Connect.
///
/// This is a domain-layer use case — all platform calls are delegated to
/// [HealthPlatformService], keeping this class fully testable without
/// real platform dependencies.
///
/// Import flow per 61_HEALTH_PLATFORM_INTEGRATION.md:
///   1. Check profile access.
///   2. Check platform availability (Health Connect may not be installed on Android).
///   3. Load sync settings (uses defaults if not yet configured).
///   4. Request read permissions for enabled data types.
///   5. For each granted type: read records since last import, deduplicate,
///      write batch, update sync status.
///   6. Return a summary: count per type, denied types, availability.
///
/// Partial success is normal — e.g. user grants heart rate but denies weight.
/// The result always describes what happened; it is never a Failure unless
/// there is an unrecoverable I/O error.
class SyncFromHealthPlatformUseCase
    implements
        UseCase<SyncFromHealthPlatformInput, SyncFromHealthPlatformResult> {
  final HealthPlatformService _platformService;
  final HealthSyncSettingsRepository _settingsRepo;
  final HealthSyncStatusRepository _statusRepo;
  final ImportedVitalRepository _vitalRepo;
  final ProfileAuthorizationService _authService;

  SyncFromHealthPlatformUseCase(
    this._platformService,
    this._settingsRepo,
    this._statusRepo,
    this._vitalRepo,
    this._authService,
  );

  @override
  Future<Result<SyncFromHealthPlatformResult, AppError>> call(
    SyncFromHealthPlatformInput input,
  ) async {
    // 1. Authorization — use canWrite because import modifies imported_vitals.
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Platform availability check.
    if (!await _platformService.isAvailable()) {
      return const Success(
        SyncFromHealthPlatformResult(platformUnavailable: true),
      );
    }

    // 3. Load sync settings; fall back to defaults if never configured.
    final settingsResult = await _settingsRepo.getByProfile(input.profileId);
    if (settingsResult.isFailure) {
      return Failure(settingsResult.errorOrNull!);
    }
    final settings =
        settingsResult.valueOrNull ??
        HealthSyncSettings.defaultsForProfile(input.profileId);

    if (settings.enabledDataTypes.isEmpty) {
      return const Success(SyncFromHealthPlatformResult());
    }

    // 4. Request permissions for all enabled data types.
    final permResult = await _platformService.requestPermissions(
      settings.enabledDataTypes,
    );
    if (permResult.isFailure) {
      return Failure(permResult.errorOrNull!);
    }
    final grantedTypes = permResult.valueOrNull ?? [];
    final deniedTypes = settings.enabledDataTypes
        .where((t) => !grantedTypes.contains(t))
        .toList();

    if (grantedTypes.isEmpty) {
      return Success(SyncFromHealthPlatformResult(deniedTypes: deniedTypes));
    }

    // 5. Determine the full-range start for first-time imports.
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    final fullRangeStartMs =
        nowMs - (settings.dateRangeDays * Duration.millisecondsPerDay);

    // 6. Import each granted data type.
    final importedCountByType = <HealthDataType, int>{};

    for (final dataType in grantedTypes) {
      // Incremental sync: start from the last successfully imported record.
      final lastImportResult = await _vitalRepo.getLastImportTime(
        input.profileId,
        dataType,
      );
      if (lastImportResult.isFailure) {
        return Failure(lastImportResult.errorOrNull!);
      }
      final sinceMs = lastImportResult.valueOrNull ?? fullRangeStartMs;

      // Read records from the platform for this data type.
      final readResult = await _platformService.readRecords(
        dataType,
        sinceMs,
        nowMs,
      );
      if (readResult.isFailure) {
        // Platform read failure for one type should not abort the whole sync.
        // Log as 0 imported and continue to next type.
        importedCountByType[dataType] = 0;
        continue;
      }

      final records = readResult.valueOrNull ?? [];
      if (records.isEmpty) {
        importedCountByType[dataType] = 0;
        continue;
      }

      // Convert raw platform records to ImportedVital entities.
      final vitals = _toVitals(records, dataType, input.profileId, nowMs);

      // Write batch — repository handles per-record deduplication
      // (same dataType + recordedAt + sourcePlatform + profileId is skipped).
      final importResult = await _vitalRepo.importBatch(vitals);
      if (importResult.isFailure) {
        return Failure(importResult.errorOrNull!);
      }
      importedCountByType[dataType] = importResult.valueOrNull ?? 0;

      // Update sync status with new last-synced timestamp and record count.
      final status = HealthSyncStatus(
        id: HealthSyncStatus.makeId(input.profileId, dataType),
        profileId: input.profileId,
        dataType: dataType,
        lastSyncedAt: nowMs,
        recordCount: importResult.valueOrNull ?? 0,
      );
      final upsertResult = await _statusRepo.upsert(status);
      if (upsertResult.isFailure) {
        return Failure(upsertResult.errorOrNull!);
      }
    }

    return Success(
      SyncFromHealthPlatformResult(
        importedCountByType: importedCountByType,
        deniedTypes: deniedTypes,
      ),
    );
  }

  /// Converts raw platform records to [ImportedVital] entities for storage.
  List<ImportedVital> _toVitals(
    List<HealthDataRecord> records,
    HealthDataType dataType,
    String profileId,
    int importedAt,
  ) => records.map((record) {
    final id = const Uuid().v4();
    return ImportedVital(
      id: id,
      clientId: id, // Use the same UUID for clientId on import
      profileId: profileId,
      dataType: dataType,
      value: record.value,
      unit: dataType.canonicalUnit,
      recordedAt: record.recordedAt,
      sourcePlatform: _platformService.currentPlatform,
      sourceDevice: record.sourceDevice,
      importedAt: importedAt,
      syncMetadata: SyncMetadata(
        syncCreatedAt: importedAt,
        syncUpdatedAt: importedAt,
        syncDeviceId: '', // Populated by repository implementation
      ),
    );
  }).toList();
}
