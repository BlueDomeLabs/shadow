// lib/domain/services/local_profile_authorization_service.dart
// Local-only implementation that allows full access for all profiles.

import 'package:shadow_app/domain/services/profile_authorization_service.dart';

/// Local profile authorization service that allows all access.
///
/// Used when running without cloud sync — every profile on the device
/// is fully accessible to the local user.
class LocalProfileAuthorizationService implements ProfileAuthorizationService {
  @override
  Future<bool> canRead(String profileId) async => true;

  @override
  Future<bool> canWrite(String profileId) async => true;

  @override
  Future<bool> isOwner(String profileId) async => true;

  @override
  Future<List<ProfileAccess>> getAccessibleProfiles() async => [];
}
