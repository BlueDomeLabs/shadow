---
name: factory-reset
description: Clear all Shadow app data before testing major features. Prevents false positives from cached data.
user_invocable: true
---

# Factory Reset

Complete cleanup of database, cache, secure storage, and preferences for fresh testing.
Only use for development/testing purposes.

**Project location:** `/Users/reidbarcus/Development/Shadow`
**Bundle ID:** `com.bluedomecolorado.shadowApp`

## Storage Locations to Clear

1. SQLCipher database (in app container)
2. SharedPreferences / NSUserDefaults (MULTIPLE locations!)
3. FlutterSecureStorage (Keychain) — OAuth tokens, encryption keys
4. App caches and Application Support
5. Flutter/Dart build and tool caches

**CRITICAL:** SharedPreferences on macOS can be stored in:
- `~/Library/Containers/BUNDLE_ID/Data/Library/Preferences/`
- `~/Library/Preferences/` (main location for SharedPreferences)
- macOS CFPreferences daemon cache (in-memory)

**CRITICAL:** Flutter prefixes ALL SharedPreferences keys with `flutter.` on macOS.

## Full Reset Procedure (10 Steps)

Execute from the project directory `/Users/reidbarcus/Development/Shadow`.

### Step 1: Kill running app instances

```bash
pkill -9 -f "shadow_app" 2>/dev/null || true
pkill -9 -f "com.bluedomecolorado.shadowApp" 2>/dev/null || true
pkill -f flutter 2>/dev/null || true
sleep 1
```

### Step 2: Delete SQLCipher database files

```bash
DB_DIR=~/Library/Containers/com.bluedomecolorado.shadowApp/Data/Documents
rm -f "$DB_DIR/shadow.db" "$DB_DIR/shadow.db-shm" "$DB_DIR/shadow.db-wal"
rm -rf "$DB_DIR"/* 2>/dev/null
```

### Step 3: Delete SharedPreferences (.plist files) — ALL locations

```bash
BUNDLE_ID="com.bluedomecolorado.shadowApp"
CONTAINER=~/Library/Containers/$BUNDLE_ID

# Location 1: App container preferences
rm -f "$CONTAINER/Data/Library/Preferences/$BUNDLE_ID.plist"

# Location 2: Main user preferences (WHERE SHAREDPREFERENCES ACTUALLY STORES DATA)
rm -f ~/Library/Preferences/$BUNDLE_ID.plist

# Location 3: Lowercase bundle ID variant
rm -f ~/Library/Preferences/com.bluedomecolorado.shadowapp.plist

# Location 4: Flutter debug mode and wildcard variants
rm -f ~/Library/Preferences/com.bluedomecolorado*.plist
rm -f ~/Library/Preferences/shadowApp*.plist
rm -f ~/Library/Preferences/shadow_app*.plist

# Location 5: Flutter/Dart plists in container
rm -f "$CONTAINER/Data/Library/Preferences"/flutter*.plist
rm -f "$CONTAINER/Data/Library/Preferences"/dart*.plist

# Flush macOS defaults cache for both bundle ID variants
defaults delete "$BUNDLE_ID" 2>/dev/null || true
defaults delete "com.bluedomecolorado.shadowapp" 2>/dev/null || true
```

### Step 4: Delete Keychain items (FlutterSecureStorage)

Delete ALL entries under flutter_secure_storage_service (brute force - keeps deleting until none remain):

```bash
# flutter_secure_storage stores all keys under service name "flutter_secure_storage_service"
# Delete ALL entries (not just known keys) to ensure complete cleanup
SERVICES=("flutter_secure_storage_service" "com.bluedomecolorado.shadowApp" "shadowApp")

for service in "${SERVICES[@]}"; do
    # Keep deleting until no more entries exist for this service
    while security delete-generic-password -s "$service" 2>/dev/null; do
        true
    done
done
```

### Step 5: Clear app caches

```bash
CONTAINER=~/Library/Containers/com.bluedomecolorado.shadowApp

# Container caches
rm -rf "$CONTAINER/Data/Library/Caches"/* 2>/dev/null

# Container Application Support
rm -rf "$CONTAINER/Data/Library/Application Support"/* 2>/dev/null

# Non-sandboxed Application Support (macOS debug builds store DB here)
rm -rf ~/Library/Application\ Support/com.bluedomecolorado.shadowApp 2>/dev/null

# User-level caches
rm -rf ~/Library/Caches/com.bluedomecolorado.shadowApp 2>/dev/null
```

### Step 6: Flutter clean

```bash
cd /Users/reidbarcus/Development/Shadow
flutter clean
```

### Step 7: Clear Dart/Flutter tool caches

```bash
rm -rf ~/.flutter-devtools 2>/dev/null
rm -rf ~/Library/Caches/io.flutter.* 2>/dev/null
rm -rf /Users/reidbarcus/Development/Shadow/.dart_tool 2>/dev/null
rm -f /Users/reidbarcus/Development/Shadow/.packages 2>/dev/null
```

### Step 8: Kill cfprefsd to flush preferences cache

macOS `cfprefsd` caches preferences in memory. Killing it forces a re-read from disk. macOS automatically restarts it.

```bash
killall cfprefsd 2>/dev/null || true
sleep 1
```

### Step 9: Reinstall dependencies

```bash
cd /Users/reidbarcus/Development/Shadow
rm -rf ios/Pods/ macos/Pods/
rm -f pubspec.lock
flutter pub get
cd macos && pod install && cd ..
```

### Step 10: Verify clean state

```bash
BUNDLE_ID="com.bluedomecolorado.shadowApp"

# Verify database deleted
ls ~/Library/Containers/$BUNDLE_ID/Data/Documents/shadow.db 2>/dev/null && echo "FAIL: Database still exists" || echo "OK: Database deleted"

# Verify preferences deleted
ls ~/Library/Preferences/$BUNDLE_ID.plist 2>/dev/null && echo "FAIL: User prefs still exist" || echo "OK: User prefs deleted"

# Verify no Flutter-prefixed keys remain in macOS defaults
if defaults read "$BUNDLE_ID" 2>/dev/null | grep -q "flutter\."; then
    echo "FAIL: Flutter keys still in defaults"
    defaults read "$BUNDLE_ID" 2>/dev/null | grep "flutter\."
else
    echo "OK: No Flutter keys in defaults"
fi

# Check critical sync keys specifically
defaults read "$BUNDLE_ID" "flutter.last_sync_timestamp" 2>/dev/null && echo "FAIL: last_sync_timestamp exists" || echo "OK: last_sync_timestamp cleared"
defaults read "$BUNDLE_ID" "flutter.sync_cloud_provider" 2>/dev/null && echo "FAIL: sync_cloud_provider exists" || echo "OK: sync_cloud_provider cleared"
defaults read "$BUNDLE_ID" "flutter.cloud_user_identifier" 2>/dev/null && echo "FAIL: cloud_user_identifier exists" || echo "OK: cloud_user_identifier cleared"

# Verify NO keychain entries remain for flutter_secure_storage
if security find-generic-password -s "flutter_secure_storage_service" 2>/dev/null; then
    echo "FAIL: Keychain entries still exist for flutter_secure_storage_service"
else
    echo "OK: All Keychain entries cleared"
fi
```

## Expected Behavior After Reset

1. Launch app with: `flutter run -d macos --dart-define=GOOGLE_OAUTH_CLIENT_ID=...`
2. App should show:
   - Welcome screen (no existing auth)
   - No profiles
   - Cloud Sync settings: "Cloud Sync Not Set Up"
   - NO "Last synced: X ago" message
   - CloudProvider.none
3. If you still see "Synced" or "Last synced: X ago" after reset:
   - Try rebooting your Mac (clears all memory caches)
   - Manually delete: `rm ~/Library/Preferences/com.bluedomecolorado.shadowApp.plist`
   - Run: `defaults delete com.bluedomecolorado.shadowApp`

**iOS:** App data must be deleted manually from the device:
Settings > General > iPhone Storage > Shadow App > Delete App

## Known Issues After Reset

### Google Drive still connected after reset
**Fixed (2026-02-18):** FlutterSecureStorage on macOS defaults to the Data Protection Keychain
(`kSecUseDataProtectionKeychain: true`) which the `security` CLI cannot access. The app was
changed to use `useDataProtectionKeyChain: false` (legacy keychain) in:
- `lib/core/bootstrap.dart` (EncryptionService storage)
- `lib/data/cloud/google_drive_provider.dart` (OAuth token storage)

This matches the database code (`lib/data/datasources/local/database.dart`) which already
used the legacy keychain. After this fix, Step 4's `security delete-generic-password` loop
properly clears all tokens.

### Black screen / Keychain error -34018
If the app shows a black screen and the console shows `PlatformException(Unexpected security result code, Code: -34018)`, the Keychain entitlement was lost. Verify both entitlements files contain:

```xml
<key>keychain-access-groups</key>
<array>
    <string>$(AppIdentifierPrefix)com.bluedomecolorado.shadowApp</string>
</array>
```

Check: `macos/Runner/DebugProfile.entitlements` and `macos/Runner/Release.entitlements`

## Why This Matters

Old data causes false positives. If you see:
- "Synced X days ago" → old sync data in SharedPreferences
- Auto sign-in → cached OAuth tokens in Keychain
- Old profile data → SQLCipher database not cleared
- Settings persisting → cfprefsd caching preferences in memory

Do a factory reset before claiming a feature works.
