// test/unit/data/datasources/local/daos/diet_exception_dao_test.dart
// Phase 15b-1 — Tests for DietExceptionDao
// Per 59_DIET_TRACKING.md

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/domain/entities/diet_exception.dart';

void main() {
  group('DietExceptionDao', () {
    late AppDatabase database;

    setUp(() {
      database = AppDatabase(DatabaseConnection.inMemoryUnencrypted());
    });

    tearDown(() async {
      await database.close();
    });

    DietException createTestException({
      String? id,
      String ruleId = 'rule-001',
      String description = 'Hard aged cheeses',
      int sortOrder = 0,
    }) => DietException(
      id: id ?? 'exc-${DateTime.now().microsecondsSinceEpoch}',
      ruleId: ruleId,
      description: description,
      sortOrder: sortOrder,
    );

    group('insert', () {
      test('insert_validException_returnsSuccess', () async {
        final exc = createTestException(id: 'exc-001');

        final result = await database.dietExceptionDao.insert(exc);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.id, 'exc-001');
        expect(result.valueOrNull?.description, 'Hard aged cheeses');
      });

      test('insert_duplicateId_returnsFailure', () async {
        final e1 = createTestException(id: 'exc-dup');
        final e2 = createTestException(id: 'exc-dup');

        await database.dietExceptionDao.insert(e1);
        final result = await database.dietExceptionDao.insert(e2);

        expect(result.isFailure, isTrue);
        expect(
          (result.errorOrNull! as DatabaseError).code,
          DatabaseError.codeConstraintViolation,
        );
      });
    });

    group('getById', () {
      test('getById_existingException_returnsSuccess', () async {
        final exc = createTestException(id: 'exc-get');
        await database.dietExceptionDao.insert(exc);

        final result = await database.dietExceptionDao.getById('exc-get');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.id, 'exc-get');
      });

      test('getById_notFound_returnsFailure', () async {
        final result = await database.dietExceptionDao.getById('nonexistent');

        expect(result.isFailure, isTrue);
        expect(
          (result.errorOrNull! as DatabaseError).code,
          DatabaseError.codeNotFound,
        );
      });
    });

    group('getForRule', () {
      test('getForRule_returnsExceptionsOrderedBySortOrder', () async {
        final e1 = createTestException(id: 'exc-so2', sortOrder: 2);
        final e2 = createTestException(id: 'exc-so0');
        final e3 = createTestException(id: 'exc-so1', sortOrder: 1);

        await database.dietExceptionDao.insert(e1);
        await database.dietExceptionDao.insert(e2);
        await database.dietExceptionDao.insert(e3);

        final result = await database.dietExceptionDao.getForRule('rule-001');

        final ids = result.valueOrNull?.map((e) => e.id).toList();
        expect(ids, ['exc-so0', 'exc-so1', 'exc-so2']);
      });

      test('getForRule_differentRule_returnsCorrectExceptions', () async {
        final e1 = createTestException(id: 'exc-r1');
        final e2 = createTestException(id: 'exc-r2', ruleId: 'rule-002');
        await database.dietExceptionDao.insert(e1);
        await database.dietExceptionDao.insert(e2);

        final result = await database.dietExceptionDao.getForRule('rule-001');

        expect(result.valueOrNull?.length, 1);
        expect(result.valueOrNull?.first.id, 'exc-r1');
      });
    });

    group('deleteById', () {
      test('deleteById_existingException_returnsSuccess', () async {
        final exc = createTestException(id: 'exc-del');
        await database.dietExceptionDao.insert(exc);

        final result = await database.dietExceptionDao.deleteById('exc-del');

        expect(result.isSuccess, isTrue);
        final getResult = await database.dietExceptionDao.getById('exc-del');
        expect(getResult.isFailure, isTrue);
      });

      test('deleteById_notFound_returnsFailure', () async {
        final result = await database.dietExceptionDao.deleteById(
          'nonexistent',
        );

        expect(result.isFailure, isTrue);
      });
    });

    group('deleteForRule', () {
      test('deleteForRule_removesAllExceptionsForRule', () async {
        final e1 = createTestException(id: 'exc-fr1', ruleId: 'rule-del');
        final e2 = createTestException(id: 'exc-fr2', ruleId: 'rule-del');
        final other = createTestException(id: 'exc-other', ruleId: 'rule-keep');
        await database.dietExceptionDao.insert(e1);
        await database.dietExceptionDao.insert(e2);
        await database.dietExceptionDao.insert(other);

        await database.dietExceptionDao.deleteForRule('rule-del');

        final deleted = await database.dietExceptionDao.getForRule('rule-del');
        expect(deleted.valueOrNull, isEmpty);

        final kept = await database.dietExceptionDao.getForRule('rule-keep');
        expect(kept.valueOrNull?.length, 1);
      });
    });
  });
}
