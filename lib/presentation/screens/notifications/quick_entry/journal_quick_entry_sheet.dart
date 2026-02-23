// lib/presentation/screens/notifications/quick_entry/journal_quick_entry_sheet.dart
// Per 57_NOTIFICATION_SYSTEM.md — Journal Entries quick-entry sheet

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/domain/usecases/journal_entries/journal_entries_usecases.dart';
import 'package:shadow_app/presentation/providers/journal_entries/journal_entry_list_provider.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';
import 'package:uuid/uuid.dart';

/// Quick-entry sheet for Journal Entries notification category.
///
/// Opened when the user taps a Journal Entries notification.
/// Creates a new journal entry with pre-filled today's date and
/// keyboard focus on the content field.
/// Per 57_NOTIFICATION_SYSTEM.md section: Journal Entries.
class JournalQuickEntrySheet extends ConsumerStatefulWidget {
  final String profileId;

  const JournalQuickEntrySheet({super.key, required this.profileId});

  /// Shows the sheet as a modal bottom sheet.
  static Future<void> show(BuildContext context, {required String profileId}) =>
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (context) => JournalQuickEntrySheet(profileId: profileId),
      );

  @override
  ConsumerState<JournalQuickEntrySheet> createState() =>
      _JournalQuickEntrySheetState();
}

class _JournalQuickEntrySheetState
    extends ConsumerState<JournalQuickEntrySheet> {
  final _contentController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  String _todayLabel() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Semantics(
        label: 'Journal entry quick-entry sheet',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant.withAlpha(100),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Title
            Semantics(
              header: true,
              child: Text('Journal Entry', style: theme.textTheme.titleLarge),
            ),
            const SizedBox(height: 4),
            Text(
              _todayLabel(),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            // Content field
            Semantics(
              label: 'Journal entry content, required',
              textField: true,
              child: ExcludeSemantics(
                child: ShadowTextField(
                  controller: _contentController,
                  label: 'How was your day?',
                  hintText: 'Write your journal entry here...',
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ShadowButton.elevated(
              onPressed: _isSaving ? null : _handleSave,
              label: 'Save journal entry',
              child: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save Entry'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
    final content = _contentController.text.trim();
    if (content.isEmpty) {
      showAccessibleSnackBar(
        context: context,
        message: 'Please enter some text before saving',
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final notifier = ref.read(
        journalEntryListProvider(widget.profileId).notifier,
      );
      await notifier.create(
        CreateJournalEntryInput(
          profileId: widget.profileId,
          clientId: const Uuid().v4(),
          timestamp: DateTime.now().millisecondsSinceEpoch,
          content: content,
        ),
      );

      if (mounted) {
        Navigator.of(context).pop();
        showAccessibleSnackBar(
          context: context,
          message: 'Journal entry saved',
        );
      }
    } on AppError catch (e) {
      if (mounted) {
        showAccessibleSnackBar(context: context, message: e.userMessage);
      }
    } on Exception {
      if (mounted) {
        showAccessibleSnackBar(
          context: context,
          message: 'An unexpected error occurred',
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}
