// test/unit/core/services/encryption_service_test.dart

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/services/encryption_service.dart';

@GenerateMocks([FlutterSecureStorage])
import 'encryption_service_test.mocks.dart';

void main() {
  late MockFlutterSecureStorage mockStorage;
  late EncryptionService service;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    service = EncryptionService(mockStorage);
  });

  group('EncryptionService', () {
    group('initialization', () {
      test('generates and stores key when none exists', () async {
        when(mockStorage.read(key: 'shadow_encryption_key_v1'))
            .thenAnswer((_) async => null);
        when(mockStorage.write(
          key: anyNamed('key'),
          value: anyNamed('value'),
        )).thenAnswer((_) async {});

        await service.initialize();

        expect(service.isInitialized, isTrue);
        verify(mockStorage.write(
          key: 'shadow_encryption_key_v1',
          value: anyNamed('value'),
        )).called(1);
      });

      test('loads existing key from storage', () async {
        final existingKey = base64Encode(List.generate(32, (i) => i));
        when(mockStorage.read(key: 'shadow_encryption_key_v1'))
            .thenAnswer((_) async => existingKey);

        await service.initialize();

        expect(service.isInitialized, isTrue);
        verifyNever(mockStorage.write(
          key: anyNamed('key'),
          value: anyNamed('value'),
        ));
      });

      test('isInitialized returns false before initialize()', () {
        expect(service.isInitialized, isFalse);
      });
    });

    group('generateKey()', () {
      test('returns 32-byte key (256 bits)', () {
        final key = service.generateKey();
        expect(key.length, equals(32));
      });

      test('generates different keys on each call', () {
        final key1 = service.generateKey();
        final key2 = service.generateKey();

        // Extremely unlikely to be equal if truly random
        expect(key1, isNot(equals(key2)));
      });

      test('returns Uint8List', () {
        final key = service.generateKey();
        expect(key, isA<Uint8List>());
      });
    });

    group('encrypt()', () {
      setUp(() async {
        final testKey = base64Encode(List.generate(32, (i) => i));
        when(mockStorage.read(key: 'shadow_encryption_key_v1'))
            .thenAnswer((_) async => testKey);
        await service.initialize();
      });

      test('throws StateError when not initialized', () async {
        final uninitializedService = EncryptionService(mockStorage);

        expect(
          () => uninitializedService.encrypt('test'),
          throwsStateError,
        );
      });

      test('returns string in format nonce:ciphertext:tag', () async {
        final encrypted = await service.encrypt('test message');

        final parts = encrypted.split(':');
        expect(parts.length, equals(3));

        // All parts should be valid base64
        expect(() => base64Decode(parts[0]), returnsNormally);
        expect(() => base64Decode(parts[1]), returnsNormally);
        expect(() => base64Decode(parts[2]), returnsNormally);
      });

      test('nonce is 12 bytes (96 bits)', () async {
        final encrypted = await service.encrypt('test');
        final nonce = base64Decode(encrypted.split(':')[0]);

        expect(nonce.length, equals(12));
      });

      test('tag is 16 bytes (128 bits)', () async {
        final encrypted = await service.encrypt('test');
        final tag = base64Decode(encrypted.split(':')[2]);

        expect(tag.length, equals(16));
      });

      test('produces different output for same input (unique nonce)', () async {
        final encrypted1 = await service.encrypt('same message');
        final encrypted2 = await service.encrypt('same message');

        // Different nonces mean different ciphertext
        expect(encrypted1, isNot(equals(encrypted2)));
      });

      test('handles empty string', () async {
        final encrypted = await service.encrypt('');

        expect(encrypted.split(':').length, equals(3));
      });

      test('handles unicode characters', () async {
        final encrypted = await service.encrypt('Hello, \u4e16\u754c! \ud83d\ude00');

        expect(encrypted.split(':').length, equals(3));
      });

      test('handles long strings', () async {
        final longString = 'a' * 10000;
        final encrypted = await service.encrypt(longString);

        expect(encrypted.split(':').length, equals(3));
      });
    });

    group('decrypt()', () {
      setUp(() async {
        final testKey = base64Encode(List.generate(32, (i) => i));
        when(mockStorage.read(key: 'shadow_encryption_key_v1'))
            .thenAnswer((_) async => testKey);
        await service.initialize();
      });

      test('throws StateError when not initialized', () async {
        final uninitializedService = EncryptionService(mockStorage);

        expect(
          () => uninitializedService.decrypt('test'),
          throwsStateError,
        );
      });

      test('throws DecryptionException for invalid format', () async {
        expect(
          () => service.decrypt('invalid'),
          throwsA(isA<DecryptionException>()),
        );

        expect(
          () => service.decrypt('only:two'),
          throwsA(isA<DecryptionException>()),
        );

        expect(
          () => service.decrypt('one:two:three:four'),
          throwsA(isA<DecryptionException>()),
        );
      });

      test('throws DecryptionException for invalid base64', () async {
        expect(
          () => service.decrypt('!!!:${base64Encode([1, 2, 3])}:${base64Encode([1, 2, 3])}'),
          throwsA(isA<DecryptionException>()),
        );
      });

      test('throws DecryptionException for invalid nonce length', () async {
        final shortNonce = base64Encode([1, 2, 3]); // Only 3 bytes
        final ciphertext = base64Encode([1, 2, 3, 4]);
        final tag = base64Encode(List.filled(16, 0));

        expect(
          () => service.decrypt('$shortNonce:$ciphertext:$tag'),
          throwsA(isA<DecryptionException>()),
        );
      });

      test('throws DecryptionException for invalid tag length', () async {
        final nonce = base64Encode(List.filled(12, 0));
        final ciphertext = base64Encode([1, 2, 3, 4]);
        final shortTag = base64Encode([1, 2, 3]); // Only 3 bytes

        expect(
          () => service.decrypt('$nonce:$ciphertext:$shortTag'),
          throwsA(isA<DecryptionException>()),
        );
      });

      test('throws DecryptionException for tampered ciphertext', () async {
        final encrypted = await service.encrypt('original message');
        final parts = encrypted.split(':');

        // Tamper with ciphertext
        final ciphertext = base64Decode(parts[1]);
        if (ciphertext.isNotEmpty) {
          ciphertext[0] = (ciphertext[0] + 1) % 256;
        }
        final tampered = '${parts[0]}:${base64Encode(ciphertext)}:${parts[2]}';

        expect(
          () => service.decrypt(tampered),
          throwsA(isA<DecryptionException>()),
        );
      });

      test('throws DecryptionException for tampered tag', () async {
        final encrypted = await service.encrypt('original message');
        final parts = encrypted.split(':');

        // Tamper with tag
        final tag = base64Decode(parts[2]);
        tag[0] = (tag[0] + 1) % 256;
        final tampered = '${parts[0]}:${parts[1]}:${base64Encode(tag)}';

        expect(
          () => service.decrypt(tampered),
          throwsA(isA<DecryptionException>()),
        );
      });
    });

    group('encrypt/decrypt round-trip', () {
      setUp(() async {
        final testKey = base64Encode(List.generate(32, (i) => i));
        when(mockStorage.read(key: 'shadow_encryption_key_v1'))
            .thenAnswer((_) async => testKey);
        await service.initialize();
      });

      test('decrypts to original plaintext', () async {
        const original = 'Hello, World!';
        final encrypted = await service.encrypt(original);
        final decrypted = await service.decrypt(encrypted);

        expect(decrypted, equals(original));
      });

      test('handles empty string', () async {
        const original = '';
        final encrypted = await service.encrypt(original);
        final decrypted = await service.decrypt(encrypted);

        expect(decrypted, equals(original));
      });

      test('handles unicode characters', () async {
        const original = 'Hello, \u4e16\u754c! \ud83d\ude00\ud83c\udf89';
        final encrypted = await service.encrypt(original);
        final decrypted = await service.decrypt(encrypted);

        expect(decrypted, equals(original));
      });

      test('handles JSON data', () async {
        const jsonData = '{"id":"123","name":"Test","values":[1,2,3]}';
        final encrypted = await service.encrypt(jsonData);
        final decrypted = await service.decrypt(encrypted);

        expect(decrypted, equals(jsonData));
        expect(jsonDecode(decrypted), isA<Map>());
      });

      test('handles long strings', () async {
        final original = 'a' * 10000;
        final encrypted = await service.encrypt(original);
        final decrypted = await service.decrypt(encrypted);

        expect(decrypted, equals(original));
      });

      test('handles special characters', () async {
        const original = 'Special: \n\t\r\x00\x1f "\'\\/<>&';
        final encrypted = await service.encrypt(original);
        final decrypted = await service.decrypt(encrypted);

        expect(decrypted, equals(original));
      });

      test('handles multiline text', () async {
        const original = '''Line 1
Line 2
Line 3''';
        final encrypted = await service.encrypt(original);
        final decrypted = await service.decrypt(encrypted);

        expect(decrypted, equals(original));
      });
    });
  });

  group('DecryptionException', () {
    test('toString includes message', () {
      final exception = DecryptionException('test error');
      expect(exception.toString(), contains('test error'));
    });

    test('message property is accessible', () {
      final exception = DecryptionException('test message');
      expect(exception.message, equals('test message'));
    });
  });
}
