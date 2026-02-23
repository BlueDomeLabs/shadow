// lib/presentation/screens/notifications/quick_entry/supplement_quick_entry_sheet.dart
// Per 57_NOTIFICATION_SYSTEM.md — Supplements quick-entry sheet

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/domain/entities/intake_log.dart';
import 'package:shadow_app/domain/entities/supplement.dart';
import 'package:shadow_app/domain/usecases/intake_logs/intake_log_inputs.dart';
import 'package:shadow_app/presentation/providers/intake_logs/intake_log_list_provider.dart';
import 'package:shadow_app/presentation/providers/supplements/supplement_list_provider.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';

/// Quick-entry sheet for the Supplements notification category.
///
/// Accepts the pending [IntakeLog] records for the current notification time
/// and displays each as a row with the supplement name/dose and "Taken" /
/// "Skip" buttons. A "Mark All Taken" button at the bottom lets the user
/// confirm all at once.
///
/// Supplement metadata (name, dosage) is loaded from [SupplementList] and
/// matched by [IntakeLog.supplementId].
///
/// Per 57_NOTIFICATION_SYSTEM.md section: Supplements.
class SupplementQuickEntrySheet extends ConsumerStatefulWidget {
  final String profileId;

  /// The pending intake logs to display. Typically the logs whose
  /// scheduledTime falls within the current notification window.
  final List<IntakeLog> pendingLogs;

  const SupplementQuickEntrySheet({
    super.key,
    required this.profileId,
    required this.pendingLogs,
  });

  /// Shows the sheet as a modal bottom sheet.
  static Future<void> show(
    BuildContext context, {
    required String profileId,
    required List<IntakeLog> pendingLogs,
  }) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => SupplementQuickEntrySheet(
      profileId: profileId,
      pendingLogs: pendingLogs,
    ),
  );

  @override
  ConsumerState<SupplementQuickEntrySheet> createState() =>
      _SupplementQuickEntrySheetState();
}

class _SupplementQuickEntrySheetState
    extends ConsumerState<SupplementQuickEntrySheet> {
  // Track which logs have been actioned so rows can show resolved state
  final Map<String, _LogAction> _actions = {};
  bool _isSavingAll = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final supplementsAsync = ref.watch(
      supplementListProvider(widget.profileId),
    );

    final allActioned =
        widget.pendingLogs.isNotEmpty &&
        widget.pendingLogs.every((l) => _actions.containsKey(l.id));

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Semantics(
        label: 'Supplement intake quick-entry sheet',
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
              child: Text(
                'Supplement Check-in',
                style: theme.textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 16),
            if (widget.pendingLogs.isEmpty)
              Text(
                'No supplements due right now.',
                style: theme.textTheme.bodyMedium,
              )
            else
              supplementsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, _) => const SizedBox.shrink(),
                data: (supplements) {
                  final suppMap = {for (final s in supplements) s.id: s};
                  return ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 300),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: widget.pendingLogs.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final log = widget.pendingLogs[index];
                        final supp = suppMap[log.supplementId];
                        return _SupplementRow(
                          log: log,
                          supplement: supp,
                          action: _actions[log.id],
                          onTaken: () => _markTaken(log),
                          onSkipped: () => _markSkipped(log),
                        );
                      },
                    ),
                  );
                },
              ),
            const SizedBox(height: 16),
            if (widget.pendingLogs.isNotEmpty && !allActioned)
              ShadowButton.elevated(
                onPressed: _isSavingAll ? null : _markAllTaken,
                label: 'Mark all supplements taken',
                child: _isSavingAll
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Mark All Taken'),
              ),
            if (allActioned)
              ShadowButton.elevated(
                onPressed: () => Navigator.of(context).pop(),
                label: 'Done',
                child: const Text('Done'),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _markTaken(IntakeLog log) async {
    try {
      final notifier = ref.read(
        intakeLogListProvider(widget.profileId).notifier,
      );
      await notifier.markTaken(
        MarkTakenInput(
          id: log.id,
          profileId: widget.profileId,
          actualTime: DateTime.now().millisecondsSinceEpoch,
        ),
      );
      if (mounted) setState(() => _actions[log.id] = _LogAction.taken);
      _popIfAllActioned();
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
    }
  }

  Future<void> _markSkipped(IntakeLog log) async {
    try {
      final notifier = ref.read(
        intakeLogListProvider(widget.profileId).notifier,
      );
      await notifier.markSkipped(
        MarkSkippedInput(id: log.id, profileId: widget.profileId),
      );
      if (mounted) setState(() => _actions[log.id] = _LogAction.skipped);
      _popIfAllActioned();
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
    }
  }

  Future<void> _markAllTaken() async {
    setState(() => _isSavingAll = true);
    try {
      final notifier = ref.read(
        intakeLogListProvider(widget.profileId).notifier,
      );
      final now = DateTime.now().millisecondsSinceEpoch;
      for (final log in widget.pendingLogs) {
        if (!_actions.containsKey(log.id)) {
          await notifier.markTaken(
            MarkTakenInput(
              id: log.id,
              profileId: widget.profileId,
              actualTime: now,
            ),
          );
          if (mounted) setState(() => _actions[log.id] = _LogAction.taken);
        }
      }
      if (mounted) {
        Navigator.of(context).pop();
        showAccessibleSnackBar(
          context: context,
          message: 'All supplements marked taken',
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
      if (mounted) setState(() => _isSavingAll = false);
    }
  }

  void _popIfAllActioned() {
    if (!mounted) return;
    final allDone = widget.pendingLogs.every((l) => _actions.containsKey(l.id));
    if (allDone) {
      showAccessibleSnackBar(
        context: context,
        message: 'All supplements logged',
      );
    }
  }
}

/// A single supplement row with Taken and Skip buttons.
class _SupplementRow extends StatelessWidget {
  final IntakeLog log;
  final Supplement? supplement;
  final _LogAction? action;
  final VoidCallback onTaken;
  final VoidCallback onSkipped;

  const _SupplementRow({
    required this.log,
    required this.supplement,
    required this.action,
    required this.onTaken,
    required this.onSkipped,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = supplement?.name ?? 'Unknown supplement';
    final dose = supplement?.displayDosage ?? '';

    if (action != null) {
      return ListTile(
        title: Text(name),
        subtitle: dose.isNotEmpty ? Text(dose) : null,
        trailing: Icon(
          action == _LogAction.taken ? Icons.check_circle : Icons.cancel,
          color: action == _LogAction.taken
              ? theme.colorScheme.primary
              : theme.colorScheme.error,
        ),
        contentPadding: EdgeInsets.zero,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (dose.isNotEmpty)
                  Text(dose, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Semantics(
            label: 'Mark $name taken',
            button: true,
            child: TextButton(onPressed: onTaken, child: const Text('Taken')),
          ),
          Semantics(
            label: 'Skip $name',
            button: true,
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.error,
              ),
              onPressed: onSkipped,
              child: const Text('Skip'),
            ),
          ),
        ],
      ),
    );
  }
}

enum _LogAction { taken, skipped }
