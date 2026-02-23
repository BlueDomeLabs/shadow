// lib/presentation/screens/notifications/quick_entry/condition_quick_entry_sheet.dart
// Per 57_NOTIFICATION_SYSTEM.md — Condition Check-ins quick-entry sheet

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/domain/entities/condition.dart';
import 'package:shadow_app/domain/usecases/condition_logs/condition_log_inputs.dart';
import 'package:shadow_app/presentation/providers/condition_logs/condition_log_list_provider.dart';
import 'package:shadow_app/presentation/providers/conditions/condition_list_provider.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';
import 'package:uuid/uuid.dart';

/// Quick-entry sheet for Condition Check-ins notification category.
///
/// Opened when the user taps a Condition Check-ins notification.
/// Lists all active conditions with a severity slider (1-10) per condition,
/// an optional shared notes field, and a "Save Check-in" button that creates
/// a ConditionLog for every active condition shown.
/// Per 57_NOTIFICATION_SYSTEM.md section: Condition Check-ins.
class ConditionQuickEntrySheet extends ConsumerStatefulWidget {
  final String profileId;

  const ConditionQuickEntrySheet({super.key, required this.profileId});

  /// Shows the sheet as a modal bottom sheet.
  static Future<void> show(BuildContext context, {required String profileId}) =>
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (context) => ConditionQuickEntrySheet(profileId: profileId),
      );

  @override
  ConsumerState<ConditionQuickEntrySheet> createState() =>
      _ConditionQuickEntrySheetState();
}

class _ConditionQuickEntrySheetState
    extends ConsumerState<ConditionQuickEntrySheet> {
  final _notesController = TextEditingController();
  // Map conditionId → severity (1-10), initialised when conditions load
  final Map<String, double> _severities = {};
  bool _isSaving = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _initSeverities(List<Condition> active) {
    for (final c in active) {
      _severities.putIfAbsent(c.id, () => 5);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final conditionsAsync = ref.watch(conditionListProvider(widget.profileId));

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Semantics(
        label: 'Condition check-in quick-entry sheet',
        child: conditionsAsync.when(
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (e, _) => Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Error loading conditions: $e'),
          ),
          data: (allConditions) {
            final active = allConditions.where((c) => c.isActive).toList();
            _initSeverities(active);

            return Column(
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
                  child: Text(
                    'Condition Check-in',
                    style: theme.textTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: 16),
                if (active.isEmpty) ...[
                  Text(
                    'No active conditions to check in on.',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                ] else ...[
                  // Per-condition severity sliders
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 300),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: active.length,
                      separatorBuilder: (_, _) => const Divider(),
                      itemBuilder: (context, index) {
                        final condition = active[index];
                        final severity = _severities[condition.id] ?? 5;
                        return _ConditionSeverityRow(
                          condition: condition,
                          severity: severity,
                          onChanged: (value) =>
                              setState(() => _severities[condition.id] = value),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Shared notes
                  Semantics(
                    label: 'Check-in notes, optional',
                    textField: true,
                    child: ExcludeSemantics(
                      child: ShadowTextField(
                        controller: _notesController,
                        label: 'Notes',
                        hintText: 'Any notes about today',
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ShadowButton.elevated(
                    onPressed: _isSaving ? null : () => _handleSave(active),
                    label: 'Save condition check-in',
                    child: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Save Check-in'),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _handleSave(List<Condition> active) async {
    if (active.isEmpty) return;

    setState(() => _isSaving = true);

    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final notes = _notesController.text.trim();

      // Create one ConditionLog per active condition
      for (final condition in active) {
        final notifier = ref.read(
          conditionLogListProvider(widget.profileId, condition.id).notifier,
        );
        await notifier.log(
          LogConditionInput(
            profileId: widget.profileId,
            clientId: const Uuid().v4(),
            conditionId: condition.id,
            timestamp: now,
            severity: (_severities[condition.id] ?? 5).round(),
            notes: notes.isEmpty ? null : notes,
          ),
        );
      }

      if (mounted) {
        Navigator.of(context).pop();
        showAccessibleSnackBar(context: context, message: 'Check-in saved');
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

/// A single condition row with name and severity slider.
class _ConditionSeverityRow extends StatelessWidget {
  final Condition condition;
  final double severity;
  final ValueChanged<double> onChanged;

  const _ConditionSeverityRow({
    required this.condition,
    required this.severity,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  condition.name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Semantics(
                label: 'Severity ${severity.round()} out of 10',
                child: Text(
                  '${severity.round()}/10',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
          Semantics(
            label: '${condition.name} severity slider, 1 to 10',
            slider: true,
            child: ExcludeSemantics(
              child: Slider(
                value: severity,
                min: 1,
                max: 10,
                divisions: 9,
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
