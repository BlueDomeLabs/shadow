// lib/presentation/screens/notifications/quick_entry/fluids_quick_entry_sheet.dart
// Per 57_NOTIFICATION_SYSTEM.md — Bodily output quick-entry sheet
// NOTE: Sheet class name retained for compatibility with home_screen.dart import.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/domain/entities/bodily_output_enums.dart';
import 'package:shadow_app/domain/entities/bodily_output_log.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/presentation/providers/bodily_output_providers.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';

/// Quick-entry sheet for the Bodily Output notification category.
///
/// Opened when the user taps a Body Output notification.
/// Allows quick logging of a urine, bowel, or gas event.
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
  BodyOutputType _outputType = BodyOutputType.urine;
  GasSeverity _gasSeverity = GasSeverity.moderate;
  bool _isSaving = false;

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
        label: 'Body output quick-entry sheet',
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
              child: Text('Log Body Output', style: theme.textTheme.titleLarge),
            ),
            const SizedBox(height: 16),
            Text('Type', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children:
                  [
                        BodyOutputType.urine,
                        BodyOutputType.bowel,
                        BodyOutputType.gas,
                      ]
                      .map(
                        (type) => ChoiceChip(
                          label: Text(_typeLabel(type)),
                          selected: _outputType == type,
                          onSelected: (_) => setState(() => _outputType = type),
                        ),
                      )
                      .toList(),
            ),
            if (_outputType == BodyOutputType.gas) ...[
              const SizedBox(height: 16),
              Text('Severity', style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: GasSeverity.values
                    .map(
                      (s) => ChoiceChip(
                        label: Text(_severityLabel(s)),
                        selected: _gasSeverity == s,
                        onSelected: (_) => setState(() => _gasSeverity = s),
                      ),
                    )
                    .toList(),
              ),
            ],
            const SizedBox(height: 24),
            ShadowButton.elevated(
              onPressed: _isSaving ? null : _handleSave,
              label: 'Log body output',
              child: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Log'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
    setState(() => _isSaving = true);

    final now = DateTime.now().millisecondsSinceEpoch;
    final log = BodilyOutputLog(
      id: '',
      clientId: '',
      profileId: widget.profileId,
      occurredAt: now,
      outputType: _outputType,
      gasSeverity: _outputType == BodyOutputType.gas ? _gasSeverity : null,
      syncMetadata: SyncMetadata(
        syncCreatedAt: now,
        syncUpdatedAt: now,
        syncDeviceId: '',
      ),
    );

    final result = await ref.read(logBodilyOutputUseCaseProvider)(log);

    if (!mounted) return;

    result.when(
      success: (_) {
        Navigator.of(context).pop();
        showAccessibleSnackBar(context: context, message: 'Event logged');
      },
      failure: (e) {
        setState(() => _isSaving = false);
        showAccessibleSnackBar(
          context: context,
          message: 'Could not save: ${e.userMessage}',
        );
      },
    );
  }

  String _typeLabel(BodyOutputType type) => switch (type) {
    BodyOutputType.urine => 'Urine',
    BodyOutputType.bowel => 'Bowel',
    BodyOutputType.gas => 'Gas',
    BodyOutputType.menstruation => 'Menstruation',
    BodyOutputType.bbt => 'BBT',
    BodyOutputType.custom => 'Custom',
  };

  String _severityLabel(GasSeverity s) => switch (s) {
    GasSeverity.mild => 'Mild',
    GasSeverity.moderate => 'Moderate',
    GasSeverity.severe => 'Severe',
  };
}
