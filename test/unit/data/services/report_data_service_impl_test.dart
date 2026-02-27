// test/unit/data/services/report_data_service_impl_test.dart
// Unit tests for ReportDataServiceImpl — Phase 25

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/services/report_data_service_impl.dart';
import 'package:shadow_app/domain/entities/condition.dart';
import 'package:shadow_app/domain/entities/condition_log.dart';
import 'package:shadow_app/domain/entities/flare_up.dart';
import 'package:shadow_app/domain/entities/fluids_entry.dart';
import 'package:shadow_app/domain/entities/food_item.dart';
import 'package:shadow_app/domain/entities/food_log.dart';
import 'package:shadow_app/domain/entities/intake_log.dart';
import 'package:shadow_app/domain/entities/journal_entry.dart';
import 'package:shadow_app/domain/entities/photo_area.dart';
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
import 'package:shadow_app/domain/repositories/photo_area_repository.dart';
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
  PhotoAreaRepository,
])
import 'report_data_service_impl_test.mocks.dart';

// ---------------------------------------------------------------------------
// Entity stubs
// ---------------------------------------------------------------------------

final _syncMeta = SyncMetadata.empty();
const _profileId = 'test-profile-001';

FoodLog _makeFoodLog({int timestamp = 1000, String? mealTypeStr}) => FoodLog(
  id: 'fl-1',
  clientId: '',
  profileId: _profileId,
  timestamp: timestamp,
  mealType: MealType.breakfast,
  adHocItems: const ['eggs'],
  syncMetadata: _syncMeta,
);

SleepEntry _makeSleepEntry({int bedTime = 2000}) => SleepEntry(
  id: 'sl-1',
  clientId: '',
  profileId: _profileId,
  bedTime: bedTime,
  wakeTime: bedTime + 28800000, // +8 hours
  syncMetadata: _syncMeta,
);

IntakeLog _makeIntakeLog({String supplementId = 'supp-1'}) => IntakeLog(
  id: 'il-1',
  clientId: '',
  profileId: _profileId,
  supplementId: supplementId,
  scheduledTime: 3000,
  actualTime: 3500,
  status: IntakeLogStatus.taken,
  syncMetadata: _syncMeta,
);

Supplement _makeSupplement({String id = 'supp-1', String name = 'Vitamin D'}) =>
    Supplement(
      id: id,
      clientId: '',
      profileId: _profileId,
      name: name,
      form: SupplementForm.capsule,
      dosageQuantity: 1000,
      dosageUnit: DosageUnit.iu,
      syncMetadata: _syncMeta,
    );

FoodItem _makeFoodItem() => FoodItem(
  id: 'fi-1',
  clientId: '',
  profileId: _profileId,
  name: 'Chicken Breast',
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
  late MockPhotoAreaRepository photoAreaRepo;
  late ReportDataServiceImpl sut;

  setUpAll(() {
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
    provideDummy<Result<List<PhotoArea>, AppError>>(const Success([]));
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
    photoAreaRepo = MockPhotoAreaRepository();

    sut = ReportDataServiceImpl(
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
      photoAreaRepo: photoAreaRepo,
    );
  });

  // -------------------------------------------------------------------------
  // fetchActivityRows — empty categories
  // -------------------------------------------------------------------------

  group('fetchActivityRows — empty categories', () {
    test('returns empty list when no categories requested', () async {
      final result = await sut.fetchActivityRows(
        profileId: _profileId,
        categories: {},
      );
      expect(result, isEmpty);
      verifyZeroInteractions(foodLogRepo);
    });
  });

  // -------------------------------------------------------------------------
  // fetchActivityRows — sorted output
  // -------------------------------------------------------------------------

  group('fetchActivityRows — sorted by timestamp', () {
    test('returns rows sorted ascending by timestamp', () async {
      // Food log timestamp=1000, sleep entry timestamp=500
      // Sorted result should have sleep (500) before food (1000).
      when(
        foodLogRepo.getByProfile(_profileId),
      ).thenAnswer((_) async => Success([_makeFoodLog()]));
      when(
        sleepEntryRepo.getByProfile(_profileId),
      ).thenAnswer((_) async => Success([_makeSleepEntry(bedTime: 500)]));

      final rows = await sut.fetchActivityRows(
        profileId: _profileId,
        categories: {ActivityCategory.foodLogs, ActivityCategory.sleep},
      );

      expect(rows.length, 2);
      expect(
        rows.first.timestamp.millisecondsSinceEpoch,
        lessThan(rows.last.timestamp.millisecondsSinceEpoch),
      );
      expect(rows.first.category, 'Sleep');
      expect(rows.last.category, 'Food Log');
    });
  });

  // -------------------------------------------------------------------------
  // fetchActivityRows — repository failure is graceful
  // -------------------------------------------------------------------------

  group('fetchActivityRows — repository failure', () {
    test('returns empty rows for failing category', () async {
      when(foodLogRepo.getByProfile(_profileId)).thenAnswer(
        (_) async =>
            Failure(DatabaseError.notFound('FoodLog', 'test-profile-001')),
      );

      final rows = await sut.fetchActivityRows(
        profileId: _profileId,
        categories: {ActivityCategory.foodLogs},
      );

      expect(rows, isEmpty);
    });
  });

  // -------------------------------------------------------------------------
  // fetchActivityRows — date range passed correctly
  // -------------------------------------------------------------------------

  group('fetchActivityRows — date range', () {
    test('passes startDate and endDate to repository', () async {
      final start = DateTime(2025);
      final end = DateTime(2025, 12, 31);

      when(
        foodLogRepo.getByProfile(
          _profileId,
          startDate: start.millisecondsSinceEpoch,
          endDate: end.millisecondsSinceEpoch,
        ),
      ).thenAnswer((_) async => Success([_makeFoodLog(timestamp: 1_000_000)]));

      final rows = await sut.fetchActivityRows(
        profileId: _profileId,
        categories: {ActivityCategory.foodLogs},
        startDate: start,
        endDate: end,
      );

      expect(rows.length, 1);
      verify(
        foodLogRepo.getByProfile(
          _profileId,
          startDate: start.millisecondsSinceEpoch,
          endDate: end.millisecondsSinceEpoch,
        ),
      );
    });
  });

  // -------------------------------------------------------------------------
  // fetchActivityRows — supplement name resolved
  // -------------------------------------------------------------------------

  group('fetchActivityRows — supplementIntake', () {
    test('resolves supplement name for intake log', () async {
      when(
        intakeLogRepo.getByProfile(_profileId),
      ).thenAnswer((_) async => Success([_makeIntakeLog()]));
      when(
        supplementRepo.getByProfile(_profileId),
      ).thenAnswer((_) async => Success([_makeSupplement()]));

      final rows = await sut.fetchActivityRows(
        profileId: _profileId,
        categories: {ActivityCategory.supplementIntake},
      );

      expect(rows.length, 1);
      expect(rows.first.title, 'Vitamin D');
      expect(rows.first.category, 'Supplement');
    });
  });

  // -------------------------------------------------------------------------
  // fetchReferenceRows — food library
  // -------------------------------------------------------------------------

  group('fetchReferenceRows — foodLibrary', () {
    test('returns one ReportRow per food item', () async {
      when(
        foodItemRepo.getByProfile(_profileId),
      ).thenAnswer((_) async => Success([_makeFoodItem()]));

      final result = await sut.fetchReferenceRows(
        profileId: _profileId,
        categories: {ReferenceCategory.foodLibrary},
      );

      expect(result[ReferenceCategory.foodLibrary], hasLength(1));
      expect(
        result[ReferenceCategory.foodLibrary]!.first.title,
        'Chicken Breast',
      );
    });
  });

  // -------------------------------------------------------------------------
  // fetchReferenceRows — empty categories
  // -------------------------------------------------------------------------

  group('fetchReferenceRows — empty categories', () {
    test('returns empty map when no categories requested', () async {
      final result = await sut.fetchReferenceRows(
        profileId: _profileId,
        categories: {},
      );
      expect(result, isEmpty);
    });
  });

  // -------------------------------------------------------------------------
  // fetchReferenceRows — repository failure
  // -------------------------------------------------------------------------

  group('fetchReferenceRows — repository failure', () {
    test('returns empty list for failing category', () async {
      when(foodItemRepo.getByProfile(_profileId)).thenAnswer(
        (_) async =>
            Failure(DatabaseError.notFound('FoodItem', 'test-profile-001')),
      );

      final result = await sut.fetchReferenceRows(
        profileId: _profileId,
        categories: {ReferenceCategory.foodLibrary},
      );

      expect(result[ReferenceCategory.foodLibrary], isEmpty);
    });
  });
}
