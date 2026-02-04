// lib/data/repositories/supplement_repository_impl.dart - EXACT IMPLEMENTATION FROM 02_CODING_STANDARDS.md Section 3.2

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/repositories/base_repository.dart';
import 'package:shadow_app/core/services/device_info_service.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/daos/supplement_dao.dart';
import 'package:shadow_app/domain/entities/supplement.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/repositories/supplement_repository.dart';
import 'package:uuid/uuid.dart';

/// Repository implementation for Supplement entities.
///
/// Extends BaseRepository for sync support and implements SupplementRepository
/// interface per 02_CODING_STANDARDS.md Section 3.2.
class SupplementRepositoryImpl extends BaseRepository<Supplement>
    implements SupplementRepository {
  final SupplementDao _dao;

  SupplementRepositoryImpl(
    this._dao,
    Uuid uuid,
    DeviceInfoService deviceInfoService,
  ) : super(uuid, deviceInfoService);

  @override
  Future<Result<List<Supplement>, AppError>> getAll({
    String? profileId,
    int? limit,
    int? offset,
  }) =>
      _dao.getAll(profileId: profileId, limit: limit, offset: offset);

  @override
  Future<Result<Supplement, AppError>> getById(String id) => _dao.getById(id);

  @override
  Future<Result<Supplement, AppError>> create(Supplement entity) async {
    // Prepare entity with ID and sync metadata if needed
    final preparedEntity = await prepareForCreate(
      entity,
      (id, syncMetadata) => entity.copyWith(id: id, syncMetadata: syncMetadata),
      existingId: entity.id.isEmpty ? null : entity.id,
    );

    return _dao.create(preparedEntity);
  }

  @override
  Future<Result<Supplement, AppError>> update(
    Supplement entity, {
    bool markDirty = true,
  }) async {
    // Prepare entity with updated sync metadata
    final preparedEntity = await prepareForUpdate(
      entity,
      (syncMetadata) => entity.copyWith(syncMetadata: syncMetadata),
      markDirty: markDirty,
      getSyncMetadata: (e) => e.syncMetadata,
    );

    return _dao.updateEntity(preparedEntity, markDirty: markDirty);
  }

  @override
  Future<Result<void, AppError>> delete(String id) => _dao.softDelete(id);

  @override
  Future<Result<void, AppError>> hardDelete(String id) => _dao.hardDelete(id);

  @override
  Future<Result<List<Supplement>, AppError>> getModifiedSince(int since) =>
      _dao.getModifiedSince(since);

  @override
  Future<Result<List<Supplement>, AppError>> getPendingSync() =>
      _dao.getPendingSync();

  @override
  Future<Result<List<Supplement>, AppError>> getByProfile(
    String profileId, {
    bool? activeOnly,
    int? limit,
    int? offset,
  }) =>
      _dao.getByProfile(
        profileId,
        activeOnly: activeOnly,
        limit: limit,
        offset: offset,
      );

  @override
  Future<Result<List<Supplement>, AppError>> getDueAt(
    String profileId,
    int time,
  ) async {
    // Get all active supplements for the profile
    final result = await _dao.getByProfile(profileId, activeOnly: true);

    return result.when(
      success: (supplements) {
        // Filter supplements that are due at the specified time
        final dueSupplements = supplements
            .where((supplement) => _isSupplementDueAt(supplement, time))
            .toList();

        return Success(dueSupplements);
      },
      failure: Failure.new,
    );
  }

  @override
  Future<Result<List<Supplement>, AppError>> search(
    String profileId,
    String query, {
    int limit = 20,
  }) =>
      _dao.search(profileId, query, limit: limit);

  /// Determines if a supplement is due at the specified time.
  ///
  /// Evaluates the supplement's schedules against the given time.
  /// Returns true if any schedule matches the time criteria.
  bool _isSupplementDueAt(Supplement supplement, int time) {
    if (!supplement.isActive || !supplement.isWithinDateRange) {
      return false;
    }

    if (supplement.schedules.isEmpty) {
      return false;
    }

    final dateTime = DateTime.fromMillisecondsSinceEpoch(time);
    final weekday = dateTime.weekday % 7; // Convert to 0-6 (Sun-Sat)
    final minutesFromMidnight = dateTime.hour * 60 + dateTime.minute;

    for (final schedule in supplement.schedules) {
      // Check frequency type
      if (!_matchesFrequency(schedule, dateTime, weekday)) {
        continue;
      }

      // Check timing
      if (_matchesTiming(schedule, minutesFromMidnight)) {
        return true;
      }
    }

    return false;
  }

  /// Checks if the schedule's frequency matches the date.
  bool _matchesFrequency(
    SupplementSchedule schedule,
    DateTime dateTime,
    int weekday,
  ) {
    switch (schedule.frequencyType) {
      case SupplementFrequencyType.daily:
        return true;
      case SupplementFrequencyType.everyXDays:
        // For everyXDays, we'd need a start date reference
        // For now, assume it matches (full implementation would track this)
        return true;
      case SupplementFrequencyType.specificWeekdays:
        return schedule.weekdays.contains(weekday);
    }
  }

  /// Checks if the schedule's timing matches the time of day.
  ///
  /// For anchor-based timing (wake, breakfast, etc.), this requires
  /// user preference data which should be injected. For now, uses defaults.
  bool _matchesTiming(SupplementSchedule schedule, int minutesFromMidnight) {
    // Get the target time based on timing type
    int targetMinutes;

    if (schedule.timingType == SupplementTimingType.specificTime) {
      targetMinutes = schedule.specificTimeMinutes ?? 0;
    } else {
      // Get anchor event time (using defaults - would come from user prefs)
      final anchorMinutes = _getAnchorEventTime(schedule.anchorEvent);

      switch (schedule.timingType) {
        case SupplementTimingType.withEvent:
          targetMinutes = anchorMinutes;
        case SupplementTimingType.beforeEvent:
          targetMinutes = anchorMinutes - schedule.offsetMinutes;
        case SupplementTimingType.afterEvent:
          targetMinutes = anchorMinutes + schedule.offsetMinutes;
        case SupplementTimingType.specificTime:
          targetMinutes = schedule.specificTimeMinutes ?? 0;
      }
    }

    // Check if current time is within a 30-minute window of target
    const windowMinutes = 30;
    return (minutesFromMidnight - targetMinutes).abs() <= windowMinutes;
  }

  /// Gets the default time for an anchor event.
  ///
  /// In production, these would come from user preferences.
  int _getAnchorEventTime(SupplementAnchorEvent event) {
    switch (event) {
      case SupplementAnchorEvent.wake:
        return 7 * 60; // 7:00 AM
      case SupplementAnchorEvent.breakfast:
        return 8 * 60; // 8:00 AM
      case SupplementAnchorEvent.lunch:
        return 12 * 60; // 12:00 PM
      case SupplementAnchorEvent.dinner:
        return 18 * 60; // 6:00 PM
      case SupplementAnchorEvent.bed:
        return 22 * 60; // 10:00 PM
    }
  }
}
