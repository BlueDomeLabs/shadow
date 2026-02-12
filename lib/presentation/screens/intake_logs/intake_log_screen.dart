// lib/presentation/screens/intake_logs/intake_log_screen.dart
// Implements 38_UI_FIELD_SPECIFICATIONS.md Section 4.2 - Intake Log Screen

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/validation/validation_rules.dart';
import 'package:shadow_app/domain/entities/intake_log.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/usecases/intake_logs/intake_logs_usecases.dart';
import 'package:shadow_app/presentation/providers/intake_logs/intake_log_list_provider.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';

/// Screen for recording taking/skipping/snoozing a supplement intake.
///
/// Follows 38_UI_FIELD_SPECIFICATIONS.md Section 4.2 exactly.
/// This is an ACTION screen - IntakeLogs are created by the scheduling system
/// in `pending` status. Users only act on them (mark taken/skipped/snoozed).
///
/// Uses [IntakeLogList] provider for state management via
/// markTaken/markSkipped/markSnoozed.
///
/// Fields:
/// - Status: Segment (Taken/Skipped/Snoozed)
/// - Actual Time: Time Picker (conditional: status == Taken)
/// - Snooze Duration: Dropdown (conditional: status == Snoozed)
/// - Skip Reason: Dropdown (conditional: status == Skipped)
/// - Custom Reason: Text (conditional: Skip Reason == Other)
/// - Notes: Text (optional)
class IntakeLogScreen extends ConsumerStatefulWidget {
  final String profileId;
  final IntakeLog intakeLog;

  const IntakeLogScreen({
    super.key,
    required this.profileId,
    required this.intakeLog,
  });

  @override
  ConsumerState<IntakeLogScreen> createState() => _IntakeLogScreenState();
}

class _IntakeLogScreenState extends ConsumerState<IntakeLogScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers - Text fields
  late final TextEditingController _customReasonController;
  late final TextEditingController _notesController;

  // State - Segment / dropdown values
  late _ScreenStatus _selectedStatus;
  late TimeOfDay _selectedTime;
  late int _selectedSnoozeDuration;
  String? _selectedSkipReason;

  // State - Form dirty tracking
  bool _isDirty = false;
  bool _isSaving = false;

  // Validation error messages
  String? _customReasonError;
  String? _notesError;

  /// Status options exposed on this screen. Per spec Section 4.2:
  /// Taken, Skipped, Snoozed. Pending and Missed are NOT user-selectable.
  static const _skipReasons = [
    'Forgot',
    'Side Effects',
    'Out of Stock',
    'Other',
  ];

  static const _snoozeDurations = ValidationRules.validSnoozeDurationMinutes;

  @override
  void initState() {
    super.initState();

    _customReasonController = TextEditingController();
    _notesController = TextEditingController(text: widget.intakeLog.note ?? '');

    // Default status is Taken per spec
    _selectedStatus = _ScreenStatus.taken;

    // Default actual time is Now per spec
    _selectedTime = TimeOfDay.now();

    // Default snooze duration is 15 min per spec
    _selectedSnoozeDuration = 15;

    _customReasonController.addListener(_markDirty);
    _notesController.addListener(_markDirty);
  }

  @override
  void dispose() {
    _customReasonController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _markDirty() {
    if (!_isDirty) {
      setState(() {
        _isDirty = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: !_isDirty,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldLeave = await _confirmDiscard();
        if (shouldLeave && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Log Supplement Intake'),
          actions: [
            if (_isSaving)
              const Padding(
                padding: EdgeInsets.all(16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
          ],
        ),
        body: Semantics(
          label: 'Log supplement intake form',
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSectionHeader(theme, 'Status'),
                const SizedBox(height: 16),
                Semantics(
                  label: 'Intake status, required, taken skipped or snoozed',
                  child: ExcludeSemantics(
                    child: SegmentedButton<_ScreenStatus>(
                      segments: const [
                        ButtonSegment<_ScreenStatus>(
                          value: _ScreenStatus.taken,
                          label: Text('Taken'),
                        ),
                        ButtonSegment<_ScreenStatus>(
                          value: _ScreenStatus.skipped,
                          label: Text('Skipped'),
                        ),
                        ButtonSegment<_ScreenStatus>(
                          value: _ScreenStatus.snoozed,
                          label: Text('Snoozed'),
                        ),
                      ],
                      selected: {_selectedStatus},
                      onSelectionChanged: (selected) {
                        setState(() {
                          _selectedStatus = selected.first;
                          _isDirty = true;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Actual Time - visible only when status == Taken
                if (_selectedStatus == _ScreenStatus.taken) ...[
                  Semantics(
                    label: 'Time taken, required if taken',
                    child: ExcludeSemantics(
                      child: ListTile(
                        title: const Text('Actual Time'),
                        subtitle: Text(_formatTimeOfDay(_selectedTime)),
                        trailing: const Icon(Icons.access_time),
                        onTap: _pickTime,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Snooze Duration - visible only when status == Snoozed
                if (_selectedStatus == _ScreenStatus.snoozed) ...[
                  Semantics(
                    label: 'Snooze duration, required if snoozed',
                    child: ExcludeSemantics(
                      child: DropdownButtonFormField<int>(
                        initialValue: _selectedSnoozeDuration,
                        decoration: const InputDecoration(
                          labelText: 'Snooze Duration',
                        ),
                        items: _snoozeDurations
                            .map(
                              (minutes) => DropdownMenuItem<int>(
                                value: minutes,
                                child: Text('$minutes min'),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedSnoozeDuration = value;
                              _isDirty = true;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Skip Reason - visible only when status == Skipped
                if (_selectedStatus == _ScreenStatus.skipped) ...[
                  Semantics(
                    label: 'Skip reason, optional, select reason',
                    child: ExcludeSemantics(
                      child: DropdownButtonFormField<String>(
                        initialValue: _selectedSkipReason,
                        decoration: const InputDecoration(
                          labelText: 'Skip Reason',
                          hintText: 'Select reason',
                        ),
                        items: _skipReasons
                            .map(
                              (reason) => DropdownMenuItem<String>(
                                value: reason,
                                child: Text(reason),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedSkipReason = value;
                            _isDirty = true;
                            if (value != 'Other') {
                              _customReasonError = null;
                              _customReasonController.clear();
                            }
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Custom Reason - visible only when Skip Reason == Other
                  if (_selectedSkipReason == 'Other') ...[
                    Semantics(
                      label: 'Custom skip reason, required if other selected',
                      textField: true,
                      child: ExcludeSemantics(
                        child: ShadowTextField(
                          controller: _customReasonController,
                          label: 'Custom Reason',
                          hintText: 'Describe reason',
                          errorText: _customReasonError,
                          maxLength: ValidationRules.skipReasonMaxLength,
                          textInputAction: TextInputAction.next,
                          onChanged: (_) => _validateCustomReason(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ],

                const SizedBox(height: 8),
                _buildSectionHeader(theme, 'Notes'),
                const SizedBox(height: 16),
                Semantics(
                  label: 'Supplement notes, optional',
                  textField: true,
                  child: ExcludeSemantics(
                    child: ShadowTextField(
                      controller: _notesController,
                      label: 'Notes',
                      hintText: 'Any additional notes',
                      errorText: _notesError,
                      maxLength: ValidationRules.intakeNotesMaxLength,
                      maxLines: 4,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      onChanged: (_) => _validateNotes(),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: ShadowButton.outlined(
                        onPressed: _isSaving ? null : _handleCancel,
                        label: 'Cancel',
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ShadowButton.elevated(
                        onPressed: _isSaving ? null : _handleSave,
                        label: 'Save intake log',
                        child: const Text('Save'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) => Semantics(
    header: true,
    child: Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    ),
  );

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      helpText: 'Time taken',
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        _isDirty = true;
      });
    }
  }

  bool _validateCustomReason() {
    if (_selectedStatus != _ScreenStatus.skipped ||
        _selectedSkipReason != 'Other') {
      setState(() => _customReasonError = null);
      return true;
    }
    final customReason = _customReasonController.text.trim();
    String? error;
    if (customReason.isEmpty) {
      error = 'Custom reason is required when Other is selected';
    } else if (customReason.length > ValidationRules.skipReasonMaxLength) {
      error =
          'Custom reason must not exceed ${ValidationRules.skipReasonMaxLength} characters';
    }
    setState(() => _customReasonError = error);
    return error == null;
  }

  bool _validateNotes() {
    final notes = _notesController.text.trim();
    String? error;
    if (notes.length > ValidationRules.intakeNotesMaxLength) {
      error =
          'Notes must not exceed ${ValidationRules.intakeNotesMaxLength} characters';
    }
    setState(() => _notesError = error);
    return error == null;
  }

  bool _validateAll() {
    final customReasonValid = _validateCustomReason();
    final notesValid = _validateNotes();
    return customReasonValid && notesValid;
  }

  Future<void> _handleCancel() async {
    if (_isDirty) {
      final shouldLeave = await _confirmDiscard();
      if (!shouldLeave || !mounted) return;
    }
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<bool> _confirmDiscard() async {
    final confirmed = await showDeleteConfirmationDialog(
      context: context,
      title: 'Discard Changes?',
      contentText:
          'You have unsaved changes. Are you sure you want to discard them?',
      confirmButtonText: 'Discard',
      cancelButtonText: 'Keep Editing',
    );
    return confirmed ?? false;
  }

  Future<void> _handleSave() async {
    if (!_validateAll()) return;

    setState(() => _isSaving = true);

    try {
      final notifier = ref.read(
        intakeLogListProvider(widget.profileId).notifier,
      );

      switch (_selectedStatus) {
        case _ScreenStatus.taken:
          // Convert TimeOfDay to epoch milliseconds for today
          final now = DateTime.now();
          final actualDateTime = DateTime(
            now.year,
            now.month,
            now.day,
            _selectedTime.hour,
            _selectedTime.minute,
          );
          await notifier.markTaken(
            MarkTakenInput(
              id: widget.intakeLog.id,
              profileId: widget.profileId,
              actualTime: actualDateTime.millisecondsSinceEpoch,
            ),
          );
        case _ScreenStatus.skipped:
          String? reason;
          if (_selectedSkipReason == 'Other') {
            reason = _customReasonController.text.trim();
          } else {
            reason = _selectedSkipReason;
          }
          await notifier.markSkipped(
            MarkSkippedInput(
              id: widget.intakeLog.id,
              profileId: widget.profileId,
              reason: reason,
            ),
          );
        case _ScreenStatus.snoozed:
          await notifier.markSnoozed(
            MarkSnoozedInput(
              id: widget.intakeLog.id,
              profileId: widget.profileId,
              snoozeDurationMinutes: _selectedSnoozeDuration,
            ),
          );
      }

      if (mounted) {
        showAccessibleSnackBar(
          context: context,
          message: 'Intake logged successfully',
        );
        Navigator.of(context).pop();
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
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}

/// Internal enum for the 3 user-selectable status options on this screen.
/// Maps to [IntakeLogStatus.taken], [IntakeLogStatus.skipped],
/// [IntakeLogStatus.snoozed] respectively.
enum _ScreenStatus { taken, skipped, snoozed }
