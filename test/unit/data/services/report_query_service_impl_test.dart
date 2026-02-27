// test/unit/data/services/report_query_service_impl_test.dart
// Unit tests for ReportQueryServiceImpl — Phase 24

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/services/report_query_service_impl.dart';
import 'package:shadow_app/domain/entities/condition.dart';
import 'package:shadow_app/domain/entities/condition_log.dart';
import 'package:shadow_app/domain/entities/flare_up.dart';
import 'package:shadow_app/domain/entities/fluids_entry.dart';
import 'package:shadow_app/domain/entities/food_item.dart';
import 'package:shadow_app/domain/entities/food_log.dart';
import 'package:shadow_app/domain/entities/intake_log.dart';
import 'package:shadow_app/domain/entities/journal_entry.dart';
import 'package:shadow_app/domain/entities/photo_entry.dart';
import 'package:shadow_app/domain/entities/sleep_entry.dart';
import 'package:shadow_app/domain/entities/supplement.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/reports/report_types.dart';
import 'package:shadow_app/domain/repositories/condition_log_repository.dart';
import 'package:shadow_app/domain/repositories/condition_repository.dart';
import 'package:shadow_app/domain/repositories/flare_up_repository.dart';
import 'package:shadow_app/domain/repositories/fluids_entry_repository.dart';
import 'package:shadow_app/domain/repositories/food_item_repository.dart';
import 'package:shadow_app/domain/repositories/food_log_repository.dart';
import 'package:shadow_app/domain/repositories/intake_log_repository.dart';
import 'package:shadow_app/domain/repositories/journal_entry_repository.dart';
import 'package:shadow_app/domain/repositories/photo_entry_repository.dart';
import 'package:shadow_app/domain/repositories/sleep_entry_repository.dart';
import 'package:shadow_app/domain/repositories/supplement_repository.dart';

@GenerateMocks([
  FoodLogRepository,
  IntakeLogRepository,
  FluidsEntryRepository,
  SleepEntryRepository,
  ConditionLogRepository,
  FlareUpRepository,
  JournalEntryRepository,
  PhotoEntryRepository,
  FoodItemRepository,
  SupplementRepository,
  ConditionRepository,
])
import 'report_query_service_impl_test.mocks.dart';

// ---------------------------------------------------------------------------
// Entity stubs — minimal valid construction for count-only queries
// ---------------------------------------------------------------------------

final _syncMeta = SyncMetadata.empty();

FoodLog _makeFoodLog() => FoodLog(
  id: '',
  clientId: '',
  profileId: 'test-profile-001',
  timestamp: 0,
  syncMetadata: _syncMeta,
);

IntakeLog _makeIntakeLog() => IntakeLog(
  id: '',
  clientId: '',
  profileId: 'test-profile-001',
  supplementId: '',
  scheduledTime: 0,
  syncMetadata: _syncMeta,
);

FluidsEntry _makeFluidsEntry() => FluidsEntry(
  id: '',
  clientId: '',
  profileId: 'test-profile-001',
  entryDate: 0,
  syncMetadata: _syncMeta,
);

SleepEntry _makeSleepEntry() => SleepEntry(
  id: '',
  clientId: '',
  profileId: 'test-profile-001',
  bedTime: 0,
  syncMetadata: _syncMeta,
);

FoodItem _makeFoodItem() => FoodItem(
  id: '',
  clientId: '',
  profileId: 'test-profile-001',
  name: 'Test Food',
  syncMetadata: _syncMeta,
);

Supplement _makeSupplement() => Supplement(
  id: '',
  clientId: '',
  profileId: 'test-profile-001',
  name: 'Test Supplement',
  form: SupplementForm.tablet,
  dosageQuantity: 1,
  dosageUnit: DosageUnit.mg,
  syncMetadata: _syncMeta,
);

Condition _makeCondition() => Condition(
  id: '',
  clientId: '',
  profileId: 'test-profile-001',
  name: 'Test Condition',
  category: 'skin',
  bodyLocations: const [],
  startTimeframe: 0,
  syncMetadata: _syncMeta,
);

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  late MockFoodLogRepository foodLogRepo;
  late MockIntakeLogRepository intakeLogRepo;
  late MockFluidsEntryRepository fluidsEntryRepo;
  late MockSleepEntryRepository sleepEntryRepo;
  late MockConditionLogRepository conditionLogRepo;
  late MockFlareUpRepository flareUpRepo;
  late MockJournalEntryRepository journalEntryRepo;
  late MockPhotoEntryRepository photoEntryRepo;
  late MockFoodItemRepository foodItemRepo;
  late MockSupplementRepository supplementRepo;
  late MockConditionRepository conditionRepo;
  late ReportQueryServiceImpl sut;

  const profileId = 'test-profile-001';

  setUpAll(() {
    // Provide dummy values for all Result<List<X>, AppError> types used by mocks
    provideDummy<Result<List<FoodLog>, AppError>>(const Success([]));
    provideDummy<Result<List<IntakeLog>, AppError>>(const Success([]));
    provideDummy<Result<List<FluidsEntry>, AppError>>(const Success([]));
    provideDummy<Result<List<SleepEntry>, AppError>>(const Success([]));
    provideDummy<Result<List<ConditionLog>, AppError>>(const Success([]));
    provideDummy<Result<List<FlareUp>, AppError>>(const Success([]));
    provideDummy<Result<List<JournalEntry>, AppError>>(const Success([]));
    provideDummy<Result<List<PhotoEntry>, AppError>>(const Success([]));
    provideDummy<Result<List<FoodItem>, AppError>>(const Success([]));
    provideDummy<Result<List<Supplement>, AppError>>(const Success([]));
    provideDummy<Result<List<Condition>, AppError>>(const Success([]));
    provideDummy<Result<Map<String, double>, AppError>>(const Success({}));
    provideDummy<Result<Map<int, int>, AppError>>(const Success({}));
    provideDummy<Result<Map<String, int>, AppError>>(const Success({}));
    provideDummy<Result<void, AppError>>(const Success(null));
    provideDummy<Result<FoodLog?, AppError>>(const Success(null));
    provideDummy<Result<IntakeLog, AppError>>(Success(_makeIntakeLog()));
    provideDummy<Result<SleepEntry?, AppError>>(const Success(null));
  });

  setUp(() {
    foodLogRepo = MockFoodLogRepository();
    intakeLogRepo = MockIntakeLogRepository();
    fluidsEntryRepo = MockFluidsEntryRepository();
    sleepEntryRepo = MockSleepEntryRepository();
    conditionLogRepo = MockConditionLogRepository();
    flareUpRepo = MockFlareUpRepository();
    journalEntryRepo = MockJournalEntryRepository();
    photoEntryRepo = MockPhotoEntryRepository();
    foodItemRepo = MockFoodItemRepository();
    supplementRepo = MockSupplementRepository();
    conditionRepo = MockConditionRepository();

    sut = ReportQueryServiceImpl(
      foodLogRepo: foodLogRepo,
      intakeLogRepo: intakeLogRepo,
      fluidsEntryRepo: fluidsEntryRepo,
      sleepEntryRepo: sleepEntryRepo,
      conditionLogRepo: conditionLogRepo,
      flareUpRepo: flareUpRepo,
      journalEntryRepo: journalEntryRepo,
      photoEntryRepo: photoEntryRepo,
      foodItemRepo: foodItemRepo,
      supplementRepo: supplementRepo,
      conditionRepo: conditionRepo,
    );
  });

  // ---------------------------------------------------------------------------
  // countActivity — empty categories
  // ---------------------------------------------------------------------------

  group('countActivity — empty categories', () {
    test('returns empty map when no categories requested', () async {
      final result = await sut.countActivity(
        profileId: profileId,
        categories: {},
      );
      expect(result, isEmpty);
      verifyZeroInteractions(foodLogRepo);
    });
  });

  // ---------------------------------------------------------------------------
  // countActivity — foodLogs
  // ---------------------------------------------------------------------------

  group('countActivity — foodLogs', () {
    test('returns correct count for foodLogs (all time)', () async {
      when(foodLogRepo.getByProfile(profileId)).thenAnswer(
        (_) async => Success(List.generate(5, (_) => _makeFoodLog())),
      );

      final result = await sut.countActivity(
        profileId: profileId,
        categories: {ActivityCategory.foodLogs},
      );

      expect(result[ActivityCategory.foodLogs], 5);
    });

    test('passes date range to foodLog repository', () async {
      final start = DateTime(2025);
      final end = DateTime(2025, 12, 31);

      when(
        foodLogRepo.getByProfile(
          profileId,
          startDate: start.millisecondsSinceEpoch,
          endDate: end.millisecondsSinceEpoch,
        ),
      ).thenAnswer(
        (_) async => Success(List.generate(3, (_) => _makeFoodLog())),
      );

      final result = await sut.countActivity(
        profileId: profileId,
        categories: {ActivityCategory.foodLogs},
        startDate: start,
        endDate: end,
      );

      expect(result[ActivityCategory.foodLogs], 3);
      verify(
        foodLogRepo.getByProfile(
          profileId,
          startDate: start.millisecondsSinceEpoch,
          endDate: end.millisecondsSinceEpoch,
        ),
      );
    });

    test('returns 0 on repository failure', () async {
      when(foodLogRepo.getByProfile(profileId)).thenAnswer(
        (_) async => Failure(DatabaseError.notFound('FoodLog', 'test-id')),
      );

      final result = await sut.countActivity(
        profileId: profileId,
        categories: {ActivityCategory.foodLogs},
      );

      expect(result[ActivityCategory.foodLogs], 0);
    });
  });

  // ---------------------------------------------------------------------------
  // countActivity — supplementIntake
  // ---------------------------------------------------------------------------

  group('countActivity — supplementIntake', () {
    test('returns correct count for supplementIntake', () async {
      when(intakeLogRepo.getByProfile(profileId)).thenAnswer(
        (_) async => Success(List.generate(10, (_) => _makeIntakeLog())),
      );

      final result = await sut.countActivity(
        profileId: profileId,
        categories: {ActivityCategory.supplementIntake},
      );

      expect(result[ActivityCategory.supplementIntake], 10);
    });
  });

  // ---------------------------------------------------------------------------
  // countActivity — fluids (special case: no getByProfile)
  // ---------------------------------------------------------------------------

  group('countActivity — fluids', () {
    test('uses getAll when no date range provided', () async {
      when(fluidsEntryRepo.getAll(profileId: profileId)).thenAnswer(
        (_) async => Success(List.generate(7, (_) => _makeFluidsEntry())),
      );

      final result = await sut.countActivity(
        profileId: profileId,
        categories: {ActivityCategory.fluids},
      );

      expect(result[ActivityCategory.fluids], 7);
      verify(fluidsEntryRepo.getAll(profileId: profileId));
      verifyNever(fluidsEntryRepo.getByDateRange(any, any, any));
    });

    test('uses getByDateRange when date range provided', () async {
      final start = DateTime(2025, 3);
      final end = DateTime(2025, 3, 31);

      when(
        fluidsEntryRepo.getByDateRange(
          profileId,
          start.millisecondsSinceEpoch,
          end.millisecondsSinceEpoch,
        ),
      ).thenAnswer(
        (_) async => Success(List.generate(4, (_) => _makeFluidsEntry())),
      );

      final result = await sut.countActivity(
        profileId: profileId,
        categories: {ActivityCategory.fluids},
        startDate: start,
        endDate: end,
      );

      expect(result[ActivityCategory.fluids], 4);
      verifyNever(fluidsEntryRepo.getAll(profileId: profileId));
    });
  });

  // ---------------------------------------------------------------------------
  // countActivity — multiple categories
  // ---------------------------------------------------------------------------

  group('countActivity — multiple categories', () {
    test('counts all requested categories independently', () async {
      when(foodLogRepo.getByProfile(profileId)).thenAnswer(
        (_) async => Success(List.generate(2, (_) => _makeFoodLog())),
      );
      when(sleepEntryRepo.getByProfile(profileId)).thenAnswer(
        (_) async => Success(List.generate(6, (_) => _makeSleepEntry())),
      );

      final result = await sut.countActivity(
        profileId: profileId,
        categories: {ActivityCategory.foodLogs, ActivityCategory.sleep},
      );

      expect(result[ActivityCategory.foodLogs], 2);
      expect(result[ActivityCategory.sleep], 6);
    });
  });

  // ---------------------------------------------------------------------------
  // countReference — food library
  // ---------------------------------------------------------------------------

  group('countReference — foodLibrary', () {
    test('counts non-archived food items', () async {
      when(foodItemRepo.getByProfile(profileId)).thenAnswer(
        (_) async => Success(List.generate(8, (_) => _makeFoodItem())),
      );

      final result = await sut.countReference(
        profileId: profileId,
        categories: {ReferenceCategory.foodLibrary},
      );

      expect(result[ReferenceCategory.foodLibrary], 8);
      verify(foodItemRepo.getByProfile(profileId));
    });
  });

  // ---------------------------------------------------------------------------
  // countReference — supplement library
  // ---------------------------------------------------------------------------

  group('countReference — supplementLibrary', () {
    test('counts active supplements', () async {
      when(supplementRepo.getByProfile(profileId, activeOnly: true)).thenAnswer(
        (_) async => Success(List.generate(3, (_) => _makeSupplement())),
      );

      final result = await sut.countReference(
        profileId: profileId,
        categories: {ReferenceCategory.supplementLibrary},
      );

      expect(result[ReferenceCategory.supplementLibrary], 3);
      verify(supplementRepo.getByProfile(profileId, activeOnly: true));
    });
  });

  // ---------------------------------------------------------------------------
  // countReference — conditions
  // ---------------------------------------------------------------------------

  group('countReference — conditions', () {
    test('counts non-archived conditions', () async {
      when(conditionRepo.getByProfile(profileId)).thenAnswer(
        (_) async => Success(List.generate(2, (_) => _makeCondition())),
      );

      final result = await sut.countReference(
        profileId: profileId,
        categories: {ReferenceCategory.conditions},
      );

      expect(result[ReferenceCategory.conditions], 2);
    });
  });

  // ---------------------------------------------------------------------------
  // countReference — empty categories
  // ---------------------------------------------------------------------------

  group('countReference — empty categories', () {
    test('returns empty map when no categories requested', () async {
      final result = await sut.countReference(
        profileId: profileId,
        categories: {},
      );
      expect(result, isEmpty);
    });
  });
}
