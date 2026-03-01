// lib/data/repositories/sleep_entry_repository_impl.dart - EXACT IMPLEMENTATION FROM 02_CODING_STANDARDS.md Section 3.2

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/repositories/base_repository.dart';
import 'package:shadow_app/core/services/device_info_service.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/daos/sleep_entry_dao.dart';
import 'package:shadow_app/domain/entities/sleep_entry.dart';
import 'package:shadow_app/domain/repositories/sleep_entry_repository.dart';
import 'package:uuid/uuid.dart';

/// Repository implementation for SleepEntry entities.
///
/// Extends BaseRepository for sync support and implements SleepEntryRepository
/// interface per 02_CODING_STANDARDS.md Section 3.2.
class SleepEntryRepositoryImpl extends BaseRepository<SleepEntry>
    implements SleepEntryRepository {
  final SleepEntryDao _dao;

  SleepEntryRepositoryImpl(
    this._dao,
    Uuid uuid,
    DeviceInfoService deviceInfoService,
  ) : super(uuid, deviceInfoService);

  @override
  Future<Result<List<SleepEntry>, AppError>> getAll({
    String? profileId,
    int? limit,
    int? offset,
  }) => _dao.getAll(profileId: profileId);

  @override
  Future<Result<SleepEntry, AppError>> getById(String id) => _dao.getById(id);

  @override
  Future<Result<SleepEntry, AppError>> create(SleepEntry entity) async {
    // Prepare entity with ID and sync metadata if needed
    final preparedEntity = await prepareForCreate(
      entity,
      (id, syncMetadata) => entity.copyWith(id: id, syncMetadata: syncMetadata),
      existingId: entity.id.isEmpty ? null : entity.id,
    );

    return _dao.create(preparedEntity);
  }

  @override
  Future<Result<SleepEntry, AppError>> update(
    SleepEntry entity, {
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
  Future<Result<List<SleepEntry>, AppError>> getModifiedSince(int since) =>
      _dao.getModifiedSince(since);

  @override
  Future<Result<List<SleepEntry>, AppError>> getPendingSync() =>
      _dao.getPendingSync();

  @override
  Future<Result<List<SleepEntry>, AppError>> getByProfile(
    String profileId, {
    int? startDate,
    int? endDate,
    int? limit,
    int? offset,
  }) => _dao.getByProfile(
    profileId,
    startDate: startDate,
    endDate: endDate,
    limit: limit,
    offset: offset,
  );

  @override
  Future<Result<SleepEntry?, AppError>> getForNight(
    String profileId,
    int date,
  ) => _dao.getForNight(profileId, date);

  @override
  Future<Result<Map<String, double>, AppError>> getAverages(
    String profileId, {
    required int startDate,
    required int endDate,
  }) async {
    final result = await _dao.getByProfile(
      profileId,
      startDate: startDate,
      endDate: endDate,
    );

    return result.when(
      success: (entries) {
        if (entries.isEmpty) {
          return const Success(<String, double>{
            'avgTotalSleepMinutes': 0.0,
            'avgDeepSleepMinutes': 0.0,
            'avgLightSleepMinutes': 0.0,
            'avgRestlessSleepMinutes': 0.0,
          });
        }

        final totalCount = entries.length;
        var totalSleepSum = 0.0;
        var deepSleepSum = 0.0;
        var lightSleepSum = 0.0;
        var restlessSleepSum = 0.0;

        for (final entry in entries) {
          final totalSleep = entry.totalSleepMinutes;
          if (totalSleep != null) {
            totalSleepSum += totalSleep;
          }
          deepSleepSum += entry.deepSleepMinutes;
          lightSleepSum += entry.lightSleepMinutes;
          restlessSleepSum += entry.restlessSleepMinutes;
        }

        return Success(<String, double>{
          'avgTotalSleepMinutes': totalSleepSum / totalCount,
          'avgDeepSleepMinutes': deepSleepSum / totalCount,
          'avgLightSleepMinutes': lightSleepSum / totalCount,
          'avgRestlessSleepMinutes': restlessSleepSum / totalCount,
        });
      },
      failure: Failure.new,
    );
  }
}
