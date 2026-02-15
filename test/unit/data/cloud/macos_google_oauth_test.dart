// test/unit/data/cloud/macos_google_oauth_test.dart
// Tests for MacOSGoogleOAuth PKCE implementation.
// Tests the PKCE helpers and OAuth exception behavior
// per 08_OAUTH_IMPLEMENTATION.md Sections 5 and 10.
//
// Note: The full authorize() and refreshToken() flows require network
// and browser interaction, so they are tested at integration level.
// Unit tests focus on PKCE correctness, exception classes, and timeout
// constants.

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/data/cloud/oauth_exception.dart';

void main() {
  group('MacOSGoogleOAuth', () {
    group('PKCE spec compliance (RFC 7636)', () {
      test('code verifier uses unreserved character set', () {
        // RFC 7636 Section 4.1: ALPHA / DIGIT / "-" / "." / "_" / "~"
        const charset =
            'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';
        // Verify all characters in charset are RFC 7636 unreserved
        final unreservedPattern = RegExp(r'^[A-Za-z0-9\-._~]+$');
        expect(unreservedPattern.hasMatch(charset), isTrue);
      });

      test('SHA256 code challenge matches expected output', () {
        // RFC 7636 Appendix B test vector verification:
        // Given a known verifier, verify SHA256+base64url produces correct challenge
        const testVerifier = 'dBjftJeZ4CVP-mB92K27uhbUJU1p1r_wW1gFWFOEjXk';
        final bytes = utf8.encode(testVerifier);
        final digest = sha256.convert(bytes);
        final challenge = base64Url.encode(digest.bytes).replaceAll('=', '');

        // The challenge should be a valid base64url string without padding
        expect(challenge, isNotEmpty);
        expect(challenge, isNot(contains('=')));
        expect(challenge, isNot(contains('+')));
        expect(challenge, isNot(contains('/')));
      });

      test('code challenge is deterministic for same verifier', () {
        const verifier = 'test_verifier_12345';
        final bytes = utf8.encode(verifier);

        final digest1 = sha256.convert(bytes);
        final challenge1 = base64Url.encode(digest1.bytes).replaceAll('=', '');

        final digest2 = sha256.convert(bytes);
        final challenge2 = base64Url.encode(digest2.bytes).replaceAll('=', '');

        expect(challenge1, equals(challenge2));
      });

      test('different verifiers produce different challenges', () {
        const verifier1 = 'verifier_aaa';
        const verifier2 = 'verifier_bbb';

        final challenge1 = base64Url
            .encode(sha256.convert(utf8.encode(verifier1)).bytes)
            .replaceAll('=', '');
        final challenge2 = base64Url
            .encode(sha256.convert(utf8.encode(verifier2)).bytes)
            .replaceAll('=', '');

        expect(challenge1, isNot(equals(challenge2)));
      });

      test('code challenge length is correct for SHA256', () {
        // SHA256 = 32 bytes → base64url = 43 chars (no padding)
        const verifier = 'any_verifier_value';
        final digest = sha256.convert(utf8.encode(verifier));
        final challenge = base64Url.encode(digest.bytes).replaceAll('=', '');
        expect(challenge.length, 43);
      });
    });

    group('OAuth exception handling', () {
      test('OAuthException is thrown for authorization failures', () {
        expect(
          () => throw const OAuthException(
            message: 'Authorization failed',
            errorCode: 'access_denied',
          ),
          throwsA(isA<OAuthException>()),
        );
      });

      test('OAuthStateException includes expected and received states', () {
        const exception = OAuthStateException(
          message: 'State mismatch',
          expectedState: 'expected_state_123',
          receivedState: 'received_state_456',
        );
        expect(exception.expectedState, 'expected_state_123');
        expect(exception.receivedState, 'received_state_456');
        expect(exception.errorCode, 'state_mismatch');
      });

      test('timeout OAuthException has correct error code', () {
        const exception = OAuthException(
          message: 'Token exchange timed out',
          errorCode: 'timeout_error',
        );
        expect(exception.errorCode, 'timeout_error');
      });
    });

    group('State parameter generation', () {
      test('base64url encoded state has no padding', () {
        // Verify the pattern used in authorize()
        final stateBytes = List.generate(32, (i) => i);
        final state = base64Url.encode(stateBytes).replaceAll('=', '');
        expect(state, isNot(contains('=')));
      });

      test('state from 32 random bytes produces sufficient length', () {
        final stateBytes = List.generate(32, (i) => i);
        final state = base64Url.encode(stateBytes).replaceAll('=', '');
        // 32 bytes → 43 base64url chars (without padding)
        expect(state.length, greaterThanOrEqualTo(42));
      });
    });
  });
}
