// lib/domain/reports/report_export_service.dart
// Abstract port for generating PDF and CSV export files.

import 'dart:io';

import 'package:shadow_app/domain/reports/report_data_service.dart';
import 'package:shadow_app/domain/reports/report_types.dart';

/// Service that generates export files (PDF and CSV) from [ReportRow] data.
///
/// Files are written to the device temporary directory and returned as [File]
/// objects. Callers are responsible for sharing or moving the files.
abstract class ReportExportService {
  /// Generate a PDF for an Activity Report.
  Future<File> exportActivityPdf({
    required String profileId,
    required String profileName,
    required List<ReportRow> rows,
    required Set<ActivityCategory> categories,
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Generate a CSV for an Activity Report.
  ///
  /// Header: Date,Time,Category,Title,Details
  Future<File> exportActivityCsv({
    required String profileId,
    required List<ReportRow> rows,
  });

  /// Generate a PDF for a Reference Report, grouped by category.
  Future<File> exportReferencePdf({
    required String profileId,
    required String profileName,
    required Map<ReferenceCategory, List<ReportRow>> data,
  });

  /// Generate a CSV for a Reference Report.
  ///
  /// Header: Category,Title,Details
  Future<File> exportReferenceCsv({
    required String profileId,
    required Map<ReferenceCategory, List<ReportRow>> data,
  });
}
