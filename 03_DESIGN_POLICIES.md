# Shadow Design Policies

**Version:** 1.0
**Last Updated:** January 30, 2026
**Compliance:** Apple Human Interface Guidelines, Material Design 3

---

## Overview

This document defines the visual design system for Shadow, ensuring consistency, accessibility, and a premium user experience across all platforms. Shadow uses an earth tone color palette that conveys trust, stability, and natural wellness.

---

## 1. Brand Identity

### 1.1 App Icon & Logo

**Design**: Shadow silhouette of a person in profile view

**Concept**: The icon represents the "shadow" metaphor - health conditions that follow us, the data that tracks alongside our daily lives, and the supportive presence of the app in monitoring wellness.

**Specifications**:
- Primary shape: Human silhouette in profile (facing right in LTR locales)
- Background: Gradient from primaryDark to primary (espresso to warm brown)
- Silhouette fill: Subtle earth tone gradient
- Style: Modern, minimal, recognizable at small sizes

**Icon Sizes Required**:
| Platform | Sizes (px) |
|----------|------------|
| Android | 48, 72, 96, 144, 192 (mipmap folders) |
| iOS | 20, 29, 40, 58, 60, 76, 80, 87, 120, 152, 167, 180, 1024 |
| macOS | 16, 32, 64, 128, 256, 512, 1024 |
| Web | 192, 512, maskable variants, favicon |

### 1.2 Brand Name

- **Name**: Shadow
- **Tagline**: "Track your health journey"
- **Typography**: Use system font (SF Pro on iOS/macOS, Roboto on Android)

---

## 2. Design Principles

### 2.1 Core Values

1. **Clarity** - Content is paramount; design should never compete with health data
2. **Deference** - UI helps users understand and interact with content without competing with it
3. **Depth** - Visual layers and realistic motion convey hierarchy and facilitate understanding
4. **Accessibility** - Design for everyone, regardless of ability
5. **Consistency** - Familiar patterns reduce cognitive load

### 2.2 Health App Considerations

- **Trust** - Medical data requires a professional, trustworthy aesthetic
- **Calm** - Health tracking should feel supportive, not stressful
- **Privacy** - Visual design should reinforce data security
- **Clarity** - Health information must be unambiguous

---

## 2. Color System

### 2.1 Brand Colors (Earth Tone Palette)

Shadow uses a warm, grounded earth tone palette that conveys trust, stability, and natural wellness.

```dart
// Primary Brand - Earth Tones
static const Color primary = Color(0xFF5D4E37);       // Warm brown
static const Color primaryLight = Color(0xFF8B7355); // Light tan
static const Color primaryDark = Color(0xFF3D3225);  // Espresso

// Secondary
static const Color secondary = Color(0xFF6B705C);    // Sage green
static const Color accent = Color(0xFFB08968);       // Caramel
```

### 2.2 Module Colors

Each feature module has a dedicated earth-tone color for visual identification:

| Module | Color | Hex Code | Usage |
|--------|-------|----------|-------|
| Supplements | Sage | `#6B705C` | Icons, headers, cards |
| Food Tracking | Caramel | `#B08968` | Icons, headers, cards |
| Conditions | Rust | `#BC6C25` | Icons, severity indicators |
| Activities | Sienna | `#7F5539` | Icons, headers, cards |
| Sleep | Slate | `#4A5568` | Icons, charts, cards |
| Photos | Olive | `#606C38` | Icons, gallery elements |
| Journal | Brown | `#795548` | Icons, headers, cards |
| Fluids | Steel Blue | `#546A7B` | Icons, tracking elements |
| Profile | Burgundy | `#7B2D26` | Icons, user elements |

### 2.3 Semantic Colors

```dart
// Status Colors (earth-tone friendly)
static const Color success = Color(0xFF606C38);  // Olive green - Positive outcomes
static const Color warning = Color(0xFFB08968);  // Caramel - Caution states
static const Color error = Color(0xFF9C3D2E);    // Terra cotta - Error states
static const Color info = Color(0xFF546A7B);     // Steel blue - Informational

// Severity Scale (1-10) - Earth tone gradient
static const List<Color> severityScale = [
  Color(0xFF606C38),  // 1 - Minimal (Olive)
  Color(0xFF7A8B4A),  // 2
  Color(0xFF8B9358),  // 3
  Color(0xFFA59F5D),  // 4
  Color(0xFFB08968),  // 5 - Moderate (Caramel)
  Color(0xFFB87D52),  // 6
  Color(0xFFC07040),  // 7
  Color(0xFFBC6C25),  // 8 - Rust
  Color(0xFFA85533),  // 9
  Color(0xFF7B2D26),  // 10 - Severe (Burgundy)
];
```

### 2.4 Neutral Colors

```dart
// Light Theme
static const Color backgroundLight = Color(0xFFFAFAFA);
static const Color surfaceLight = Color(0xFFFFFFFF);
static const Color textPrimaryLight = Color(0xFF212121);
static const Color textSecondaryLight = Color(0xFF757575);
static const Color dividerLight = Color(0xFFBDBDBD);

// Dark Theme
static const Color backgroundDark = Color(0xFF121212);
static const Color surfaceDark = Color(0xFF1E1E1E);
static const Color textPrimaryDark = Color(0xFFFFFFFF);
static const Color textSecondaryDark = Color(0xFFB3B3B3);
static const Color dividerDark = Color(0xFF424242);
```

### 2.5 Chart Colors

```dart
// Data Visualization (8 distinct earth-tone colors)
static const List<Color> chartColors = [
  Color(0xFF5D4E37),  // Warm Brown (primary)
  Color(0xFF6B705C),  // Sage
  Color(0xFFB08968),  // Caramel
  Color(0xFF7F5539),  // Sienna
  Color(0xFFBC6C25),  // Rust
  Color(0xFF546A7B),  // Steel Blue
  Color(0xFF606C38),  // Olive
  Color(0xFF7B2D26),  // Burgundy
];
```

---

## 3. Typography

### 3.1 Font Families

```dart
// Platform-Specific Fonts
static const String iosFontFamily = '.SF Pro Text';
static const String androidFontFamily = 'Roboto';
```

### 3.2 Type Scale

| Style | Size | Weight | Line Height | Usage |
|-------|------|--------|-------------|-------|
| Display Large | 57sp | Regular | 1.12 | Hero numbers |
| Display Medium | 45sp | Regular | 1.16 | Large stats |
| Display Small | 36sp | Regular | 1.22 | Feature titles |
| Headline Large | 32sp | Regular | 1.25 | Screen titles |
| Headline Medium | 28sp | Regular | 1.29 | Section headers |
| Headline Small | 24sp | Regular | 1.33 | Card titles |
| Title Large | 22sp | Medium | 1.27 | List headers |
| Title Medium | 16sp | Medium | 1.50 | Subtitles |
| Title Small | 14sp | Medium | 1.43 | Small headers |
| Body Large | 16sp | Regular | 1.50 | Primary content |
| Body Medium | 14sp | Regular | 1.43 | Secondary content |
| Body Small | 12sp | Regular | 1.33 | Tertiary content |
| Label Large | 14sp | Medium | 1.43 | Button text |
| Label Medium | 12sp | Medium | 1.33 | Tabs, chips |
| Label Small | 11sp | Medium | 1.45 | Captions |

### 3.3 Font Weights

```dart
static const FontWeight light = FontWeight.w300;
static const FontWeight regular = FontWeight.w400;
static const FontWeight medium = FontWeight.w500;
static const FontWeight semiBold = FontWeight.w600;
static const FontWeight bold = FontWeight.w700;
static const FontWeight extraBold = FontWeight.w800;
```

### 3.4 Specialized Styles

```dart
// Number Display (for health metrics)
static const TextStyle numberLarge = TextStyle(
  fontSize: 48,
  fontWeight: FontWeight.w300,
  letterSpacing: -0.5,
);

static const TextStyle numberMedium = TextStyle(
  fontSize: 32,
  fontWeight: FontWeight.w400,
);

static const TextStyle numberSmall = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w500,
);
```

---

## 4. Spacing System

### 4.1 Base Units

```dart
// Spacing Scale (4dp base unit)
static const double xs = 4.0;    // Minimal spacing
static const double sm = 8.0;    // Tight spacing
static const double md = 12.0;   // Comfortable spacing
static const double lg = 16.0;   // Standard spacing
static const double xl = 24.0;   // Relaxed spacing
static const double xxl = 32.0;  // Section spacing
static const double xxxl = 48.0; // Page sections
```

### 4.2 Standard Padding

```dart
// Screen Padding
static const EdgeInsets screenPadding = EdgeInsets.all(16.0);
static const EdgeInsets screenPaddingHorizontal = EdgeInsets.symmetric(horizontal: 16.0);

// Card Padding
static const EdgeInsets cardPadding = EdgeInsets.all(16.0);
static const EdgeInsets cardPaddingCompact = EdgeInsets.all(12.0);

// List Item Padding
static const EdgeInsets listItemPadding = EdgeInsets.symmetric(
  horizontal: 16.0,
  vertical: 12.0,
);
```

### 4.3 Component Heights

```dart
// Standard Heights
static const double appBarHeight = 56.0;
static const double tabBarHeight = 48.0;
static const double bottomNavHeight = 64.0;
static const double buttonHeightSm = 36.0;
static const double buttonHeightMd = 44.0;
static const double buttonHeightLg = 52.0;
static const double formFieldHeight = 48.0;
static const double listItemHeightSm = 48.0;
static const double listItemHeightMd = 64.0;
static const double listItemHeightLg = 80.0;
```

### 4.4 Border Radius

```dart
static const double radiusXs = 4.0;   // Subtle rounding
static const double radiusSm = 8.0;   // Small components
static const double radiusMd = 12.0;  // Cards, buttons
static const double radiusLg = 16.0;  // Large cards
static const double radiusXl = 24.0;  // Bottom sheets
static const double radiusFull = 9999.0; // Circular
```

---

## 5. Component Specifications

### 5.1 Cards

```dart
// Standard Card
- Background: Surface color
- Border Radius: 12dp
- Elevation: 2dp (light), 4dp (dark)
- Padding: 16dp all sides
- Margin: 8dp horizontal, 4dp vertical

// Tappable Card
- All standard card properties
- Ripple effect on tap
- Elevation increase on press: 8dp
```

### 5.2 Buttons

```dart
// Primary Button (Elevated)
- Height: 44dp minimum
- Border Radius: 12dp
- Horizontal Padding: 24dp
- Background: Primary color
- Text: White, Label Large

// Secondary Button (Outlined)
- Height: 44dp minimum
- Border Radius: 12dp
- Border: 1.5dp primary color
- Background: Transparent
- Text: Primary color, Label Large

// Text Button
- Height: 44dp minimum
- Horizontal Padding: 16dp
- Background: Transparent
- Text: Primary color, Label Large
```

### 5.3 Form Fields

```dart
// Text Input
- Height: 48dp
- Border Radius: 8dp
- Border: 1.5dp outline (grey when unfocused, primary when focused)
- Label: Above field, Body Small
- Error: Below field, Body Small, Error color
- Padding: 16dp horizontal, 12dp vertical
```

### 5.4 Lists

```dart
// List Tile
- Min Height: 48dp (single line), 64dp (two line), 80dp (three line)
- Leading: 40dp width reserved
- Trailing: 24dp width reserved
- Content Padding: 16dp horizontal
- Divider: 1dp, positioned below content
```

### 5.5 Bottom Navigation

```dart
// Bottom Navigation Bar
- Height: 64dp
- Elevation: 8dp
- Background: Surface color
- Items: 5 maximum
- Icon Size: 24dp
- Label: 12sp
- Selected: Primary color
- Unselected: Grey
```

---

## 6. Iconography

### 6.1 Icon Sizes

```dart
static const double iconXs = 16.0;  // Inline icons
static const double iconSm = 20.0;  // Small UI elements
static const double iconMd = 24.0;  // Standard icons
static const double iconLg = 32.0;  // Emphasized icons
static const double iconXl = 48.0;  // Feature icons
static const double iconXxl = 64.0; // Empty states
static const double iconXxxl = 96.0; // Hero graphics
```

### 6.2 Icon Style

- Use Material Icons (filled style) for consistency
- 2dp stroke weight for outlined variants
- Maintain optical balance with text
- Use module colors for feature icons

---

## 7. Motion & Animation

### 7.1 Duration Standards

```dart
static const Duration durationFast = Duration(milliseconds: 200);
static const Duration durationNormal = Duration(milliseconds: 300);
static const Duration durationSlow = Duration(milliseconds: 500);
```

### 7.2 Easing Curves

```dart
// Standard Easing
static const Curve easeInOut = Curves.easeInOut;
static const Curve easeOut = Curves.easeOut;
static const Curve easeIn = Curves.easeIn;

// Emphasized Easing (for important transitions)
static const Curve emphasized = Curves.easeInOutCubic;
```

### 7.3 Transition Guidelines

| Transition | Duration | Curve | Usage |
|------------|----------|-------|-------|
| Fade | 200ms | easeInOut | Content changes |
| Slide | 300ms | easeOut | Page transitions |
| Scale | 200ms | easeOut | Button press |
| Elevation | 200ms | easeInOut | Card hover/press |

---

## 8. Dark Mode

### 8.1 Color Adjustments

- Backgrounds: Use dark grey (`#121212`), not pure black
- Surfaces: Elevate with lighter greys (`#1E1E1E`, `#2C2C2C`)
- Text: Use off-white (`#FFFFFF` at 87% opacity for primary)
- Colors: Desaturate bright colors slightly
- Elevation: Use lighter surface colors instead of shadows

### 8.2 Implementation

```dart
// Dark Theme Elevation Overlay
// Higher elevation = lighter surface
static Color getSurfaceWithElevation(double elevation) {
  final overlayOpacity = (4.5 * log(elevation + 1) + 2) / 100;
  return Color.lerp(surfaceDark, Colors.white, overlayOpacity)!;
}
```

---

## 9. Accessibility Requirements

### 9.1 Color Contrast

- Text on background: Minimum 4.5:1 (WCAG AA)
- Large text (18sp+): Minimum 3:1
- UI components: Minimum 3:1
- Never rely on color alone to convey information

### 9.2 Touch Targets

- Minimum size: 48x48dp
- Minimum spacing between targets: 8dp
- Recommended size for primary actions: 56x56dp

### 9.3 Text Scaling

- Support Dynamic Type (iOS) / Font Scale (Android)
- Test at 200% text scale
- Use flexible layouts that accommodate larger text

---

## 10. Platform Considerations

### 10.1 iOS Specifics

- Use San Francisco font family
- Support Safe Area insets
- Follow iOS navigation patterns (back swipe)
- Use iOS-style date pickers

### 10.2 Android Specifics

- Use Roboto font family
- Support edge-to-edge display
- Follow Material navigation patterns
- Use Material date pickers

### 10.3 macOS Specifics

- Support menu bar integration
- Respect system accent color
- Support keyboard navigation
- Follow macOS window behaviors

---

## 11. PDF Export Styling

### 11.1 PDF Constants

```dart
// Font Sizes
static const double pdfTitleSize = 24.0;
static const double pdfHeadingSize = 18.0;
static const double pdfSubheadingSize = 14.0;
static const double pdfBodySize = 11.0;
static const double pdfCaptionSize = 9.0;

// Layout
static const double pdfMargin = 40.0;
static const double pdfLineSpacing = 6.0;
static const double pdfTableCellPadding = 8.0;

// Brand Colors for PDF (Earth Tones)
static const PdfColor pdfPrimary = PdfColor.fromInt(0xFF5D4E37);   // Warm brown
static const PdfColor pdfAccent = PdfColor.fromInt(0xFFB08968);    // Caramel
static const PdfColor pdfSecondary = PdfColor.fromInt(0xFF6B705C); // Sage
```

---

## 12. Design Tokens Reference

### 12.1 File Locations

| Token Category | File Path |
|----------------|-----------|
| Colors | `lib/presentation/theme/app_colors.dart` |
| Typography | `lib/presentation/theme/app_typography.dart` |
| Spacing | `lib/presentation/theme/app_spacing.dart` |
| Theme | `lib/presentation/theme/app_theme.dart` |
| Constants | `lib/core/config/app_constants.dart` |

### 12.2 Usage

```dart
import 'package:shadow_app/presentation/theme/app_colors.dart';
import 'package:shadow_app/presentation/theme/app_typography.dart';
import 'package:shadow_app/presentation/theme/app_spacing.dart';

// In widgets
Container(
  padding: AppSpacing.paddingMd,
  decoration: BoxDecoration(
    color: AppColors.surfaceLight,
    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
  ),
  child: Text(
    'Health Data',
    style: AppTypography.headlineSmall,
  ),
)
```

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-30 | Initial release |
| 1.1 | 2026-01-30 | Updated to earth tone color palette, added shadow silhouette logo specs, renamed Bowel/Urine to Fluids |
