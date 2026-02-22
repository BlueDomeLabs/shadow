// lib/data/repositories/guest_invite_repository_impl.dart
// Repository implementation for GuestInvite per 22_API_CONTRACTS.md Section 18.2

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/daos/guest_invite_dao.dart';
import 'package:shadow_app/domain/entities/guest_invite.dart';
import 'package:shadow_app/domain/repositories/guest_invite_repository.dart';

/// Implementation of GuestInviteRepository.
///
/// Delegates directly to GuestInviteDao. Unlike health data repositories,
/// this does not extend BaseRepository because GuestInvite is not a
/// syncable entity — it has no SyncMetadata.
class GuestInviteRepositoryImpl implements GuestInviteRepository {
  final GuestInviteDao _dao;

  GuestInviteRepositoryImpl(this._dao);

  @override
  Future<Result<GuestInvite, AppError>> create(GuestInvite invite) =>
      _dao.create(invite);

  @override
  Future<Result<GuestInvite, AppError>> getById(String id) => _dao.getById(id);

  @override
  Future<Result<GuestInvite?, AppError>> getByToken(String token) =>
      _dao.getByToken(token);

  @override
  Future<Result<List<GuestInvite>, AppError>> getByProfile(String profileId) =>
      _dao.getByProfile(profileId);

  @override
  Future<Result<GuestInvite, AppError>> update(GuestInvite invite) =>
      _dao.updateEntity(invite);

  @override
  Future<Result<void, AppError>> revoke(String id) => _dao.revoke(id);

  @override
  Future<Result<void, AppError>> hardDelete(String id) => _dao.hardDelete(id);
}
