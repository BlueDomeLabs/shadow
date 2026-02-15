// test/unit/core/config/secure_storage_keys_test.dart
// Tests for SecureStorageKeys per 08_OAUTH_IMPLEMENTATION.md Section 7.1.

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/config/secure_storage_keys.dart';

void main() {
  group('SecureStorageKeys', () {
    test('googleDriveAccessToken matches spec value', () {
      expect(
        SecureStorageKeys.googleDriveAccessToken,
        'google_drive_access_token',
      );
    });

    test('googleDriveRefreshToken matches spec value', () {
      expect(
        SecureStorageKeys.googleDriveRefreshToken,
        'google_drive_refresh_token',
      );
    });

    test('googleDriveTokenExpiry matches spec value', () {
      expect(
        SecureStorageKeys.googleDriveTokenExpiry,
        'google_drive_token_expiry',
      );
    });

    test('googleDriveUserEmail matches spec value', () {
      expect(SecureStorageKeys.googleDriveUserEmail, 'google_drive_user_email');
    });

    test('googleDriveLegacyTokens matches spec value', () {
      expect(
        SecureStorageKeys.googleDriveLegacyTokens,
        'google_drive_macos_tokens',
      );
    });

    test('all keys are unique', () {
      final keys = [
        SecureStorageKeys.googleDriveAccessToken,
        SecureStorageKeys.googleDriveRefreshToken,
        SecureStorageKeys.googleDriveTokenExpiry,
        SecureStorageKeys.googleDriveUserEmail,
        SecureStorageKeys.googleDriveLegacyTokens,
      ];
      expect(keys.toSet().length, keys.length);
    });

    test('all keys use google_drive prefix for namespacing', () {
      final keys = [
        SecureStorageKeys.googleDriveAccessToken,
        SecureStorageKeys.googleDriveRefreshToken,
        SecureStorageKeys.googleDriveTokenExpiry,
        SecureStorageKeys.googleDriveUserEmail,
        SecureStorageKeys.googleDriveLegacyTokens,
      ];
      for (final key in keys) {
        expect(key, startsWith('google_drive_'));
      }
    });
  });
}
