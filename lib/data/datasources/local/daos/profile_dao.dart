// lib/data/datasources/local/daos/profile_dao.dart
// Data Access Object for profiles table per 22_API_CONTRACTS.md Section 10.7

import 'package:drift/drift.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/data/datasources/local/tables/profiles_table.dart';
import 'package:shadow_app/domain/entities/profile.dart' as domain;
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

part 'profile_dao.g.dart';

/// Data Access Object for the profiles table.
///
/// Implements all database operations for Profile entities.
/// Returns Result types for all operations per 22_API_CONTRACTS.md.
@DriftAccessor(tables: [Profiles])
class ProfileDao extends DatabaseAccessor<AppDatabase> with _$ProfileDaoMixin {
  ProfileDao(super.db);

  /// Get all profiles, excluding soft-deleted.
  Future<Result<List<domain.Profile>, AppError>> getAll({
    int? limit,
    int? offset,
  }) async {
    try {
      var query = select(profiles)
        ..where((p) => p.syncDeletedAt.isNull())
        ..orderBy([(p) => OrderingTerm.asc(p.name)]);

      if (limit != null) {
        query = query..limit(limit, offset: offset);
      }

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('profiles', e.toString(), stack),
      );
    }
  }

  /// Get a single profile by ID.
  Future<Result<domain.Profile, AppError>> getById(String id) async {
    try {
      final query = select(profiles)
        ..where((p) => p.id.equals(id) & p.syncDeletedAt.isNull());

      final row = await query.getSingleOrNull();

      if (row == null) {
        return Failure(DatabaseError.notFound('Profile', id));
      }

      return Success(_rowToEntity(row));
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('profiles', e.toString(), stack),
      );
    }
  }

  /// Create a new profile.
  Future<Result<domain.Profile, AppError>> create(domain.Profile entity) async {
    try {
      final companion = _entityToCompanion(entity);
      await into(profiles).insert(companion);
      return getById(entity.id);
    } on Exception catch (e, stack) {
      if (e.toString().contains('UNIQUE constraint failed')) {
        return Failure(
          DatabaseError.constraintViolation('Duplicate ID: ${entity.id}'),
        );
      }
      return Failure(DatabaseError.insertFailed('profiles', e, stack));
    }
  }

  /// Update an existing profile.
  Future<Result<domain.Profile, AppError>> updateEntity(
    domain.Profile entity, {
    bool markDirty = true,
  }) async {
    try {
      final existsResult = await getById(entity.id);
      if (existsResult.isFailure) {
        return existsResult;
      }

      final companion = _entityToCompanion(entity);
      await (update(
        profiles,
      )..where((p) => p.id.equals(entity.id))).write(companion);

      return getById(entity.id);
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.updateFailed('profiles', entity.id, e, stack),
      );
    }
  }

  /// Soft delete a profile.
  Future<Result<void, AppError>> softDelete(String id) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final rowsAffected =
          await (update(
            profiles,
          )..where((p) => p.id.equals(id) & p.syncDeletedAt.isNull())).write(
            ProfilesCompanion(
              syncDeletedAt: Value(now),
              syncUpdatedAt: Value(now),
              syncIsDirty: const Value(true),
              syncStatus: Value(SyncStatus.deleted.value),
            ),
          );

      if (rowsAffected == 0) {
        return Failure(DatabaseError.notFound('Profile', id));
      }

      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(DatabaseError.deleteFailed('profiles', id, e, stack));
    }
  }

  /// Hard delete a profile (permanent removal).
  Future<Result<void, AppError>> hardDelete(String id) async {
    try {
      final rowsAffected = await (delete(
        profiles,
      )..where((p) => p.id.equals(id))).go();

      if (rowsAffected == 0) {
        return Failure(DatabaseError.notFound('Profile', id));
      }

      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(DatabaseError.deleteFailed('profiles', id, e, stack));
    }
  }

  /// Get profiles modified since timestamp (for sync).
  Future<Result<List<domain.Profile>, AppError>> getModifiedSince(
    int since,
  ) async {
    try {
      final query = select(profiles)
        ..where((p) => p.syncUpdatedAt.isBiggerThanValue(since))
        ..orderBy([(p) => OrderingTerm.asc(p.syncUpdatedAt)]);

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('profiles', e.toString(), stack),
      );
    }
  }

  /// Get profiles pending sync.
  Future<Result<List<domain.Profile>, AppError>> getPendingSync() async {
    try {
      final query = select(profiles)
        ..where((p) => p.syncIsDirty.equals(true))
        ..orderBy([(p) => OrderingTerm.asc(p.syncUpdatedAt)]);

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('profiles', e.toString(), stack),
      );
    }
  }

  /// Get all profiles owned by a specific user.
  Future<Result<List<domain.Profile>, AppError>> getByOwner(
    String ownerId,
  ) async {
    try {
      final query = select(profiles)
        ..where((p) => p.ownerId.equals(ownerId) & p.syncDeletedAt.isNull())
        ..orderBy([(p) => OrderingTerm.asc(p.name)]);

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('profiles', e.toString(), stack),
      );
    }
  }

  /// Get the default profile for a user (first created).
  Future<Result<domain.Profile?, AppError>> getDefault(String ownerId) async {
    try {
      final query = select(profiles)
        ..where((p) => p.ownerId.equals(ownerId) & p.syncDeletedAt.isNull())
        ..orderBy([(p) => OrderingTerm.asc(p.syncCreatedAt)])
        ..limit(1);

      final row = await query.getSingleOrNull();

      if (row == null) {
        return const Success(null);
      }

      return Success(_rowToEntity(row));
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('profiles', e.toString(), stack),
      );
    }
  }

  /// Convert database row to domain Profile entity.
  domain.Profile _rowToEntity(ProfileRow row) => domain.Profile(
    id: row.id,
    clientId: row.clientId,
    name: row.name,
    birthDate: row.birthDate,
    biologicalSex: row.biologicalSex != null
        ? BiologicalSex.fromValue(row.biologicalSex!)
        : null,
    ethnicity: row.ethnicity,
    notes: row.notes,
    ownerId: row.ownerId,
    dietType: ProfileDietType.fromValue(row.dietType),
    dietDescription: row.dietDescription,
    syncMetadata: SyncMetadata(
      syncCreatedAt: row.syncCreatedAt,
      syncUpdatedAt: row.syncUpdatedAt ?? row.syncCreatedAt,
      syncDeletedAt: row.syncDeletedAt,
      syncLastSyncedAt: row.syncLastSyncedAt,
      syncStatus: SyncStatus.fromValue(row.syncStatus),
      syncVersion: row.syncVersion,
      syncDeviceId: row.syncDeviceId ?? '',
      syncIsDirty: row.syncIsDirty,
      conflictData: row.conflictData,
    ),
  );

  /// Convert domain Profile entity to database companion.
  ProfilesCompanion _entityToCompanion(domain.Profile entity) =>
      ProfilesCompanion(
        id: Value(entity.id),
        clientId: Value(entity.clientId),
        name: Value(entity.name),
        birthDate: Value(entity.birthDate),
        biologicalSex: Value(entity.biologicalSex?.value),
        ethnicity: Value(entity.ethnicity),
        notes: Value(entity.notes),
        ownerId: Value(entity.ownerId),
        dietType: Value(entity.dietType.value),
        dietDescription: Value(entity.dietDescription),
        syncCreatedAt: Value(entity.syncMetadata.syncCreatedAt),
        syncUpdatedAt: Value(entity.syncMetadata.syncUpdatedAt),
        syncDeletedAt: Value(entity.syncMetadata.syncDeletedAt),
        syncLastSyncedAt: Value(entity.syncMetadata.syncLastSyncedAt),
        syncStatus: Value(entity.syncMetadata.syncStatus.value),
        syncVersion: Value(entity.syncMetadata.syncVersion),
        syncDeviceId: Value(entity.syncMetadata.syncDeviceId),
        syncIsDirty: Value(entity.syncMetadata.syncIsDirty),
        conflictData: Value(entity.syncMetadata.conflictData),
      );
}
