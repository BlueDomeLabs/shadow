// lib/presentation/screens/journal_entries/journal_entry_list_screen.dart
// Journal entry list screen following ConditionListScreen pattern.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/utils/date_formatters.dart';
import 'package:shadow_app/core/validation/validation_rules.dart';
import 'package:shadow_app/domain/entities/journal_entry.dart';
import 'package:shadow_app/domain/usecases/journal_entries/journal_entries_usecases.dart';
import 'package:shadow_app/presentation/providers/journal_entries/journal_entry_list_provider.dart';
import 'package:shadow_app/presentation/screens/journal_entries/journal_entry_edit_screen.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';

/// Screen displaying the list of journal entries for a profile.
///
/// Cards show title/date/mood/snippet, delete via popup menu.
/// FAB to create new entry.
class JournalEntryListScreen extends ConsumerWidget {
  final String profileId;

  const JournalEntryListScreen({super.key, required this.profileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(journalEntryListProvider(profileId));

    return Scaffold(
      appBar: AppBar(title: const Text('Journal')),
      body: Semantics(
        label: 'Journal entry list',
        child: entriesAsync.when(
          data: (entries) => _buildEntryList(context, ref, entries),
          loading: () => const Center(
            child: ShadowStatus.loading(label: 'Loading journal entries'),
          ),
          error: (error, stack) => _buildErrorState(context, ref, error),
        ),
      ),
      floatingActionButton: Semantics(
        label: 'Add new journal entry',
        child: FloatingActionButton(
          onPressed: () => _navigateToAddEntry(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildEntryList(
    BuildContext context,
    WidgetRef ref,
    List<JournalEntry> entries,
  ) {
    if (entries.isEmpty) {
      return _buildEmptyState(context);
    }

    // Sort by timestamp descending (newest first)
    final sorted = List<JournalEntry>.from(entries)
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(journalEntryListProvider(profileId));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sorted.length,
        itemBuilder: (context, index) =>
            _buildEntryCard(context, ref, sorted[index]),
      ),
    );
  }

  Widget _buildEntryCard(
    BuildContext context,
    WidgetRef ref,
    JournalEntry entry,
  ) {
    final theme = Theme.of(context);
    final date = DateTime.fromMillisecondsSinceEpoch(entry.timestamp);
    final dateStr = DateFormatters.numericDate(date);
    final snippet =
        entry.content.length > ValidationRules.journalSnippetMaxLength
        ? '${entry.content.substring(0, ValidationRules.journalSnippetMaxLength)}...'
        : entry.content;

    return Padding(
      key: ValueKey(entry.id),
      padding: const EdgeInsets.only(bottom: 8),
      child: ShadowCard.listItem(
        onTap: () => _navigateToEditEntry(context, entry),
        semanticLabel: entry.title ?? 'Journal entry, $dateStr',
        semanticHint: 'Double tap to edit',
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.book,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (entry.title != null && entry.title!.isNotEmpty)
                    Text(
                      entry.title!,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  Text(
                    dateStr,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (entry.hasMood) ...[
                    const SizedBox(height: 2),
                    Text(
                      'Mood: ${entry.mood}/10',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    snippet,
                    style: theme.textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (entry.hasTags) ...[
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 4,
                      runSpacing: 2,
                      children: entry.tags!
                          .take(ValidationRules.tagPreviewMaxCount)
                          .map(
                            (tag) => Chip(
                              label: Text(tag),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              tooltip: 'More options',
              onSelected: (value) =>
                  _handleEntryAction(context, ref, entry, value),
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
              Icons.book_outlined,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text('No journal entries yet', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to write your first entry',
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
              'Failed to load journal entries',
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
                  ref.invalidate(journalEntryListProvider(profileId)),
              label: 'Retry',
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAddEntry(BuildContext context) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) => JournalEntryEditScreen(profileId: profileId),
      ),
    );
  }

  void _navigateToEditEntry(BuildContext context, JournalEntry entry) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) =>
            JournalEntryEditScreen(profileId: profileId, entry: entry),
      ),
    );
  }

  Future<void> _handleEntryAction(
    BuildContext context,
    WidgetRef ref,
    JournalEntry entry,
    String action,
  ) async {
    switch (action) {
      case 'edit':
        _navigateToEditEntry(context, entry);
      case 'delete':
        await _deleteEntry(context, ref, entry);
    }
  }

  Future<void> _deleteEntry(
    BuildContext context,
    WidgetRef ref,
    JournalEntry entry,
  ) async {
    final confirmed = await showDeleteConfirmationDialog(
      context: context,
      title: 'Delete Journal Entry?',
      contentText: 'This entry will be permanently deleted.',
    );

    if (confirmed ?? false) {
      try {
        await ref
            .read(journalEntryListProvider(profileId).notifier)
            .delete(
              DeleteJournalEntryInput(id: entry.id, profileId: profileId),
            );
        if (context.mounted) {
          showAccessibleSnackBar(
            context: context,
            message: 'Journal entry deleted',
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
