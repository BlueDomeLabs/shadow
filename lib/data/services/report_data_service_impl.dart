// lib/data/services/report_data_service_impl.dart
// Concrete implementation of ReportDataService using existing repositories.

import 'package:shadow_app/domain/reports/report_data_service.dart';
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

/// Fetches full entity data from repositories and maps to [ReportRow].
///
/// Uses the same repository methods as [ReportQueryServiceImpl]. Lookup maps
/// for related entities (supplement names, condition names, photo area names)
/// are built on demand based on which categories are requested.
///
/// On any individual repository failure, that category returns empty rows so
/// a partial failure does not block the rest of the export.
class ReportDataServiceImpl implements ReportDataService {
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
  final PhotoAreaRepository _photoAreaRepo;

  ReportDataServiceImpl({
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
    required PhotoAreaRepository photoAreaRepo,
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
       _conditionRepo = conditionRepo,
       _photoAreaRepo = photoAreaRepo;

  @override
  Future<List<ReportRow>> fetchActivityRows({
    required String profileId,
    required Set<ActivityCategory> categories,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    if (categories.isEmpty) return [];

    final startMs = startDate?.millisecondsSinceEpoch;
    final endMs = endDate?.millisecondsSinceEpoch;

    // Build lookup maps only for categories that need them.
    final needSupplements = categories.contains(
      ActivityCategory.supplementIntake,
    );
    final needConditions =
        categories.contains(ActivityCategory.conditionLogs) ||
        categories.contains(ActivityCategory.flareUps);
    final needAreas = categories.contains(ActivityCategory.photos);

    final supplementMap = needSupplements
        ? await _buildSupplementMap(profileId)
        : <String, String>{};
    final conditionMap = needConditions
        ? await _buildConditionMap(profileId)
        : <String, String>{};
    final areaMap = needAreas
        ? await _buildPhotoAreaMap(profileId)
        : <String, String>{};

    final allRows = <ReportRow>[];
    for (final category in categories) {
      final rows = await _fetchCategoryRows(
        category,
        profileId,
        startMs,
        endMs,
        supplementMap,
        conditionMap,
        areaMap,
      );
      allRows.addAll(rows);
    }

    allRows.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return allRows;
  }

  @override
  Future<Map<ReferenceCategory, List<ReportRow>>> fetchReferenceRows({
    required String profileId,
    required Set<ReferenceCategory> categories,
  }) async {
    final result = <ReferenceCategory, List<ReportRow>>{};
    for (final category in categories) {
      result[category] = await _fetchReferenceCategoryRows(category, profileId);
    }
    return result;
  }

  // ---------------------------------------------------------------------------
  // Activity category dispatchers
  // ---------------------------------------------------------------------------

  Future<List<ReportRow>> _fetchCategoryRows(
    ActivityCategory category,
    String profileId,
    int? startMs,
    int? endMs,
    Map<String, String> supplementMap,
    Map<String, String> conditionMap,
    Map<String, String> areaMap,
  ) async {
    switch (category) {
      case ActivityCategory.foodLogs:
        return _fetchFoodLogs(profileId, startMs, endMs);
      case ActivityCategory.supplementIntake:
        return _fetchIntakeLogs(profileId, startMs, endMs, supplementMap);
      case ActivityCategory.fluids:
        return _fetchFluidsEntries(profileId, startMs, endMs);
      case ActivityCategory.sleep:
        return _fetchSleepEntries(profileId, startMs, endMs);
      case ActivityCategory.conditionLogs:
        return _fetchConditionLogs(profileId, startMs, endMs, conditionMap);
      case ActivityCategory.flareUps:
        return _fetchFlareUps(profileId, startMs, endMs, conditionMap);
      case ActivityCategory.journalEntries:
        return _fetchJournalEntries(profileId, startMs, endMs);
      case ActivityCategory.photos:
        return _fetchPhotoEntries(profileId, startMs, endMs, areaMap);
    }
  }

  Future<List<ReportRow>> _fetchFoodLogs(
    String profileId,
    int? startMs,
    int? endMs,
  ) async {
    final result = await _foodLogRepo.getByProfile(
      profileId,
      startDate: startMs,
      endDate: endMs,
    );
    return result.when(
      success: (logs) => logs.map((log) {
        final mealPart = log.mealType != null
            ? _capitalize(log.mealType!.name)
            : 'Meal';
        final itemPart = log.adHocItems.isNotEmpty
            ? log.adHocItems.join(', ')
            : log.foodItemIds.isNotEmpty
            ? '${log.foodItemIds.length} item${log.foodItemIds.length == 1 ? '' : 's'}'
            : 'logged';
        return ReportRow(
          timestamp: DateTime.fromMillisecondsSinceEpoch(log.timestamp),
          category: 'Food Log',
          title: '$mealPart — $itemPart',
          details: 'Items: ${log.totalItems}',
        );
      }).toList(),
      failure: (_) => [],
    );
  }

  Future<List<ReportRow>> _fetchIntakeLogs(
    String profileId,
    int? startMs,
    int? endMs,
    Map<String, String> supplementMap,
  ) async {
    final result = await _intakeLogRepo.getByProfile(
      profileId,
      startDate: startMs,
      endDate: endMs,
    );
    return result.when(
      success: (logs) => logs.map((log) {
        final supplementName =
            supplementMap[log.supplementId] ?? 'Unknown Supplement';
        final ts = log.actualTime ?? log.scheduledTime;
        return ReportRow(
          timestamp: DateTime.fromMillisecondsSinceEpoch(ts),
          category: 'Supplement',
          title: supplementName,
          details: 'Status: ${_capitalize(log.status.name)}',
        );
      }).toList(),
      failure: (_) => [],
    );
  }

  Future<List<ReportRow>> _fetchFluidsEntries(
    String profileId,
    int? startMs,
    int? endMs,
  ) async {
    final result = startMs != null && endMs != null
        ? await _fluidsEntryRepo.getByDateRange(profileId, startMs, endMs)
        : await _fluidsEntryRepo.getAll(profileId: profileId);
    return result.when(
      success: (entries) => entries.map((entry) {
        final parts = <String>[];
        if (entry.waterIntakeMl != null) {
          parts.add('Water: ${entry.waterIntakeMl}ml');
        }
        if (entry.bowelCondition != null) {
          parts.add('Bowel: ${_capitalize(entry.bowelCondition!.name)}');
        }
        if (entry.urineCondition != null) {
          parts.add('Urine: ${_capitalize(entry.urineCondition!.name)}');
        }
        if (entry.menstruationFlow != null) {
          parts.add('Flow: ${_capitalize(entry.menstruationFlow!.name)}');
        }
        return ReportRow(
          timestamp: DateTime.fromMillisecondsSinceEpoch(entry.entryDate),
          category: 'Fluids',
          title: 'Fluids Entry',
          details: parts.isEmpty ? 'No tracked data' : parts.join(', '),
        );
      }).toList(),
      failure: (_) => [],
    );
  }

  Future<List<ReportRow>> _fetchSleepEntries(
    String profileId,
    int? startMs,
    int? endMs,
  ) async {
    final result = await _sleepEntryRepo.getByProfile(
      profileId,
      startDate: startMs,
      endDate: endMs,
    );
    return result.when(
      success: (entries) => entries.map((entry) {
        final bedStr = _formatEpochTime(entry.bedTime);
        final wakeStr = entry.wakeTime != null
            ? _formatEpochTime(entry.wakeTime!)
            : 'unknown';
        return ReportRow(
          timestamp: DateTime.fromMillisecondsSinceEpoch(entry.bedTime),
          category: 'Sleep',
          title: 'Sleep Entry',
          details:
              'Bed: $bedStr Wake: $wakeStr Quality: ${_capitalize(entry.wakingFeeling.name)}',
        );
      }).toList(),
      failure: (_) => [],
    );
  }

  Future<List<ReportRow>> _fetchConditionLogs(
    String profileId,
    int? startMs,
    int? endMs,
    Map<String, String> conditionMap,
  ) async {
    final result = await _conditionLogRepo.getByProfile(
      profileId,
      startDate: startMs,
      endDate: endMs,
    );
    return result.when(
      success: (logs) => logs.map((log) {
        final conditionName =
            conditionMap[log.conditionId] ?? 'Unknown Condition';
        return ReportRow(
          timestamp: DateTime.fromMillisecondsSinceEpoch(log.timestamp),
          category: 'Condition Check-in',
          title: conditionName,
          details: 'Severity: ${log.severity}/10',
        );
      }).toList(),
      failure: (_) => [],
    );
  }

  Future<List<ReportRow>> _fetchFlareUps(
    String profileId,
    int? startMs,
    int? endMs,
    Map<String, String> conditionMap,
  ) async {
    final result = await _flareUpRepo.getByProfile(
      profileId,
      startDate: startMs,
      endDate: endMs,
    );
    return result.when(
      success: (flareUps) => flareUps.map((f) {
        final conditionName =
            conditionMap[f.conditionId] ?? 'Unknown Condition';
        return ReportRow(
          timestamp: DateTime.fromMillisecondsSinceEpoch(f.startDate),
          category: 'Flare-Up',
          title: conditionName,
          details: 'Severity: ${f.severity}/10, Ongoing: ${f.isOngoing}',
        );
      }).toList(),
      failure: (_) => [],
    );
  }

  Future<List<ReportRow>> _fetchJournalEntries(
    String profileId,
    int? startMs,
    int? endMs,
  ) async {
    final result = await _journalEntryRepo.getByProfile(
      profileId,
      startDate: startMs,
      endDate: endMs,
    );
    return result.when(
      success: (entries) => entries.map((entry) {
        final preview = entry.content.length > 60
            ? '${entry.content.substring(0, 60)}...'
            : entry.content;
        final moodStr = entry.mood != null ? '${entry.mood}' : 'Not recorded';
        return ReportRow(
          timestamp: DateTime.fromMillisecondsSinceEpoch(entry.timestamp),
          category: 'Journal',
          title: preview,
          details: 'Mood: $moodStr',
        );
      }).toList(),
      failure: (_) => [],
    );
  }

  Future<List<ReportRow>> _fetchPhotoEntries(
    String profileId,
    int? startMs,
    int? endMs,
    Map<String, String> areaMap,
  ) async {
    final result = await _photoEntryRepo.getByProfile(
      profileId,
      startDate: startMs,
      endDate: endMs,
    );
    return result.when(
      success: (entries) => entries.map((entry) {
        final areaName = areaMap[entry.photoAreaId] ?? 'Unknown Area';
        return ReportRow(
          timestamp: DateTime.fromMillisecondsSinceEpoch(entry.timestamp),
          category: 'Photo',
          title: areaName,
          details: 'Area: $areaName',
        );
      }).toList(),
      failure: (_) => [],
    );
  }

  // ---------------------------------------------------------------------------
  // Reference category dispatchers
  // ---------------------------------------------------------------------------

  Future<List<ReportRow>> _fetchReferenceCategoryRows(
    ReferenceCategory category,
    String profileId,
  ) async {
    switch (category) {
      case ReferenceCategory.foodLibrary:
        return _fetchFoodLibraryRows(profileId);
      case ReferenceCategory.supplementLibrary:
        return _fetchSupplementLibraryRows(profileId);
      case ReferenceCategory.conditions:
        return _fetchConditionRows(profileId);
    }
  }

  Future<List<ReportRow>> _fetchFoodLibraryRows(String profileId) async {
    final result = await _foodItemRepo.getByProfile(profileId);
    return result.when(
      success: (items) => items.map((item) {
        final typeStr = _capitalize(item.type.name);
        final brandPart = item.brand != null && item.brand!.isNotEmpty
            ? ' — ${item.brand}'
            : '';
        return ReportRow(
          timestamp: DateTime.now(),
          category: 'Food Library',
          title: item.name,
          details: '$typeStr$brandPart',
        );
      }).toList(),
      failure: (_) => [],
    );
  }

  Future<List<ReportRow>> _fetchSupplementLibraryRows(String profileId) async {
    final result = await _supplementRepo.getByProfile(
      profileId,
      activeOnly: true,
    );
    return result.when(
      success: (supplements) => supplements.map((s) {
        final brandPart = s.brand.isNotEmpty ? ' — ${s.brand}' : '';
        return ReportRow(
          timestamp: DateTime.now(),
          category: 'Supplement Library',
          title: s.name,
          details: '${_capitalize(s.form.name)} ${s.displayDosage}$brandPart',
        );
      }).toList(),
      failure: (_) => [],
    );
  }

  Future<List<ReportRow>> _fetchConditionRows(String profileId) async {
    final result = await _conditionRepo.getByProfile(profileId);
    return result.when(
      success: (conditions) => conditions.map((c) {
        final startStr = _formatDate(
          DateTime.fromMillisecondsSinceEpoch(c.startTimeframe),
        );
        return ReportRow(
          timestamp: DateTime.now(),
          category: 'Conditions',
          title: c.name,
          details:
              '${_capitalize(c.category)} — ${_capitalize(c.status.name)} — Since: $startStr',
        );
      }).toList(),
      failure: (_) => [],
    );
  }

  // ---------------------------------------------------------------------------
  // Lookup map builders
  // ---------------------------------------------------------------------------

  Future<Map<String, String>> _buildSupplementMap(String profileId) async {
    final result = await _supplementRepo.getByProfile(profileId);
    return result.when(
      success: (supplements) => {for (final s in supplements) s.id: s.name},
      failure: (_) => {},
    );
  }

  Future<Map<String, String>> _buildConditionMap(String profileId) async {
    final result = await _conditionRepo.getByProfile(
      profileId,
      includeArchived: true,
    );
    return result.when(
      success: (conditions) => {for (final c in conditions) c.id: c.name},
      failure: (_) => {},
    );
  }

  Future<Map<String, String>> _buildPhotoAreaMap(String profileId) async {
    final result = await _photoAreaRepo.getByProfile(
      profileId,
      includeArchived: true,
    );
    return result.when(
      success: (areas) => {for (final a in areas) a.id: a.name},
      failure: (_) => {},
    );
  }

  // ---------------------------------------------------------------------------
  // Formatting helpers
  // ---------------------------------------------------------------------------

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  String _formatEpochTime(int epochMs) {
    final dt = DateTime.fromMillisecondsSinceEpoch(epochMs);
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
}
