// lib/domain/repositories/entity_repository.dart - EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 4.1

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';

/// Base contract for all entity repositories.
/// ALL repositories MUST implement these exact method signatures.
abstract class EntityRepository<T, ID> {
  /// Get all entities, optionally filtered by profile.
  /// Returns empty list if none found, never null.
  Future<Result<List<T>, AppError>> getAll({
    String? profileId,
    int? limit,
    int? offset,
  });

  /// Get single entity by ID.
  /// Returns Failure(DatabaseError.notFound) if not found.
  Future<Result<T, AppError>> getById(ID id);

  /// Create new entity.
  /// Entity ID will be generated if empty.
  /// Returns created entity with generated ID and sync metadata.
  Future<Result<T, AppError>> create(T entity);

  /// Update existing entity.
  /// Returns Failure(DatabaseError.notFound) if not found.
  /// Set markDirty=false only during sync operations.
  Future<Result<T, AppError>> update(T entity, {bool markDirty = true});

  /// Soft delete entity (sets deletedAt).
  /// Returns Failure(DatabaseError.notFound) if not found.
  Future<Result<void, AppError>> delete(ID id);

  /// Permanently remove entity from database.
  /// Use only for sync cleanup. Normal deletes should use delete().
  Future<Result<void, AppError>> hardDelete(ID id);

  /// Get entities modified since timestamp (for sync).
  Future<Result<List<T>, AppError>> getModifiedSince(int since); // Epoch ms

  /// Get entities pending sync (isDirty = true).
  Future<Result<List<T>, AppError>> getPendingSync();
}

/// Alias for EntityRepository used by intelligence and other subsystems.
/// IMPORTANT: BaseRepository and EntityRepository are interchangeable.
/// Use EntityRepository for new code; BaseRepositoryContract exists for consistency
/// with patterns used in intelligence repositories.
typedef BaseRepositoryContract<T, ID> = EntityRepository<T, ID>;
