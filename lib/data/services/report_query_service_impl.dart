// lib/data/services/report_query_service_impl.dart
// Concrete implementation of ReportQueryService using existing repositories.

import 'package:shadow_app/domain/reports/report_query_service.dart';
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

/// Queries record counts from existing repositories for report previews.
///
/// Uses whichever getByProfile / getByDateRange / getAll methods exist on each
/// repository. Does NOT add new repository methods — reads from what is there.
///
/// On repository failure for any individual category, that category returns 0
/// so a partial failure does not block the whole preview.
class ReportQueryServiceImpl implements ReportQueryService {
  final FoodLogRepository _foodLogRepo;
  final IntakeLogRepository _intakeLogRepo;
  final FluidsEntryRepository _fluidsEntryRepo;
  final SleepEntryRepository _sleepEntryRepo;
  final ConditionLogRepository _conditionLogRepo;
  final FlareUpRepository _flareUpRepo;
  final JournalEntryRepository _journalEntryRepo;
  final PhotoEntryRepository _photoEntryRepo;
  final FoodItemRepository _foodItemRepo;
  final SupplementRepository _supplementRepo;
  final ConditionRepository _conditionRepo;

  ReportQueryServiceImpl({
    required FoodLogRepository foodLogRepo,
    required IntakeLogRepository intakeLogRepo,
    required FluidsEntryRepository fluidsEntryRepo,
    required SleepEntryRepository sleepEntryRepo,
    required ConditionLogRepository conditionLogRepo,
    required FlareUpRepository flareUpRepo,
    required JournalEntryRepository journalEntryRepo,
    required PhotoEntryRepository photoEntryRepo,
    required FoodItemRepository foodItemRepo,
    required SupplementRepository supplementRepo,
    required ConditionRepository conditionRepo,
  }) : _foodLogRepo = foodLogRepo,
       _intakeLogRepo = intakeLogRepo,
       _fluidsEntryRepo = fluidsEntryRepo,
       _sleepEntryRepo = sleepEntryRepo,
       _conditionLogRepo = conditionLogRepo,
       _flareUpRepo = flareUpRepo,
       _journalEntryRepo = journalEntryRepo,
       _photoEntryRepo = photoEntryRepo,
       _foodItemRepo = foodItemRepo,
       _supplementRepo = supplementRepo,
       _conditionRepo = conditionRepo;

  @override
  Future<Map<ActivityCategory, int>> countActivity({
    required String profileId,
    required Set<ActivityCategory> categories,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final startMs = startDate?.millisecondsSinceEpoch;
    final endMs = endDate?.millisecondsSinceEpoch;
    final counts = <ActivityCategory, int>{};
    for (final category in categories) {
      counts[category] = await _countActivityCategory(
        category,
        profileId,
        startMs,
        endMs,
      );
    }
    return counts;
  }

  @override
  Future<Map<ReferenceCategory, int>> countReference({
    required String profileId,
    required Set<ReferenceCategory> categories,
  }) async {
    final counts = <ReferenceCategory, int>{};
    for (final category in categories) {
      counts[category] = await _countReferenceCategory(category, profileId);
    }
    return counts;
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  Future<int> _countActivityCategory(
    ActivityCategory category,
    String profileId,
    int? startMs,
    int? endMs,
  ) async {
    switch (category) {
      case ActivityCategory.foodLogs:
        final result = await _foodLogRepo.getByProfile(
          profileId,
          startDate: startMs,
          endDate: endMs,
        );
        return result.when(success: (list) => list.length, failure: (_) => 0);

      case ActivityCategory.supplementIntake:
        final result = await _intakeLogRepo.getByProfile(
          profileId,
          startDate: startMs,
          endDate: endMs,
        );
        return result.when(success: (list) => list.length, failure: (_) => 0);

      case ActivityCategory.fluids:
        // FluidsEntryRepository has no getByProfile — use getByDateRange when
        // dates are provided, or getAll(profileId) for all-time.
        if (startMs != null && endMs != null) {
          final result = await _fluidsEntryRepo.getByDateRange(
            profileId,
            startMs,
            endMs,
          );
          return result.when(success: (list) => list.length, failure: (_) => 0);
        } else {
          final result = await _fluidsEntryRepo.getAll(profileId: profileId);
          return result.when(success: (list) => list.length, failure: (_) => 0);
        }

      case ActivityCategory.sleep:
        final result = await _sleepEntryRepo.getByProfile(
          profileId,
          startDate: startMs,
          endDate: endMs,
        );
        return result.when(success: (list) => list.length, failure: (_) => 0);

      case ActivityCategory.conditionLogs:
        final result = await _conditionLogRepo.getByProfile(
          profileId,
          startDate: startMs,
          endDate: endMs,
        );
        return result.when(success: (list) => list.length, failure: (_) => 0);

      case ActivityCategory.flareUps:
        final result = await _flareUpRepo.getByProfile(
          profileId,
          startDate: startMs,
          endDate: endMs,
        );
        return result.when(success: (list) => list.length, failure: (_) => 0);

      case ActivityCategory.journalEntries:
        final result = await _journalEntryRepo.getByProfile(
          profileId,
          startDate: startMs,
          endDate: endMs,
        );
        return result.when(success: (list) => list.length, failure: (_) => 0);

      case ActivityCategory.photos:
        final result = await _photoEntryRepo.getByProfile(
          profileId,
          startDate: startMs,
          endDate: endMs,
        );
        return result.when(success: (list) => list.length, failure: (_) => 0);
    }
  }

  Future<int> _countReferenceCategory(
    ReferenceCategory category,
    String profileId,
  ) async {
    switch (category) {
      case ReferenceCategory.foodLibrary:
        final result = await _foodItemRepo.getByProfile(profileId);
        return result.when(success: (list) => list.length, failure: (_) => 0);

      case ReferenceCategory.supplementLibrary:
        final result = await _supplementRepo.getByProfile(
          profileId,
          activeOnly: true,
        );
        return result.when(success: (list) => list.length, failure: (_) => 0);

      case ReferenceCategory.conditions:
        final result = await _conditionRepo.getByProfile(profileId);
        return result.when(success: (list) => list.length, failure: (_) => 0);
    }
  }
}
