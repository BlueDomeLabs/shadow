---
name: factory-reset
description: Complete factory reset of the Shadow app. Clears database, encryption key, caches, and build artifacts to restore the app to its original first-launch state.
---

# Shadow Factory Reset Skill

## Purpose

Perform a complete factory reset of the Shadow app, clearing all user data and restoring it to the original first-launch state (Welcome Screen). Use this when:

- Database is corrupted or stale from a previous run
- All queries are failing with "Database query failed"
- You want to test the fresh first-launch experience
- You need a clean slate after development/testing

---

## EXECUTION PROTOCOL

**Execute these steps in order. Do NOT skip steps.**

---

### Step 1: Stop the Running App

If the app is currently running, stop it first:

```bash
# Kill any running Flutter processes for this app
pkill -f "flutter.*shadow" || true
pkill -f "shadow_app" || true
```

Verify no instances are running before proceeding.

---

### Step 2: Delete the Database File

The encrypted SQLite database is stored at platform-specific locations:

**macOS (development):**
```bash
rm -f "/Users/reidbarcus/Library/Containers/com.bluedomecolorado.shadowApp/Data/Documents/shadow.db"
```

**If the Containers path doesn't exist, check Application Support:**
```bash
rm -f ~/Library/Application\ Support/com.bluedomecolorado.shadowApp/shadow.db
```

**Verify deletion:**
```bash
ls -la "/Users/reidbarcus/Library/Containers/com.bluedomecolorado.shadowApp/Data/Documents/shadow.db" 2>/dev/null && echo "WARNING: Database still exists!" || echo "OK: No database file"
```

#### Database Location Reference

From `lib/data/datasources/local/database.dart`:
- Database filename: `shadow.db`
- iOS/Android: `getApplicationDocumentsDirectory()`
- macOS: `getApplicationSupportDirectory()`
- Encryption: AES-256 via SQLCipher
- Key storage: `shadow_db_encryption_key` in platform Keychain/KeyStore

---

### Step 3: Clear the Encryption Key

The encryption key is stored in the macOS Keychain via `FlutterSecureStorage`. Deleting only the database without the key can cause issues if the new database gets a different key.

**Option A: Use the app's built-in method (preferred)**

The codebase provides `DatabaseConnection.deleteDatabaseAndKey()` in `lib/data/datasources/local/database.dart` (line 279). This handles both the database file and the encryption key atomically.

**Option B: Manual key deletion (if Option A is not feasible)**

```bash
security delete-generic-password -a "shadow_db_encryption_key" -s "shadow_db_encryption_key" 2>/dev/null || echo "Keychain entry not found or already deleted"
```

Note: The exact Keychain service name may vary based on `FlutterSecureStorage` defaults. The app handles missing keys gracefully by generating a new one on next launch.

---

### Step 4: Clear Flutter Build Cache

```bash
cd /Users/reidbarcus/Development/Shadow
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

---

### Step 5: Clear macOS App Data (Optional)

For a truly complete reset that also clears preferences and cached state:

```bash
defaults delete com.bluedomecolorado.shadowApp 2>/dev/null || true
rm -rf "/Users/reidbarcus/Library/Containers/com.bluedomecolorado.shadowApp/Data/Library/Caches/" 2>/dev/null || true
rm -rf "/Users/reidbarcus/Library/Containers/com.bluedomecolorado.shadowApp/Data/Library/Preferences/" 2>/dev/null || true
```

---

### Step 6: Verify Clean State

```bash
ls -la "/Users/reidbarcus/Library/Containers/com.bluedomecolorado.shadowApp/Data/Documents/shadow.db" 2>/dev/null && echo "WARNING: Database still exists!" || echo "OK: No database file"

cd /Users/reidbarcus/Development/Shadow
flutter analyze
```

---

### Step 7: Relaunch the App

```bash
cd /Users/reidbarcus/Development/Shadow
flutter run -d macos
```

**Expected result:** The app launches to the **Welcome Screen** showing:
- Shadow app logo and "Welcome to Shadow" heading
- Feature list (Track Supplements, Log Food & Reactions, Monitor Conditions, Photo Tracking, Cloud Sync)
- "Create New Account" and "Join Existing Account" buttons
- Privacy notice

---

## Quick Factory Reset (Minimal)

For a quick reset when you just need to clear data:

```bash
pkill -f "shadow_app" || true
rm -f "/Users/reidbarcus/Library/Containers/com.bluedomecolorado.shadowApp/Data/Documents/shadow.db"
rm -f ~/Library/Application\ Support/com.bluedomecolorado.shadowApp/shadow.db
cd /Users/reidbarcus/Development/Shadow && flutter run -d macos
```

---

## Full Factory Reset (Everything)

```bash
# 1. Stop app
pkill -f "shadow_app" || true

# 2. Delete database
rm -f "/Users/reidbarcus/Library/Containers/com.bluedomecolorado.shadowApp/Data/Documents/shadow.db"
rm -f ~/Library/Application\ Support/com.bluedomecolorado.shadowApp/shadow.db

# 3. Clear encryption key
security delete-generic-password -a "shadow_db_encryption_key" -s "shadow_db_encryption_key" 2>/dev/null || true

# 4. Clear app preferences and caches
defaults delete com.bluedomecolorado.shadowApp 2>/dev/null || true
rm -rf "/Users/reidbarcus/Library/Containers/com.bluedomecolorado.shadowApp/Data/Library/Caches/" 2>/dev/null || true
rm -rf "/Users/reidbarcus/Library/Containers/com.bluedomecolorado.shadowApp/Data/Library/Preferences/" 2>/dev/null || true

# 5. Clean Flutter build
cd /Users/reidbarcus/Development/Shadow
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs

# 6. Relaunch
flutter run -d macos
```

---

## Troubleshooting

### Database still exists after deletion
The app may be holding a lock on the file. Kill all app processes first (Step 1).

### App crashes on launch after reset
Run `flutter clean && flutter pub get && dart run build_runner build --delete-conflicting-outputs`.

### "Database query failed" errors persist
Search for the database at an unexpected path:
```bash
find ~/Library -name "shadow.db" 2>/dev/null
```

### Encryption key mismatch
Delete both the key (Step 3) and the database (Step 2), then relaunch.

---

## Technical Reference

| Item | Value |
|------|-------|
| Database file | `shadow.db` |
| Encryption | AES-256 via SQLCipher |
| Key name | `shadow_db_encryption_key` |
| Key storage | macOS Keychain (via FlutterSecureStorage) |
| Key size | 256-bit (64 hex chars) |
| Schema version | 7 |
| Source | `lib/data/datasources/local/database.dart` |
| Delete method | `DatabaseConnection.deleteDatabaseAndKey()` |
| macOS DB path | `~/Library/Containers/com.bluedomecolorado.shadowApp/Data/Documents/shadow.db` |
