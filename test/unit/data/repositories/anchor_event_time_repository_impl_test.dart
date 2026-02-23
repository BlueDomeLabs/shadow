// test/unit/data/repositories/anchor_event_time_repository_impl_test.dart
// Tests for AnchorEventTimeRepositoryImpl per 57_NOTIFICATION_SYSTEM.md

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/daos/anchor_event_time_dao.dart';
import 'package:shadow_app/data/repositories/anchor_event_time_repository_impl.dart';
import 'package:shadow_app/domain/entities/anchor_event_time.dart';
import 'package:shadow_app/domain/enums/notification_enums.dart';

@GenerateMocks([AnchorEventTimeDao])
import 'anchor_event_time_repository_impl_test.mocks.dart';

void main() {
  provideDummy<Result<List<AnchorEventTime>, AppError>>(const Success([]));
  provideDummy<Result<AnchorEventTime, AppError>>(
    const Success(
      AnchorEventTime(
        id: 'dummy',
        name: AnchorEventName.wake,
        timeOfDay: '07:00',
      ),
    ),
  );
  provideDummy<Result<AnchorEventTime?, AppError>>(const Success(null));

  const testEvent = AnchorEventTime(
    id: 'evt-001',
    name: AnchorEventName.wake,
    timeOfDay: '07:00',
  );

  group('AnchorEventTimeRepositoryImpl', () {
    late MockAnchorEventTimeDao mockDao;
    late AnchorEventTimeRepositoryImpl repository;

    setUp(() {
      mockDao = MockAnchorEventTimeDao();
      repository = AnchorEventTimeRepositoryImpl(mockDao);
    });

    test('getAll delegates to dao', () async {
      when(
        mockDao.getAll(),
      ).thenAnswer((_) async => const Success([testEvent]));

      final result = await repository.getAll();

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull?.length, 1);
      verify(mockDao.getAll()).called(1);
    });

    test('getByName delegates to dao', () async {
      when(
        mockDao.getByName(AnchorEventName.wake),
      ).thenAnswer((_) async => const Success(testEvent));

      final result = await repository.getByName(AnchorEventName.wake);

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull?.name, AnchorEventName.wake);
      verify(mockDao.getByName(AnchorEventName.wake)).called(1);
    });

    test('getById delegates to dao', () async {
      when(
        mockDao.getById('evt-001'),
      ).thenAnswer((_) async => const Success(testEvent));

      final result = await repository.getById('evt-001');

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull?.id, 'evt-001');
      verify(mockDao.getById('evt-001')).called(1);
    });

    test('create delegates to dao insert', () async {
      when(
        mockDao.insert(any),
      ).thenAnswer((_) async => const Success(testEvent));

      final result = await repository.create(testEvent);

      expect(result.isSuccess, isTrue);
      verify(mockDao.insert(testEvent)).called(1);
    });

    test('update delegates to dao updateEntity', () async {
      when(
        mockDao.updateEntity(any),
      ).thenAnswer((_) async => const Success(testEvent));

      final result = await repository.update(testEvent);

      expect(result.isSuccess, isTrue);
      verify(mockDao.updateEntity(testEvent)).called(1);
    });

    test('propagates dao failure', () async {
      when(mockDao.getAll()).thenAnswer(
        (_) async => Failure(
          DatabaseError.queryFailed(
            'anchor_event_times',
            'error',
            StackTrace.empty,
          ),
        ),
      );

      final result = await repository.getAll();

      expect(result.isFailure, isTrue);
    });
  });
}
