# Shadow Accessibility Guidelines

**Version:** 1.0
**Last Updated:** January 30, 2026
**Compliance:** WCAG 2.1 Level AA, Apple HIG, Material Design Accessibility

---

## Overview

Shadow is designed to be fully accessible to users with disabilities, including those using screen readers, requiring high contrast modes, or needing large text scaling. This document defines accessibility requirements and implementation patterns.

---

## 1. Accessibility Standards

### 1.1 Compliance Targets

| Standard | Level | Requirement |
|----------|-------|-------------|
| WCAG 2.1 | AA | Minimum compliance |
| Apple HIG | Full | iOS/macOS accessibility |
| Material Design | Full | Android accessibility |
| Section 508 | Full | U.S. federal compliance |

### 1.2 Key Principles (POUR)

1. **Perceivable** - Information must be presentable in ways users can perceive
2. **Operable** - Interface components must be operable by all users
3. **Understandable** - Information and operation must be understandable
4. **Robust** - Content must be robust enough for diverse assistive technologies

---

## 2. Screen Reader Support

### 2.1 Semantic Labels

Every interactive element MUST have a descriptive semantic label:

```dart
// CORRECT: Descriptive label
AccessibleIconButton(
  icon: Icons.add,
  label: 'Add new supplement',  // Screen reader announces this
  onPressed: () => addSupplement(),
)

// WRONG: Missing label
IconButton(
  icon: Icon(Icons.add),  // Screen reader says "button"
  onPressed: () => addSupplement(),
)
```

### 2.2 Semantic Hints

Provide action hints for complex interactions:

```dart
AccessibleCard(
  semanticLabel: 'Vitamin D supplement, 5000 IU daily',
  semanticHint: 'Double tap to view details',  // Explains the action
  onTap: () => viewDetails(),
  child: SupplementContent(),
)
```

### 2.3 Live Regions

Announce dynamic content changes immediately:

```dart
// Success/error messages
showAccessibleSnackBar(
  context: context,
  message: 'Supplement saved successfully',
  // Uses liveRegion: true internally for immediate announcement
);

// Manual announcement
SemanticsService.announce(
  'Data synchronized successfully',
  TextDirection.ltr,
);
```

### 2.4 Grouping Related Content

Use `MergeSemantics` for logical grouping:

```dart
MergeSemantics(
  child: Row(
    children: [
      Icon(Icons.medication),
      Text('Vitamin D'),
      Text('5000 IU'),
    ],
  ),
)
// Screen reader: "Vitamin D 5000 IU" (single announcement)
```

### 2.5 Excluding Decorative Content

Mark decorative elements to avoid clutter:

```dart
// Decorative image (no semantic meaning)
AccessibleImage(
  image: AssetImage('assets/decorative_bg.png'),
  isDecorative: true,  // Excluded from screen reader
)

// Alternative: ExcludeSemantics wrapper
ExcludeSemantics(
  child: Icon(Icons.star, color: Colors.yellow),
)
```

---

## 3. Touch Targets

### 3.1 Minimum Size Requirements

| Standard | Minimum Size |
|----------|--------------|
| WCAG 2.1 AA | 44x44 CSS pixels |
| Apple HIG | 44x44 points |
| Material Design | 48x48 dp |

**Shadow Standard:** 48x48 dp minimum for all interactive elements

### 3.2 Implementation

```dart
// All accessible buttons enforce minimum size
class AccessibleIconButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: SizedBox(
        width: 48,   // Minimum touch target
        height: 48,
        child: IconButton(
          icon: Icon(icon),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
```

### 3.3 Spacing Between Targets

Minimum 8dp spacing between adjacent touch targets to prevent accidental activation.

---

## 4. Color & Contrast

### 4.1 Contrast Requirements

| Content Type | Minimum Ratio |
|--------------|---------------|
| Normal text (<18sp) | 4.5:1 |
| Large text (≥18sp or 14sp bold) | 3:1 |
| UI components | 3:1 |
| Focus indicators | 3:1 |

### 4.2 Color Independence

**NEVER rely on color alone** to convey information:

```dart
// CORRECT: Icon + color + text
Row(
  children: [
    Icon(Icons.error, color: Colors.red),
    Text('Error: Invalid input', style: TextStyle(color: Colors.red)),
  ],
)

// WRONG: Color only
Container(
  color: Colors.red,  // What does red mean?
  child: Text('Status'),
)
```

### 4.3 High Contrast Detection

```dart
// Detect and respond to high contrast mode
bool isHighContrast = MediaQuery.of(context).highContrast;

if (isHighContrast) {
  // Use higher contrast colors
  return HighContrastTheme();
}
```

---

## 5. Text Scaling

### 5.1 Dynamic Type Support

Support text scaling up to 200%:

```dart
// Get current scale factor
double scaleFactor = MediaQuery.of(context).textScaleFactor;

// Detect large text mode
bool isLargeText = scaleFactor > 1.3;
```

### 5.2 Flexible Layouts

Design layouts that accommodate larger text:

```dart
// CORRECT: Flexible layout
Flexible(
  child: Text(
    'Supplement Name',
    overflow: TextOverflow.ellipsis,
    maxLines: 2,
  ),
)

// WRONG: Fixed width
SizedBox(
  width: 100,
  child: Text('This will overflow...'),
)
```

### 5.3 Testing Requirements

Test all screens at:
- 100% scale (default)
- 150% scale (common)
- 200% scale (maximum)

---

## 6. Focus Management

### 6.1 Visible Focus Indicators

All focusable elements must show clear focus state:

```dart
Theme(
  data: ThemeData(
    focusColor: Colors.blue,
    inputDecorationTheme: InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue, width: 2),
      ),
    ),
  ),
)
```

### 6.2 Logical Focus Order

Focus should follow visual reading order (left-to-right, top-to-bottom):

```dart
// Use FocusTraversalGroup for custom order
FocusTraversalGroup(
  policy: OrderedTraversalPolicy(
    order: [
      NumericFocusOrder(1),  // First
      NumericFocusOrder(2),  // Second
      NumericFocusOrder(3),  // Third
    ],
  ),
  child: Column(...),
)
```

### 6.3 Managing Focus in Dialogs

```dart
showDialog(
  context: context,
  builder: (context) => AccessibleAlertDialog(
    title: 'Confirm Delete',
    // Focus automatically moves to dialog
    // Returns to trigger on dismiss
  ),
);
```

---

## 7. Form Accessibility

### 7.1 Label Association

Every form field must have an associated label:

```dart
AccessibleTextField(
  label: 'Supplement Name',         // Visual label
  semanticLabel: 'Supplement name', // Screen reader label (if different)
  hintText: 'e.g., Vitamin D3',
)
```

### 7.2 Error Handling

Errors must be:
1. Associated with the field
2. Announced by screen reader
3. Visually distinct

```dart
AccessibleTextField(
  label: 'Email',
  errorText: _emailError,  // Associated with field
  // Semantic hint automatically includes error state
)
```

### 7.3 Required Field Indication

```dart
AccessibleTextField(
  label: 'Name *',  // Visual asterisk
  semanticHint: 'Required field',  // Screen reader context
)
```

---

## 8. Navigation Accessibility

### 8.1 Screen Headers

Use semantic headers for screen reader navigation:

```dart
Semantics(
  header: true,  // Marks as heading
  child: Text('Supplements', style: Theme.of(context).textTheme.headlineLarge),
)
```

### 8.2 Section Headers

```dart
SectionHeader(
  title: 'Active Conditions',
  count: 3,
  // Automatically includes header semantics
  // "Active Conditions, 3 items"
)
```

### 8.3 List Item Position

Provide position context in lists:

```dart
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return Semantics(
      label: '${items[index].name}, item ${index + 1} of ${items.length}',
      child: ListTile(...),
    );
  },
)
```

---

## 9. Accessibility Helper Utilities

### 9.1 Available Helper Functions

**Location:** `lib/core/accessibility/accessibility_helper.dart`

```dart
class AccessibilityHelper {
  // Semantic label generators
  static String dateLabel(DateTime date);          // "Today at 3:30 PM"
  static String severityLabel(int level);          // "Severity 7 out of 10, high"
  static String countLabel(int count, String singular, String plural);
  static String emptyStateLabel(String entityType);
  static String loadingLabel(String content);
  static String errorLabel(String content, String error);

  // Semantic wrappers
  static Widget accessibleButton(Widget child, String label);
  static Widget accessibleImage(Widget child, String label, {bool isDecorative});
  static Widget accessibleHeader(Widget child, String label, {int level});
  static Widget accessibleListItem(Widget child, String label, {int position, int total});

  // Environment detection
  static bool isHighContrastEnabled(BuildContext context);
  static bool isLargeTextEnabled(BuildContext context);
  static bool isScreenReaderEnabled(BuildContext context);
  static double getTextScaleFactor(BuildContext context);
}
```

### 9.2 Usage Examples

```dart
// Generate semantic date label
Text(
  formattedDate,
  semanticsLabel: AccessibilityHelper.dateLabel(entryDate),
  // "Yesterday at 2:30 PM" instead of "01/29/2026"
)

// Severity with context
Text(
  '$severity/10',
  semanticsLabel: AccessibilityHelper.severityLabel(severity),
  // "Severity 8 out of 10, high"
)

// Empty state
EmptyStateWidget(
  message: 'No supplements',
  // Automatically generates: "Empty state: No supplements"
)
```

---

## 10. Testing Accessibility

### 10.1 Automated Testing

```dart
testWidgets('button has semantic label', (tester) async {
  await tester.pumpWidget(
    AccessibleIconButton(
      icon: Icons.add,
      label: 'Add supplement',
      onPressed: () {},
    ),
  );

  expect(
    tester.getSemantics(find.byType(AccessibleIconButton)),
    matchesSemantics(
      label: 'Add supplement',
      isButton: true,
      hasEnabledState: true,
      isEnabled: true,
    ),
  );
});
```

### 10.2 Manual Testing Checklist

**Screen Reader Testing (VoiceOver/TalkBack):**

- [ ] All interactive elements announced
- [ ] Labels are descriptive and accurate
- [ ] Focus order is logical
- [ ] State changes are announced
- [ ] Errors are announced when they occur

**Visual Testing:**

- [ ] Content readable at 200% text scale
- [ ] UI functional with high contrast
- [ ] Focus indicators visible
- [ ] Touch targets meet 48dp minimum

### 10.3 Testing Tools

| Platform | Tool |
|----------|------|
| iOS | VoiceOver (Settings > Accessibility) |
| Android | TalkBack (Settings > Accessibility) |
| macOS | VoiceOver (Cmd + F5) |
| All | Accessibility Inspector (Flutter DevTools) |

---

## 11. Accessible Widget Reference

### 11.1 Required Widgets

All screens MUST use these accessible widgets:

| Widget | Purpose | Location |
|--------|---------|----------|
| `AccessibleButton` | Buttons with labels | `accessible_widgets.dart` |
| `AccessibleIconButton` | Icon buttons with labels | `accessible_widgets.dart` |
| `AccessibleTextField` | Form inputs | `accessible_widgets.dart` |
| `AccessibleCard` | Tappable cards | `accessible_widgets.dart` |
| `AccessibleImage` | Images with alt text | `accessible_widgets.dart` |
| `AccessibleLoadingIndicator` | Loading states | `accessible_widgets.dart` |
| `AccessibleEmptyState` | Empty states | `accessible_widgets.dart` |

### 11.2 Import Statement

```dart
import 'package:shadow_app/presentation/widgets/accessible_widgets.dart';
```

---

## 12. Common Patterns

### 12.1 Data Cards

```dart
AccessibleCard(
  semanticLabel: '${condition.name}, ${condition.category}, ${condition.status}',
  semanticHint: 'Double tap to view details',
  onTap: () => viewCondition(condition),
  child: ConditionCardContent(condition: condition),
)
```

### 12.2 Action Buttons

```dart
AccessibleFloatingActionButton(
  label: 'Add new supplement',
  onPressed: () => addSupplement(),
  child: Icon(Icons.add),
)
```

### 12.3 Status Indicators

```dart
AccessibleStatusIndicator(
  status: 'Synced',
  color: Colors.green,
  icon: Icons.cloud_done,
  semanticLabel: 'Data synchronized to cloud',
)
```

### 12.4 Empty States

```dart
AccessibleEmptyState(
  message: 'No conditions tracked',
  icon: Icon(Icons.health_and_safety_outlined, size: 64),
  action: AccessibleElevatedButton(
    label: 'Add your first condition',
    onPressed: () => addCondition(),
    child: Text('Add Condition'),
  ),
)
```

---

## 13. Checklist for New Features

Before shipping any new feature:

- [ ] All buttons have semantic labels
- [ ] All images have alt text (or marked decorative)
- [ ] All form fields have labels
- [ ] Touch targets are ≥48dp
- [ ] Color is not the only indicator
- [ ] Text contrast meets 4.5:1 (normal) or 3:1 (large)
- [ ] Focus order is logical
- [ ] Dynamic content changes are announced
- [ ] Tested with screen reader
- [ ] Tested at 200% text scale
- [ ] Tested in high contrast mode

---

## 14. Resources

### 14.1 Documentation

- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [Apple Accessibility Guidelines](https://developer.apple.com/accessibility/)
- [Material Design Accessibility](https://material.io/design/usability/accessibility.html)
- [Flutter Accessibility](https://docs.flutter.dev/accessibility-and-localization/accessibility)

### 14.2 Testing Tools

- Flutter Accessibility Inspector (DevTools)
- iOS Accessibility Inspector (Xcode)
- Android Accessibility Scanner (Play Store)

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-30 | Initial release |
