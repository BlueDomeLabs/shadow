// lib/domain/services/profile_authorization_service.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 9.1

/// Service contract for profile-level authorization checks.
/// ALL use cases MUST use this service before accessing profile data.
abstract class ProfileAuthorizationService {
  /// Check if current user can read profile data.
  /// Returns true if access is granted.
  Future<bool> canRead(String profileId);

  /// Check if current user can write to profile.
  /// Returns true if access is granted.
  Future<bool> canWrite(String profileId);

  /// Check if current user owns the profile.
  /// Returns true if current user is the owner.
  Future<bool> isOwner(String profileId);

  /// Get all profiles current user can access.
  Future<List<ProfileAccess>> getAccessibleProfiles();
}

/// Represents access level for a profile.
class ProfileAccess {
  final String profileId;
  final String profileName;
  final AccessLevel accessLevel;
  final int? grantedAt; // Epoch milliseconds
  final int? expiresAt; // Epoch milliseconds
  final String? grantedBy; // Profile ID of granter (for shared profiles)

  const ProfileAccess({
    required this.profileId,
    required this.profileName,
    required this.accessLevel,
    this.grantedAt,
    this.expiresAt,
    this.grantedBy,
  });
}

/// Access levels for profile authorization.
enum AccessLevel {
  readOnly, // Can view data only
  readWrite, // Can view and modify data
  owner, // Full control including deletion and sharing
}
