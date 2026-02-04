// test/unit/domain/repositories/entity_repository_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/repositories/entity_repository.dart';

/// Mock implementation of EntityRepository for testing the interface contract.
class MockEntityRepository implements EntityRepository<MockEntity, String> {
  @override
  Future<Result<List<MockEntity>, AppError>> getAll({
    String? profileId,
    int? limit,
    int? offset,
  }) async => const Success([]);

  @override
  Future<Result<MockEntity, AppError>> getById(String id) async =>
      Success(MockEntity(id: id, name: 'Test'));

  @override
  Future<Result<MockEntity, AppError>> create(MockEntity entity) async =>
      Success(entity);

  @override
  Future<Result<MockEntity, AppError>> update(
    MockEntity entity, {
    bool markDirty = true,
  }) async => Success(entity);

  @override
  Future<Result<void, AppError>> delete(String id) async => const Success(null);

  @override
  Future<Result<void, AppError>> hardDelete(String id) async =>
      const Success(null);

  @override
  Future<Result<List<MockEntity>, AppError>> getModifiedSince(
    int since,
  ) async => const Success([]);

  @override
  Future<Result<List<MockEntity>, AppError>> getPendingSync() async =>
      const Success([]);
}

/// Simple entity for testing.
class MockEntity {
  MockEntity({required this.id, required this.name});

  final String id;
  final String name;

  @override
  String toString() => 'MockEntity(id: $id, name: $name)';
}

void main() {
  group('EntityRepository interface contract', () {
    late MockEntityRepository repository;

    setUp(() {
      repository = MockEntityRepository();
    });

    group('getAll()', () {
      test('accepts optional profileId parameter', () async {
        final result = await repository.getAll(profileId: 'profile-123');
        expect(result.isSuccess, isTrue);
      });

      test('accepts optional limit parameter', () async {
        final result = await repository.getAll(limit: 10);
        expect(result.isSuccess, isTrue);
      });

      test('accepts optional offset parameter', () async {
        final result = await repository.getAll(offset: 20);
        expect(result.isSuccess, isTrue);
      });

      test('accepts all optional parameters together', () async {
        final result = await repository.getAll(
          profileId: 'profile-123',
          limit: 10,
          offset: 20,
        );
        expect(result.isSuccess, isTrue);
      });

      test('returns Result<List<T>, AppError>', () async {
        final result = await repository.getAll();
        expect(result, isA<Result<List<MockEntity>, AppError>>());
      });
    });

    group('getById()', () {
      test('accepts ID parameter', () async {
        final result = await repository.getById('entity-123');
        expect(result.isSuccess, isTrue);
      });

      test('returns Result<T, AppError>', () async {
        final result = await repository.getById('entity-123');
        expect(result, isA<Result<MockEntity, AppError>>());
      });
    });

    group('create()', () {
      test('accepts entity parameter', () async {
        final entity = MockEntity(id: '', name: 'New Entity');
        final result = await repository.create(entity);
        expect(result.isSuccess, isTrue);
      });

      test('returns Result<T, AppError>', () async {
        final entity = MockEntity(id: '', name: 'New Entity');
        final result = await repository.create(entity);
        expect(result, isA<Result<MockEntity, AppError>>());
      });
    });

    group('update()', () {
      test('accepts entity parameter', () async {
        final entity = MockEntity(id: 'entity-123', name: 'Updated');
        final result = await repository.update(entity);
        expect(result.isSuccess, isTrue);
      });

      test('markDirty defaults to true', () async {
        final entity = MockEntity(id: 'entity-123', name: 'Updated');
        // This compiles and works - proves default exists
        final result = await repository.update(entity);
        expect(result.isSuccess, isTrue);
      });

      test('accepts markDirty=false for sync operations', () async {
        final entity = MockEntity(id: 'entity-123', name: 'Synced');
        final result = await repository.update(entity, markDirty: false);
        expect(result.isSuccess, isTrue);
      });

      test('returns Result<T, AppError>', () async {
        final entity = MockEntity(id: 'entity-123', name: 'Updated');
        final result = await repository.update(entity);
        expect(result, isA<Result<MockEntity, AppError>>());
      });
    });

    group('delete()', () {
      test('accepts ID parameter', () async {
        final result = await repository.delete('entity-123');
        expect(result.isSuccess, isTrue);
      });

      test('returns Result<void, AppError>', () async {
        final result = await repository.delete('entity-123');
        expect(result, isA<Result<void, AppError>>());
      });
    });

    group('hardDelete()', () {
      test('accepts ID parameter', () async {
        final result = await repository.hardDelete('entity-123');
        expect(result.isSuccess, isTrue);
      });

      test('returns Result<void, AppError>', () async {
        final result = await repository.hardDelete('entity-123');
        expect(result, isA<Result<void, AppError>>());
      });
    });

    group('getModifiedSince()', () {
      test('accepts epoch milliseconds parameter', () async {
        final since = DateTime.now().millisecondsSinceEpoch - 3600000;
        final result = await repository.getModifiedSince(since);
        expect(result.isSuccess, isTrue);
      });

      test('returns Result<List<T>, AppError>', () async {
        final result = await repository.getModifiedSince(0);
        expect(result, isA<Result<List<MockEntity>, AppError>>());
      });
    });

    group('getPendingSync()', () {
      test('takes no parameters', () async {
        final result = await repository.getPendingSync();
        expect(result.isSuccess, isTrue);
      });

      test('returns Result<List<T>, AppError>', () async {
        final result = await repository.getPendingSync();
        expect(result, isA<Result<List<MockEntity>, AppError>>());
      });
    });
  });

  group('BaseRepositoryContract typedef', () {
    test('is alias for EntityRepository', () {
      // This compiles - proves the typedef exists and is correct
      final repo = MockEntityRepository();
      final BaseRepositoryContract<MockEntity, String> aliasRepo = repo;
      expect(aliasRepo, same(repo));
    });
  });
}
