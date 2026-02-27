// lib/domain/reports/report_types.dart
// Ephemeral report configuration types — not persisted to database.

/// The two supported report types.
enum ReportType { activity, reference }

/// Logged-event categories available in an Activity Report.
enum ActivityCategory {
  foodLogs,
  supplementIntake,
  fluids,
  sleep,
  conditionLogs,
  flareUps,
  journalEntries,
  photos,
}

/// Library/setup categories available in a Reference Report.
enum ReferenceCategory { foodLibrary, supplementLibrary, conditions }

/// User-selected configuration for building a report.
///
/// These are ephemeral UI objects — they are never persisted to the database.
/// [startDate] and [endDate] are nullable; null means "all time".
class ReportConfig {
  final ReportType type;
  final Set<ActivityCategory> activityCategories;
  final Set<ReferenceCategory> referenceCategories;
  final DateTime? startDate;
  final DateTime? endDate;

  const ReportConfig({
    required this.type,
    this.activityCategories = const {},
    this.referenceCategories = const {},
    this.startDate,
    this.endDate,
  });
}
