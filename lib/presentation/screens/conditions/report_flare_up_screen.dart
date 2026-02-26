// lib/presentation/screens/conditions/report_flare_up_screen.dart
// Implements Phase 18b — ReportFlareUpScreen
// Modal bottom sheet for creating a new flare-up or viewing/editing an existing one.
//
// Edit mode constraints: UpdateFlareUpInput only accepts severity, notes, triggers,
// photoPath. Condition, startDate, and endDate are read-only in edit mode.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/validation/validation_rules.dart';
import 'package:shadow_app/domain/entities/condition.dart';
import 'package:shadow_app/domain/entities/flare_up.dart';
import 'package:shadow_app/domain/usecases/flare_ups/flare_up_inputs.dart';
import 'package:shadow_app/presentation/providers/conditions/condition_list_provider.dart';
import 'package:shadow_app/presentation/providers/flare_ups/flare_up_list_provider.dart';
import 'package:uuid/uuid.dart';

/// Modal bottom sheet for reporting a new flare-up or editing an existing one.
///
/// Constructor parameters:
/// - [profileId]: required, scopes the provider and use case calls
/// - [preselectedConditionId]: optional, pre-selects a condition in new mode
/// - [editingFlareUp]: optional, if provided the sheet opens in edit mode.
///   In edit mode, condition / startDate / endDate are read-only because
///   [UpdateFlareUpInput] does not support changing those fields.
class ReportFlareUpScreen extends ConsumerStatefulWidget {
  final String profileId;
  final String? preselectedConditionId;
  final FlareUp? editingFlareUp;

  const ReportFlareUpScreen({
    super.key,
    required this.profileId,
    this.preselectedConditionId,
    this.editingFlareUp,
  });

  @override
  ConsumerState<ReportFlareUpScreen> createState() =>
      _ReportFlareUpScreenState();
}

class _ReportFlareUpScreenState extends ConsumerState<ReportFlareUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _triggersController = TextEditingController();
  final _notesController = TextEditingController();

  String? _selectedConditionId;
  DateTime _startDateTime = DateTime.now();
  DateTime? _endDateTime;
  int _severity = 5;
  String? _errorMessage;
  bool _isSaving = false;

  bool get _isEditing => widget.editingFlareUp != null;

  static final _dateFormat = DateFormat('MMM d, yyyy h:mm a');

  @override
  void initState() {
    super.initState();
    final editing = widget.editingFlareUp;
    if (editing != null) {
      _selectedConditionId = editing.conditionId;
      _startDateTime = DateTime.fromMillisecondsSinceEpoch(editing.startDate);
      _endDateTime = editing.endDate != null
          ? DateTime.fromMillisecondsSinceEpoch(editing.endDate!)
          : null;
      _severity = editing.severity;
      _triggersController.text = editing.triggers.join(', ');
      _notesController.text = editing.notes ?? '';
    } else {
      _selectedConditionId = widget.preselectedConditionId;
    }
  }

  @override
  void dispose() {
    _triggersController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final conditionsAsync = ref.watch(conditionListProvider(widget.profileId));
    final activeConditions = conditionsAsync.maybeWhen(
      data: (conditions) => conditions.where((c) => !c.isArchived).toList(),
      orElse: () => <Condition>[],
    );

    final theme = Theme.of(context);
    final title = _isEditing ? 'Edit Flare-Up' : 'Report Flare-Up';

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: theme.textTheme.titleLarge),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                      tooltip: 'Close',
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Error banner
                if (_errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(
                        color: theme.colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // 1. Condition
                if (_isEditing)
                  _buildReadOnlyField(
                    context,
                    label: 'Condition',
                    value:
                        activeConditions
                            .where((c) => c.id == _selectedConditionId)
                            .map((c) => c.name)
                            .firstOrNull ??
                        _selectedConditionId ??
                        'Unknown',
                  )
                else
                  DropdownButtonFormField<String>(
                    key: const Key('condition_dropdown'),
                    initialValue: _selectedConditionId,
                    decoration: const InputDecoration(
                      labelText: 'Condition',
                      border: OutlineInputBorder(),
                    ),
                    items: activeConditions
                        .map(
                          (c) => DropdownMenuItem<String>(
                            value: c.id,
                            child: Text(c.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) =>
                        setState(() => _selectedConditionId = value),
                    validator: (value) =>
                        value == null ? 'Please select a condition' : null,
                  ),
                const SizedBox(height: 16),

                // 2. Start Date/Time
                if (_isEditing)
                  _buildReadOnlyField(
                    context,
                    label: 'Start Date/Time',
                    value: _dateFormat.format(_startDateTime),
                  )
                else
                  _buildDateTimeField(
                    context,
                    key: const Key('start_date_field'),
                    label: 'Start Date/Time',
                    value: _startDateTime,
                    onPicked: (dt) => setState(() => _startDateTime = dt),
                  ),
                const SizedBox(height: 16),

                // 3. End Date/Time
                if (_isEditing)
                  _buildReadOnlyField(
                    context,
                    label: 'End Date/Time',
                    value: _endDateTime != null
                        ? _dateFormat.format(_endDateTime!)
                        : 'Ongoing',
                  )
                else
                  _buildDateTimeField(
                    context,
                    key: const Key('end_date_field'),
                    label: 'End (leave empty if ongoing)',
                    value: _endDateTime,
                    onPicked: (dt) => setState(() => _endDateTime = dt),
                    optional: true,
                  ),
                const SizedBox(height: 16),

                // 4. Severity
                Text('Severity: $_severity', style: theme.textTheme.labelLarge),
                const SizedBox(height: 4),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: _severityColor(_severity),
                    thumbColor: _severityColor(_severity),
                  ),
                  child: Slider(
                    key: const Key('severity_slider'),
                    value: _severity.toDouble(),
                    min: ValidationRules.severityMin.toDouble(),
                    max: ValidationRules.severityMax.toDouble(),
                    divisions:
                        ValidationRules.severityMax -
                        ValidationRules.severityMin,
                    label: '$_severity',
                    onChanged: (value) =>
                        setState(() => _severity = value.round()),
                  ),
                ),
                const SizedBox(height: 16),

                // 5. Triggers
                TextFormField(
                  key: const Key('triggers_field'),
                  controller: _triggersController,
                  decoration: const InputDecoration(
                    labelText: 'Triggers (optional)',
                    hintText: 'e.g. stress, dairy, poor sleep',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                  validator: _validateTriggers,
                ),
                const SizedBox(height: 16),

                // 6. Notes
                TextFormField(
                  key: const Key('notes_field'),
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notes (optional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  maxLength: ValidationRules.notesMaxLength,
                  validator: _validateNotes,
                ),
                const SizedBox(height: 24),

                // Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      key: const Key('save_button'),
                      onPressed: _isSaving ? null : _save,
                      child: _isSaving
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.outline),
            borderRadius: BorderRadius.circular(4),
            color: theme.colorScheme.surfaceContainerHighest,
          ),
          child: Text(value, style: theme.textTheme.bodyLarge),
        ),
      ],
    );
  }

  Widget _buildDateTimeField(
    BuildContext context, {
    required Key key,
    required String label,
    required DateTime? value,
    required void Function(DateTime) onPicked,
    bool optional = false,
  }) {
    final displayValue = value != null ? _dateFormat.format(value) : 'Not set';

    return InkWell(
      key: key,
      onTap: () => _pickDateTime(context, value ?? DateTime.now(), onPicked),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: optional && value != null
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  tooltip: 'Clear end date',
                  onPressed: () => setState(() => _endDateTime = null),
                )
              : const Icon(Icons.calendar_today),
        ),
        child: Text(displayValue),
      ),
    );
  }

  Future<void> _pickDateTime(
    BuildContext context,
    DateTime initial,
    void Function(DateTime) onPicked,
  ) async {
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(hours: 1)),
    );
    if (date == null || !context.mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (time == null) return;

    onPicked(DateTime(date.year, date.month, date.day, time.hour, time.minute));
  }

  String? _validateTriggers(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final triggers = value.split(',').map((t) => t.trim()).toList();
    for (final trigger in triggers) {
      if (trigger.isNotEmpty &&
          trigger.length > ValidationRules.triggerMaxLength) {
        return 'Each trigger must be ${ValidationRules.triggerMaxLength} characters or less';
      }
    }
    return null;
  }

  String? _validateNotes(String? value) {
    if (value == null || value.isEmpty) return null;
    if (value.length > ValidationRules.notesMaxLength) {
      return 'Notes must be ${ValidationRules.notesMaxLength} characters or less';
    }
    return null;
  }

  Color _severityColor(int severity) {
    if (severity <= 3) return Colors.green.shade700;
    if (severity <= 6) return Colors.amber.shade800;
    return Colors.red.shade700;
  }

  List<String> _parseTriggers(String text) {
    if (text.trim().isEmpty) return [];
    return text
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      if (_isEditing) {
        await _saveEdit();
      } else {
        await _saveNew();
      }
      if (mounted) Navigator.pop(context);
    } on AppError catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.userMessage;
          _isSaving = false;
        });
      }
    } on Exception catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _saveNew() async {
    final input = LogFlareUpInput(
      profileId: widget.profileId,
      clientId: const Uuid().v4(),
      conditionId: _selectedConditionId!,
      startDate: _startDateTime.millisecondsSinceEpoch,
      endDate: _endDateTime?.millisecondsSinceEpoch,
      severity: _severity,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      triggers: _parseTriggers(_triggersController.text),
    );

    await ref.read(flareUpListProvider(widget.profileId).notifier).log(input);
  }

  Future<void> _saveEdit() async {
    final editing = widget.editingFlareUp!;
    final input = UpdateFlareUpInput(
      id: editing.id,
      profileId: widget.profileId,
      severity: _severity,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      triggers: _parseTriggers(_triggersController.text),
    );

    await ref
        .read(flareUpListProvider(widget.profileId).notifier)
        .updateFlareUp(input);
  }
}
