// test/unit/data/cloud/google_auth_client_test.dart
// Tests for GoogleAuthClient header injection.

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:shadow_app/data/cloud/google_auth_client.dart';

void main() {
  group('GoogleAuthClient', () {
    test('extends BaseClient', () {
      final client = GoogleAuthClient({'Authorization': 'Bearer token'});
      expect(client, isA<http.BaseClient>());
      client.close();
    });

    test('accepts authorization headers', () {
      final headers = {'Authorization': 'Bearer test_token_123'};
      final authClient = GoogleAuthClient(headers);
      expect(authClient, isA<http.BaseClient>());
      authClient.close();
    });

    test('accepts empty headers map', () {
      final client = GoogleAuthClient({});
      expect(client, isA<http.BaseClient>());
      client.close();
    });

    test('accepts multiple headers', () {
      final headers = {
        'Authorization': 'Bearer token123',
        'X-Custom-Header': 'custom-value',
      };
      final client = GoogleAuthClient(headers);
      expect(client, isA<http.BaseClient>());
      client.close();
    });

    test('close does not throw', () {
      final client = GoogleAuthClient({'Authorization': 'Bearer token'});
      expect(client.close, returnsNormally);
    });
  });
}
