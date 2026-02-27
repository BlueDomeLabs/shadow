// lib/presentation/screens/condition_logs/condition_log_screen.dart
// Implements 38_UI_FIELD_SPECIFICATIONS.md Section 8.2 - Condition Log Screen

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/utils/photo_picker_utils.dart';
import 'package:shadow_app/core/validation/validation_rules.dart';
import 'package:shadow_app/domain/entities/condition.dart';
import 'package:shadow_app/domain/entities/condition_log.dart';
import 'package:shadow_app/domain/usecases/condition_logs/condition_logs_usecases.dart';
import 'package:shadow_app/presentation/providers/condition_logs/condition_log_list_provider.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';
import 'package:uuid/uuid.dart';

/// Screen for creating or editing a condition log entry.
///
/// Follows 38_UI_FIELD_SPECIFICATIONS.md Section 8.2 exactly.
/// Uses [ConditionLogList] provider for state management via log().
///
/// Fields:
/// - Date & Time: DateTime picker (required, not future)
/// - Severity: Slider 1-10 (required, default 5)
/// - Is Flare-up: Toggle (optional, default false)
/// - Triggers: Multi-select from condition's trigger list + add new
/// - Photos: Multi-image picker stub (max 5, 5MB each)
/// - Notes: Text area (optional, max 2000)
class ConditionLogScreen extends ConsumerStatefulWidget {
  final String profileId;
  final Condition condition;
  final ConditionLog? conditionLog;

  const ConditionLogScreen({
    super.key,
    required this.profileId,
    required this.condition,
    this.conditionLog,
  });

  @override
  ConsumerState<ConditionLogScreen> createState() => _ConditionLogScreenState();
}

class _ConditionLogScreenState extends ConsumerState<ConditionLogScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late final TextEditingController _notesController;
  late final TextEditingController _newTriggerController;

  // State - Date & Time
  late DateTime _selectedDateTime;

  // State - Severity
  late double _severity;

  // State - Flare-up toggle
  late bool _isFlare;

  // State - Triggers
  late List<String> _availableTriggers;
  late List<String> _selectedTriggers;

  // State - Photo
  String? _photoPath;

  // State - Form dirty tracking
  bool _isDirty = false;
  bool _isSaving = false;

  // Validation error messages
  String? _dateTimeError;
  String? _notesError;
  String? _newTriggerError;

  bool get _isEditing => widget.conditionLog != null;

  @override
  void initState() {
    super.initState();
    final log = widget.conditionLog;

    _notesController = TextEditingController(text: log?.notes ?? '');
    _newTriggerController = TextEditingController();

    _selectedDateTime = log != null
        ? DateTime.fromMillisecondsSinceEpoch(log.timestamp)
        : DateTime.now();

    _severity = log != null ? log.severity.toDouble() : 5.0;
    _isFlare = log?.isFlare ?? false;

    // Initialize available triggers from condition + any existing triggers from log
    _availableTriggers = List<String>.from(widget.condition.triggers);
    if (log != null) {
      final existingTriggers = log.triggerList;
      for (final trigger in existingTriggers) {
        if (!_availableTriggers.contains(trigger)) {
          _availableTriggers.add(trigger);
        }
      }
      _selectedTriggers = List<String>.from(existingTriggers);
    } else {
      _selectedTriggers = [];
    }

    _photoPath = log?.photoPath;

    _notesController.addListener(_markDirty);
    _newTriggerController.addListener(_markDirty);
  }

  @override
  void dispose() {
    _notesController.dispose();
    _newTriggerController.dispose();
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
          title: Text(
            _isEditing ? 'Edit Condition Entry' : 'Log Condition Entry',
          ),
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
          label: _isEditing
              ? 'Edit condition log form'
              : 'Log condition entry form',
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSectionHeader(theme, 'Date & Time'),
                const SizedBox(height: 16),
                _buildDateTimePicker(theme),
                if (_dateTimeError != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    _dateTimeError!,
                    style: TextStyle(
                      color: theme.colorScheme.error,
                      fontSize: 12,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                const SizedBox(height: 8),
                _buildSectionHeader(theme, 'Severity'),
                const SizedBox(height: 16),
                _buildSeveritySlider(theme),
                const SizedBox(height: 16),
                const SizedBox(height: 8),
                _buildSectionHeader(theme, 'Flare Status'),
                const SizedBox(height: 16),
                _buildFlareToggle(theme),
                const SizedBox(height: 16),
                const SizedBox(height: 8),
                _buildSectionHeader(theme, 'Triggers'),
                const SizedBox(height: 16),
                _buildTriggersSection(theme),
                const SizedBox(height: 16),
                const SizedBox(height: 8),
                _buildSectionHeader(theme, 'Photos'),
                const SizedBox(height: 16),
                _buildPhotosSection(theme),
                const SizedBox(height: 16),
                const SizedBox(height: 8),
                _buildSectionHeader(theme, 'Notes'),
                const SizedBox(height: 16),
                Semantics(
                  label: 'Condition log notes, optional',
                  textField: true,
                  child: ExcludeSemantics(
                    child: ShadowTextField(
                      controller: _notesController,
                      label: 'Notes',
                      hintText: 'Notes about today',
                      errorText: _notesError,
                      maxLength: ValidationRules.notesMaxLength,
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
                        label: _isEditing
                            ? 'Save condition log changes'
                            : 'Save new condition log',
                        child: Text(_isEditing ? 'Save Changes' : 'Save'),
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

  Widget _buildDateTimePicker(ThemeData theme) {
    final dateText =
        '${_selectedDateTime.year}-${_selectedDateTime.month.toString().padLeft(2, '0')}-${_selectedDateTime.day.toString().padLeft(2, '0')}';
    final timeText =
        '${_selectedDateTime.hour.toString().padLeft(2, '0')}:${_selectedDateTime.minute.toString().padLeft(2, '0')}';

    return Semantics(
      label: 'Date of this log entry',
      child: ExcludeSemantics(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _pickDate,
                icon: const Icon(Icons.calendar_today),
                label: Text(dateText),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _pickTime,
                icon: const Icon(Icons.access_time),
                label: Text(timeText),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(ValidationRules.earliestSelectableYear),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        _selectedDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _selectedDateTime.hour,
          _selectedDateTime.minute,
        );
        _isDirty = true;
        _validateDateTime();
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );
    if (picked != null) {
      setState(() {
        _selectedDateTime = DateTime(
          _selectedDateTime.year,
          _selectedDateTime.month,
          _selectedDateTime.day,
          picked.hour,
          picked.minute,
        );
        _isDirty = true;
        _validateDateTime();
      });
    }
  }

  Widget _buildSeveritySlider(ThemeData theme) {
    final severityInt = _severity.round();
    final severityLabel = _severityLabel(severityInt);

    return Semantics(
      label: 'Current severity, 1 minimal to 10 severe, required',
      child: ExcludeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Severity: $severityInt',
                  style: theme.textTheme.bodyLarge,
                ),
                Text(severityLabel, style: theme.textTheme.bodyMedium),
              ],
            ),
            Slider(
              value: _severity,
              min: ValidationRules.severityMin.toDouble(),
              max: ValidationRules.severityMax.toDouble(),
              divisions:
                  ValidationRules.severityMax - ValidationRules.severityMin,
              label: '$severityInt - $severityLabel',
              onChanged: (value) {
                setState(() {
                  _severity = value;
                  _isDirty = true;
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('1 - Minimal', style: theme.textTheme.bodySmall),
                Text('5 - Moderate', style: theme.textTheme.bodySmall),
                Text('10 - Severe', style: theme.textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _severityLabel(int severity) {
    if (severity <= 1) return 'Minimal';
    if (severity <= 3) return 'Mild';
    if (severity <= 5) return 'Moderate';
    if (severity <= 7) return 'Significant';
    if (severity <= 9) return 'High';
    return 'Severe';
  }

  Widget _buildFlareToggle(ThemeData theme) => Semantics(
    label: 'Currently in flare-up, toggle',
    toggled: _isFlare,
    child: ExcludeSemantics(
      child: SwitchListTile(
        title: const Text('Is Flare-up'),
        value: _isFlare,
        onChanged: (value) {
          setState(() {
            _isFlare = value;
            _isDirty = true;
          });
        },
      ),
    ),
  );

  Widget _buildTriggersSection(ThemeData theme) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (_availableTriggers.isNotEmpty) ...[
        Text('Select triggers', style: theme.textTheme.bodyMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: _availableTriggers.map((trigger) {
            final isSelected = _selectedTriggers.contains(trigger);
            return FilterChip(
              label: Text(trigger),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedTriggers.add(trigger);
                  } else {
                    _selectedTriggers.remove(trigger);
                  }
                  _isDirty = true;
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
      ],
      Row(
        children: [
          Expanded(
            child: ShadowTextField(
              controller: _newTriggerController,
              label: 'Add New Trigger',
              hintText: 'Add new trigger',
              errorText: _newTriggerError,
              maxLength: ValidationRules.triggerMaxLength,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _addNewTrigger(),
            ),
          ),
          const SizedBox(width: 8),
          ShadowButton.icon(
            onPressed: _addNewTrigger,
            label: 'Add trigger',
            icon: Icons.add,
          ),
        ],
      ),
    ],
  );

  void _addNewTrigger() {
    final newTrigger = _newTriggerController.text.trim();
    if (newTrigger.isEmpty) {
      return;
    }
    if (newTrigger.length > ValidationRules.triggerMaxLength) {
      setState(() {
        _newTriggerError =
            'Trigger must not exceed ${ValidationRules.triggerMaxLength} characters';
      });
      return;
    }
    if (_availableTriggers.contains(newTrigger)) {
      // Already exists, just select it
      if (!_selectedTriggers.contains(newTrigger)) {
        setState(() {
          _selectedTriggers.add(newTrigger);
          _isDirty = true;
        });
      }
    } else {
      setState(() {
        _availableTriggers.add(newTrigger);
        _selectedTriggers.add(newTrigger);
        _isDirty = true;
      });
    }
    _newTriggerController.clear();
    setState(() {
      _newTriggerError = null;
    });
  }

  Widget _buildPhotosSection(ThemeData theme) => Semantics(
    label: 'Add photos',
    child: ExcludeSemantics(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_photoPath != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(_photoPath!),
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.broken_image),
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _photoPath = null;
                  _isDirty = true;
                });
              },
              icon: const Icon(Icons.close, size: 16),
              label: const Text('Remove photo'),
            ),
            const SizedBox(height: 8),
          ],
          OutlinedButton.icon(
            onPressed: _pickPhoto,
            icon: const Icon(Icons.photo_camera),
            label: const Text('Add photos'),
          ),
        ],
      ),
    ),
  );

  Future<void> _pickPhoto() async {
    try {
      final path = await showPhotoPicker(context);
      if (path != null && mounted) {
        setState(() {
          _photoPath = path;
          _isDirty = true;
        });
      }
    } on Exception {
      if (mounted) {
        showAccessibleSnackBar(
          context: context,
          message: 'Could not load photo',
        );
      }
    }
  }

  bool _validateDateTime() {
    String? error;
    if (_selectedDateTime.isAfter(DateTime.now())) {
      error = 'Date and time cannot be in the future';
    }
    setState(() => _dateTimeError = error);
    return error == null;
  }

  bool _validateNotes() {
    final notes = _notesController.text.trim();
    String? error;
    if (notes.length > ValidationRules.notesMaxLength) {
      error =
          'Notes must not exceed ${ValidationRules.notesMaxLength} characters';
    }
    setState(() => _notesError = error);
    return error == null;
  }

  bool _validateAll() {
    final dateTimeValid = _validateDateTime();
    final notesValid = _validateNotes();
    return dateTimeValid && notesValid;
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
      final triggersString = _selectedTriggers.isNotEmpty
          ? _selectedTriggers.join(',')
          : null;

      final notifier = ref.read(
        conditionLogListProvider(
          widget.profileId,
          widget.condition.id,
        ).notifier,
      );

      if (_isEditing) {
        await notifier.updateLog(
          UpdateConditionLogInput(
            id: widget.conditionLog!.id,
            profileId: widget.profileId,
            timestamp: _selectedDateTime.millisecondsSinceEpoch,
            severity: _severity.round(),
            notes: _notesController.text.trim().isNotEmpty
                ? _notesController.text.trim()
                : null,
            isFlare: _isFlare,
            triggers: triggersString,
            photoPath: _photoPath,
          ),
        );
      } else {
        await notifier.log(
          LogConditionInput(
            profileId: widget.profileId,
            clientId: const Uuid().v4(),
            conditionId: widget.condition.id,
            timestamp: _selectedDateTime.millisecondsSinceEpoch,
            severity: _severity.round(),
            notes: _notesController.text.trim().isNotEmpty
                ? _notesController.text.trim()
                : null,
            isFlare: _isFlare,
            triggers: triggersString,
            photoPath: _photoPath,
          ),
        );
      }

      if (mounted) {
        showAccessibleSnackBar(
          context: context,
          message: _isEditing
              ? 'Condition log updated successfully'
              : 'Condition log created successfully',
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
