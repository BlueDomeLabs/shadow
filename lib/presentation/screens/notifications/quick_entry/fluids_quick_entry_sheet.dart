// lib/presentation/screens/notifications/quick_entry/fluids_quick_entry_sheet.dart
// Per 57_NOTIFICATION_SYSTEM.md — Fluids quick-entry sheet

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/domain/usecases/fluids_entries/fluids_entries_usecases.dart';
import 'package:shadow_app/presentation/providers/fluids_entries/fluids_entry_list_provider.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';
import 'package:uuid/uuid.dart';

/// Quick-entry sheet for Fluids notification category.
///
/// Opened when the user taps a Fluids notification.
/// Captures water intake in ml and an optional other fluid entry,
/// then creates a FluidsEntry record.
/// Per 57_NOTIFICATION_SYSTEM.md section: Fluids.
class FluidsQuickEntrySheet extends ConsumerStatefulWidget {
  final String profileId;

  const FluidsQuickEntrySheet({super.key, required this.profileId});

  /// Shows the sheet as a modal bottom sheet.
  static Future<void> show(BuildContext context, {required String profileId}) =>
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (context) => FluidsQuickEntrySheet(profileId: profileId),
      );

  @override
  ConsumerState<FluidsQuickEntrySheet> createState() =>
      _FluidsQuickEntrySheetState();
}

class _FluidsQuickEntrySheetState extends ConsumerState<FluidsQuickEntrySheet> {
  final _waterController = TextEditingController();
  final _otherFluidNameController = TextEditingController();
  final _otherFluidAmountController = TextEditingController();
  bool _isSaving = false;
  String? _waterError;

  @override
  void dispose() {
    _waterController.dispose();
    _otherFluidNameController.dispose();
    _otherFluidAmountController.dispose();
    super.dispose();
  }

  bool _validate() {
    final waterText = _waterController.text.trim();
    final otherName = _otherFluidNameController.text.trim();

    // At least one fluid type must be entered
    if (waterText.isEmpty && otherName.isEmpty) {
      setState(() => _waterError = 'Enter water amount or an other fluid');
      return false;
    }

    if (waterText.isNotEmpty) {
      final ml = int.tryParse(waterText);
      if (ml == null || ml <= 0) {
        setState(() => _waterError = 'Enter a positive number of ml');
        return false;
      }
    }
    setState(() => _waterError = null);
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
        label: 'Fluids quick-entry sheet',
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
              child: Text('Log Fluids', style: theme.textTheme.titleLarge),
            ),
            const SizedBox(height: 16),
            // Water intake
            Semantics(
              label: 'Water intake in millilitres, optional',
              textField: true,
              child: ExcludeSemantics(
                child: ShadowTextField(
                  controller: _waterController,
                  label: 'Water (ml)',
                  hintText: 'e.g. 250',
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  errorText: _waterError,
                  onChanged: (_) {
                    if (_waterError != null) _validate();
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Other fluid
            Semantics(
              header: true,
              child: Text('Other Fluid', style: theme.textTheme.titleSmall),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Semantics(
                    label: 'Other fluid name, optional',
                    textField: true,
                    child: ExcludeSemantics(
                      child: ShadowTextField(
                        controller: _otherFluidNameController,
                        label: 'Name',
                        hintText: 'e.g. Coffee',
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Semantics(
                    label: 'Other fluid amount, optional',
                    textField: true,
                    child: ExcludeSemantics(
                      child: ShadowTextField(
                        controller: _otherFluidAmountController,
                        label: 'Amount',
                        hintText: 'e.g. 1 cup',
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ShadowButton.elevated(
              onPressed: _isSaving ? null : _handleSave,
              label: 'Log fluids',
              child: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Log Fluids'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
    if (!_validate()) return;

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

      final waterText = _waterController.text.trim();
      final otherName = _otherFluidNameController.text.trim();
      final otherAmount = _otherFluidAmountController.text.trim();

      await notifier.log(
        LogFluidsEntryInput(
          profileId: widget.profileId,
          clientId: const Uuid().v4(),
          entryDate: now.millisecondsSinceEpoch,
          waterIntakeMl: waterText.isNotEmpty ? int.parse(waterText) : null,
          otherFluidName: otherName.isNotEmpty ? otherName : null,
          otherFluidAmount: otherAmount.isNotEmpty ? otherAmount : null,
        ),
      );

      if (mounted) {
        Navigator.of(context).pop();
        showAccessibleSnackBar(context: context, message: 'Fluids logged');
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
