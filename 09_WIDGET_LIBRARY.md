# Shadow Widget Library

**Version:** 1.0
**Last Updated:** January 30, 2026
**Compliance:** WCAG 2.1 Level AA, Apple HIG, Material Design 3

---

## Overview

This document catalogs all reusable widget components in the Shadow application. All widgets are designed for accessibility compliance and consistent user experience.

---

## Widget Consolidation Strategy

To reduce complexity and improve maintainability, widgets are consolidated into core abstractions with configuration options rather than separate implementations for each variant.

### Consolidated Widget Architecture

| Core Widget | Consolidates | Configuration |
|-------------|--------------|---------------|
| `ShadowButton` | AccessibleButton, AccessibleElevatedButton, AccessibleTextButton, AccessibleIconButton, AccessibleFAB | `variant: ButtonVariant.elevated/text/icon/fab` |
| `ShadowTextField` | AccessibleTextField, AccessibleDropdown | `inputType: InputType.text/dropdown/numeric/password` |
| `ShadowCard` | AccessibleCard, AccessibleListTile | `variant: CardVariant.standard/listItem` |
| `ShadowImage` | AccessibleImage, AccessibleFileImage | `source: ImageSource.asset/file/network` |
| `ShadowPicker` | FlowIntensityPicker, WeekdaySelector, DietTypeSelector, NotificationTimePicker | `pickerType: PickerType.flow/weekday/dietType/time` |
| `ShadowChart` | BBTChart, WaterIntakeChart, BowelChart, UrineChart, MenstruationChart, ComplianceChart, TriggerCorrelationChart | `chartType: ChartType.bbt/trend/bar/calendar/scatter/heatmap` |
| `ShadowInput` | BBTInputWidget, DietTypeSelector | `inputType: HealthInputType.temperature/diet/flow` |
| `ShadowStatus` | AccessibleStatusIndicator, AccessibleProgressIndicator, AccessibleLoadingIndicator, SyncStatusIndicator | `variant: StatusVariant.loading/progress/status/sync` |
| `ShadowDialog` | AccessibleAlertDialog, DeleteConfirmationDialog, TextInputDialog | `dialogType: DialogType.alert/confirm/input` |
| `ShadowBadge` | DietTypeBadge, AccessibleStatusIndicator | `badgeType: BadgeType.diet/status/count` |

### Recommended Widget Count

**Before Consolidation:** 35+ widgets
**After Consolidation:** 15 core widgets with variants

### Core Widget Pattern

```dart
/// Unified button widget with configurable variants.
class ShadowButton extends StatelessWidget {
  final ButtonVariant variant;
  final VoidCallback? onPressed;
  final String label;              // Required: Accessibility
  final String? hint;              // Optional: Additional context
  final IconData? icon;
  final Widget? child;
  final ButtonStyle? style;

  const ShadowButton({
    super.key,
    this.variant = ButtonVariant.elevated,
    required this.onPressed,
    required this.label,
    this.hint,
    this.icon,
    this.child,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      hint: hint,
      button: true,
      child: _buildButton(context),
    );
  }

  Widget _buildButton(BuildContext context) {
    switch (variant) {
      case ButtonVariant.elevated:
        return ElevatedButton(onPressed: onPressed, style: style, child: _content);
      case ButtonVariant.text:
        return TextButton(onPressed: onPressed, style: style, child: _content);
      case ButtonVariant.icon:
        return IconButton(onPressed: onPressed, icon: Icon(icon!), tooltip: label);
      case ButtonVariant.fab:
        return FloatingActionButton(onPressed: onPressed, child: _content);
    }
  }

  Widget get _content => icon != null ? Row(children: [Icon(icon!), child!]) : child!;
}

enum ButtonVariant { elevated, text, icon, fab, outlined }
```

### Migration Path

When implementing, follow this order:
1. Create core consolidated widgets
2. Create variant enums
3. Implement all variants within single widget class
4. Add factory constructors for common configurations
5. Deprecate individual widget classes
6. Update all usages to consolidated widgets

---

## 1. Accessible Widgets Library

**Location:** `lib/presentation/widgets/accessible_widgets.dart`

The core accessibility library with 25+ components meeting WCAG 2.1 Level AA standards.

### 1.1 Buttons

#### AccessibleButton

Generic button wrapper with full semantic support.

```dart
AccessibleButton(
  onPressed: () => handleTap(),
  label: 'Submit',           // Required: Screen reader label
  hint: 'Saves your changes', // Optional: Action description
  isPrimary: true,           // Visual styling
  icon: Icons.check,         // Optional leading icon
  style: ButtonStyle(...),   // Custom styling
  child: Text('Submit'),
)
```

**Properties:**
| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `onPressed` | `VoidCallback?` | Yes | Tap handler |
| `label` | `String` | Yes | Screen reader label |
| `hint` | `String?` | No | Action description |
| `isPrimary` | `bool` | No | Primary styling (default: false) |
| `icon` | `IconData?` | No | Leading icon |
| `style` | `ButtonStyle?` | No | Custom button style |
| `child` | `Widget` | Yes | Button content |

#### AccessibleElevatedButton

Elevated button variant with accessibility features.

```dart
AccessibleElevatedButton(
  onPressed: () => save(),
  label: 'Save Profile',
  hint: 'Saves profile changes',
  child: Text('Save'),
)
```

#### AccessibleTextButton

Text button variant for secondary actions.

```dart
AccessibleTextButton(
  onPressed: () => cancel(),
  label: 'Cancel',
  child: Text('Cancel'),
)
```

#### AccessibleIconButton

Icon-only button with mandatory semantic label.

```dart
AccessibleIconButton(
  onPressed: () => openMenu(),
  icon: Icons.more_vert,
  label: 'Open menu',        // Required for screen readers
  tooltip: 'More options',   // Visual tooltip
  iconSize: 24.0,
  color: Colors.grey,
)
```

**Accessibility:** Minimum touch target of 44x44pt enforced.

#### AccessibleFloatingActionButton

FAB with full semantic support.

```dart
AccessibleFloatingActionButton(
  onPressed: () => addItem(),
  label: 'Add new supplement',
  child: Icon(Icons.add),
  heroTag: 'addSupplementFab',
  mini: false,
)
```

---

### 1.2 Form Inputs

#### AccessibleTextField

Comprehensive text input with accessibility features.

```dart
AccessibleTextField(
  controller: _nameController,
  label: 'Supplement Name',
  semanticLabel: 'Enter supplement name',
  semanticHint: 'Required field',
  hintText: 'e.g., Vitamin D3',
  helperText: 'Enter the brand and product name',
  errorText: _hasError ? 'Name is required' : null,
  keyboardType: TextInputType.text,
  textInputAction: TextInputAction.next,
  maxLines: 1,
  maxLength: 100,
  enabled: true,
  onChanged: (value) => validate(value),
  focusNode: _nameFocusNode,
)
```

**Properties:**
| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `controller` | `TextEditingController?` | No | Text controller |
| `label` | `String` | Yes | Field label |
| `semanticLabel` | `String?` | No | Screen reader label |
| `semanticHint` | `String?` | No | Additional context |
| `hintText` | `String?` | No | Placeholder text |
| `helperText` | `String?` | No | Helper text below field |
| `errorText` | `String?` | No | Error message |
| `obscureText` | `bool` | No | Password masking |
| `keyboardType` | `TextInputType` | No | Keyboard type |
| `maxLines` | `int` | No | Maximum lines |
| `maxLength` | `int?` | No | Character limit |
| `enabled` | `bool` | No | Enabled state |
| `focusNode` | `FocusNode?` | No | Focus management |

#### AccessibleDropdown<T>

Accessible dropdown selector.

```dart
AccessibleDropdown<SupplementForm>(
  value: _selectedForm,
  items: SupplementForm.values.map((form) =>
    DropdownMenuItem(
      value: form,
      child: Text(form.displayName),
    )
  ).toList(),
  onChanged: (value) => setState(() => _selectedForm = value),
  label: 'Supplement Form',
  semanticLabel: 'Select supplement form',
  semanticHint: 'Choose capsule, tablet, powder, or liquid',
)
```

#### AccessibleSwitch

Toggle switch with state indication.

```dart
AccessibleSwitch(
  value: _autoSync,
  onChanged: (value) => setState(() => _autoSync = value),
  label: 'Auto-sync',
  semanticLabel: 'Enable automatic synchronization',
  subtitle: 'Sync data automatically when connected',
  enabled: true,
)
```

#### AccessibleCheckbox

Checkbox with semantic labels.

```dart
AccessibleCheckbox(
  value: _agreedToTerms,
  onChanged: (value) => setState(() => _agreedToTerms = value),
  label: 'I agree to the terms',
  semanticLabel: 'Agree to terms and conditions',
)
```

---

### 1.3 Layout & Containers

#### AccessibleCard

Card container with optional tap interaction.

```dart
AccessibleCard(
  onTap: () => viewDetails(),
  semanticLabel: 'Vitamin D supplement card',
  semanticHint: 'Double tap to view details',
  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  padding: EdgeInsets.all(16),
  elevation: 2,
  child: SupplementContent(),
)
```

#### AccessibleListTile

List item with semantic labels.

```dart
AccessibleListTile(
  leading: Icon(Icons.medication),
  title: Text('Vitamin D3'),
  subtitle: Text('5000 IU daily'),
  trailing: Icon(Icons.chevron_right),
  onTap: () => navigateToDetails(),
  semanticLabel: 'Vitamin D3, 5000 IU daily',
  semanticHint: 'Double tap to view supplement details',
  enabled: true,
)
```

---

### 1.4 Images

#### AccessibleImage

Image with semantic labels and memory optimization.

```dart
AccessibleImage(
  image: AssetImage('assets/icons/supplement.png'),
  semanticLabel: 'Supplement icon',
  width: 48,
  height: 48,
  fit: BoxFit.cover,
  isDecorative: false,       // Set true for decorative images
  cacheWidth: 96,            // Memory optimization
  cacheHeight: 96,
)
```

**Performance:** Uses `ResizeImage` wrapper for memory-efficient image loading.

#### AccessibleFileImage

Image loaded from file path.

```dart
AccessibleFileImage(
  filePath: '/path/to/photo.jpg',
  semanticLabel: 'Condition photo taken on January 15',
  width: 200,
  height: 200,
  fit: BoxFit.cover,
  cacheWidth: 400,
  cacheHeight: 400,
)
```

---

### 1.5 Status & Feedback

#### AccessibleLoadingIndicator

Loading spinner with semantic label.

```dart
AccessibleLoadingIndicator(
  loadingMessage: 'Loading supplements',
  size: 24.0,
)
```

#### AccessibleEmptyState

Empty state display with action.

```dart
AccessibleEmptyState(
  message: 'No supplements yet',
  icon: Icon(Icons.medication_outlined, size: 64),
  action: ElevatedButton(
    onPressed: () => addSupplement(),
    child: Text('Add Supplement'),
  ),
)
```

#### AccessibleStatusIndicator

Status display with icon and color.

```dart
AccessibleStatusIndicator(
  status: 'Synced',
  color: Colors.green,
  icon: Icons.cloud_done,
  semanticLabel: 'Data is synced to cloud',
)
```

#### AccessibleProgressIndicator

Progress bar with percentage label.

```dart
AccessibleProgressIndicator(
  value: 0.75,               // null for indeterminate
  progressLabel: '75% complete',
  color: Colors.green,
  strokeWidth: 4.0,
)
```

---

### 1.6 Navigation

#### AccessibleBottomNavItem

Bottom navigation item with semantics.

```dart
AccessibleBottomNavItem(
  icon: Icons.home_outlined,
  activeIcon: Icons.home,
  label: 'Home',
  semanticLabel: 'Home tab, currently selected',
)
```

#### AccessibleTab

Tab with selection state indication.

```dart
AccessibleTab(
  icon: Icons.list,
  label: 'All',
  semanticLabel: 'All supplements tab',
  isSelected: _currentTab == 0,
)
```

---

### 1.7 Dialogs

#### AccessibleAlertDialog

Alert dialog with focus management.

```dart
showDialog(
  context: context,
  builder: (context) => AccessibleAlertDialog(
    title: 'Delete Supplement?',
    content: 'This action cannot be undone.',
    semanticLabel: 'Confirmation dialog',
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text('Cancel'),
      ),
      TextButton(
        onPressed: () => deleteAndClose(),
        child: Text('Delete'),
      ),
    ],
  ),
);
```

#### showAccessibleSnackBar

Accessible notification function.

```dart
showAccessibleSnackBar(
  context: context,
  message: 'Supplement saved successfully',
  actionLabel: 'Undo',
  onAction: () => undoSave(),
  duration: Duration(seconds: 4),
);
```

**Accessibility:** Uses `liveRegion: true` for immediate screen reader announcement.

---

### 1.8 Miscellaneous

#### AccessiblePopupMenuButton<T>

Popup menu with semantic labels.

```dart
AccessiblePopupMenuButton<String>(
  items: [
    PopupMenuItem(value: 'edit', child: Text('Edit')),
    PopupMenuItem(value: 'delete', child: Text('Delete')),
  ],
  onSelected: (value) => handleMenuAction(value),
  icon: Icons.more_vert,
  label: 'Supplement options',
  semanticHint: 'Shows edit and delete options',
)
```

#### AccessibleIcon

Icon with optional semantic label.

```dart
AccessibleIcon(
  icon: Icons.warning,
  label: 'Warning indicator',    // Required unless decorative
  size: 24,
  color: Colors.orange,
  isDecorative: false,
)
```

---

## 2. Common Dialogs

**Location:** `lib/presentation/widgets/common_dialogs.dart`

### showDeleteConfirmationDialog

Reusable delete confirmation.

```dart
final confirmed = await showDeleteConfirmationDialog(
  context: context,
  title: 'Delete Supplement',
  contentText: 'Are you sure you want to delete "Vitamin D3"?',
  confirmButtonText: 'Delete',
  cancelButtonText: 'Cancel',
);

if (confirmed == true) {
  // Perform deletion
}
```

**Returns:** `Future<bool?>` - `true` if confirmed, `false` or `null` if cancelled.

### showTextInputDialog

Text input dialog.

```dart
final categoryName = await showTextInputDialog(
  context: context,
  title: 'New Category',
  labelText: 'Category Name',
  hintText: 'Enter category name',
  initialValue: '',
  confirmButtonText: 'Create',
  maxLines: 1,
  textCapitalization: TextCapitalization.words,
);

if (categoryName != null) {
  // Use the sanitized input
}
```

**Security:** Input is automatically sanitized.

---

## 3. Common Widgets

**Location:** `lib/presentation/widgets/`

### EmptyStateWidget

Centered empty state display.

```dart
EmptyStateWidget(
  icon: Icons.medication_outlined,
  message: 'No supplements added',
  submessage: 'Tap the + button to add your first supplement',
  iconColor: Colors.grey[400],
  iconSize: 100.0,
)
```

**Location:** `lib/presentation/widgets/empty_state.dart`

### ItemMenuButton

Three-dot popup menu for list items.

```dart
ItemMenuButton(
  onEdit: () => editSupplement(),
  onDelete: () => deleteSupplement(),
  showEdit: true,
  showDelete: true,
  iconColor: Colors.grey,
  itemName: 'Vitamin D3',    // For semantic labels
)
```

**Location:** `lib/presentation/widgets/item_menu_button.dart`

### SectionHeader

Section header with icon, title, and optional add button.

```dart
SectionHeader(
  title: 'Supplements',
  count: 5,
  color: AppColors.supplements,
  icon: Icons.medication,
  onAdd: () => addSupplement(),
  addTooltip: 'Add supplement',
)
```

**Accessibility:**
- Header semantics for screen reader navigation
- Proper pluralization: "5 items" vs "1 item"

**Location:** `lib/presentation/widgets/section_header.dart`

### SyncStatusIndicator

Cloud sync status display.

```dart
SyncStatusIndicator(
  showLabel: true,
)
```

**Features:**
- Dynamic icon (syncing/error/configured/not synced)
- Timing display: "just now" (<1 min), "X min ago" (1-59), "X hours ago" (1-23), "yesterday", "X days ago" (2-6), "MMM d" (same year), "MMM d 'YY" (different year)
- Tappable for status dialog

**Location:** `lib/presentation/widgets/sync_status_indicator.dart`

---

## 4. Sync Widgets

**Location:** `lib/presentation/widgets/sync/`

### SyncStatusWidget

Router widget that displays appropriate sync state card.

```dart
SyncStatusWidget(
  connectionState: ConnectionState.connected,
  provider: CloudProvider.googleDrive,
  userIdentifier: 'user@example.com',
  lastSync: DateTime.now(),
  isSyncing: false,
  errorMessage: null,
  onSetup: () => setupSync(),
  onInitialSync: () => performInitialSync(),
  onManualSync: () => syncNow(),
  onDisconnect: () => disconnect(),
  onRetry: () => retryConnection(),
)
```

### Sync State Cards

| Widget | Purpose | Properties |
|--------|---------|------------|
| `NotConfiguredCard` | Sync not set up | `onSetup` |
| `ConnectingCard` | Connection in progress | None |
| `ConnectedNotSyncedCard` | Connected, awaiting first sync | `provider`, `userIdentifier`, `onInitialSync`, `onDisconnect` |
| `ConnectedSyncedCard` | Connected and synced | `provider`, `userIdentifier`, `lastSync`, `isSyncing`, `onManualSync`, `onDisconnect` |
| `ErrorCard` | Connection error | `errorMessage`, `onRetry` |

### SyncSettingsWidget

Sync configuration options.

```dart
SyncSettingsWidget(
  autoSyncEnabled: true,
  syncOnLaunch: true,
  wifiOnly: false,
  syncFrequency: Duration(minutes: 30),
  photoStorageStrategy: PhotoStorageStrategy.localAndCloud,
  onAutoSyncChanged: (value) => updateAutoSync(value),
  onSyncOnLaunchChanged: (value) => updateSyncOnLaunch(value),
  onWifiOnlyChanged: (value) => updateWifiOnly(value),
  onSyncFrequencyChanged: (value) => updateFrequency(value),
  onPhotoStorageStrategyChanged: (value) => updateStrategy(value),
)
```

### SyncMessageWidgets

```dart
// Error message
SyncErrorWidget(
  message: 'Failed to connect to Google Drive',
  onDismiss: () => clearError(),
)

// Success message
SyncSuccessWidget(
  message: 'All data synced successfully',
  onDismiss: () => clearSuccess(),
)
```

**Accessibility:** Both use `liveRegion: true` for screen reader announcement.

---

## 5. Widget Usage Guidelines

### 5.1 Accessibility Checklist

- [ ] Every interactive element has a semantic label
- [ ] Touch targets are minimum 48x48dp
- [ ] State changes are communicated (enabled/disabled, selected/unselected)
- [ ] Error messages are associated with form fields
- [ ] Loading states have descriptive messages
- [ ] Decorative images use `isDecorative: true`
- [ ] Lists provide position information

### 5.2 Performance Guidelines

- [ ] Use `AccessibleImage` with cache dimensions for photos
- [ ] Prefer `const` constructors where possible
- [ ] Avoid rebuilding widgets unnecessarily
- [ ] Use `RepaintBoundary` for complex widgets

### 5.3 Styling Guidelines

- [ ] Use theme colors from `AppColors`
- [ ] Use typography from `AppTypography`
- [ ] Use spacing from `AppSpacing`
- [ ] Follow module color conventions

---

## 6. Fluids & Notification Widgets

**Location:** `lib/presentation/widgets/fluids/` and `lib/presentation/widgets/notifications/`

### 6.1 Menstruation Flow Picker

Visual picker for menstruation flow intensity.

```dart
FlowIntensityPicker(
  value: MenstruationFlow.medium,
  onChanged: (flow) => setState(() => _selectedFlow = flow),
  showLabels: true,
  orientation: Axis.horizontal,
)
```

**Properties:**
| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `value` | `MenstruationFlow?` | No | Currently selected flow |
| `onChanged` | `ValueChanged<MenstruationFlow?>` | Yes | Selection callback |
| `showLabels` | `bool` | No | Show text labels (default: true) |
| `orientation` | `Axis` | No | Layout direction (default: horizontal) |

**Visual Design:**
- 5 options: None, Spotty, Light, Medium, Heavy
- Progressive color intensity (light to dark)
- Icon representation for each level
- Accessible with screen reader labels

### 6.2 BBT Input Widget

Temperature input with time picker for basal body temperature tracking.

```dart
BBTInputWidget(
  temperature: 98.6,
  unit: TemperatureUnit.fahrenheit,
  recordedTime: DateTime.now(),
  onTemperatureChanged: (temp) => setState(() => _temperature = temp),
  onTimeChanged: (time) => setState(() => _recordedTime = time),
  onUnitChanged: (unit) => setState(() => _unit = unit),
)
```

**Properties:**
| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `temperature` | `double?` | No | Current temperature value |
| `unit` | `TemperatureUnit` | No | °F or °C (default: Fahrenheit) |
| `recordedTime` | `DateTime?` | No | Time of measurement |
| `onTemperatureChanged` | `ValueChanged<double?>` | Yes | Temperature change callback |
| `onTimeChanged` | `ValueChanged<DateTime?>` | Yes | Time change callback |
| `onUnitChanged` | `ValueChanged<TemperatureUnit>?` | No | Unit toggle callback |

**Features:**
- Numeric keyboard input
- Temperature range validation (95-105°F / 35-40.5°C)
- Time picker for recording time
- Unit toggle (°F/°C)
- Converts between units when toggled

### 6.3 BBT Chart

Temperature chart for cycle visualization.

```dart
BBTChart(
  entries: fluidsEntries,
  dateRange: DateTimeRange(start: cycleStart, end: today),
  showMenstruationOverlay: true,
  height: 200,
)
```

**Properties:**
| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `entries` | `List<FluidsEntry>` | Yes | Fluids entries with BBT data |
| `dateRange` | `DateTimeRange` | Yes | Date range to display |
| `showMenstruationOverlay` | `bool` | No | Show menstruation periods (default: true) |
| `height` | `double` | No | Chart height (default: 200) |

**Features:**
- Line chart of temperature over time
- Menstruation period overlay (colored background)
- Tap to view daily details
- Pinch to zoom
- Accessible with data table alternative

### 6.4 Notification Time Picker

Multi-time picker for notification schedules.

```dart
NotificationTimePicker(
  times: [TimeOfDay(hour: 8, minute: 0), TimeOfDay(hour: 20, minute: 0)],
  onTimesChanged: (times) => setState(() => _reminderTimes = times),
  maxTimes: 5,
  label: 'Reminder Times',
)
```

**Properties:**
| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `times` | `List<TimeOfDay>` | Yes | Currently selected times |
| `onTimesChanged` | `ValueChanged<List<TimeOfDay>>` | Yes | Times change callback |
| `maxTimes` | `int` | No | Maximum number of times (default: 5) |
| `label` | `String?` | No | Section label |

**Features:**
- Add/remove multiple times
- Time picker dialog for each time
- Sorted display (earliest first)
- Duplicate prevention
- Accessible chips with remove action

### 6.5 Weekday Selector

Multi-select weekday picker for notification schedules.

```dart
WeekdaySelector(
  selectedDays: [0, 1, 2, 3, 4],  // Mon-Fri
  onChanged: (days) => setState(() => _selectedDays = days),
  compact: false,
)
```

**Properties:**
| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `selectedDays` | `List<int>` | Yes | Selected days (0=Mon, 6=Sun) |
| `onChanged` | `ValueChanged<List<int>>` | Yes | Selection callback |
| `compact` | `bool` | No | Use abbreviated labels (default: false) |

**Features:**
- Toggle individual days
- "Every day" / "Weekdays" / "Weekends" quick select
- Visual distinction for selected/unselected
- Accessible toggle buttons

### 6.6 Diet Type Selector

Dropdown selector for diet type with optional description field.

```dart
DietTypeSelector(
  value: DietPresetType.vegan,
  description: null,
  onTypeChanged: (type) => setState(() => _dietType = type),
  onDescriptionChanged: (desc) => setState(() => _dietDescription = desc),
)
```

**Properties:**
| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `value` | `DietPresetType?` | No | Currently selected diet type |
| `description` | `String?` | No | Custom description (for 'other' type) |
| `onTypeChanged` | `ValueChanged<DietPresetType?>` | Yes | Type change callback |
| `onDescriptionChanged` | `ValueChanged<String?>` | No | Description callback (visible when type is 'other') |

**Features:**
- Dropdown with all diet types
- Description field appears when "Other" selected
- Diet type icons
- Accessible with proper labels

### 6.7 Diet Type Badge

Display badge for current diet type.

```dart
DietTypeBadge(
  dietType: DietPresetType.vegan,
  showIcon: true,
  size: BadgeSize.medium,
)
```

**Properties:**
| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `dietType` | `DietPresetType` | Yes | Diet type to display |
| `showIcon` | `bool` | No | Show diet icon (default: true) |
| `size` | `BadgeSize` | No | Badge size (default: medium) |

---

## 7. Creating New Widgets

### 7.1 File Header Template

Every widget file MUST include a library header:

```dart
/// Accessible button components for Shadow app.
///
/// Provides [ShadowButton] with configurable variants for all button use cases,
/// following WCAG 2.1 Level AA accessibility standards.
///
/// See also:
/// * [12_ACCESSIBILITY_GUIDELINES.md] for full requirements
/// * [ShadowTextField] for form inputs
/// * [ShadowCard] for tappable containers
library;

import 'package:flutter/material.dart';
import 'package:shadow/presentation/theme/app_colors.dart';
```

### 7.2 Widget Dartdoc Template

Every public widget MUST have complete Dartdoc documentation:

```dart
/// A consolidated button widget with accessible semantics.
///
/// [ShadowButton] provides a unified interface for all button variants
/// in the Shadow app, ensuring consistent accessibility support.
///
/// {@template shadow_button}
/// All button instances:
/// - Meet WCAG 2.1 touch target requirements (48x48 dp minimum)
/// - Include semantic labels for screen readers
/// - Support disabled states with appropriate styling
/// {@endtemplate}
///
/// ## Basic Usage
///
/// ```dart
/// ShadowButton(
///   label: 'Save',
///   onPressed: () => save(),
/// )
/// ```
///
/// ## Variants
///
/// ```dart
/// // Elevated button (default)
/// ShadowButton(
///   variant: ButtonVariant.elevated,
///   label: 'Primary Action',
///   onPressed: doAction,
/// )
///
/// // Text button
/// ShadowButton(
///   variant: ButtonVariant.text,
///   label: 'Cancel',
///   onPressed: cancel,
/// )
///
/// // Icon button
/// ShadowButton(
///   variant: ButtonVariant.icon,
///   icon: Icons.add,
///   label: 'Add item',
///   onPressed: addItem,
/// )
/// ```
///
/// See also:
///
/// * [ButtonVariant] for available button styles
/// * [ShadowTextField] for form inputs
/// * [38_UI_FIELD_SPECIFICATIONS.md] for field-level button requirements
class ShadowButton extends StatelessWidget {
  /// The visual variant of the button.
  ///
  /// Defaults to [ButtonVariant.elevated].
  final ButtonVariant variant;

  /// Called when the button is tapped.
  ///
  /// If null, the button is disabled and appears grayed out.
  final VoidCallback? onPressed;

  /// The semantic label for screen readers.
  ///
  /// This is announced by VoiceOver/TalkBack when the button receives focus.
  /// Must describe the button's action, e.g., "Save supplement" not just "Save".
  final String label;

  /// Optional hint providing additional context.
  ///
  /// Announced after [label] by screen readers. Use for clarification,
  /// e.g., "Double-tap to activate".
  final String? hint;

  /// The icon to display for [ButtonVariant.icon] or [ButtonVariant.fab].
  ///
  /// Required when [variant] is [ButtonVariant.icon] or [ButtonVariant.fab].
  final IconData? icon;

  /// Custom child widget.
  ///
  /// If provided, overrides the default text/icon content.
  final Widget? child;

  /// Custom button style.
  ///
  /// Merged with the default style for this [variant].
  final ButtonStyle? style;

  /// Creates an accessible button.
  ///
  /// The [label] is required for accessibility and must describe the action.
  const ShadowButton({
    super.key,
    this.variant = ButtonVariant.elevated,
    required this.onPressed,
    required this.label,
    this.hint,
    this.icon,
    this.child,
    this.style,
  });

  // ... implementation
}
```

### 7.3 Enum Dartdoc Template

Document all enum values:

```dart
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
```

### 7.4 Widget Implementation Mapping

When creating forms, use the correct widget for each field type:

| Field Type (from spec) | Widget Class | Notes |
|------------------------|--------------|-------|
| Text | `ShadowTextField` | inputType: text |
| Password | `ShadowTextField` | inputType: password |
| Number | `ShadowTextField` | inputType: numeric |
| Dropdown | `ShadowTextField` | inputType: dropdown |
| Date Picker | `ShadowPicker` | pickerType: date |
| Time Picker | `ShadowPicker` | pickerType: time |
| Multi-select | `ShadowPicker` | pickerType: multiSelect |
| Weekday Selector | `ShadowPicker` | pickerType: weekday |
| Flow Intensity | `ShadowPicker` | pickerType: flow |
| Toggle/Switch | `ShadowToggle` | - |
| Slider | `ShadowSlider` | - |
| Image Picker | `ShadowImage` | source: picker |
| Chart | `ShadowChart` | chartType: varies |

### 7.5 Accessibility Requirements for All Widgets

Every widget MUST support:

1. **Semantic Label** - Required parameter or derived from label
2. **Focus Handling** - Can receive focus via keyboard
3. **Touch Target** - Minimum 48x48 dp
4. **Color Independence** - Information not conveyed by color alone
5. **State Announcement** - Loading, error, disabled states announced

```dart
class ShadowWidget extends StatelessWidget {
  // REQUIRED: Semantic information
  final String label;
  final String? semanticLabel;  // Uses label if not provided

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? label,
      child: SizedBox(
        // REQUIRED: Minimum touch target
        width: 48,
        height: 48,
        child: // ... widget content
      ),
    );
  }
}
```

### 7.6 Focus Order Requirements

Forms MUST define logical focus order using FocusTraversalGroup:

```dart
class AddSupplementForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
      policy: OrderedTraversalPolicy(),
      child: Column(
        children: [
          // Fields in order: 1, 2, 3...
          FocusTraversalOrder(
            order: NumericFocusOrder(1),
            child: ShadowTextField(
              label: 'Supplement Name',
              // ...
            ),
          ),
          FocusTraversalOrder(
            order: NumericFocusOrder(2),
            child: ShadowTextField(
              label: 'Brand',
              // ...
            ),
          ),
          FocusTraversalOrder(
            order: NumericFocusOrder(3),
            child: ShadowTextField(
              label: 'Dosage',
              // ...
            ),
          ),
          // ... more fields
          FocusTraversalOrder(
            order: NumericFocusOrder(10),
            child: ShadowButton(
              label: 'Save',
              onPressed: save,
            ),
          ),
        ],
      ),
    );
  }
}
```

### 7.7 Widget Testing Requirements

Every widget MUST have corresponding tests:

```dart
// test/presentation/widgets/shadow_button_test.dart

void main() {
  group('ShadowButton', () {
    testWidgets('renders with semantic label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ShadowButton(
            label: 'Test Button',
            onPressed: () {},
          ),
        ),
      );

      expect(find.bySemanticsLabel('Test Button'), findsOneWidget);
    });

    testWidgets('meets touch target size', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ShadowButton(
            variant: ButtonVariant.icon,
            icon: Icons.add,
            label: 'Add',
            onPressed: () {},
          ),
        ),
      );

      final button = tester.getSize(find.byType(ShadowButton));
      expect(button.width, greaterThanOrEqualTo(48));
      expect(button.height, greaterThanOrEqualTo(48));
    });

    testWidgets('disabled button is not tappable', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: ShadowButton(
            label: 'Disabled',
            onPressed: null, // Disabled
          ),
        ),
      );

      await tester.tap(find.byType(ShadowButton));
      expect(tapped, isFalse);
    });
  });
}
```

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-30 | Initial release |
| 1.1 | 2026-01-30 | Added Fluids widgets (FlowIntensityPicker, BBTInput, BBTChart), Notification widgets (TimePicker, WeekdaySelector), Diet widgets (DietTypeSelector, DietTypeBadge) |
