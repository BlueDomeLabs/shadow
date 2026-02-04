// test/unit/core/result_test.dart - Tests for Result type per 22_API_CONTRACTS.md

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/types/result.dart';

void main() {
  group('Result', () {
    group('Success', () {
      test('isSuccess returns true', () {
        const result = Success<int, String>(42);
        expect(result.isSuccess, isTrue);
      });

      test('isFailure returns false', () {
        const result = Success<int, String>(42);
        expect(result.isFailure, isFalse);
      });

      test('valueOrNull returns the value', () {
        const result = Success<int, String>(42);
        expect(result.valueOrNull, equals(42));
      });

      test('errorOrNull returns null', () {
        const result = Success<int, String>(42);
        expect(result.errorOrNull, isNull);
      });

      test('when() calls success callback with value', () {
        const result = Success<int, String>(42);
        final output = result.when(
          success: (value) => 'Got: $value',
          failure: (error) => 'Error: $error',
        );
        expect(output, equals('Got: 42'));
      });

      test('can hold null value', () {
        const result = Success<int?, String>(null);
        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isNull);
      });

      test('can hold complex types', () {
        const result = Success<List<int>, String>([1, 2, 3]);
        expect(result.valueOrNull, equals([1, 2, 3]));
      });
    });

    group('Failure', () {
      test('isSuccess returns false', () {
        const result = Failure<int, String>('error');
        expect(result.isSuccess, isFalse);
      });

      test('isFailure returns true', () {
        const result = Failure<int, String>('error');
        expect(result.isFailure, isTrue);
      });

      test('valueOrNull returns null', () {
        const result = Failure<int, String>('error');
        expect(result.valueOrNull, isNull);
      });

      test('errorOrNull returns the error', () {
        const result = Failure<int, String>('error');
        expect(result.errorOrNull, equals('error'));
      });

      test('when() calls failure callback with error', () {
        const result = Failure<int, String>('oops');
        final output = result.when(
          success: (value) => 'Got: $value',
          failure: (error) => 'Error: $error',
        );
        expect(output, equals('Error: oops'));
      });

      test('can hold complex error types', () {
        final exception = Exception('test');
        final result = Failure<int, Exception>(exception);
        expect(result.errorOrNull, equals(exception));
      });
    });

    group('Type safety', () {
      test('Result can be used with AppError types', () {
        // This test verifies the type system works as expected
        Result<String, String> createResult({required bool succeed}) {
          if (succeed) {
            return const Success('data');
          } else {
            return const Failure('error');
          }
        }

        final success = createResult(succeed: true);
        final failure = createResult(succeed: false);

        expect(success.isSuccess, isTrue);
        expect(failure.isFailure, isTrue);
      });

      test('when() return type is properly inferred', () {
        const Result<int, String> result = Success(42);

        // Return type should be int
        final intResult = result.when(
          success: (value) => value * 2,
          failure: (error) => -1,
        );
        expect(intResult, equals(84));

        // Return type should be String
        final stringResult = result.when(
          success: (value) => value.toString(),
          failure: (error) => error,
        );
        expect(stringResult, equals('42'));
      });
    });
  });
}
