// lib/data/services/report_export_service_impl.dart
// Concrete implementation of ReportExportService — PDF via pdf package, CSV via string building.

import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shadow_app/domain/reports/report_data_service.dart';
import 'package:shadow_app/domain/reports/report_export_service.dart';
import 'package:shadow_app/domain/reports/report_types.dart';

/// Generates PDF and CSV export files from [ReportRow] data.
///
/// PDF uses the `pdf` package. CSV is built with plain string concatenation.
/// Files are written to [getTemporaryDirectory] (overridable in tests).
class ReportExportServiceImpl implements ReportExportService {
  final Future<Directory> Function() _getDirectory;

  ReportExportServiceImpl({Future<Directory> Function()? getDirectory})
    : _getDirectory = getDirectory ?? getTemporaryDirectory;

  // ---------------------------------------------------------------------------
  // Activity exports
  // ---------------------------------------------------------------------------

  @override
  Future<File> exportActivityPdf({
    required String profileId,
    required String profileName,
    required List<ReportRow> rows,
    required Set<ActivityCategory> categories,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final now = DateTime.now();
    final doc = pw.Document()
      ..addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          header: (context) => _buildPdfHeader(
            profileName: profileName,
            reportType: 'Activity Report',
            dateRange: _buildDateRangeStr(startDate, endDate),
            generatedDate: _formatDate(now),
          ),
          footer: (context) => pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(
              'Page ${context.pageNumber} of ${context.pagesCount}',
              style: const pw.TextStyle(fontSize: 9),
            ),
          ),
          build: (context) => [
            if (rows.isEmpty)
              pw.Padding(
                padding: const pw.EdgeInsets.only(top: 16),
                child: pw.Text('No records found for the selected criteria.'),
              )
            else
              pw.Table(
                border: pw.TableBorder.all(
                  color: PdfColors.grey400,
                  width: 0.5,
                ),
                columnWidths: const {
                  0: pw.FixedColumnWidth(58),
                  1: pw.FixedColumnWidth(36),
                  2: pw.FixedColumnWidth(80),
                  3: pw.FlexColumnWidth(2),
                  4: pw.FlexColumnWidth(3),
                },
                children: [
                  _buildPdfHeaderRow([
                    'Date',
                    'Time',
                    'Category',
                    'Title',
                    'Details',
                  ]),
                  ...rows.map(
                    (row) => pw.TableRow(
                      children: [
                        _pdfCell(_formatDate(row.timestamp)),
                        _pdfCell(_formatTime(row.timestamp)),
                        _pdfCell(row.category),
                        _pdfCell(row.title),
                        _pdfCell(row.details),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      );

    final dir = await _getDirectory();
    final filename = 'shadow_activity_report_${_formatFilenameDate(now)}.pdf';
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(await doc.save());
    return file;
  }

  @override
  Future<File> exportActivityCsv({
    required String profileId,
    required List<ReportRow> rows,
  }) async {
    final buffer = StringBuffer()..writeln('Date,Time,Category,Title,Details');
    for (final row in rows) {
      buffer.writeln(
        '"${_formatDate(row.timestamp)}",'
        '"${_formatTime(row.timestamp)}",'
        '"${_csvEscape(row.category)}",'
        '"${_csvEscape(row.title)}",'
        '"${_csvEscape(row.details)}"',
      );
    }

    final dir = await _getDirectory();
    final now = DateTime.now();
    final filename = 'shadow_activity_report_${_formatFilenameDate(now)}.csv';
    final file = File('${dir.path}/$filename');
    await file.writeAsString(buffer.toString());
    return file;
  }

  // ---------------------------------------------------------------------------
  // Reference exports
  // ---------------------------------------------------------------------------

  @override
  Future<File> exportReferencePdf({
    required String profileId,
    required String profileName,
    required Map<ReferenceCategory, List<ReportRow>> data,
  }) async {
    final now = DateTime.now();
    final doc = pw.Document()
      ..addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          header: (context) => _buildPdfHeader(
            profileName: profileName,
            reportType: 'Reference Report',
            dateRange: null,
            generatedDate: _formatDate(now),
          ),
          footer: (context) => pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(
              'Page ${context.pageNumber} of ${context.pagesCount}',
              style: const pw.TextStyle(fontSize: 9),
            ),
          ),
          build: (context) {
            final widgets = <pw.Widget>[];
            for (final entry in data.entries) {
              widgets.add(
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 12, bottom: 4),
                  child: pw.Text(
                    _referenceCategoryLabel(entry.key),
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              );
              if (entry.value.isEmpty) {
                widgets.add(
                  pw.Text(
                    'No items in this category.',
                    style: const pw.TextStyle(fontSize: 9),
                  ),
                );
              } else {
                widgets.add(
                  pw.Table(
                    border: pw.TableBorder.all(
                      color: PdfColors.grey400,
                      width: 0.5,
                    ),
                    columnWidths: const {
                      0: pw.FlexColumnWidth(2),
                      1: pw.FlexColumnWidth(3),
                    },
                    children: [
                      _buildPdfHeaderRow(['Title', 'Details']),
                      ...entry.value.map(
                        (row) => pw.TableRow(
                          children: [
                            _pdfCell(row.title),
                            _pdfCell(row.details),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            }
            return widgets;
          },
        ),
      );

    final dir = await _getDirectory();
    final filename = 'shadow_reference_report_${_formatFilenameDate(now)}.pdf';
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(await doc.save());
    return file;
  }

  @override
  Future<File> exportReferenceCsv({
    required String profileId,
    required Map<ReferenceCategory, List<ReportRow>> data,
  }) async {
    final buffer = StringBuffer()..writeln('Category,Title,Details');
    for (final entry in data.entries) {
      final categoryLabel = _referenceCategoryLabel(entry.key);
      for (final row in entry.value) {
        buffer.writeln(
          '"${_csvEscape(categoryLabel)}",'
          '"${_csvEscape(row.title)}",'
          '"${_csvEscape(row.details)}"',
        );
      }
    }

    final dir = await _getDirectory();
    final now = DateTime.now();
    final filename = 'shadow_reference_report_${_formatFilenameDate(now)}.csv';
    final file = File('${dir.path}/$filename');
    await file.writeAsString(buffer.toString());
    return file;
  }

  // ---------------------------------------------------------------------------
  // PDF widget helpers
  // ---------------------------------------------------------------------------

  pw.Widget _buildPdfHeader({
    required String profileName,
    required String reportType,
    required String? dateRange,
    required String generatedDate,
  }) => pw.Container(
    margin: const pw.EdgeInsets.only(bottom: 8),
    padding: const pw.EdgeInsets.only(bottom: 8),
    decoration: const pw.BoxDecoration(
      border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey400)),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Shadow — $reportType',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16),
        ),
        pw.Text(
          'Profile: $profileName',
          style: const pw.TextStyle(fontSize: 10),
        ),
        if (dateRange != null)
          pw.Text(
            'Date range: $dateRange',
            style: const pw.TextStyle(fontSize: 10),
          ),
        pw.Text(
          'Generated: $generatedDate',
          style: const pw.TextStyle(fontSize: 10),
        ),
      ],
    ),
  );

  pw.TableRow _buildPdfHeaderRow(List<String> headers) => pw.TableRow(
    decoration: const pw.BoxDecoration(color: PdfColors.grey200),
    children: headers.map(_pdfHeaderCell).toList(),
  );

  pw.Widget _pdfHeaderCell(String text) => pw.Padding(
    padding: const pw.EdgeInsets.all(4),
    child: pw.Text(
      text,
      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9),
    ),
  );

  pw.Widget _pdfCell(String text) => pw.Padding(
    padding: const pw.EdgeInsets.all(4),
    child: pw.Text(text, style: const pw.TextStyle(fontSize: 9)),
  );

  // ---------------------------------------------------------------------------
  // Shared formatting helpers
  // ---------------------------------------------------------------------------

  String _csvEscape(String value) => value.replaceAll('"', '""');

  String _formatDate(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';

  String _formatTime(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  String _formatFilenameDate(DateTime dt) =>
      '${dt.year}${dt.month.toString().padLeft(2, '0')}${dt.day.toString().padLeft(2, '0')}';

  String _buildDateRangeStr(DateTime? start, DateTime? end) {
    if (start == null && end == null) return 'All time';
    if (start != null && end != null) {
      return '${_formatDate(start)} to ${_formatDate(end)}';
    }
    if (start != null) return 'From ${_formatDate(start)}';
    return 'Until ${_formatDate(end!)}';
  }

  String _referenceCategoryLabel(ReferenceCategory category) =>
      switch (category) {
        ReferenceCategory.foodLibrary => 'Food Library',
        ReferenceCategory.supplementLibrary => 'Supplement Library',
        ReferenceCategory.conditions => 'Conditions',
      };
}
