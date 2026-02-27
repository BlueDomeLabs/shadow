// lib/domain/reports/report_data_service.dart
// Abstract port for fetching full record data for report export.

import 'package:shadow_app/domain/reports/report_types.dart';

/// A single row in a report — generic enough for both PDF and CSV.
class ReportRow {
  final DateTime timestamp;
  final String category; // 'Food Log', 'Sleep', etc.
  final String title; // Primary description
  final String details; // Secondary details (key: value pairs)

  const ReportRow({
    required this.timestamp,
    required this.category,
    required this.title,
    required this.details,
  });
}

/// Service that fetches full record data for PDF/CSV export.
///
/// Unlike [ReportQueryService] (which only counts records), this service
/// fetches actual entity data and maps it to [ReportRow] for export.
abstract class ReportDataService {
  /// Fetch all activity records for selected categories and optional date range.
  ///
  /// Returns a flat chronological list of [ReportRow], sorted ascending by
  /// timestamp. On partial repository failure, affected categories return
  /// empty — the remaining categories are still included.
  Future<List<ReportRow>> fetchActivityRows({
    required String profileId,
    required Set<ActivityCategory> categories,
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Fetch reference library records for selected categories.
  ///
  /// Returns a map of category → list of [ReportRow]. No date filtering
  /// applies — reference data is current state, not time-series.
  Future<Map<ReferenceCategory, List<ReportRow>>> fetchReferenceRows({
    required String profileId,
    required Set<ReferenceCategory> categories,
  });
}
