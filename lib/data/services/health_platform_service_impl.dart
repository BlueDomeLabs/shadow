// lib/data/services/health_platform_service_impl.dart
// Phase 16c — Concrete implementation of HealthPlatformService
// Per 61_HEALTH_PLATFORM_INTEGRATION.md
//
// The `health` plugin is ONLY imported here — never in the domain layer.
// This keeps SyncFromHealthPlatformUseCase fully testable without real
// platform dependencies. Inject [hp.Health] for testing.

import 'dart:io';

import 'package:health/health.dart' as hp;
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/repositories/health_platform_service.dart';

/// Maps a Shadow [HealthDataType] to the corresponding health plugin type(s).
List<hp.HealthDataType> _toPluginTypes(HealthDataType type) => switch (type) {
  HealthDataType.heartRate => [hp.HealthDataType.HEART_RATE],
  HealthDataType.restingHeartRate => [hp.HealthDataType.RESTING_HEART_RATE],
  HealthDataType.weight => [hp.HealthDataType.WEIGHT],
  HealthDataType.bpSystolic => [hp.HealthDataType.BLOOD_PRESSURE_SYSTOLIC],
  HealthDataType.bpDiastolic => [hp.HealthDataType.BLOOD_PRESSURE_DIASTOLIC],
  HealthDataType.sleepDuration => [hp.HealthDataType.SLEEP_ASLEEP],
  HealthDataType.steps => [hp.HealthDataType.STEPS],
  HealthDataType.activeCalories => [hp.HealthDataType.ACTIVE_ENERGY_BURNED],
  HealthDataType.bloodOxygen => [hp.HealthDataType.BLOOD_OXYGEN],
};

/// Platform display name for error messages.
String _platformName() =>
    Platform.isIOS ? 'Apple Health' : 'Google Health Connect';

/// Concrete implementation of [HealthPlatformService] using the `health` plugin.
///
/// - iOS: reads from Apple HealthKit via the health plugin.
/// - Android: reads from Google Health Connect via the health plugin.
/// - Other platforms (macOS, desktop): [isAvailable] returns false; all
///   methods return empty results rather than throwing.
///
/// Inject [hp.Health] to enable mocking in unit tests.
class HealthPlatformServiceImpl implements HealthPlatformService {
  final hp.Health _health;

  HealthPlatformServiceImpl(this._health);

  @override
  HealthSourcePlatform get currentPlatform => Platform.isIOS
      ? HealthSourcePlatform.appleHealth
      : HealthSourcePlatform.googleHealthConnect;

  /// Returns false on non-mobile platforms and when Health Connect is not
  /// installed on Android. Always returns true on iOS (HealthKit is built in).
  @override
  Future<bool> isAvailable() async {
    if (!Platform.isIOS && !Platform.isAndroid) return false;
    return _health.isHealthConnectAvailable();
  }

  /// Requests read permissions for [types] and returns the granted subset.
  ///
  /// Calls the platform permission dialog once for all types, then checks
  /// each type individually. On iOS, [hasPermissions] can return null (privacy
  /// protection) — null is treated as granted since HealthKit will prompt
  /// during the actual read if permission was not previously granted.
  @override
  Future<Result<List<HealthDataType>, AppError>> requestPermissions(
    List<HealthDataType> types,
  ) async {
    if (types.isEmpty) return const Success([]);
    try {
      final pluginTypes = types.expand(_toPluginTypes).toSet().toList();
      final perms = pluginTypes.map((_) => hp.HealthDataAccess.READ).toList();

      // Present platform permission dialog (result indicates if ALL were granted).
      await _health.requestAuthorization(pluginTypes, permissions: perms);

      // Determine which domain types are actually accessible.
      // hasPermissions returns: true = granted, false = denied, null = unknown.
      // Treat null as granted (iOS privacy — assume accessible, fail on read).
      final granted = <HealthDataType>[];
      for (final domainType in types) {
        final pts = _toPluginTypes(domainType);
        final ptPerms = pts.map((_) => hp.HealthDataAccess.READ).toList();
        final result = await _health.hasPermissions(pts, permissions: ptPerms);
        if (result ?? true) granted.add(domainType);
      }
      return Success(granted);
    } on Exception catch (e) {
      return Failure(WearableError.authFailed(_platformName(), e));
    }
  }

  /// Reads health records for [dataType] in the time window
  /// [sinceEpochMs]–[untilEpochMs] (epoch ms UTC).
  ///
  /// Sleep values are converted from minutes (plugin internal) to hours
  /// (Shadow canonical unit). Blood oxygen is already 0–100 from HealthKit.
  @override
  Future<Result<List<HealthDataRecord>, AppError>> readRecords(
    HealthDataType dataType,
    int sinceEpochMs,
    int untilEpochMs,
  ) async {
    try {
      final pluginTypes = _toPluginTypes(dataType);
      final points = await _health.getHealthDataFromTypes(
        types: pluginTypes,
        startTime: DateTime.fromMillisecondsSinceEpoch(
          sinceEpochMs,
          isUtc: true,
        ),
        endTime: DateTime.fromMillisecondsSinceEpoch(untilEpochMs, isUtc: true),
      );
      return Success(points.map((p) => _toRecord(dataType, p)).toList());
    } on Exception catch (e, st) {
      return Failure(
        WearableError.syncFailed(_platformName(), e.toString(), e, st),
      );
    }
  }

  /// Converts a health plugin [hp.HealthDataPoint] to a domain [HealthDataRecord].
  HealthDataRecord _toRecord(HealthDataType type, hp.HealthDataPoint p) {
    final raw = (p.value as hp.NumericHealthValue).numericValue.toDouble();

    // Sleep duration: plugin returns minutes → convert to hours (canonical unit).
    final value = type == HealthDataType.sleepDuration ? raw / 60.0 : raw;

    return HealthDataRecord(
      recordedAt: p.dateFrom.millisecondsSinceEpoch,
      value: value,
      sourceDevice: p.sourceName.isNotEmpty ? p.sourceName : null,
    );
  }
}
