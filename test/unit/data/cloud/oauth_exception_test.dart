// test/unit/data/cloud/oauth_exception_test.dart
// Tests for OAuth exception classes per Coding Standards Section 4.

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/data/cloud/oauth_exception.dart';

void main() {
  group('OAuthException', () {
    test('creates with required message', () {
      const exception = OAuthException(message: 'test error');
      expect(exception.message, 'test error');
      expect(exception.errorCode, isNull);
      expect(exception.details, isNull);
    });

    test('creates with all parameters', () {
      const exception = OAuthException(
        message: 'Authorization failed',
        errorCode: 'access_denied',
        details: 'User denied access',
      );
      expect(exception.message, 'Authorization failed');
      expect(exception.errorCode, 'access_denied');
      expect(exception.details, 'User denied access');
    });

    test('implements Exception', () {
      const exception = OAuthException(message: 'test');
      expect(exception, isA<Exception>());
    });

    test('toString includes message', () {
      const exception = OAuthException(message: 'test error');
      expect(exception.toString(), contains('test error'));
    });

    test('toString includes error code when present', () {
      const exception = OAuthException(
        message: 'test',
        errorCode: 'invalid_grant',
      );
      expect(exception.toString(), contains('[invalid_grant]'));
    });

    test('toString includes details when present', () {
      const exception = OAuthException(
        message: 'test',
        details: 'Token expired',
      );
      expect(exception.toString(), contains('Token expired'));
    });

    test('toString includes all fields when present', () {
      const exception = OAuthException(
        message: 'Token exchange failed',
        errorCode: 'exchange_failed',
        details: 'Invalid code',
      );
      final str = exception.toString();
      expect(str, contains('Token exchange failed'));
      expect(str, contains('[exchange_failed]'));
      expect(str, contains('Invalid code'));
    });

    test('can be used as const', () {
      const exception1 = OAuthException(message: 'test');
      const exception2 = OAuthException(message: 'test');
      expect(identical(exception1, exception2), isTrue);
    });
  });

  group('OAuthStateException', () {
    test('creates with required parameters', () {
      const exception = OAuthStateException(
        message: 'State parameter mismatch',
        expectedState: 'abc123',
        receivedState: 'xyz789',
      );
      expect(exception.message, 'State parameter mismatch');
      expect(exception.expectedState, 'abc123');
      expect(exception.receivedState, 'xyz789');
    });

    test('has default errorCode of state_mismatch', () {
      const exception = OAuthStateException(
        message: 'test',
        expectedState: 'a',
        receivedState: 'b',
      );
      expect(exception.errorCode, 'state_mismatch');
    });

    test('extends OAuthException', () {
      const exception = OAuthStateException(
        message: 'test',
        expectedState: 'a',
        receivedState: 'b',
      );
      expect(exception, isA<OAuthException>());
      expect(exception, isA<Exception>());
    });

    test('preserves custom errorCode', () {
      const exception = OAuthStateException(
        message: 'test',
        expectedState: 'a',
        receivedState: 'b',
        errorCode: 'custom_state_error',
      );
      expect(exception.errorCode, 'custom_state_error');
    });

    test('preserves details', () {
      const exception = OAuthStateException(
        message: 'test',
        expectedState: 'a',
        receivedState: 'b',
        details: 'Possible CSRF attack',
      );
      expect(exception.details, 'Possible CSRF attack');
    });

    test('can be used as const', () {
      const exception1 = OAuthStateException(
        message: 'test',
        expectedState: 'a',
        receivedState: 'b',
      );
      const exception2 = OAuthStateException(
        message: 'test',
        expectedState: 'a',
        receivedState: 'b',
      );
      expect(identical(exception1, exception2), isTrue);
    });
  });
}
