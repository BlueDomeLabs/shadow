---
name: launch-shadow
description: Regenerate code and launch Shadow app on macOS. Use after factory reset, flutter clean, or any time generated code is missing.
user_invocable: true
---

# Launch Shadow

Regenerate all Drift/freezed/Riverpod code and launch the Shadow app on macOS.
Run this after `/factory-reset`, `flutter clean`, or whenever the app won't build due to missing `.g.dart` / `.freezed.dart` files.

**Project location:** `/Users/reidbarcus/Development/Shadow`

## Launch Procedure (4 Steps)

Execute from the project directory `/Users/reidbarcus/Development/Shadow`.

### Step 1: Ensure dependencies are installed

```bash
cd /Users/reidbarcus/Development/Shadow
flutter pub get
```

If this was already done (e.g., during factory reset), it completes instantly.

### Step 2: Regenerate all generated code

```bash
cd /Users/reidbarcus/Development/Shadow
dart run build_runner build --delete-conflicting-outputs
```

This regenerates:
- `database.g.dart` (Drift schema, ~874KB)
- All DAO `.g.dart` files (Drift queries)
- All entity `.freezed.dart` files (immutable models)
- All entity `.g.dart` files (JSON serialization)
- All provider `.g.dart` files (Riverpod code generation)

Expected: ~939 outputs written. Takes ~60-90 seconds.

### Step 3: Run the Flutter analyzer

```bash
cd /Users/reidbarcus/Development/Shadow
flutter analyze
```

Verify "No issues found!" before launching. If there are issues, fix them first.

### Step 4: Launch the app

```bash
cd /Users/reidbarcus/Development/Shadow
flutter run -d macos
```

Launch as a **background task** so the conversation can continue while the app builds and runs.

## Expected Behavior After Launch

- If launching after factory reset: Welcome screen, no profiles, no cached data
- If launching normally: Previous state restored from SQLCipher database
- Console should show `[Shadow DB]` diagnostic lines confirming:
  - Database path
  - Whether DB file existed
  - Whether encryption key is new or existing
  - Foreign keys enabled
  - Tables created (if fresh DB)

## Troubleshooting

If the app fails to build after code generation:
1. Check `flutter analyze` output for errors
2. Try `flutter clean && flutter pub get` then re-run from Step 2
3. If Drift schema errors: check that table definitions match `10_DATABASE_SCHEMA.md`

If the app launches but all queries fail:
1. Check console for `[Shadow DB]` lines — they show the real error
2. If "SQLCipher key mismatch": run `/factory-reset` to clear the old DB and key
3. If tables missing: ensure Step 2 completed without errors
