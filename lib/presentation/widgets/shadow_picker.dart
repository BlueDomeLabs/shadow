/// Accessible picker components for Shadow app health data input.
///
/// Provides [ShadowPicker] with configurable picker types for specialized
/// health data selection, following WCAG 2.1 Level AA accessibility standards.
///
/// See also:
/// * [09_WIDGET_LIBRARY.md] Section 6 for picker specifications
/// * [12_ACCESSIBILITY_GUIDELINES.md] for full accessibility requirements
/// * [ShadowInput] for temperature and diet inputs
library;

import 'package:flutter/material.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/presentation/widgets/widget_enums.dart';

/// A consolidated picker widget for health data selection.
///
/// [ShadowPicker] provides a unified interface for specialized pickers
/// in the Shadow app, ensuring consistent accessibility support.
///
/// {@template shadow_picker}
/// All picker instances:
/// - Meet WCAG 2.1 touch target requirements (48x48 dp minimum)
/// - Include semantic labels for screen readers
/// - Support keyboard navigation
/// {@endtemplate}
///
/// ## Flow Picker
///
/// ```dart
/// ShadowPicker.flow(
///   value: MenstruationFlow.medium,
///   onChanged: (flow) => setState(() => _flow = flow),
///   label: 'Flow Intensity',
/// )
/// ```
///
/// ## Weekday Selector
///
/// ```dart
/// ShadowPicker.weekday(
///   selectedDays: [0, 1, 2, 3, 4],  // Mon-Fri
///   onChanged: (days) => setState(() => _days = days),
///   label: 'Reminder Days',
/// )
/// ```
///
/// ## Time Picker
///
/// ```dart
/// ShadowPicker.time(
///   times: [TimeOfDay(hour: 8, minute: 0)],
///   onTimesChanged: (times) => setState(() => _times = times),
///   label: 'Notification Times',
/// )
/// ```
///
/// See also:
///
/// * [PickerType] for available picker variants
/// * [ShadowInput] for health-specific inputs
class ShadowPicker extends StatelessWidget {
  /// The type of picker to display.
  final PickerType pickerType;

  /// The semantic label for screen readers.
  ///
  /// This is announced by VoiceOver/TalkBack when the picker receives focus.
  final String label;

  /// Optional hint providing additional context.
  final String? hint;

  /// Whether to show text labels for options (default: true).
  final bool showLabels;

  /// Layout orientation for applicable picker types.
  final Axis orientation;

  /// Whether the picker uses compact layout.
  final bool compact;

  /// Current flow value (for [PickerType.flow]).
  final MenstruationFlow? flowValue;

  /// Callback when flow changes.
  final ValueChanged<MenstruationFlow?>? onFlowChanged;

  /// Selected weekday indices (for [PickerType.weekday]).
  /// 0 = Monday, 6 = Sunday.
  final List<int>? selectedDays;

  /// Callback when weekdays change.
  final ValueChanged<List<int>>? onDaysChanged;

  /// Current diet type (for [PickerType.dietType]).
  final DietPresetType? dietValue;

  /// Custom diet description (shown when dietValue is 'custom').
  final String? dietDescription;

  /// Callback when diet type changes.
  final ValueChanged<DietPresetType?>? onDietChanged;

  /// Callback when diet description changes.
  final ValueChanged<String?>? onDescriptionChanged;

  /// Selected times (for [PickerType.time]).
  final List<TimeOfDay>? times;

  /// Callback when times change.
  final ValueChanged<List<TimeOfDay>>? onTimesChanged;

  /// Maximum number of times selectable (for [PickerType.time]).
  final int maxTimes;

  /// Selected date (for [PickerType.date]).
  final DateTime? dateValue;

  /// Callback when date changes.
  final ValueChanged<DateTime?>? onDateChanged;

  /// First selectable date (for [PickerType.date]).
  final DateTime? firstDate;

  /// Last selectable date (for [PickerType.date]).
  final DateTime? lastDate;

  /// Selected items (for [PickerType.multiSelect]).
  final List<String>? selectedItems;

  /// Available items (for [PickerType.multiSelect]).
  final List<String>? availableItems;

  /// Callback when selection changes (for [PickerType.multiSelect]).
  final ValueChanged<List<String>>? onSelectionChanged;

  /// Creates a picker widget.
  const ShadowPicker({
    super.key,
    required this.pickerType,
    required this.label,
    this.hint,
    this.showLabels = true,
    this.orientation = Axis.horizontal,
    this.compact = false,
    this.flowValue,
    this.onFlowChanged,
    this.selectedDays,
    this.onDaysChanged,
    this.dietValue,
    this.dietDescription,
    this.onDietChanged,
    this.onDescriptionChanged,
    this.times,
    this.onTimesChanged,
    this.maxTimes = 5,
    this.dateValue,
    this.onDateChanged,
    this.firstDate,
    this.lastDate,
    this.selectedItems,
    this.availableItems,
    this.onSelectionChanged,
  });

  /// Creates a flow intensity picker.
  const ShadowPicker.flow({
    super.key,
    required this.label,
    this.hint,
    this.showLabels = true,
    this.orientation = Axis.horizontal,
    this.flowValue,
    required this.onFlowChanged,
  }) : pickerType = PickerType.flow,
       compact = false,
       selectedDays = null,
       onDaysChanged = null,
       dietValue = null,
       dietDescription = null,
       onDietChanged = null,
       onDescriptionChanged = null,
       times = null,
       onTimesChanged = null,
       maxTimes = 5,
       dateValue = null,
       onDateChanged = null,
       firstDate = null,
       lastDate = null,
       selectedItems = null,
       availableItems = null,
       onSelectionChanged = null;

  /// Creates a weekday selector.
  const ShadowPicker.weekday({
    super.key,
    required this.label,
    this.hint,
    this.compact = false,
    required this.selectedDays,
    required this.onDaysChanged,
  }) : pickerType = PickerType.weekday,
       showLabels = true,
       orientation = Axis.horizontal,
       flowValue = null,
       onFlowChanged = null,
       dietValue = null,
       dietDescription = null,
       onDietChanged = null,
       onDescriptionChanged = null,
       times = null,
       onTimesChanged = null,
       maxTimes = 5,
       dateValue = null,
       onDateChanged = null,
       firstDate = null,
       lastDate = null,
       selectedItems = null,
       availableItems = null,
       onSelectionChanged = null;

  /// Creates a diet type selector.
  const ShadowPicker.dietType({
    super.key,
    required this.label,
    this.hint,
    this.dietValue,
    this.dietDescription,
    required this.onDietChanged,
    this.onDescriptionChanged,
  }) : pickerType = PickerType.dietType,
       showLabels = true,
       orientation = Axis.horizontal,
       compact = false,
       flowValue = null,
       onFlowChanged = null,
       selectedDays = null,
       onDaysChanged = null,
       times = null,
       onTimesChanged = null,
       maxTimes = 5,
       dateValue = null,
       onDateChanged = null,
       firstDate = null,
       lastDate = null,
       selectedItems = null,
       availableItems = null,
       onSelectionChanged = null;

  /// Creates a time picker for notifications.
  const ShadowPicker.time({
    super.key,
    required this.label,
    this.hint,
    required this.times,
    required this.onTimesChanged,
    this.maxTimes = 5,
  }) : pickerType = PickerType.time,
       showLabels = true,
       orientation = Axis.horizontal,
       compact = false,
       flowValue = null,
       onFlowChanged = null,
       selectedDays = null,
       onDaysChanged = null,
       dietValue = null,
       dietDescription = null,
       onDietChanged = null,
       onDescriptionChanged = null,
       dateValue = null,
       onDateChanged = null,
       firstDate = null,
       lastDate = null,
       selectedItems = null,
       availableItems = null,
       onSelectionChanged = null;

  /// Creates a date picker.
  const ShadowPicker.date({
    super.key,
    required this.label,
    this.hint,
    this.dateValue,
    required this.onDateChanged,
    this.firstDate,
    this.lastDate,
  }) : pickerType = PickerType.date,
       showLabels = true,
       orientation = Axis.horizontal,
       compact = false,
       flowValue = null,
       onFlowChanged = null,
       selectedDays = null,
       onDaysChanged = null,
       dietValue = null,
       dietDescription = null,
       onDietChanged = null,
       onDescriptionChanged = null,
       times = null,
       onTimesChanged = null,
       maxTimes = 5,
       selectedItems = null,
       availableItems = null,
       onSelectionChanged = null;

  /// Creates a multi-select picker.
  const ShadowPicker.multiSelect({
    super.key,
    required this.label,
    this.hint,
    required this.selectedItems,
    required this.availableItems,
    required this.onSelectionChanged,
  }) : pickerType = PickerType.multiSelect,
       showLabels = true,
       orientation = Axis.horizontal,
       compact = false,
       flowValue = null,
       onFlowChanged = null,
       selectedDays = null,
       onDaysChanged = null,
       dietValue = null,
       dietDescription = null,
       onDietChanged = null,
       onDescriptionChanged = null,
       times = null,
       onTimesChanged = null,
       maxTimes = 5,
       dateValue = null,
       onDateChanged = null,
       firstDate = null,
       lastDate = null;

  @override
  Widget build(BuildContext context) =>
      Semantics(label: label, hint: hint, child: _buildPicker(context));

  Widget _buildPicker(BuildContext context) {
    switch (pickerType) {
      case PickerType.flow:
        return _FlowPicker(
          value: flowValue,
          onChanged: onFlowChanged,
          showLabels: showLabels,
          orientation: orientation,
          label: label,
        );
      case PickerType.weekday:
        return _WeekdayPicker(
          selectedDays: selectedDays ?? [],
          onChanged: onDaysChanged ?? (_) {},
          compact: compact,
          label: label,
        );
      case PickerType.dietType:
        return _DietTypePicker(
          value: dietValue,
          description: dietDescription,
          onTypeChanged: onDietChanged,
          onDescriptionChanged: onDescriptionChanged,
          label: label,
        );
      case PickerType.time:
        return _TimePicker(
          times: times ?? [],
          onTimesChanged: onTimesChanged ?? (_) {},
          maxTimes: maxTimes,
          label: label,
        );
      case PickerType.date:
        return _DatePicker(
          value: dateValue,
          onChanged: onDateChanged,
          firstDate: firstDate,
          lastDate: lastDate,
          label: label,
        );
      case PickerType.multiSelect:
        return _MultiSelectPicker(
          selectedItems: selectedItems ?? [],
          availableItems: availableItems ?? [],
          onSelectionChanged: onSelectionChanged ?? (_) {},
          label: label,
        );
    }
  }
}

/// Internal flow intensity picker implementation.
class _FlowPicker extends StatelessWidget {
  final MenstruationFlow? value;
  final ValueChanged<MenstruationFlow?>? onChanged;
  final bool showLabels;
  final Axis orientation;
  final String label;

  const _FlowPicker({
    required this.value,
    required this.onChanged,
    required this.showLabels,
    required this.orientation,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const options = MenstruationFlow.values;

    final children = options.map((flow) {
      final isSelected = value == flow;
      final color = _getFlowColor(flow);

      return Semantics(
        label: _getFlowLabel(flow),
        selected: isSelected,
        child: InkWell(
          onTap: onChanged != null ? () => onChanged!(flow) : null,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected ? color.withAlpha(51) : null,
              border: Border.all(
                color: isSelected ? color : theme.colorScheme.outline,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getFlowIcon(flow),
                  color: isSelected ? color : theme.colorScheme.onSurface,
                  size: 24,
                ),
                if (showLabels) ...[
                  const SizedBox(height: 4),
                  Text(
                    _getFlowLabel(flow),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isSelected ? color : null,
                      fontWeight: isSelected ? FontWeight.bold : null,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    }).toList();

    return orientation == Axis.horizontal
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: children,
          )
        : Column(children: children);
  }

  Color _getFlowColor(MenstruationFlow flow) => switch (flow) {
    MenstruationFlow.none => Colors.grey,
    MenstruationFlow.spotty => Colors.pink.shade200,
    MenstruationFlow.light => Colors.pink.shade300,
    MenstruationFlow.medium => Colors.pink.shade400,
    MenstruationFlow.heavy => Colors.pink.shade600,
  };

  IconData _getFlowIcon(MenstruationFlow flow) => switch (flow) {
    MenstruationFlow.none => Icons.remove_circle_outline,
    MenstruationFlow.spotty => Icons.water_drop_outlined,
    MenstruationFlow.light => Icons.water_drop,
    MenstruationFlow.medium => Icons.opacity,
    MenstruationFlow.heavy => Icons.water,
  };

  String _getFlowLabel(MenstruationFlow flow) => switch (flow) {
    MenstruationFlow.none => 'None',
    MenstruationFlow.spotty => 'Spotty',
    MenstruationFlow.light => 'Light',
    MenstruationFlow.medium => 'Medium',
    MenstruationFlow.heavy => 'Heavy',
  };
}

/// Internal weekday picker implementation.
class _WeekdayPicker extends StatelessWidget {
  final List<int> selectedDays;
  final ValueChanged<List<int>> onChanged;
  final bool compact;
  final String label;

  const _WeekdayPicker({
    required this.selectedDays,
    required this.onChanged,
    required this.compact,
    required this.label,
  });

  static const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _weekdaysFull = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Quick select buttons
        Wrap(
          spacing: 8,
          children: [
            _QuickSelectButton(
              label: 'Every day',
              isSelected: selectedDays.length == 7,
              onTap: () => onChanged([0, 1, 2, 3, 4, 5, 6]),
            ),
            _QuickSelectButton(
              label: 'Weekdays',
              isSelected: _listEquals(selectedDays.toList()..sort(), [
                0,
                1,
                2,
                3,
                4,
              ]),
              onTap: () => onChanged([0, 1, 2, 3, 4]),
            ),
            _QuickSelectButton(
              label: 'Weekends',
              isSelected: _listEquals(selectedDays.toList()..sort(), [5, 6]),
              onTap: () => onChanged([5, 6]),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Day toggle buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(7, (index) {
            final isSelected = selectedDays.contains(index);
            return Semantics(
              label:
                  '${_weekdaysFull[index]}, ${isSelected ? "selected" : "not selected"}',
              toggled: isSelected,
              child: InkWell(
                onTap: () {
                  final newDays = List<int>.from(selectedDays);
                  if (isSelected) {
                    newDays.remove(index);
                  } else {
                    newDays.add(index);
                  }
                  newDays.sort();
                  onChanged(newDays);
                },
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  constraints: const BoxConstraints(
                    minWidth: 48,
                    minHeight: 48,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.surfaceContainerHighest,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    compact ? _weekdays[index][0] : _weekdays[index],
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isSelected
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurface,
                      fontWeight: isSelected ? FontWeight.bold : null,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  bool _listEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

class _QuickSelectButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _QuickSelectButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      label: label,
      selected: isSelected,
      child: ActionChip(
        label: Text(label),
        onPressed: onTap,
        backgroundColor: isSelected ? theme.colorScheme.primaryContainer : null,
      ),
    );
  }
}

/// Internal diet type picker implementation.
class _DietTypePicker extends StatelessWidget {
  final DietPresetType? value;
  final String? description;
  final ValueChanged<DietPresetType?>? onTypeChanged;
  final ValueChanged<String?>? onDescriptionChanged;
  final String label;

  const _DietTypePicker({
    required this.value,
    required this.description,
    required this.onTypeChanged,
    required this.onDescriptionChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Semantics(
        label: label,
        child: DropdownButtonFormField<DietPresetType>(
          initialValue: value,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            prefixIcon: Icon(_getDietIcon(value)),
          ),
          items: DietPresetType.values
              .map(
                (type) => DropdownMenuItem(
                  value: type,
                  child: Row(
                    children: [
                      Icon(_getDietIcon(type), size: 20),
                      const SizedBox(width: 8),
                      Text(_getDietLabel(type)),
                    ],
                  ),
                ),
              )
              .toList(),
          onChanged: onTypeChanged,
        ),
      ),
      // Show description field for 'custom' type
      if (value == DietPresetType.custom) ...[
        const SizedBox(height: 12),
        TextFormField(
          initialValue: description,
          decoration: const InputDecoration(
            labelText: 'Diet Description',
            hintText: 'Describe your custom diet',
            border: OutlineInputBorder(),
          ),
          onChanged: onDescriptionChanged,
        ),
      ],
    ],
  );

  IconData _getDietIcon(DietPresetType? type) => switch (type) {
    DietPresetType.vegan => Icons.eco,
    DietPresetType.vegetarian => Icons.grass,
    DietPresetType.pescatarian => Icons.set_meal,
    DietPresetType.paleo => Icons.restaurant,
    DietPresetType.keto => Icons.egg,
    DietPresetType.ketoStrict => Icons.egg_alt,
    DietPresetType.lowCarb => Icons.no_food,
    DietPresetType.mediterranean => Icons.local_dining,
    DietPresetType.whole30 => Icons.calendar_month,
    DietPresetType.aip => Icons.healing,
    DietPresetType.lowFodmap => Icons.science,
    DietPresetType.glutenFree => Icons.do_not_disturb,
    DietPresetType.dairyFree => Icons.water_drop,
    DietPresetType.if168 => Icons.timer,
    DietPresetType.if186 => Icons.timer,
    DietPresetType.if204 => Icons.timer,
    DietPresetType.omad => Icons.dinner_dining,
    DietPresetType.fiveTwoDiet => Icons.calendar_today,
    DietPresetType.zone => Icons.balance,
    DietPresetType.custom => Icons.edit,
    null => Icons.restaurant_menu,
  };

  String _getDietLabel(DietPresetType type) => switch (type) {
    DietPresetType.vegan => 'Vegan',
    DietPresetType.vegetarian => 'Vegetarian',
    DietPresetType.pescatarian => 'Pescatarian',
    DietPresetType.paleo => 'Paleo',
    DietPresetType.keto => 'Keto',
    DietPresetType.ketoStrict => 'Strict Keto',
    DietPresetType.lowCarb => 'Low Carb',
    DietPresetType.mediterranean => 'Mediterranean',
    DietPresetType.whole30 => 'Whole30',
    DietPresetType.aip => 'AIP (Autoimmune)',
    DietPresetType.lowFodmap => 'Low FODMAP',
    DietPresetType.glutenFree => 'Gluten Free',
    DietPresetType.dairyFree => 'Dairy Free',
    DietPresetType.if168 => 'IF 16:8',
    DietPresetType.if186 => 'IF 18:6',
    DietPresetType.if204 => 'IF 20:4',
    DietPresetType.omad => 'OMAD',
    DietPresetType.fiveTwoDiet => '5:2 Diet',
    DietPresetType.zone => 'Zone Diet',
    DietPresetType.custom => 'Custom',
  };
}

/// Internal time picker implementation.
class _TimePicker extends StatelessWidget {
  final List<TimeOfDay> times;
  final ValueChanged<List<TimeOfDay>> onTimesChanged;
  final int maxTimes;
  final String label;

  const _TimePicker({
    required this.times,
    required this.onTimesChanged,
    required this.maxTimes,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sortedTimes = List<TimeOfDay>.from(times)
      ..sort((a, b) => _timeToMinutes(a).compareTo(_timeToMinutes(b)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(label, style: theme.textTheme.titleSmall),
          ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...sortedTimes.map(
              (time) => Semantics(
                label: 'Time ${_formatTime(time)}, double tap to remove',
                child: InputChip(
                  label: Text(_formatTime(time)),
                  onDeleted: () {
                    final newTimes = List<TimeOfDay>.from(times)..remove(time);
                    onTimesChanged(newTimes);
                  },
                  onPressed: () => _showTimePicker(context, existingTime: time),
                ),
              ),
            ),
            if (times.length < maxTimes)
              Semantics(
                label: 'Add time',
                child: ActionChip(
                  avatar: const Icon(Icons.add, size: 18),
                  label: const Text('Add time'),
                  onPressed: () => _showTimePicker(context),
                ),
              ),
          ],
        ),
      ],
    );
  }

  int _timeToMinutes(TimeOfDay time) => time.hour * 60 + time.minute;

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Future<void> _showTimePicker(
    BuildContext context, {
    TimeOfDay? existingTime,
  }) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: existingTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      final newTimes = List<TimeOfDay>.from(times);
      if (existingTime != null) {
        newTimes.remove(existingTime);
      }
      // Prevent duplicates
      if (!newTimes.any(
        (t) => t.hour == picked.hour && t.minute == picked.minute,
      )) {
        newTimes.add(picked);
        onTimesChanged(newTimes);
      }
    }
  }
}

/// Internal date picker implementation.
class _DatePicker extends StatelessWidget {
  final DateTime? value;
  final ValueChanged<DateTime?>? onChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String label;

  const _DatePicker({
    required this.value,
    required this.onChanged,
    required this.firstDate,
    required this.lastDate,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label:
          '$label, ${value != null ? _formatDate(value!) : "no date selected"}',
      child: InkWell(
        onTap: onChanged != null ? () => _showDatePicker(context) : null,
        borderRadius: BorderRadius.circular(8),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            suffixIcon: const Icon(Icons.calendar_today),
          ),
          child: Text(
            value != null ? _formatDate(value!) : 'Select date',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: value != null ? null : theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: value ?? now,
      firstDate: firstDate ?? DateTime(2020),
      lastDate: lastDate ?? DateTime(2100),
    );
    if (picked != null) {
      onChanged?.call(picked);
    }
  }
}

/// Internal multi-select picker implementation.
class _MultiSelectPicker extends StatelessWidget {
  final List<String> selectedItems;
  final List<String> availableItems;
  final ValueChanged<List<String>> onSelectionChanged;
  final String label;

  const _MultiSelectPicker({
    required this.selectedItems,
    required this.availableItems,
    required this.onSelectionChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(label, style: theme.textTheme.titleSmall),
          ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: availableItems.map((item) {
            final isSelected = selectedItems.contains(item);
            return Semantics(
              label: '$item, ${isSelected ? "selected" : "not selected"}',
              toggled: isSelected,
              child: FilterChip(
                label: Text(item),
                selected: isSelected,
                onSelected: (selected) {
                  final newSelection = List<String>.from(selectedItems);
                  if (selected) {
                    newSelection.add(item);
                  } else {
                    newSelection.remove(item);
                  }
                  onSelectionChanged(newSelection);
                },
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
