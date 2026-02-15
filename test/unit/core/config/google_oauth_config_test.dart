// test/unit/core/config/google_oauth_config_test.dart
// Tests for GoogleOAuthConfig per 08_OAUTH_IMPLEMENTATION.md Section 4.

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/config/google_oauth_config.dart';

void main() {
  group('GoogleOAuthConfig', () {
    group('OAuth Endpoints', () {
      test('authUri matches spec Section 1.2', () {
        expect(
          GoogleOAuthConfig.authUri,
          'https://accounts.google.com/o/oauth2/auth',
        );
      });

      test('tokenUri matches spec Section 1.2', () {
        expect(
          GoogleOAuthConfig.tokenUri,
          'https://oauth2.googleapis.com/token',
        );
      });

      test('userInfoUri matches spec Section 1.2', () {
        expect(
          GoogleOAuthConfig.userInfoUri,
          'https://www.googleapis.com/oauth2/v2/userinfo',
        );
      });

      test('all endpoints use HTTPS', () {
        expect(GoogleOAuthConfig.authUri, startsWith('https://'));
        expect(GoogleOAuthConfig.tokenUri, startsWith('https://'));
        expect(GoogleOAuthConfig.userInfoUri, startsWith('https://'));
      });
    });

    group('Client Configuration', () {
      test('clientId returns development fallback when no env var set', () {
        // In test context, no --dart-define is set, so dev fallback applies
        final clientId = GoogleOAuthConfig.clientId;
        expect(clientId, isNotEmpty);
        expect(clientId, contains('.apps.googleusercontent.com'));
      });

      test('clientId matches spec Section 1.1 desktop client ID', () {
        final clientId = GoogleOAuthConfig.clientId;
        expect(
          clientId,
          '656246118580-nvu5ckn9l7vst8hmj8no3t7cb10egui3'
          '.apps.googleusercontent.com',
        );
      });

      test('redirectUri returns development fallback', () {
        // In test context, no --dart-define is set
        final redirectUri = GoogleOAuthConfig.redirectUri;
        expect(redirectUri, 'http://localhost:8080');
      });

      test('proxyBaseUrl returns development fallback', () {
        final proxyBaseUrl = GoogleOAuthConfig.proxyBaseUrl;
        expect(proxyBaseUrl, 'http://localhost:5000');
      });
    });

    group('Scopes', () {
      test('includes drive.file scope per spec Section 1.3', () {
        expect(
          GoogleOAuthConfig.scopes,
          contains('https://www.googleapis.com/auth/drive.file'),
        );
      });

      test('includes email scope', () {
        expect(GoogleOAuthConfig.scopes, contains('email'));
      });

      test('includes profile scope', () {
        expect(GoogleOAuthConfig.scopes, contains('profile'));
      });

      test('has exactly 3 scopes per spec', () {
        expect(GoogleOAuthConfig.scopes.length, 3);
      });

      test('uses drive.file not drive (HIPAA compliance)', () {
        for (final scope in GoogleOAuthConfig.scopes) {
          if (scope.contains('drive')) {
            expect(scope, contains('drive.file'));
          }
        }
      });
    });

    group('Validation', () {
      test('validate completes without error in dev mode', () {
        // Should not throw in debug/test mode
        expect(GoogleOAuthConfig.validate, returnsNormally);
      });
    });
  });
}
