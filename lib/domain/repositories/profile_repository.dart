// lib/domain/repositories/profile_repository.dart - EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 10.7

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/profile.dart';
import 'package:shadow_app/domain/repositories/entity_repository.dart';

/// Repository contract for Profile entities.
///
/// Extends EntityRepository with profile-specific query methods.
abstract class ProfileRepository implements EntityRepository<Profile, String> {
  // Inherited from EntityRepository:
  // - getAll, getById, create, update, delete, hardDelete
  // - getModifiedSince, getPendingSync

  /// Get all profiles owned by a specific user.
  Future<Result<List<Profile>, AppError>> getByOwner(String ownerId);

  /// Get the default profile for a user (first created or explicitly set).
  Future<Result<Profile?, AppError>> getDefault(String ownerId);

  /// Get all profiles for a user (alias for getByOwner for clarity in user context).
  Future<Result<List<Profile>, AppError>> getByUser(String userId);
}
