// lib/domain/repositories/health_platform_service.dart
// Phase 16b — Abstract port for reading from Apple HealthKit / Google Health Connect
// Per 61_HEALTH_PLATFORM_INTEGRATION.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

/// A single raw health record read from the platform.
///
/// Returned by [HealthPlatformService.readRecords]. The use case converts
/// these into [ImportedVital] entities for storage.
class HealthDataRecord {
  /// When the measurement was recorded by the source device (epoch ms UTC).
  final int recordedAt;

  /// Numeric value in the data type's canonical unit.
  final double value;

  /// Device name if available (e.g. "Apple Watch Series 9").
  final String? sourceDevice;

  const HealthDataRecord({
    required this.recordedAt,
    required this.value,
    this.sourceDevice,
  });
}

/// Abstract port for reading health data from Apple HealthKit (iOS) or
/// Google Health Connect (Android).
///
/// Implemented in Phase 16c/16d by HealthPlatformServiceImpl using the
/// `health` Flutter plugin. The domain layer depends only on this interface,
/// keeping [SyncFromHealthPlatformUseCase] fully testable without platform
/// dependencies.
///
/// Per 61_HEALTH_PLATFORM_INTEGRATION.md:
/// - Shadow requests read-only access — never writes to either platform.
/// - All data reads are manual (user-triggered) — no background sync.
abstract interface class HealthPlatformService {
  /// The source platform this service reads from.
  ///
  /// Determined at runtime by the concrete implementation:
  /// [HealthSourcePlatform.appleHealth] on iOS,
  /// [HealthSourcePlatform.googleHealthConnect] on Android.
  HealthSourcePlatform get currentPlatform;

  /// Returns false if the health platform is unavailable on this device.
  ///
  /// On Android: returns false if Health Connect is not installed.
  /// On iOS: always returns true (HealthKit is built into the OS).
  ///
  /// When false, [SyncFromHealthPlatformUseCase] returns a result with
  /// [SyncFromHealthPlatformResult.platformUnavailable] set to true.
  Future<bool> isAvailable();

  /// Requests read permissions for the given data types.
  ///
  /// Presents the platform permission dialog to the user. Returns the
  /// subset of [types] that the user actually granted. Types the user denied
  /// are not included in the returned list (not an error — partial grants
  /// are valid).
  ///
  /// Returns [Failure] only on unexpected errors (e.g. platform crash).
  Future<Result<List<HealthDataType>, AppError>> requestPermissions(
    List<HealthDataType> types,
  );

  /// Reads health records for [dataType] in the given time window.
  ///
  /// [sinceEpochMs]: start of window (exclusive), epoch ms UTC.
  /// [untilEpochMs]: end of window (inclusive), epoch ms UTC.
  ///
  /// Returns raw records ordered by [HealthDataRecord.recordedAt] ascending.
  /// The caller handles deduplication via [ImportedVitalRepository.importBatch].
  ///
  /// Returns an empty list (not a Failure) when no records exist in the window.
  Future<Result<List<HealthDataRecord>, AppError>> readRecords(
    HealthDataType dataType,
    int sinceEpochMs,
    int untilEpochMs,
  );
}
