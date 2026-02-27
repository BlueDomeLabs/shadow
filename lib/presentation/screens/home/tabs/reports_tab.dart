// lib/presentation/screens/home/tabs/reports_tab.dart
// Reports tab — Activity Report and Reference Report configuration and preview.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/domain/reports/report_query_service.dart';
import 'package:shadow_app/domain/reports/report_types.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';

/// Reports tab — lets the user configure, preview, and export health reports.
///
/// Two report types are supported:
/// - Activity Report: time-stamped health events (logs)
/// - Reference Report: library/setup data (supplements, food, conditions)
///
/// PDF/CSV export is not yet available; the Export button is disabled.
class ReportsTab extends ConsumerWidget {
  final String profileId;
  final String? profileName;

  const ReportsTab({super.key, required this.profileId, this.profileName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titlePrefix = profileName != null ? "$profileName's " : '';
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('${titlePrefix}Reports'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 8),
          _ReportTypeCard(
            icon: Icons.event_note,
            title: 'Activity Report',
            description:
                'A chronological log of your health events — food logs, '
                'supplement intake, fluids, sleep, condition check-ins, '
                'flare-ups, journal entries, and photos.',
            onConfigure: () => _openActivitySheet(context, ref),
          ),
          const SizedBox(height: 16),
          _ReportTypeCard(
            icon: Icons.menu_book,
            title: 'Reference Report',
            description:
                'A snapshot of your library data — food items, supplements, '
                'and conditions currently set up in the app.',
            onConfigure: () => _openReferenceSheet(context, ref),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'PDF and CSV export will be available in an upcoming update.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  void _openActivitySheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _ActivityReportSheet(
        profileId: profileId,
        service: ref.read(reportQueryServiceProvider),
      ),
    );
  }

  void _openReferenceSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _ReferenceReportSheet(
        profileId: profileId,
        service: ref.read(reportQueryServiceProvider),
      ),
    );
  }
}

// =============================================================================
// Report type card
// =============================================================================

class _ReportTypeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onConfigure;

  const _ReportTypeCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onConfigure,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.teal, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Semantics(
              label: 'Configure $title',
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onConfigure,
                  icon: const Icon(Icons.tune),
                  label: const Text('Configure'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// Activity Report bottom sheet
// =============================================================================

class _ActivityReportSheet extends StatefulWidget {
  final String profileId;
  final ReportQueryService service;

  const _ActivityReportSheet({required this.profileId, required this.service});

  @override
  State<_ActivityReportSheet> createState() => _ActivityReportSheetState();
}

class _ActivityReportSheetState extends State<_ActivityReportSheet> {
  final Set<ActivityCategory> _selected = {};
  DateTime? _startDate;
  DateTime? _endDate;
  Map<ActivityCategory, int>? _counts;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Default: all categories selected
    _selected.addAll(ActivityCategory.values);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Column(
        children: [
          // Handle
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  'Activity Report',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  tooltip: 'Close',
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(),
          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Date range
                  Text(
                    'Date Range',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Semantics(
                          label:
                              'Start date: ${_startDate != null ? _formatDate(_startDate!) : 'All time'}',
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.calendar_today, size: 16),
                            label: Text(
                              _startDate != null
                                  ? _formatDate(_startDate!)
                                  : 'Start date',
                            ),
                            onPressed: () => _pickStartDate(context),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Semantics(
                          label:
                              'End date: ${_endDate != null ? _formatDate(_endDate!) : 'All time'}',
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.calendar_today, size: 16),
                            label: Text(
                              _endDate != null
                                  ? _formatDate(_endDate!)
                                  : 'End date',
                            ),
                            onPressed: () => _pickEndDate(context),
                          ),
                        ),
                      ),
                      if (_startDate != null || _endDate != null)
                        IconButton(
                          icon: const Icon(Icons.clear),
                          tooltip: 'Clear date range',
                          onPressed: () => setState(() {
                            _startDate = null;
                            _endDate = null;
                            _counts = null;
                          }),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Category select
                  Row(
                    children: [
                      Text(
                        'Categories',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: _selectAll,
                        child: const Text('Select All'),
                      ),
                      TextButton(
                        onPressed: _clearAll,
                        child: const Text('Clear All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ..._buildActivityCheckboxes(theme),
                ],
              ),
            ),
          ),
          // Preview results — pinned so always visible after calling Preview
          if (_counts != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Preview',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ..._buildCountRows(theme),
                ],
              ),
            ),
          // Action buttons — pinned outside scroll so always visible
          Padding(
            padding: EdgeInsets.fromLTRB(
              16,
              8,
              16,
              mediaQuery.viewInsets.bottom + 16,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Semantics(
                    label: 'Preview activity report',
                    child: FilledButton.icon(
                      key: const Key('activity-preview-btn'),
                      onPressed: _selected.isEmpty || _isLoading
                          ? null
                          : _preview,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.preview),
                      label: Text(_isLoading ? 'Loading…' : 'Preview'),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Tooltip(
                    message: 'PDF & CSV export coming soon',
                    child: Semantics(
                      label: 'Export activity report — coming soon',
                      child: FilledButton.icon(
                        key: const Key('activity-export-btn'),
                        onPressed: null,
                        icon: const Icon(Icons.download),
                        label: const Text('Export'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildActivityCheckboxes(ThemeData theme) {
    const labels = {
      ActivityCategory.foodLogs: 'Food Logs',
      ActivityCategory.supplementIntake: 'Supplement Intake',
      ActivityCategory.fluids: 'Fluids',
      ActivityCategory.sleep: 'Sleep',
      ActivityCategory.conditionLogs: 'Condition Check-ins',
      ActivityCategory.flareUps: 'Flare-Ups',
      ActivityCategory.journalEntries: 'Journal Entries',
      ActivityCategory.photos: 'Photos',
    };
    return ActivityCategory.values
        .map(
          (cat) => Semantics(
            label: '${labels[cat]} checkbox',
            child: CheckboxListTile(
              title: Text(labels[cat]!),
              value: _selected.contains(cat),
              onChanged: (checked) => setState(() {
                if (checked ?? false) {
                  _selected.add(cat);
                } else {
                  _selected.remove(cat);
                }
                _counts = null;
              }),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ),
        )
        .toList();
  }

  List<Widget> _buildCountRows(ThemeData theme) {
    const labels = {
      ActivityCategory.foodLogs: 'Food Logs',
      ActivityCategory.supplementIntake: 'Supplement Intake',
      ActivityCategory.fluids: 'Fluids',
      ActivityCategory.sleep: 'Sleep',
      ActivityCategory.conditionLogs: 'Condition Check-ins',
      ActivityCategory.flareUps: 'Flare-Ups',
      ActivityCategory.journalEntries: 'Journal Entries',
      ActivityCategory.photos: 'Photos',
    };
    return _counts!.entries
        .map(
          (e) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                Text(labels[e.key] ?? e.key.name),
                const Spacer(),
                Text(
                  '${e.value} record${e.value == 1 ? '' : 's'}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();
  }

  void _selectAll() => setState(() {
    _selected.addAll(ActivityCategory.values);
    _counts = null;
  });

  void _clearAll() => setState(() {
    _selected.clear();
    _counts = null;
  });

  Future<void> _pickStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
        _counts = null;
      });
    }
  }

  Future<void> _pickEndDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _endDate = picked;
        _counts = null;
      });
    }
  }

  Future<void> _preview() async {
    setState(() => _isLoading = true);
    try {
      final counts = await widget.service.countActivity(
        profileId: widget.profileId,
        categories: Set.from(_selected),
        startDate: _startDate,
        endDate: _endDate,
      );
      if (mounted) {
        setState(() {
          _counts = counts;
          _isLoading = false;
        });
      }
    } on Exception {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

// =============================================================================
// Reference Report bottom sheet
// =============================================================================

class _ReferenceReportSheet extends StatefulWidget {
  final String profileId;
  final ReportQueryService service;

  const _ReferenceReportSheet({required this.profileId, required this.service});

  @override
  State<_ReferenceReportSheet> createState() => _ReferenceReportSheetState();
}

class _ReferenceReportSheetState extends State<_ReferenceReportSheet> {
  final Set<ReferenceCategory> _selected = {};
  Map<ReferenceCategory, int>? _counts;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selected.addAll(ReferenceCategory.values);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.85,
      builder: (context, scrollController) => Column(
        children: [
          // Handle
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  'Reference Report',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  tooltip: 'Close',
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(),
          // Scrollable content (categories only)
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Categories',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  ..._buildReferenceCheckboxes(theme),
                ],
              ),
            ),
          ),
          // Preview results — pinned so always visible after calling Preview
          if (_counts != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Preview',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ..._buildCountRows(theme),
                ],
              ),
            ),
          // Action buttons — pinned outside scroll so always visible
          Padding(
            padding: EdgeInsets.fromLTRB(
              16,
              8,
              16,
              mediaQuery.viewInsets.bottom + 16,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Semantics(
                    label: 'Preview reference report',
                    child: FilledButton.icon(
                      key: const Key('reference-preview-btn'),
                      onPressed: _selected.isEmpty || _isLoading
                          ? null
                          : _preview,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.preview),
                      label: Text(_isLoading ? 'Loading…' : 'Preview'),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Tooltip(
                    message: 'PDF & CSV export coming soon',
                    child: Semantics(
                      label: 'Export reference report — coming soon',
                      child: FilledButton.icon(
                        key: const Key('reference-export-btn'),
                        onPressed: null,
                        icon: const Icon(Icons.download),
                        label: const Text('Export'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildReferenceCheckboxes(ThemeData theme) {
    const labels = {
      ReferenceCategory.foodLibrary: 'Food Library',
      ReferenceCategory.supplementLibrary: 'Supplement Library',
      ReferenceCategory.conditions: 'Conditions',
    };
    return ReferenceCategory.values
        .map(
          (cat) => Semantics(
            label: '${labels[cat]} checkbox',
            child: CheckboxListTile(
              title: Text(labels[cat]!),
              value: _selected.contains(cat),
              onChanged: (checked) => setState(() {
                if (checked ?? false) {
                  _selected.add(cat);
                } else {
                  _selected.remove(cat);
                }
                _counts = null;
              }),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ),
        )
        .toList();
  }

  List<Widget> _buildCountRows(ThemeData theme) {
    const labels = {
      ReferenceCategory.foodLibrary: 'Food Library',
      ReferenceCategory.supplementLibrary: 'Supplement Library',
      ReferenceCategory.conditions: 'Conditions',
    };
    return _counts!.entries
        .map(
          (e) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                Text(labels[e.key] ?? e.key.name),
                const Spacer(),
                Text(
                  '${e.value} record${e.value == 1 ? '' : 's'}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();
  }

  Future<void> _preview() async {
    setState(() => _isLoading = true);
    try {
      final counts = await widget.service.countReference(
        profileId: widget.profileId,
        categories: Set.from(_selected),
      );
      if (mounted) {
        setState(() {
          _counts = counts;
          _isLoading = false;
        });
      }
    } on Exception {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
