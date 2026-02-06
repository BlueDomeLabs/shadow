// test/unit/domain/usecases/journal_entries/journal_entry_usecases_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/journal_entry.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/repositories/journal_entry_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/journal_entries/create_journal_entry_use_case.dart';
import 'package:shadow_app/domain/usecases/journal_entries/delete_journal_entry_use_case.dart';
import 'package:shadow_app/domain/usecases/journal_entries/get_journal_entries_use_case.dart';
import 'package:shadow_app/domain/usecases/journal_entries/journal_entry_inputs.dart';
import 'package:shadow_app/domain/usecases/journal_entries/search_journal_entries_use_case.dart';
import 'package:shadow_app/domain/usecases/journal_entries/update_journal_entry_use_case.dart';

@GenerateMocks([JournalEntryRepository, ProfileAuthorizationService])
import 'journal_entry_usecases_test.mocks.dart';

void main() {
  provideDummy<Result<List<JournalEntry>, AppError>>(const Success([]));
  provideDummy<Result<void, AppError>>(const Success(null));

  const testProfileId = 'profile-001';
  const testClientId = 'client-001';

  final now = DateTime.now().millisecondsSinceEpoch;
  final timestamp = now - (2 * 60 * 60 * 1000); // 2 hours ago

  JournalEntry createTestJournalEntry({
    String id = 'entry-001',
    String clientId = testClientId,
    String profileId = testProfileId,
    int? ts,
    String content = 'Today was a good day.',
    String? title,
    int? mood,
    List<String>? tags,
    SyncMetadata? syncMetadata,
  }) => JournalEntry(
    id: id,
    clientId: clientId,
    profileId: profileId,
    timestamp: ts ?? timestamp,
    content: content,
    title: title,
    mood: mood,
    tags: tags,
    syncMetadata: syncMetadata ?? SyncMetadata.create(deviceId: 'test-device'),
  );

  provideDummy<Result<JournalEntry, AppError>>(
    Success(createTestJournalEntry()),
  );

  group('CreateJournalEntryUseCase', () {
    late MockJournalEntryRepository mockRepository;
    late MockProfileAuthorizationService mockAuthService;
    late CreateJournalEntryUseCase useCase;

    setUp(() {
      mockRepository = MockJournalEntryRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = CreateJournalEntryUseCase(mockRepository, mockAuthService);
    });

    test('call_whenAuthorized_createsJournalEntry', () async {
      final expectedEntry = createTestJournalEntry();
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.create(any),
      ).thenAnswer((_) async => Success(expectedEntry));

      final result = await useCase(
        CreateJournalEntryInput(
          profileId: testProfileId,
          clientId: testClientId,
          timestamp: timestamp,
          content: 'Today was a good day.',
        ),
      );

      expect(result.isSuccess, isTrue);
      verify(mockAuthService.canWrite(testProfileId)).called(1);
      verify(mockRepository.create(any)).called(1);
    });

    test('call_whenUnauthorized_returnsAuthError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => false);

      final result = await useCase(
        CreateJournalEntryInput(
          profileId: testProfileId,
          clientId: testClientId,
          timestamp: timestamp,
          content: 'Today was a good day.',
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
      verifyNever(mockRepository.create(any));
    });

    test('call_whenContentEmpty_returnsValidationError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);

      final result = await useCase(
        CreateJournalEntryInput(
          profileId: testProfileId,
          clientId: testClientId,
          timestamp: timestamp,
          content: '', // Empty content
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
      verifyNever(mockRepository.create(any));
    });

    test('call_whenMoodOutOfRange_returnsValidationError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);

      final result = await useCase(
        CreateJournalEntryInput(
          profileId: testProfileId,
          clientId: testClientId,
          timestamp: timestamp,
          content: 'Today was a good day.',
          mood: 11, // Out of range (1-10)
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
    });

    test('call_whenTimestampTooFarInFuture_returnsValidationError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);

      final futureTimestamp = now + (2 * 60 * 60 * 1000); // 2 hours from now

      final result = await useCase(
        CreateJournalEntryInput(
          profileId: testProfileId,
          clientId: testClientId,
          timestamp: futureTimestamp,
          content: 'Future entry.',
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
    });

    test('call_withValidMood_createsEntry', () async {
      final expectedEntry = createTestJournalEntry(mood: 8);
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.create(any),
      ).thenAnswer((_) async => Success(expectedEntry));

      final result = await useCase(
        CreateJournalEntryInput(
          profileId: testProfileId,
          clientId: testClientId,
          timestamp: timestamp,
          content: 'Feeling great!',
          mood: 8,
        ),
      );

      expect(result.isSuccess, isTrue);
    });
  });

  group('GetJournalEntriesUseCase', () {
    late MockJournalEntryRepository mockRepository;
    late MockProfileAuthorizationService mockAuthService;
    late GetJournalEntriesUseCase useCase;

    setUp(() {
      mockRepository = MockJournalEntryRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = GetJournalEntriesUseCase(mockRepository, mockAuthService);
    });

    test('call_whenAuthorized_returnsEntries', () async {
      final entries = [createTestJournalEntry()];
      when(
        mockAuthService.canRead(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getByProfile(testProfileId),
      ).thenAnswer((_) async => Success(entries));

      final result = await useCase(
        const GetJournalEntriesInput(profileId: testProfileId),
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull, entries);
    });

    test('call_whenUnauthorized_returnsAuthError', () async {
      when(
        mockAuthService.canRead(testProfileId),
      ).thenAnswer((_) async => false);

      final result = await useCase(
        const GetJournalEntriesInput(profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
    });

    test('call_whenStartDateAfterEndDate_returnsValidationError', () async {
      when(
        mockAuthService.canRead(testProfileId),
      ).thenAnswer((_) async => true);

      final result = await useCase(
        GetJournalEntriesInput(
          profileId: testProfileId,
          startDate: timestamp + 1000,
          endDate: timestamp,
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
    });
  });

  group('SearchJournalEntriesUseCase', () {
    late MockJournalEntryRepository mockRepository;
    late MockProfileAuthorizationService mockAuthService;
    late SearchJournalEntriesUseCase useCase;

    setUp(() {
      mockRepository = MockJournalEntryRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = SearchJournalEntriesUseCase(mockRepository, mockAuthService);
    });

    test('call_whenAuthorized_searchesEntries', () async {
      final entries = [createTestJournalEntry()];
      when(
        mockAuthService.canRead(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.search(testProfileId, 'good day'),
      ).thenAnswer((_) async => Success(entries));

      final result = await useCase(
        const SearchJournalEntriesInput(
          profileId: testProfileId,
          query: 'good day',
        ),
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull, entries);
    });

    test('call_whenEmptyQuery_returnsValidationError', () async {
      when(
        mockAuthService.canRead(testProfileId),
      ).thenAnswer((_) async => true);

      final result = await useCase(
        const SearchJournalEntriesInput(
          profileId: testProfileId,
          query: '   ', // Empty/whitespace query
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
    });
  });

  group('UpdateJournalEntryUseCase', () {
    late MockJournalEntryRepository mockRepository;
    late MockProfileAuthorizationService mockAuthService;
    late UpdateJournalEntryUseCase useCase;

    setUp(() {
      mockRepository = MockJournalEntryRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = UpdateJournalEntryUseCase(mockRepository, mockAuthService);
    });

    test('call_whenAuthorized_updatesEntry', () async {
      final existing = createTestJournalEntry();
      final updated = existing.copyWith(content: 'Updated content');

      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getById('entry-001'),
      ).thenAnswer((_) async => Success(existing));
      when(
        mockRepository.update(any),
      ).thenAnswer((_) async => Success(updated));

      final result = await useCase(
        const UpdateJournalEntryInput(
          id: 'entry-001',
          profileId: testProfileId,
          content: 'Updated content',
        ),
      );

      expect(result.isSuccess, isTrue);
      verify(mockRepository.update(any)).called(1);
    });

    test('call_whenUnauthorized_returnsAuthError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => false);

      final result = await useCase(
        const UpdateJournalEntryInput(
          id: 'entry-001',
          profileId: testProfileId,
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
    });

    test('call_whenEntryNotFound_returnsError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(mockRepository.getById('entry-001')).thenAnswer(
        (_) async =>
            Failure(DatabaseError.notFound('JournalEntry', 'entry-001')),
      );

      final result = await useCase(
        const UpdateJournalEntryInput(
          id: 'entry-001',
          profileId: testProfileId,
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<DatabaseError>());
    });

    test('call_whenEntryBelongsToDifferentProfile_returnsAuthError', () async {
      final existing = createTestJournalEntry(profileId: 'other-profile');

      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getById('entry-001'),
      ).thenAnswer((_) async => Success(existing));

      final result = await useCase(
        const UpdateJournalEntryInput(
          id: 'entry-001',
          profileId: testProfileId,
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
    });
  });

  group('DeleteJournalEntryUseCase', () {
    late MockJournalEntryRepository mockRepository;
    late MockProfileAuthorizationService mockAuthService;
    late DeleteJournalEntryUseCase useCase;

    setUp(() {
      mockRepository = MockJournalEntryRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = DeleteJournalEntryUseCase(mockRepository, mockAuthService);
    });

    test('call_whenAuthorized_deletesEntry', () async {
      final existing = createTestJournalEntry();

      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getById('entry-001'),
      ).thenAnswer((_) async => Success(existing));
      when(
        mockRepository.delete('entry-001'),
      ).thenAnswer((_) async => const Success(null));

      final result = await useCase(
        const DeleteJournalEntryInput(
          id: 'entry-001',
          profileId: testProfileId,
        ),
      );

      expect(result.isSuccess, isTrue);
      verify(mockRepository.delete('entry-001')).called(1);
    });

    test('call_whenUnauthorized_returnsAuthError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => false);

      final result = await useCase(
        const DeleteJournalEntryInput(
          id: 'entry-001',
          profileId: testProfileId,
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
    });

    test('call_whenEntryNotFound_returnsError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(mockRepository.getById('entry-001')).thenAnswer(
        (_) async =>
            Failure(DatabaseError.notFound('JournalEntry', 'entry-001')),
      );

      final result = await useCase(
        const DeleteJournalEntryInput(
          id: 'entry-001',
          profileId: testProfileId,
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<DatabaseError>());
    });

    test('call_whenEntryBelongsToDifferentProfile_returnsAuthError', () async {
      final existing = createTestJournalEntry(profileId: 'other-profile');

      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getById('entry-001'),
      ).thenAnswer((_) async => Success(existing));

      final result = await useCase(
        const DeleteJournalEntryInput(
          id: 'entry-001',
          profileId: testProfileId,
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
    });
  });
}
