// lib/data/repositories/imported_vital_repository_impl.dart
// Phase 16 — Repository implementation for imported vitals
// Per 61_HEALTH_PLATFORM_INTEGRATION.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/daos/imported_vital_dao.dart';
import 'package:shadow_app/domain/entities/imported_vital.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/repositories/imported_vital_repository.dart';

class ImportedVitalRepositoryImpl implements ImportedVitalRepository {
  ImportedVitalRepositoryImpl(this._dao);

  final ImportedVitalDao _dao;

  @override
  Future<Result<List<ImportedVital>, AppError>> getByProfile({
    required String profileId,
    int? startEpoch,
    int? endEpoch,
    HealthDataType? dataType,
  }) => _dao.getByProfile(
    profileId: profileId,
    startEpoch: startEpoch,
    endEpoch: endEpoch,
    dataType: dataType,
  );

  @override
  Future<Result<int, AppError>> importBatch(List<ImportedVital> vitals) async {
    var inserted = 0;
    for (final vital in vitals) {
      final result = await _dao.insertIfNotDuplicate(vital);
      if (result.isFailure) return Failure(result.errorOrNull!);
      inserted++;
    }
    return Success(inserted);
  }

  @override
  Future<Result<int?, AppError>> getLastImportTime(
    String profileId,
    HealthDataType dataType,
  ) => _dao.getLastImportTime(profileId, dataType);

  @override
  Future<Result<List<ImportedVital>, AppError>> getModifiedSince(int since) =>
      _dao.getModifiedSince(since);
}
