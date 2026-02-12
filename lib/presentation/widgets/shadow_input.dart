/// Accessible health input components for Shadow app.
///
/// Provides [ShadowInput] with specialized inputs for health data,
/// following WCAG 2.1 Level AA accessibility standards.
///
/// See also:
/// * [09_WIDGET_LIBRARY.md] Section 6.2 for BBT specifications
/// * [12_ACCESSIBILITY_GUIDELINES.md] for full accessibility requirements
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shadow_app/core/validation/validation_rules.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/presentation/widgets/widget_enums.dart';

/// Temperature unit for BBT input.
enum TemperatureUnit {
  /// Fahrenheit (°F).
  fahrenheit,

  /// Celsius (°C).
  celsius,
}

/// A consolidated health input widget for specialized data entry.
///
/// [ShadowInput] provides a unified interface for health-specific inputs
/// in the Shadow app, ensuring consistent accessibility support.
///
/// {@template shadow_input}
/// All input instances:
/// - Meet WCAG 2.1 touch target requirements (48x48 dp minimum)
/// - Include semantic labels for screen readers
/// - Provide appropriate keyboard types
/// {@endtemplate}
///
/// ## Temperature Input (BBT)
///
/// ```dart
/// ShadowInput.temperature(
///   value: 98.6,
///   unit: TemperatureUnit.fahrenheit,
///   recordedTime: DateTime.now(),
///   onValueChanged: (temp) => setState(() => _temp = temp),
///   onTimeChanged: (time) => setState(() => _time = time),
///   onUnitChanged: (unit) => setState(() => _unit = unit),
///   label: 'Basal Body Temperature',
/// )
/// ```
///
/// ## Diet Input
///
/// ```dart
/// ShadowInput.diet(
///   value: DietPresetType.keto,
///   description: null,
///   onValueChanged: (diet) => setState(() => _diet = diet),
///   onDescriptionChanged: (desc) => setState(() => _desc = desc),
///   label: 'Diet Type',
/// )
/// ```
///
/// ## Flow Input
///
/// ```dart
/// ShadowInput.flow(
///   value: MenstruationFlow.medium,
///   onValueChanged: (flow) => setState(() => _flow = flow),
///   label: 'Flow Intensity',
/// )
/// ```
///
/// See also:
///
/// * [HealthInputType] for available input types
/// * [ShadowPicker] for picker-style inputs
class ShadowInput extends StatelessWidget {
  /// The type of health input.
  final HealthInputType inputType;

  /// The semantic label for screen readers.
  final String label;

  /// Optional hint providing additional context.
  final String? hint;

  // Temperature properties
  /// Current temperature value (for [HealthInputType.temperature]).
  final double? temperatureValue;

  /// Temperature unit (Fahrenheit or Celsius).
  final TemperatureUnit temperatureUnit;

  /// Time of temperature recording.
  final DateTime? recordedTime;

  /// Callback when temperature changes.
  final ValueChanged<double?>? onTemperatureChanged;

  /// Callback when recording time changes.
  final ValueChanged<DateTime?>? onTimeChanged;

  /// Callback when temperature unit changes.
  final ValueChanged<TemperatureUnit>? onUnitChanged;

  // Diet properties
  /// Current diet type (for [HealthInputType.diet]).
  final DietPresetType? dietValue;

  /// Custom diet description.
  final String? dietDescription;

  /// Callback when diet type changes.
  final ValueChanged<DietPresetType?>? onDietChanged;

  /// Callback when diet description changes.
  final ValueChanged<String?>? onDescriptionChanged;

  // Flow properties
  /// Current flow value (for [HealthInputType.flow]).
  final MenstruationFlow? flowValue;

  /// Callback when flow changes.
  final ValueChanged<MenstruationFlow?>? onFlowChanged;

  /// Creates a health input widget.
  const ShadowInput({
    super.key,
    required this.inputType,
    required this.label,
    this.hint,
    this.temperatureValue,
    this.temperatureUnit = TemperatureUnit.fahrenheit,
    this.recordedTime,
    this.onTemperatureChanged,
    this.onTimeChanged,
    this.onUnitChanged,
    this.dietValue,
    this.dietDescription,
    this.onDietChanged,
    this.onDescriptionChanged,
    this.flowValue,
    this.onFlowChanged,
  });

  /// Creates a temperature (BBT) input.
  const ShadowInput.temperature({
    super.key,
    required this.label,
    this.hint,
    this.temperatureValue,
    this.temperatureUnit = TemperatureUnit.fahrenheit,
    this.recordedTime,
    required this.onTemperatureChanged,
    this.onTimeChanged,
    this.onUnitChanged,
  }) : inputType = HealthInputType.temperature,
       dietValue = null,
       dietDescription = null,
       onDietChanged = null,
       onDescriptionChanged = null,
       flowValue = null,
       onFlowChanged = null;

  /// Creates a diet type input.
  const ShadowInput.diet({
    super.key,
    required this.label,
    this.hint,
    this.dietValue,
    this.dietDescription,
    required this.onDietChanged,
    this.onDescriptionChanged,
  }) : inputType = HealthInputType.diet,
       temperatureValue = null,
       temperatureUnit = TemperatureUnit.fahrenheit,
       recordedTime = null,
       onTemperatureChanged = null,
       onTimeChanged = null,
       onUnitChanged = null,
       flowValue = null,
       onFlowChanged = null;

  /// Creates a flow intensity input.
  const ShadowInput.flow({
    super.key,
    required this.label,
    this.hint,
    this.flowValue,
    required this.onFlowChanged,
  }) : inputType = HealthInputType.flow,
       temperatureValue = null,
       temperatureUnit = TemperatureUnit.fahrenheit,
       recordedTime = null,
       onTemperatureChanged = null,
       onTimeChanged = null,
       onUnitChanged = null,
       dietValue = null,
       dietDescription = null,
       onDietChanged = null,
       onDescriptionChanged = null;

  @override
  Widget build(BuildContext context) =>
      Semantics(label: label, hint: hint, child: _buildInput(context));

  Widget _buildInput(BuildContext context) {
    switch (inputType) {
      case HealthInputType.temperature:
        return _TemperatureInput(
          value: temperatureValue,
          unit: temperatureUnit,
          recordedTime: recordedTime,
          onValueChanged: onTemperatureChanged,
          onTimeChanged: onTimeChanged,
          onUnitChanged: onUnitChanged,
          label: label,
        );
      case HealthInputType.diet:
        return _DietInput(
          value: dietValue,
          description: dietDescription,
          onValueChanged: onDietChanged,
          onDescriptionChanged: onDescriptionChanged,
          label: label,
        );
      case HealthInputType.flow:
        return _FlowInput(
          value: flowValue,
          onValueChanged: onFlowChanged,
          label: label,
        );
    }
  }
}

/// Internal temperature input implementation.
class _TemperatureInput extends StatefulWidget {
  final double? value;
  final TemperatureUnit unit;
  final DateTime? recordedTime;
  final ValueChanged<double?>? onValueChanged;
  final ValueChanged<DateTime?>? onTimeChanged;
  final ValueChanged<TemperatureUnit>? onUnitChanged;
  final String label;

  const _TemperatureInput({
    required this.value,
    required this.unit,
    required this.recordedTime,
    required this.onValueChanged,
    required this.onTimeChanged,
    required this.onUnitChanged,
    required this.label,
  });

  @override
  State<_TemperatureInput> createState() => _TemperatureInputState();
}

class _TemperatureInputState extends State<_TemperatureInput> {
  late TextEditingController _controller;

  // Temperature ranges
  static const _minF = ValidationRules.bbtMinFahrenheit;
  static const _maxF = ValidationRules.bbtMaxFahrenheit;
  static const _minC = ValidationRules.bbtMinCelsius;
  static const _maxC = ValidationRules.bbtMaxCelsius;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.value?.toStringAsFixed(1) ?? '',
    );
  }

  @override
  void didUpdateWidget(_TemperatureInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _controller.text = widget.value?.toStringAsFixed(1) ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unitSymbol = widget.unit == TemperatureUnit.fahrenheit ? '°F' : '°C';
    final minTemp = widget.unit == TemperatureUnit.fahrenheit ? _minF : _minC;
    final maxTemp = widget.unit == TemperatureUnit.fahrenheit ? _maxF : _maxC;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        Row(
          children: [
            // Temperature input
            Expanded(
              flex: 2,
              child: Semantics(
                label: 'Temperature in $unitSymbol',
                child: TextField(
                  controller: _controller,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: widget.unit == TemperatureUnit.fahrenheit
                        ? '98.6'
                        : '37.0',
                    helperText: '$minTemp - $maxTemp $unitSymbol',
                  ),
                  onChanged: (text) {
                    final value = double.tryParse(text);
                    if (value != null) {
                      if (value >= minTemp && value <= maxTemp) {
                        widget.onValueChanged?.call(value);
                      }
                    } else if (text.isEmpty) {
                      widget.onValueChanged?.call(null);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Unit toggle
            Semantics(
              label: 'Temperature unit, $unitSymbol',
              child: SegmentedButton<TemperatureUnit>(
                segments: const [
                  ButtonSegment(
                    value: TemperatureUnit.fahrenheit,
                    label: Text('°F'),
                  ),
                  ButtonSegment(
                    value: TemperatureUnit.celsius,
                    label: Text('°C'),
                  ),
                ],
                selected: {widget.unit},
                onSelectionChanged: (selected) {
                  if (selected.isNotEmpty && widget.onUnitChanged != null) {
                    final newUnit = selected.first;
                    widget.onUnitChanged!(newUnit);
                    // Convert temperature value
                    if (widget.value != null) {
                      final converted = newUnit == TemperatureUnit.celsius
                          ? (widget.value! - 32) * 5 / 9
                          : widget.value! * 9 / 5 + 32;
                      widget.onValueChanged?.call(
                        double.parse(converted.toStringAsFixed(1)),
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Time picker
        Semantics(
          label:
              'Recording time, ${widget.recordedTime != null ? _formatTime(TimeOfDay.fromDateTime(widget.recordedTime!)) : "not set"}',
          child: InkWell(
            onTap: widget.onTimeChanged != null
                ? () => _showTimePicker(context)
                : null,
            borderRadius: BorderRadius.circular(8),
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Time Recorded',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.access_time),
              ),
              child: Text(
                widget.recordedTime != null
                    ? _formatTime(TimeOfDay.fromDateTime(widget.recordedTime!))
                    : 'Select time',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: widget.recordedTime != null
                      ? null
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: widget.recordedTime != null
          ? TimeOfDay.fromDateTime(widget.recordedTime!)
          : TimeOfDay.now(),
    );
    if (picked != null && widget.onTimeChanged != null) {
      final now = DateTime.now();
      final newTime = DateTime(
        now.year,
        now.month,
        now.day,
        picked.hour,
        picked.minute,
      );
      widget.onTimeChanged!(newTime);
    }
  }
}

/// Internal diet input implementation.
class _DietInput extends StatelessWidget {
  final DietPresetType? value;
  final String? description;
  final ValueChanged<DietPresetType?>? onValueChanged;
  final ValueChanged<String?>? onDescriptionChanged;
  final String label;

  const _DietInput({
    required this.value,
    required this.description,
    required this.onValueChanged,
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
          onChanged: onValueChanged,
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

/// Internal flow input implementation.
class _FlowInput extends StatelessWidget {
  final MenstruationFlow? value;
  final ValueChanged<MenstruationFlow?>? onValueChanged;
  final String label;

  const _FlowInput({
    required this.value,
    required this.onValueChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const options = MenstruationFlow.values;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: options.map((flow) {
            final isSelected = value == flow;
            final color = _getFlowColor(flow);

            return Semantics(
              label: _getFlowLabel(flow),
              selected: isSelected,
              child: InkWell(
                onTap: onValueChanged != null
                    ? () => onValueChanged!(flow)
                    : null,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  constraints: const BoxConstraints(
                    minWidth: 48,
                    minHeight: 48,
                  ),
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
                      const SizedBox(height: 4),
                      Text(
                        _getFlowLabel(flow),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isSelected ? color : null,
                          fontWeight: isSelected ? FontWeight.bold : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
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
