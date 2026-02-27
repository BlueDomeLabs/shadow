// lib/domain/reports/report_query_service.dart
// Abstract port for querying record counts used in report previews.

import 'package:shadow_app/domain/reports/report_types.dart';

/// Service that counts records for each report category.
///
/// Used by the Reports tab to show a preview summary before export.
/// All methods return record counts — they do NOT fetch full entity data.
abstract class ReportQueryService {
  /// Returns the record count for each requested [ActivityCategory].
  ///
  /// [startDate] and [endDate] are optional date filters. When null, all
  /// records for the profile are counted regardless of date.
  Future<Map<ActivityCategory, int>> countActivity({
    required String profileId,
    required Set<ActivityCategory> categories,
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Returns the record count for each requested [ReferenceCategory].
  ///
  /// Reference categories are library items (not time-stamped events),
  /// so date filtering does not apply. Only non-archived items are counted.
  Future<Map<ReferenceCategory, int>> countReference({
    required String profileId,
    required Set<ReferenceCategory> categories,
  });
}
