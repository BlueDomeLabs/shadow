// lib/presentation/screens/notifications/quick_entry/vitals_quick_entry_sheet.dart
// Per 57_NOTIFICATION_SYSTEM.md — BBT/Vitals quick-entry sheet

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/domain/usecases/fluids_entries/fluids_entries_usecases.dart';
import 'package:shadow_app/presentation/providers/fluids_entries/fluids_entry_list_provider.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';
import 'package:uuid/uuid.dart';

/// Quick-entry sheet for BBT/Vitals notification category.
///
/// Captures basal body temperature (BBT) and optional notes.
/// BP, heart rate, and weight are intentionally excluded pending a dedicated
/// VitalsLog entity — see DECISIONS.md 2026-02-23.
/// Per 57_NOTIFICATION_SYSTEM.md section: BBT / Vitals.
class VitalsQuickEntrySheet extends ConsumerStatefulWidget {
  final String profileId;

  const VitalsQuickEntrySheet({super.key, required this.profileId});

  /// Shows the sheet as a modal bottom sheet.
  static Future<void> show(BuildContext context, {required String profileId}) =>
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (context) => VitalsQuickEntrySheet(profileId: profileId),
      );

  @override
  ConsumerState<VitalsQuickEntrySheet> createState() =>
      _VitalsQuickEntrySheetState();
}

class _VitalsQuickEntrySheetState extends ConsumerState<VitalsQuickEntrySheet> {
  final _bbtController = TextEditingController();
  final _notesController = TextEditingController();
  bool _isSaving = false;
  String? _bbtError;

  @override
  void dispose() {
    _bbtController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  bool _validateBbt() {
    final text = _bbtController.text.trim();
    if (text.isEmpty) {
      setState(() => _bbtError = 'BBT temperature is required');
      return false;
    }
    final value = double.tryParse(text);
    if (value == null) {
      setState(() => _bbtError = 'Enter a valid temperature');
      return false;
    }
    // Reasonable range: 35–42 °C / 95–108 °F
    if (value < 35 || value > 108) {
      setState(() => _bbtError = 'Temperature appears out of range');
      return false;
    }
    setState(() => _bbtError = null);
    return true;
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
        label: 'BBT and vitals quick-entry sheet',
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
            Semantics(
              header: true,
              child: Text('BBT / Vitals', style: theme.textTheme.titleLarge),
            ),
            const SizedBox(height: 8),
            // BBT reminder per spec
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'For accuracy, BBT should be measured before getting out of bed.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // BBT temperature input
            Semantics(
              label: 'BBT temperature, required',
              textField: true,
              child: ExcludeSemantics(
                child: ShadowTextField(
                  controller: _bbtController,
                  label: 'BBT Temperature',
                  hintText: 'e.g. 36.5',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textInputAction: TextInputAction.next,
                  errorText: _bbtError,
                  onChanged: (_) {
                    if (_bbtError != null) _validateBbt();
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Notes field
            Semantics(
              label: 'Vitals notes, optional',
              textField: true,
              child: ExcludeSemantics(
                child: ShadowTextField(
                  controller: _notesController,
                  label: 'Notes',
                  hintText: 'Any additional notes',
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ShadowButton.elevated(
              onPressed: _isSaving ? null : _handleSave,
              label: 'Save vitals',
              child: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save Vitals'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
    if (!_validateBbt()) return;

    setState(() => _isSaving = true);

    try {
      final now = DateTime.now();
      final startOfToday = DateTime(
        now.year,
        now.month,
        now.day,
      ).millisecondsSinceEpoch;
      final endOfToday = DateTime(
        now.year,
        now.month,
        now.day,
        23,
        59,
        59,
      ).millisecondsSinceEpoch;

      final notifier = ref.read(
        fluidsEntryListProvider(
          widget.profileId,
          startOfToday,
          endOfToday,
        ).notifier,
      );

      await notifier.log(
        LogFluidsEntryInput(
          profileId: widget.profileId,
          clientId: const Uuid().v4(),
          entryDate: now.millisecondsSinceEpoch,
          basalBodyTemperature: double.parse(_bbtController.text.trim()),
          bbtRecordedTime: now.millisecondsSinceEpoch,
          notes: _notesController.text.trim(),
        ),
      );

      if (mounted) {
        Navigator.of(context).pop();
        showAccessibleSnackBar(context: context, message: 'Vitals saved');
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
