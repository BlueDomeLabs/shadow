// test/unit/data/repositories/guest_invite_repository_impl_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/daos/guest_invite_dao.dart';
import 'package:shadow_app/data/repositories/guest_invite_repository_impl.dart';
import 'package:shadow_app/domain/entities/guest_invite.dart';

@GenerateMocks([GuestInviteDao])
import 'guest_invite_repository_impl_test.mocks.dart';

void main() {
  // Provide dummy values for Result types that Mockito can't generate
  provideDummy<Result<List<GuestInvite>, AppError>>(const Success([]));
  provideDummy<Result<GuestInvite, AppError>>(
    const Success(
      GuestInvite(
        id: 'dummy',
        profileId: 'dummy',
        token: 'dummy',
        createdAt: 0,
      ),
    ),
  );
  provideDummy<Result<GuestInvite?, AppError>>(const Success(null));
  provideDummy<Result<void, AppError>>(const Success(null));

  group('GuestInviteRepositoryImpl', () {
    late MockGuestInviteDao mockDao;
    late GuestInviteRepositoryImpl repository;

    GuestInvite createTestInvite({
      String id = 'invite-001',
      String profileId = 'profile-001',
      String token = 'token-001',
      String label = 'Test Device',
    }) => GuestInvite(
      id: id,
      profileId: profileId,
      token: token,
      label: label,
      createdAt: 1000,
    );

    setUp(() {
      mockDao = MockGuestInviteDao();
      repository = GuestInviteRepositoryImpl(mockDao);
    });

    group('create', () {
      test('delegates to dao', () async {
        final invite = createTestInvite();
        when(mockDao.create(any)).thenAnswer((_) async => Success(invite));

        final result = await repository.create(invite);

        expect(result.isSuccess, isTrue);
        verify(mockDao.create(invite)).called(1);
      });
    });

    group('getById', () {
      test('delegates to dao', () async {
        final invite = createTestInvite();
        when(
          mockDao.getById('invite-001'),
        ).thenAnswer((_) async => Success(invite));

        final result = await repository.getById('invite-001');

        expect(result.isSuccess, isTrue);
        verify(mockDao.getById('invite-001')).called(1);
      });
    });

    group('getByToken', () {
      test('delegates to dao', () async {
        final invite = createTestInvite();
        when(
          mockDao.getByToken('token-001'),
        ).thenAnswer((_) async => Success(invite));

        final result = await repository.getByToken('token-001');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.token, 'token-001');
        verify(mockDao.getByToken('token-001')).called(1);
      });
    });

    group('getByProfile', () {
      test('delegates to dao', () async {
        when(
          mockDao.getByProfile('profile-001'),
        ).thenAnswer((_) async => const Success([]));

        final result = await repository.getByProfile('profile-001');

        expect(result.isSuccess, isTrue);
        verify(mockDao.getByProfile('profile-001')).called(1);
      });
    });

    group('update', () {
      test('delegates to dao updateEntity', () async {
        final invite = createTestInvite();
        when(
          mockDao.updateEntity(any),
        ).thenAnswer((_) async => Success(invite));

        final result = await repository.update(invite);

        expect(result.isSuccess, isTrue);
        verify(mockDao.updateEntity(invite)).called(1);
      });
    });

    group('revoke', () {
      test('delegates to dao', () async {
        when(
          mockDao.revoke('invite-001'),
        ).thenAnswer((_) async => const Success(null));

        final result = await repository.revoke('invite-001');

        expect(result.isSuccess, isTrue);
        verify(mockDao.revoke('invite-001')).called(1);
      });
    });

    group('hardDelete', () {
      test('delegates to dao', () async {
        when(
          mockDao.hardDelete('invite-001'),
        ).thenAnswer((_) async => const Success(null));

        final result = await repository.hardDelete('invite-001');

        expect(result.isSuccess, isTrue);
        verify(mockDao.hardDelete('invite-001')).called(1);
      });
    });
  });
}
