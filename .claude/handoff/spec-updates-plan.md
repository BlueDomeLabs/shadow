# Spec Updates & Implementation Plan

**Created:** 2026-02-12
**Updated:** 2026-02-12
**Status:** IN PROGRESS
**Priority:** HIGH

---

## Part A: Platform Configuration Spec Updates (from database debugging)

### 1. `10_DATABASE_SCHEMA.md` — Section 1.1 (Encryption Configuration)

**What to add:** Document the full `FlutterSecureStorage` configuration required for the encryption key storage.

Current spec says: "256-bit key stored in Keychain/KeyStore" — but doesn't specify the `MacOsOptions` needed.

**Add these details:**
```dart
// Required FlutterSecureStorage configuration for all platforms
const storage = FlutterSecureStorage(
  aOptions: AndroidOptions(encryptedSharedPreferences: true),
  iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  mOptions: MacOsOptions(
    accessibility: KeychainAccessibility.first_unlock,
    useDataProtectionKeyChain: false,  // CRITICAL — see note below
  ),
);
```

**Why `useDataProtectionKeyChain: false`:**
- `flutter_secure_storage` defaults `useDataProtectionKeyChain` to `true`
- This uses Apple's Data Protection Keychain (`kSecUseDataProtectionKeychain`), which requires a provisioning profile with Data Protection capability
- Without it, all Keychain operations fail with error -34018 (`errSecMissingEntitlement`)
- Setting to `false` uses the legacy macOS Keychain, which works without special entitlements
- The fix is in `lib/data/datasources/local/database.dart` in both `getOrCreateEncryptionKey()` and `deleteDatabaseAndKey()`

### 2. New Section or Document — macOS Code Signing Configuration

**What to add:** Document the required Xcode project settings for code signing.

All three Runner build configurations (Debug, Profile, Release) in `macos/Runner.xcodeproj/project.pbxproj` require:
```
DEVELOPMENT_TEAM = 742J35L2JR;
CODE_SIGN_IDENTITY = "Apple Development";
```

**Where to put it:**
- Option A: New section in `02_CODING_STANDARDS.md` under platform configuration
- Option B: New spec document (e.g., `56_PLATFORM_CONFIGURATION.md`)
- The user should decide which location is best

### 3. Verify Compliance with Coding Standards

Per user instruction: "verify they comply with the Coding Standards as well as best practices"

- Review `02_CODING_STANDARDS.md` for any platform-specific sections that may need updating
- Check Apple/Google best practices for Keychain/KeyStore configuration
- Ensure the `MacOsOptions` configuration aligns with Apple's recommendation for non-App Store debug builds
- Consider whether `useDataProtectionKeyChain: true` should be used for Release/production builds (requires provisioning profile setup)

### 4. Add Coding Standard for Date-Range Provider Keys

Family providers with date-range parameters MUST normalize dates to stable boundaries (e.g., day start/end) to prevent infinite rebuild loops. This was the root cause of the FluidsEntryList polling bug.

### 5. Factory Reset Skill — Already Fixed

The following changes were already applied to `~/.claude/skills/factory-reset/skill.md`:
- Added `shadow_db_encryption_key` to the KEYS array (matching `database.dart:172`)
- Added cleanup of `~/Library/Application Support/com.bluedomecolorado.shadowApp` for non-sandboxed debug builds

---

## Part B: UI Label & Feature Corrections (from user feedback 2026-02-12)

### 1. Bowel/Urine Tab → "Fluids" Tab

The tab currently labeled "Bowel/Urine Log" should be labeled "Fluids". This was changed in specs but the UI reverted to old labels when the look was updated to match the original app.

**File:** `lib/presentation/screens/home/tabs/fluids_tab.dart`
- Line 38: `Text('${titlePrefix}Bowel/Urine Log')` → should be `Text('${titlePrefix}Fluids')`
- Check the bottom navigation tab label too (likely in the home screen)

### 2. BBT (Basal Body Temperature) Tracking

BBT tracking was part of the fluids entry screen spec but may have been lost during UI updates. Verify:
- `FluidsEntry` entity has BBT fields (check `22_API_CONTRACTS.md`)
- `FluidsEntryScreen` includes BBT input fields
- The fluids_tab.dart displays BBT data in the expansion tile when present

### 3. Verify Fluids Tab Shows Complete Data

The fluids tab's expansion tile should show all tracked data, not just bowel/urine:
- Water intake
- Bowel condition & size
- Urine condition & size
- Menstruation flow
- BBT (basal body temperature)
- Other fluid tracking
- Notes

---

## Part C: Unimplemented Features

### 1. Cloud Sync

Cloud sync functionality has NOT been implemented yet. Check specs for:
- `35_CLOUD_SYNC.md` or equivalent spec
- Google Drive integration (OAuth is partially set up)
- Sync protocol and conflict resolution

### 2. Reports

Reports feature has NOT been implemented yet. Check specs for:
- Report generation specs
- Data visualization requirements
- Export functionality

---

## Files Modified (Implementation — Already Done)

| File | Change |
|------|--------|
| `lib/data/datasources/local/database.dart` | Added `MacOsOptions(useDataProtectionKeyChain: false)` to both FlutterSecureStorage instances; diagnostic logging in migration strategy |
| `macos/Runner.xcodeproj/project.pbxproj` | Added DEVELOPMENT_TEAM + CODE_SIGN_IDENTITY to all 3 Runner build configs |
| `lib/presentation/screens/home/tabs/fluids_tab.dart` | Normalized date parameters to day boundaries to prevent infinite provider polling |
| `lib/core/utils/sample_data_generator.dart` | Removed `FoodItemType.complex` from Chicken Rice Bowl (validation requires component IDs) |
| `~/.claude/skills/factory-reset/skill.md` | Added correct keychain key name + Application Support path |

## Verification Steps

After spec updates are complete:
1. Verify specs are internally consistent
2. Run `/compliance` to check implementation matches updated specs
3. Run `flutter test` and `flutter analyze`
4. Factory reset + relaunch to verify clean state
5. Generate sample data — all items should succeed
6. Verify no polling loops in console
7. Check all tab labels match specs
