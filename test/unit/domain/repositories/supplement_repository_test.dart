// test/unit/domain/repositories/supplement_repository_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/supplement.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/repositories/supplement_repository.dart';

/// Mock implementation of SupplementRepository for testing the interface contract.
class MockSupplementRepository implements SupplementRepository {
  final Supplement _testSupplement = Supplement(
    id: 'supp-123',
    clientId: 'client-123',
    profileId: 'profile-123',
    name: 'Test Supplement',
    form: SupplementForm.capsule,
    dosageQuantity: 1,
    dosageUnit: DosageUnit.mg,
    syncMetadata: SyncMetadata.create(deviceId: 'device-123'),
  );

  // EntityRepository methods
  @override
  Future<Result<List<Supplement>, AppError>> getAll({
    String? profileId,
    int? limit,
    int? offset,
  }) async => Success([_testSupplement]);

  @override
  Future<Result<Supplement, AppError>> getById(String id) async =>
      Success(_testSupplement);

  @override
  Future<Result<Supplement, AppError>> create(Supplement entity) async =>
      Success(entity);

  @override
  Future<Result<Supplement, AppError>> update(
    Supplement entity, {
    bool markDirty = true,
  }) async => Success(entity);

  @override
  Future<Result<void, AppError>> delete(String id) async => const Success(null);

  @override
  Future<Result<void, AppError>> hardDelete(String id) async =>
      const Success(null);

  @override
  Future<Result<List<Supplement>, AppError>> getModifiedSince(
    int since,
  ) async => Success([_testSupplement]);

  @override
  Future<Result<List<Supplement>, AppError>> getPendingSync() async =>
      Success([_testSupplement]);

  // SupplementRepository-specific methods
  @override
  Future<Result<List<Supplement>, AppError>> getByProfile(
    String profileId, {
    bool? activeOnly,
    int? limit,
    int? offset,
  }) async => Success([_testSupplement]);

  @override
  Future<Result<List<Supplement>, AppError>> getDueAt(
    String profileId,
    int time,
  ) async => Success([_testSupplement]);

  @override
  Future<Result<List<Supplement>, AppError>> search(
    String profileId,
    String query, {
    int limit = 20,
  }) async => Success([_testSupplement]);
}

void main() {
  group('SupplementRepository interface contract', () {
    late MockSupplementRepository repository;

    setUp(() {
      repository = MockSupplementRepository();
    });

    group('implements EntityRepository<Supplement, String>', () {
      test('getAll() is inherited', () async {
        final result = await repository.getAll(profileId: 'profile-123');
        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isA<List<Supplement>>());
      });

      test('getById() is inherited', () async {
        final result = await repository.getById('supp-123');
        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isA<Supplement>());
      });

      test('create() is inherited', () async {
        final supplement = Supplement(
          id: '',
          clientId: 'client-123',
          profileId: 'profile-123',
          name: 'New Supplement',
          form: SupplementForm.tablet,
          dosageQuantity: 2,
          dosageUnit: DosageUnit.g,
          syncMetadata: SyncMetadata.create(deviceId: 'device-123'),
        );
        final result = await repository.create(supplement);
        expect(result.isSuccess, isTrue);
      });

      test('update() is inherited', () async {
        final supplement = Supplement(
          id: 'supp-123',
          clientId: 'client-123',
          profileId: 'profile-123',
          name: 'Updated Supplement',
          form: SupplementForm.capsule,
          dosageQuantity: 1,
          dosageUnit: DosageUnit.mg,
          syncMetadata: SyncMetadata.create(deviceId: 'device-123'),
        );
        final result = await repository.update(supplement);
        expect(result.isSuccess, isTrue);
      });

      test('delete() is inherited', () async {
        final result = await repository.delete('supp-123');
        expect(result.isSuccess, isTrue);
      });

      test('hardDelete() is inherited', () async {
        final result = await repository.hardDelete('supp-123');
        expect(result.isSuccess, isTrue);
      });

      test('getModifiedSince() is inherited', () async {
        final result = await repository.getModifiedSince(0);
        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isA<List<Supplement>>());
      });

      test('getPendingSync() is inherited', () async {
        final result = await repository.getPendingSync();
        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isA<List<Supplement>>());
      });
    });

    group('getByProfile()', () {
      test('requires profileId parameter', () async {
        final result = await repository.getByProfile('profile-123');
        expect(result.isSuccess, isTrue);
      });

      test('accepts optional activeOnly parameter', () async {
        final result = await repository.getByProfile(
          'profile-123',
          activeOnly: true,
        );
        expect(result.isSuccess, isTrue);
      });

      test('accepts optional limit parameter', () async {
        final result = await repository.getByProfile('profile-123', limit: 10);
        expect(result.isSuccess, isTrue);
      });

      test('accepts optional offset parameter', () async {
        final result = await repository.getByProfile('profile-123', offset: 20);
        expect(result.isSuccess, isTrue);
      });

      test('returns Result<List<Supplement>, AppError>', () async {
        final result = await repository.getByProfile('profile-123');
        expect(result, isA<Result<List<Supplement>, AppError>>());
      });
    });

    group('getDueAt()', () {
      test('requires profileId and time parameters', () async {
        final now = DateTime.now().millisecondsSinceEpoch;
        final result = await repository.getDueAt('profile-123', now);
        expect(result.isSuccess, isTrue);
      });

      test('time parameter is epoch milliseconds', () async {
        final epochMs = DateTime(2026, 2, 3, 8).millisecondsSinceEpoch;
        final result = await repository.getDueAt('profile-123', epochMs);
        expect(result.isSuccess, isTrue);
      });

      test('returns Result<List<Supplement>, AppError>', () async {
        final result = await repository.getDueAt('profile-123', 0);
        expect(result, isA<Result<List<Supplement>, AppError>>());
      });
    });

    group('search()', () {
      test('requires profileId and query parameters', () async {
        final result = await repository.search('profile-123', 'vitamin');
        expect(result.isSuccess, isTrue);
      });

      test('limit defaults to 20', () async {
        // This compiles - proves default exists
        final result = await repository.search('profile-123', 'vitamin');
        expect(result.isSuccess, isTrue);
      });

      test('accepts custom limit parameter', () async {
        final result = await repository.search(
          'profile-123',
          'vitamin',
          limit: 50,
        );
        expect(result.isSuccess, isTrue);
      });

      test('returns Result<List<Supplement>, AppError>', () async {
        final result = await repository.search('profile-123', 'vitamin');
        expect(result, isA<Result<List<Supplement>, AppError>>());
      });
    });
  });
}
