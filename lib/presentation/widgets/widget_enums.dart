/// Widget variant enums for Shadow app consolidated widgets.
///
/// Provides configuration enums for all Shadow widget variants,
/// enabling consistent behavior across the application.
///
/// See also:
/// * [09_WIDGET_LIBRARY.md] for full widget documentation
/// * [12_ACCESSIBILITY_GUIDELINES.md] for accessibility requirements
library;

/// Visual variants for [ShadowButton].
///
/// Each variant follows Material Design 3 guidelines while maintaining
/// WCAG 2.1 accessibility compliance.
enum ButtonVariant {
  /// A filled button for primary actions.
  ///
  /// Use for the main action on a screen, e.g., "Save", "Submit".
  /// Only one elevated button per logical group.
  elevated,

  /// A text button for secondary actions.
  ///
  /// Use for less prominent actions, e.g., "Cancel", "Skip".
  /// Can appear alongside elevated buttons.
  text,

  /// An icon-only button.
  ///
  /// Use in toolbars or compact layouts.
  /// [ShadowButton.label] is used as tooltip and for screen readers.
  icon,

  /// A floating action button.
  ///
  /// Use for the primary action on a screen.
  /// Only one FAB per screen.
  fab,

  /// An outlined button.
  ///
  /// Use for medium-emphasis actions.
  outlined,
}

/// Input types for [ShadowTextField].
///
/// Determines the keyboard type, masking, and validation behavior.
enum InputType {
  /// Standard text input.
  text,

  /// Dropdown selection input.
  dropdown,

  /// Numeric input with number keyboard.
  numeric,

  /// Password input with masking.
  password,
}

/// Visual variants for [ShadowCard].
///
/// Determines the card's layout and tap behavior.
enum CardVariant {
  /// Standard card with elevation and padding.
  standard,

  /// List item style card optimized for vertical lists.
  listItem,
}

/// Image source types for [ShadowImage].
///
/// Determines how the image is loaded.
enum ImageSource {
  /// Image from app assets.
  asset,

  /// Image from local file path.
  file,

  /// Image from network URL.
  network,

  /// Image picker mode.
  picker,
}

/// Picker types for [ShadowPicker].
///
/// Specialized pickers for health data input.
enum PickerType {
  /// Menstruation flow intensity picker.
  flow,

  /// Day of week multi-selector.
  weekday,

  /// Diet type dropdown with optional description.
  dietType,

  /// Time picker for notifications/reminders.
  time,

  /// Date picker.
  date,

  /// Multi-select picker.
  multiSelect,
}

/// Chart types for [ShadowChart].
///
/// Visualization types for health data.
enum ChartType {
  /// Basal body temperature line chart.
  bbt,

  /// Generic trend line chart.
  trend,

  /// Bar chart for comparisons.
  bar,

  /// Calendar heatmap.
  calendar,

  /// Scatter plot for correlations.
  scatter,

  /// Heatmap visualization.
  heatmap,
}

/// Health input types for [ShadowInput].
///
/// Specialized input widgets for health data.
enum HealthInputType {
  /// Temperature input (BBT).
  temperature,

  /// Diet type selection.
  diet,

  /// Flow intensity selection.
  flow,
}

/// Status indicator variants for [ShadowStatus].
///
/// Different status display styles.
enum StatusVariant {
  /// Circular loading spinner.
  loading,

  /// Progress bar with percentage.
  progress,

  /// Status icon with label.
  status,

  /// Sync status with cloud icon.
  sync,
}

/// Dialog types for [ShadowDialog].
///
/// Standard dialog patterns.
enum DialogType {
  /// Simple alert with message.
  alert,

  /// Confirmation dialog with cancel/confirm.
  confirm,

  /// Dialog with text input field.
  input,
}

/// Badge types for [ShadowBadge].
///
/// Badge display variants.
enum BadgeType {
  /// Diet type badge with icon.
  diet,

  /// Status indicator badge.
  status,

  /// Numeric count badge.
  count,
}

/// Badge size options for [ShadowBadge].
enum BadgeSize {
  /// Small badge (compact display).
  small,

  /// Medium badge (default).
  medium,

  /// Large badge (prominent display).
  large,
}
