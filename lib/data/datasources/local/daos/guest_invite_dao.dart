// lib/data/datasources/local/daos/guest_invite_dao.dart
// Data Access Object for guest_invites table per 22_API_CONTRACTS.md Section 18

import 'package:drift/drift.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/data/datasources/local/tables/guest_invites_table.dart';
import 'package:shadow_app/domain/entities/guest_invite.dart' as domain;

part 'guest_invite_dao.g.dart';

/// Data Access Object for the guest_invites table.
///
/// Implements all database operations for GuestInvite entities.
/// Returns Result types for all operations per 22_API_CONTRACTS.md.
@DriftAccessor(tables: [GuestInvites])
class GuestInviteDao extends DatabaseAccessor<AppDatabase>
    with _$GuestInviteDaoMixin {
  GuestInviteDao(super.db);

  /// Create a new guest invite.
  Future<Result<domain.GuestInvite, AppError>> create(
    domain.GuestInvite entity,
  ) async {
    try {
      final companion = _entityToCompanion(entity);
      await into(guestInvites).insert(companion);
      return getById(entity.id);
    } on Exception catch (e, stack) {
      if (e.toString().contains('UNIQUE constraint failed')) {
        return Failure(
          DatabaseError.constraintViolation(
            'Duplicate ID or token: ${entity.id}',
          ),
        );
      }
      return Failure(DatabaseError.insertFailed('guest_invites', e, stack));
    }
  }

  /// Get a guest invite by ID.
  Future<Result<domain.GuestInvite, AppError>> getById(String id) async {
    try {
      final query = select(guestInvites)..where((g) => g.id.equals(id));

      final row = await query.getSingleOrNull();

      if (row == null) {
        return Failure(DatabaseError.notFound('GuestInvite', id));
      }

      return Success(_rowToEntity(row));
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('guest_invites', e.toString(), stack),
      );
    }
  }

  /// Get a guest invite by its token.
  Future<Result<domain.GuestInvite?, AppError>> getByToken(String token) async {
    try {
      final query = select(guestInvites)..where((g) => g.token.equals(token));

      final row = await query.getSingleOrNull();

      if (row == null) {
        return const Success(null);
      }

      return Success(_rowToEntity(row));
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('guest_invites', e.toString(), stack),
      );
    }
  }

  /// Get all invites for a profile.
  Future<Result<List<domain.GuestInvite>, AppError>> getByProfile(
    String profileId,
  ) async {
    try {
      final query = select(guestInvites)
        ..where((g) => g.profileId.equals(profileId))
        ..orderBy([(g) => OrderingTerm.desc(g.createdAt)]);

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('guest_invites', e.toString(), stack),
      );
    }
  }

  /// Update an existing invite.
  Future<Result<domain.GuestInvite, AppError>> updateEntity(
    domain.GuestInvite entity,
  ) async {
    try {
      final existsResult = await getById(entity.id);
      if (existsResult.isFailure) {
        return existsResult;
      }

      final companion = _entityToCompanion(entity);
      await (update(
        guestInvites,
      )..where((g) => g.id.equals(entity.id))).write(companion);

      return getById(entity.id);
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.updateFailed('guest_invites', entity.id, e, stack),
      );
    }
  }

  /// Revoke a guest invite (sets isRevoked=true, clears activeDeviceId).
  Future<Result<void, AppError>> revoke(String id) async {
    try {
      final rowsAffected =
          await (update(guestInvites)..where((g) => g.id.equals(id))).write(
            const GuestInvitesCompanion(
              isRevoked: Value(true),
              activeDeviceId: Value(null),
            ),
          );

      if (rowsAffected == 0) {
        return Failure(DatabaseError.notFound('GuestInvite', id));
      }

      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(DatabaseError.updateFailed('guest_invites', id, e, stack));
    }
  }

  /// Permanently delete an invite.
  Future<Result<void, AppError>> hardDelete(String id) async {
    try {
      final rowsAffected = await (delete(
        guestInvites,
      )..where((g) => g.id.equals(id))).go();

      if (rowsAffected == 0) {
        return Failure(DatabaseError.notFound('GuestInvite', id));
      }

      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(DatabaseError.deleteFailed('guest_invites', id, e, stack));
    }
  }

  /// Convert database row to domain GuestInvite entity.
  domain.GuestInvite _rowToEntity(GuestInviteRow row) => domain.GuestInvite(
    id: row.id,
    profileId: row.profileId,
    token: row.token,
    label: row.label,
    createdAt: row.createdAt,
    expiresAt: row.expiresAt,
    isRevoked: row.isRevoked,
    lastSeenAt: row.lastSeenAt,
    activeDeviceId: row.activeDeviceId,
  );

  /// Convert domain GuestInvite entity to database companion.
  GuestInvitesCompanion _entityToCompanion(domain.GuestInvite entity) =>
      GuestInvitesCompanion(
        id: Value(entity.id),
        profileId: Value(entity.profileId),
        token: Value(entity.token),
        label: Value(entity.label),
        createdAt: Value(entity.createdAt),
        expiresAt: Value(entity.expiresAt),
        isRevoked: Value(entity.isRevoked),
        lastSeenAt: Value(entity.lastSeenAt),
        activeDeviceId: Value(entity.activeDeviceId),
      );
}
