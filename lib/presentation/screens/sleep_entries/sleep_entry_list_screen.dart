// lib/presentation/screens/sleep_entries/sleep_entry_list_screen.dart
// Implements 38_UI_FIELD_SPECIFICATIONS.md Section 7 - Sleep Entry Screens

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/utils/date_formatters.dart';
import 'package:shadow_app/domain/entities/sleep_entry.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/usecases/sleep_entries/sleep_entries_usecases.dart';
import 'package:shadow_app/presentation/providers/sleep_entries/sleep_entry_list_provider.dart';
import 'package:shadow_app/presentation/screens/sleep_entries/sleep_entry_edit_screen.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';

/// Screen displaying the list of sleep entries for a profile.
///
/// Follows 38_UI_FIELD_SPECIFICATIONS.md Section 7 exactly.
/// Uses [SleepEntryList] provider for state management.
class SleepEntryListScreen extends ConsumerStatefulWidget {
  final String profileId;

  const SleepEntryListScreen({super.key, required this.profileId});

  @override
  ConsumerState<SleepEntryListScreen> createState() =>
      _SleepEntryListScreenState();
}

class _SleepEntryListScreenState extends ConsumerState<SleepEntryListScreen> {
  DateTimeRange? _dateFilter;

  String get profileId => widget.profileId;

  @override
  Widget build(BuildContext context) {
    final sleepEntriesAsync = ref.watch(sleepEntryListProvider(profileId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sleep Log'),
        actions: [
          if (_dateFilter != null)
            IconButton(
              icon: const Icon(Icons.filter_alt_off),
              onPressed: () => setState(() => _dateFilter = null),
              tooltip: 'Clear date filter',
            ),
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: _dateFilter != null
                  ? Theme.of(context).colorScheme.primary
                  : null,
            ),
            onPressed: () => _showFilterOptions(context),
            tooltip: 'Filter sleep entries',
          ),
        ],
      ),
      body: Semantics(
        label: 'Sleep entry list',
        child: sleepEntriesAsync.when(
          data: (entries) => _buildSleepEntryList(context, ref, entries),
          loading: () => const Center(
            child: ShadowStatus.loading(label: 'Loading sleep entries'),
          ),
          error: (error, stack) => _buildErrorState(context, ref, error),
        ),
      ),
      floatingActionButton: Semantics(
        label: 'Add new sleep entry',
        child: FloatingActionButton(
          onPressed: () => _navigateToAddSleepEntry(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildSleepEntryList(
    BuildContext context,
    WidgetRef ref,
    List<SleepEntry> entries,
  ) {
    // Apply date range filter if set
    final filtered = _dateFilter == null
        ? entries
        : entries.where((e) {
            final entryDate = DateTime.fromMillisecondsSinceEpoch(e.bedTime);
            return !entryDate.isBefore(_dateFilter!.start) &&
                !entryDate.isAfter(
                  _dateFilter!.end.add(const Duration(days: 1)),
                );
          }).toList();

    if (filtered.isEmpty) {
      return _buildEmptyState(context);
    }

    // Sort by bed time, most recent first
    final sortedEntries = List<SleepEntry>.from(filtered)
      ..sort((a, b) => b.bedTime.compareTo(a.bedTime));

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(sleepEntryListProvider(profileId));
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader(context, 'Sleep Entries'),
          const SizedBox(height: 8),
          ...sortedEntries.map(
            (entry) => _buildSleepEntryCard(context, ref, entry),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Semantics(
      header: true,
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSleepEntryCard(
    BuildContext context,
    WidgetRef ref,
    SleepEntry entry,
  ) {
    final theme = Theme.of(context);
    final bedDateTime = DateTime.fromMillisecondsSinceEpoch(entry.bedTime);
    final wakeDateTime = entry.wakeTime != null
        ? DateTime.fromMillisecondsSinceEpoch(entry.wakeTime!)
        : null;

    final dateStr = _formatDate(bedDateTime);
    final bedTimeStr = _formatTime(bedDateTime);
    final wakeTimeStr = wakeDateTime != null
        ? _formatTime(wakeDateTime)
        : 'Not recorded';
    final durationStr = _formatDuration(entry.totalSleepMinutes);
    final feelingStr = _getWakingFeelingLabel(entry.wakingFeeling);

    return Padding(
      key: ValueKey(entry.id),
      padding: const EdgeInsets.only(bottom: 8),
      child: ShadowCard.listItem(
        onTap: () => _navigateToEditSleepEntry(context, entry),
        semanticLabel: '$dateStr, $bedTimeStr to $wakeTimeStr, $feelingStr',
        semanticHint: 'Double tap to edit',
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getWakingFeelingIcon(entry.wakingFeeling),
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dateStr,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$bedTimeStr - $wakeTimeStr',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        durationStr,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        feelingStr,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              tooltip: 'More options',
              onSelected: (value) =>
                  _handleSleepEntryAction(context, ref, entry, value),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: ListTile(
                    leading: Icon(Icons.edit),
                    title: Text('Edit'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(Icons.delete),
                    title: Text('Delete'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
              child: const Icon(Icons.more_vert),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bedtime_outlined,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text('No sleep entries yet', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to log your first sleep entry',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, Object error) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text(
              'Failed to load sleep entries',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              error is AppError
                  ? error.userMessage
                  : 'Something went wrong. Please try again.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ShadowButton(
              onPressed: () =>
                  ref.invalidate(sleepEntryListProvider(profileId)),
              label: 'Retry',
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) => DateFormatters.shortDate(date);

  String _formatTime(DateTime dateTime) => DateFormatters.dateTime12h(dateTime);

  String _formatDuration(int? totalMinutes) {
    if (totalMinutes == null) return 'Duration unknown';
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    if (hours == 0) return '${minutes}m';
    if (minutes == 0) return '${hours}h';
    return '${hours}h ${minutes}m';
  }

  String _getWakingFeelingLabel(WakingFeeling feeling) => switch (feeling) {
    WakingFeeling.unrested => 'Unrested',
    WakingFeeling.neutral => 'Neutral',
    WakingFeeling.rested => 'Rested',
  };

  IconData _getWakingFeelingIcon(WakingFeeling feeling) => switch (feeling) {
    WakingFeeling.unrested => Icons.sentiment_dissatisfied,
    WakingFeeling.neutral => Icons.sentiment_neutral,
    WakingFeeling.rested => Icons.sentiment_satisfied,
  };

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => _FilterBottomSheet(
        initialRange: _dateFilter,
        onApply: (range) => setState(() => _dateFilter = range),
      ),
    );
  }

  void _navigateToAddSleepEntry(BuildContext context) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) => SleepEntryEditScreen(profileId: profileId),
      ),
    );
  }

  void _navigateToEditSleepEntry(BuildContext context, SleepEntry entry) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) =>
            SleepEntryEditScreen(profileId: profileId, sleepEntry: entry),
      ),
    );
  }

  Future<void> _handleSleepEntryAction(
    BuildContext context,
    WidgetRef ref,
    SleepEntry entry,
    String action,
  ) async {
    switch (action) {
      case 'edit':
        _navigateToEditSleepEntry(context, entry);
      case 'delete':
        await _confirmDelete(context, ref, entry);
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    SleepEntry entry,
  ) async {
    final confirmed = await showDeleteConfirmationDialog(
      context: context,
      title: 'Delete Sleep Entry?',
      contentText: 'This sleep entry will be permanently deleted.',
    );

    if (confirmed ?? false) {
      try {
        await ref
            .read(sleepEntryListProvider(profileId).notifier)
            .delete(DeleteSleepEntryInput(id: entry.id, profileId: profileId));
        if (context.mounted) {
          showAccessibleSnackBar(
            context: context,
            message: 'Sleep entry deleted',
          );
        }
      } on AppError catch (e) {
        if (context.mounted) {
          showAccessibleSnackBar(context: context, message: e.userMessage);
        }
      } on Exception {
        if (context.mounted) {
          showAccessibleSnackBar(
            context: context,
            message: 'An unexpected error occurred',
          );
        }
      }
    }
  }
}

/// Bottom sheet for filtering sleep entries by date range.
class _FilterBottomSheet extends StatefulWidget {
  final DateTimeRange? initialRange;
  final void Function(DateTimeRange?) onApply;

  const _FilterBottomSheet({required this.initialRange, required this.onApply});

  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  DateTimeRange? _selectedRange;

  @override
  void initState() {
    super.initState();
    _selectedRange = widget.initialRange;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = _selectedRange == null
        ? 'All dates'
        : '${DateFormatters.shortDate(_selectedRange!.start)} – '
              '${DateFormatters.shortDate(_selectedRange!.end)}';

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Filter Sleep Entries', style: theme.textTheme.titleLarge),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.date_range),
            title: const Text('Date range'),
            subtitle: Text(label),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              final now = DateTime.now();
              final range = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: now,
                initialDateRange: _selectedRange,
              );
              if (range != null) {
                setState(() => _selectedRange = range);
              }
            },
          ),
          if (_selectedRange != null)
            TextButton(
              onPressed: () => setState(() => _selectedRange = null),
              child: const Text('Clear filter'),
            ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: () {
                  widget.onApply(_selectedRange);
                  Navigator.pop(context);
                },
                child: const Text('Apply'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
