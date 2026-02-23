// test/core/services/deep_link_service_test.dart
// Tests for DeepLinkService URL parsing.

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/services/deep_link_service.dart';

void main() {
  group('DeepLinkService.parseInviteLink', () {
    test('parses valid shadow://invite URL', () {
      final result = DeepLinkService.parseInviteLink(
        'shadow://invite?token=abc-123&profile=profile-001',
      );

      expect(result, isNotNull);
      expect(result!.token, 'abc-123');
      expect(result.profileId, 'profile-001');
    });

    test('returns null for non-shadow scheme', () {
      final result = DeepLinkService.parseInviteLink(
        'https://invite?token=abc&profile=p1',
      );

      expect(result, isNull);
    });

    test('returns null for non-invite host', () {
      final result = DeepLinkService.parseInviteLink(
        'shadow://settings?token=abc&profile=p1',
      );

      expect(result, isNull);
    });

    test('returns null when token is missing', () {
      final result = DeepLinkService.parseInviteLink(
        'shadow://invite?profile=p1',
      );

      expect(result, isNull);
    });

    test('returns null when profile is missing', () {
      final result = DeepLinkService.parseInviteLink(
        'shadow://invite?token=abc',
      );

      expect(result, isNull);
    });

    test('returns null when token is empty', () {
      final result = DeepLinkService.parseInviteLink(
        'shadow://invite?token=&profile=p1',
      );

      expect(result, isNull);
    });

    test('returns null when profile is empty', () {
      final result = DeepLinkService.parseInviteLink(
        'shadow://invite?token=abc&profile=',
      );

      expect(result, isNull);
    });

    test('returns null for invalid URL', () {
      final result = DeepLinkService.parseInviteLink('not a url');

      expect(result, isNull);
    });

    test('handles URL-encoded token', () {
      final result = DeepLinkService.parseInviteLink(
        'shadow://invite?token=abc%20def&profile=p1',
      );

      expect(result, isNotNull);
      expect(result!.token, 'abc def');
    });
  });
}
