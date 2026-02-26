// lib/presentation/screens/supplements/supplement_log_screen.dart
// Ad-hoc supplement intake logging screen.
// Per 38_UI_FIELD_SPECIFICATIONS.md Section 4.2

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/domain/entities/intake_log.dart';
import 'package:shadow_app/domain/entities/supplement.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';
import 'package:uuid/uuid.dart';

/// Screen for recording an ad-hoc supplement intake.
///
/// Creates an [IntakeLog] with status=taken directly via the repository,
/// bypassing the scheduling system (which handles pre-scheduled logs).
class SupplementLogScreen extends ConsumerStatefulWidget {
  final String profileId;
  final Supplement supplement;

  const SupplementLogScreen({
    super.key,
    required this.profileId,
    required this.supplement,
  });

  @override
  ConsumerState<SupplementLogScreen> createState() =>
      _SupplementLogScreenState();
}

class _SupplementLogScreenState extends ConsumerState<SupplementLogScreen> {
  late DateTime _loggedAt;
  final _notesController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loggedAt = DateTime.now();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Log Intake')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Supplement info card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.supplement.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.supplement.displayDosage,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Time picker
            InkWell(
              onTap: _pickTime,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Time Taken',
                  suffixIcon: Icon(Icons.access_time),
                ),
                child: Text(_formatDateTime(_loggedAt)),
              ),
            ),
            const SizedBox(height: 16),

            // Notes field
            ShadowTextField(
              controller: _notesController,
              label: 'Notes',
              hintText: 'Optional notes',
              maxLength: 200,
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
            ),

            const Spacer(),

            // Save button
            ShadowButton.elevated(
              onPressed: _isSaving ? null : _handleSave,
              label: 'Log supplement as taken',
              child: Text(_isSaving ? 'Saving…' : 'Log as Taken'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _loggedAt,
      firstDate: DateTime(2020),
      lastDate: now,
    );
    if (!mounted || date == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_loggedAt),
    );
    if (!mounted || time == null) return;
    final picked = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    if (!picked.isAfter(DateTime.now())) {
      setState(() => _loggedAt = picked);
    }
  }

  Future<void> _handleSave() async {
    setState(() => _isSaving = true);
    try {
      final now = _loggedAt.millisecondsSinceEpoch;
      final log = IntakeLog(
        id: const Uuid().v4(),
        clientId: const Uuid().v4(),
        profileId: widget.profileId,
        supplementId: widget.supplement.id,
        scheduledTime: now,
        actualTime: now,
        status: IntakeLogStatus.taken,
        note: _notesController.text.trim().isNotEmpty
            ? _notesController.text.trim()
            : null,
        syncMetadata: SyncMetadata(
          syncCreatedAt: now,
          syncUpdatedAt: now,
          syncDeviceId: '',
        ),
      );

      final repo = ref.read(intakeLogRepositoryProvider);
      final result = await repo.create(log);

      if (!mounted) return;
      result.when(
        success: (_) {
          showAccessibleSnackBar(
            context: context,
            message: '${widget.supplement.name} logged as taken',
          );
          Navigator.of(context).pop();
        },
        failure: (error) {
          showAccessibleSnackBar(context: context, message: error.userMessage);
        },
      );
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

  String _formatDateTime(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour < 12 ? 'AM' : 'PM';
    return '${dt.month}/${dt.day}/${dt.year} $hour:$minute $period';
  }
}
