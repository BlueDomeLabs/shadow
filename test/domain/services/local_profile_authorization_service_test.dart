// test/domain/services/local_profile_authorization_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/services/local_profile_authorization_service.dart';

void main() {
  group('LocalProfileAuthorizationService', () {
    late LocalProfileAuthorizationService service;

    setUp(() {
      service = LocalProfileAuthorizationService();
    });

    test('canRead returns true for any profileId', () async {
      expect(await service.canRead('profile-1'), true);
      expect(await service.canRead('profile-2'), true);
      expect(await service.canRead(''), true);
    });

    test('canWrite returns true for any profileId', () async {
      expect(await service.canWrite('profile-1'), true);
      expect(await service.canWrite('profile-2'), true);
      expect(await service.canWrite(''), true);
    });

    test('isOwner returns true for any profileId', () async {
      expect(await service.isOwner('profile-1'), true);
      expect(await service.isOwner('profile-2'), true);
      expect(await service.isOwner(''), true);
    });

    test('getAccessibleProfiles returns empty list', () async {
      final profiles = await service.getAccessibleProfiles();
      expect(profiles, isEmpty);
    });
  });
}
