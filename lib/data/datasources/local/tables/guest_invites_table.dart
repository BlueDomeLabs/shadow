// lib/data/datasources/local/tables/guest_invites_table.dart
// Drift table definition for guest_invites per 22_API_CONTRACTS.md Section 18.4

import 'package:drift/drift.dart';

/// Drift table definition for guest invites.
///
/// Stores active invites allowing guest devices to access a single profile.
/// See 56_GUEST_PROFILE_ACCESS.md for full feature spec.
///
/// NOTE: @DataClassName('GuestInviteRow') avoids conflict with domain entity GuestInvite.
@DataClassName('GuestInviteRow')
class GuestInvites extends Table {
  // Primary key
  TextColumn get id => text()();

  // Required fields
  TextColumn get profileId => text().named('profile_id')();
  TextColumn get token => text().unique()();
  TextColumn get label => text().withDefault(const Constant(''))();
  IntColumn get createdAt => integer().named('created_at')();

  // Optional fields
  IntColumn get expiresAt => integer().named('expires_at').nullable()();
  BoolColumn get isRevoked =>
      boolean().named('is_revoked').withDefault(const Constant(false))();
  IntColumn get lastSeenAt => integer().named('last_seen_at').nullable()();
  TextColumn get activeDeviceId =>
      text().named('active_device_id').nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  String get tableName => 'guest_invites';
}
