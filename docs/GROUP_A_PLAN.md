# GROUP A — Profile Architecture Implementation Plan
**Prepared by:** Shadow (Claude Code)
**Date:** 2026-03-03
**Status:** PLANNING — awaiting Architect review and approval
**Opening tests:** 3,488 passing

---

## 1. Finding Summary

| Finding | Severity | Current Behavior | Target Behavior |
|---------|----------|-----------------|-----------------|
| AUDIT-01-006 | HIGH | ProfileNotifier reads/writes SharedPreferences directly, bypassing the repository. Domain Profile entity and ProfileRepositoryImpl exist but are unused by the UI. | ProfileNotifier uses profileRepositoryProvider through use cases. All profile reads/writes go through Drift/SQLCipher. SharedPreferences profile writes eliminated. |
| AUDIT-04-002 | MEDIUM | _load(), _save(), addProfile(), updateProfile(), deleteProfile() have no error handling. ProfileState has no error field. Screens call fire-and-forget; persistence failures are silent. | Use cases return Result<T, AppError>. ProfileNotifier handles failures. ProfileState has isLoading and error fields. Users see error messages on failure. |
| AUDIT-05-002 | MEDIUM | Profile JSON (names, IDs) stored in plain SharedPreferences on Android — unencrypted PII on disk. | Profile data stored in Drift/SQLCipher (encrypted at rest). This resolves automatically when AUDIT-01-006 is fixed. |
| AUDIT-CA-001 | HIGH | deleteProfile(id) removes the entry from SharedPreferences only. All health data for that profileId in the Drift DB (supplements, conditions, logs, photos, etc.) is permanently orphaned. No DeleteProfileUseCase exists. | DeleteProfileUseCase soft-deletes all health entity rows with matching profileId in a single DB transaction, then soft-deletes the profile itself. |
| AUDIT-CA-002 | MEDIUM | deleteProfile() makes no call to revoke guest invites. Active guest invites for the deleted profile persist with isRevoked=false. | DeleteProfileUseCase lists all non-revoked guest invites for the profileId and revokes them before deletion. GuestInviteRepository.getByProfile() already exists for this purpose. |
| AUDIT-CA-003 | MEDIUM | FIXED in a prior session — try/catch added to _load(). | Already resolved. No further action needed. |
| AUDIT-CA-004 | MEDIUM | HomeScreen and HomeTab fall back to the hardcoded string 'test-profile-001' when currentProfileId is null. Data tabs return empty results with no recovery path visible. | Replace fallback with a guard: if currentProfileId is null, show "No profile selected" overlay or redirect to ProfilesScreen. Remove 'test-profile-001' from non-test code entirely. |
| AUDIT-CA-005 | LOW | Delete dialog says "This cannot be undone" but does not mention that all health data will be deleted (supplements, conditions, all logs, photos, journal, etc.). | Dialog lists the categories of data that will be permanently deleted. Resolve after AUDIT-CA-001 is implemented. |

**Total Group A open items: 7** (AUDIT-CA-003 is already fixed)

---

## 2. What Already Exists (No Change Needed)

These pieces are complete and correct. The implementation plan builds on them:

| Component | Location | Status |
|-----------|----------|--------|
| Domain Profile entity | lib/domain/entities/profile.dart | Correct — id, clientId, name, birthDate, biologicalSex, ethnicity, notes, ownerId, dietType, syncMetadata |
| ProfileRepository interface | lib/domain/repositories/profile_repository.dart | Correct — getAll, getById, create, update, delete, hardDelete, getByOwner, getDefault |
| ProfileRepositoryImpl | lib/data/repositories/profile_repository_impl.dart | Correct — full implementation with BaseRepository for sync |
| ProfileDao | lib/data/datasources/local/daos/profile_dao.dart | Correct — all CRUD + softDelete + markSynced + getByOwner |
| profiles DB table | lib/data/datasources/local/tables/profiles_table.dart | Correct — in schema v19, all sync columns present |
| SyncEntityAdapter<Profile> | lib/core/bootstrap.dart line 370 | Correct — wired |
| profileRepositoryProvider | lib/presentation/providers/di/di_providers.dart line 206 | Wired in bootstrap (line 451), just throws UnimplementedError when not overridden |
| CreateProfileInput, UpdateProfileInput, DeleteProfileInput | lib/domain/usecases/profiles/profile_inputs.dart | Correct freezed classes exist |
| GuestInviteRepository.getByProfile() | lib/domain/repositories/guest_invite_repository.dart line 24 | Exists and is correct |
| RevokeGuestInviteUseCase | lib/domain/usecases/guest_invites/revoke_guest_invite_use_case.dart | Exists and correct |
| revokeGuestInviteUseCaseProvider | lib/presentation/providers/di/di_providers.dart line 1017 | Wired |
| AddEditProfileScreen _isSaving, _isDirty, PopScope | Confirmed present (AUDIT-06-002 already fixed) | Already resolved |

---

## 3. Exact Gaps (by file and line)

### AUDIT-01-006: ProfileNotifier bypasses repository

**lib/presentation/providers/profile/profile_provider.dart**
- Lines 1–157: The entire file is the problem. It contains a local `Profile` class (duplicate of domain entity), `ProfileState`, and `ProfileNotifier` that uses `SharedPreferences` directly.
- Lines 80–98: `_load()` reads SharedPreferences JSON
- Lines 101–110: `_save()` writes SharedPreferences JSON
- Lines 112–124: `addProfile()` generates UUID and writes to SharedPreferences
- Lines 127–135: `updateProfile()` writes to SharedPreferences
- Lines 138–146: `deleteProfile()` removes from SharedPreferences list only
- Lines 148–151: `setCurrentProfile()` writes to SharedPreferences
- Line 17: local `Profile` class shadows the domain entity — all consumers import THIS, not `lib/domain/entities/profile.dart`

**Schema migration required:** NO — profiles table already exists in schema v19.

**Provider API change required:** YES — but narrow. The public API of `profileProvider` changes:
- `state.profiles` type changes from `List<ui.Profile>` to `List<domain.Profile>`
- `state.currentProfile` type changes from `ui.Profile?` to `domain.Profile?`
- `notifier.addProfile(ui.Profile)` → `notifier.addProfile(CreateProfileInput)`
- `notifier.updateProfile(ui.Profile)` → `notifier.updateProfile(UpdateProfileInput)`
- Field name changes on Profile: `dateOfBirth: DateTime?` → `birthDate: int?` (epoch ms)
- Cascades to: `add_edit_profile_screen.dart`, `profiles_screen.dart` only (field-access screens)
- Does NOT cascade to: `home_screen.dart`, `home_tab.dart`, `main.dart`, `cloud_sync_settings_screen.dart`, `conflict_resolution_screen.dart`, `health_sync_settings_screen.dart` — these only read `currentProfileId` (String) or `currentProfile?.name` (both unchanged)

### AUDIT-CA-001: No cascade delete

**lib/presentation/providers/profile/profile_provider.dart line 138–146:** `deleteProfile()` removes from SharedPreferences list, touches no Drift tables.

**19 Drift tables** have `profile_id` columns with no FK CASCADE:
- supplements, conditions, condition_logs, flare_ups, fluids_entries, sleep_entries, activities, activity_logs, food_items, food_logs, journal_entries, photo_areas, photo_entries, diets, diet_violations, fasting_sessions, imported_vitals, intake_logs, guest_invites

No DAO currently has a `softDeleteByProfile(profileId)` method. None need to be added individually — see Implementation Approach below for the preferred approach.

### AUDIT-CA-004: Hardcoded sentinel

**lib/presentation/screens/home/home_screen.dart lines 61–62, 103–104:** Four occurrences of `?? 'test-profile-001'`. No guard or redirect when profile is null.

---

## 4. Dependency Graph

```
AUDIT-01-006 ──────────────────────────────────────────► AUDIT-04-002 (resolves)
                                                         AUDIT-05-002 (resolves)

AUDIT-01-006 ──(A1: create use cases, migrate notifier)──► A2 can start

AUDIT-CA-001 ──────────────────────────────────────────► AUDIT-CA-002 (must be in same use case)
             ──────────────────────────────────────────► AUDIT-CA-005 (dialog update after impl)

AUDIT-CA-004 ──── independent (can be done in any session once A1 is done)
              └─── depends on A1 having a safe null currentProfileId state
```

**Critical order constraint:** A1 (use cases + notifier migration) MUST complete before A2 (cascade delete). The notifier must be calling the real delete use case before we expand that use case to do cascade work.

**A3 (home screen sentinel) is independent** once A1 is done — the null `currentProfileId` case is safe to handle.

---

## 5. Session Breakdown

### Session A1 — Use Cases + Notifier Migration (1 session)
**Start state:** 3,488 tests passing. Profile in SharedPreferences.
**End state:** All tests passing. Profiles stored in Drift/SQLCipher. Use cases wired. Error handling present.

**What gets built:**
1. `lib/domain/usecases/profiles/create_profile_use_case.dart` — calls `repository.create()`
2. `lib/domain/usecases/profiles/update_profile_use_case.dart` — calls `repository.update()`
3. `lib/domain/usecases/profiles/delete_profile_use_case.dart` (stub only, no cascade yet) — calls `repository.delete()`
4. `lib/domain/usecases/profiles/get_profiles_use_case.dart` — calls `repository.getAll()`
5. Wire all 4 into `di_providers.dart`
6. Rewrite `profile_provider.dart`:
   - Delete local `Profile` class and `ProfileState`
   - New `ProfileState` holds `List<domain.Profile>`, `String? currentProfileId`, `bool isLoading`, `AppError? error`
   - `ProfileNotifier` receives use case providers via Riverpod ref (not raw repo)
   - `_load()` calls `getProfilesUseCase`
   - `addProfile(CreateProfileInput)` calls `createProfileUseCase`
   - `updateProfile(UpdateProfileInput)` calls `updateProfileUseCase`
   - `deleteProfile(String)` calls `deleteProfileUseCase` (stub version)
   - `setCurrentProfile(String)` keeps SharedPreferences (only an ID string, not PII)
   - Delete local `_uuid` and `SharedPreferences` imports for profile data
   - Keep `SharedPreferences` for `currentProfileId` only
7. Update `add_edit_profile_screen.dart`:
   - Import `domain.Profile` instead of `ui.Profile`
   - `widget.profile!` type changes to `domain.Profile`
   - Map `dateOfBirth: DateTime?` ↔ `birthDate: int?` on read/write
   - Change `notifier.addProfile(Profile(...))` → `notifier.addProfile(CreateProfileInput(...))`
   - Change `notifier.updateProfile(profile.copyWith(...))` → `notifier.updateProfile(UpdateProfileInput(...))`
8. Update `profiles_screen.dart`:
   - Import `domain.Profile` instead of `ui.Profile`
   - `profile.dateOfBirth` → `profile.birthDate` in any display logic
   - `notifier.addProfile(Profile(id: '', ...))` → `notifier.addProfile(CreateProfileInput(...))`
9. Fix home_screen.dart sentinel (AUDIT-CA-004):
   - Replace `?? 'test-profile-001'` with a null guard
   - When `currentProfileId == null` and not in guest mode: show "No profile selected" message or redirect to ProfilesScreen
10. Delete data migration (development only): on `_load()`, if DB is empty but SharedPreferences has profiles, migrate them to DB and clear SharedPreferences

**Tests to write/update:**
- New unit tests for `CreateProfileUseCase`, `UpdateProfileUseCase`, `GetProfilesUseCase`, `DeleteProfileUseCase` (stub)
- Update `profiles_screen_test.dart` — currently calls `notifier.addProfile(Profile(id: '', ...))` which will break
- Update `add_edit_profile_screen_test.dart` — field name changes
- Update `profile_dao_test.dart` — likely no changes needed (already tests the DAO directly)

**Risk:** Medium. Many files, but each change is small and bounded. The biggest risk is the `Profile` class rename cascade — must audit ALL import sites. The ProfileNotifier state change is clean since it's a StateNotifier (no change to Riverpod pattern needed).

**Does NOT leave codebase broken:** A stub `DeleteProfileUseCase` (calls `repository.delete()` only, no cascade) is sufficient for A1 — it fixes the architectural bypass. The cascade work is A2.

---

### Session A2 — Cascade Delete + Guest Invite Revocation + Delete Dialog (1 session)
**Start state:** A1 complete. 3,488+ tests passing.
**End state:** All tests passing. Profile deletion cascades to all health data. Guest invites revoked. Delete dialog updated.

**What gets built:**
1. Add a `deleteProfileCascade(String profileId)` transaction method to `AppDatabase` (database.dart):
   - Single Drift `transaction()` block
   - Uses `customUpdate()` to soft-delete 19 entity tables by profileId in one transaction
   - Soft-delete means: set `sync_deleted_at = now`, `sync_is_dirty = 1`, `sync_status = SyncStatus.deleted.value`
   - Tables: supplements, conditions, condition_logs, flare_ups, fluids_entries, sleep_entries, activities, activity_logs, food_items, food_logs, journal_entries, photo_areas, photo_entries, diets, diet_violations, fasting_sessions, imported_vitals, intake_logs, guest_invites
   - Then soft-delete the profile itself (using ProfileDao.softDelete)

2. Expand `DeleteProfileUseCase`:
   - Inject `AppDatabase` (or a new `DeleteProfileCascadeRepository` interface if preferred — see note)
   - Step 1: `guestInviteRepository.getByProfile(profileId)` → revoke all non-revoked invites
   - Step 2: `database.deleteProfileCascade(profileId)` — soft-delete all health data + profile

3. Update `profiles_screen.dart` delete dialog (AUDIT-CA-005):
   - Add explicit list of data categories to be deleted
   - Example: "This will permanently delete all of [profile name]'s data, including supplements, conditions, activity logs, food logs, photos, journal entries, sleep records, and fluids. This cannot be undone."

**Architecture note on `deleteProfileCascade`:** Injecting `AppDatabase` directly into a use case violates the layer boundary rule (domain should not know about the data layer). The cleanest approach: add a `cascadeDeleteProfileData(String profileId)` method to `ProfileRepository` interface, implement it in `ProfileRepositoryImpl` using `_database.deleteProfileCascade()` (or by delegating to the database class). This keeps the use case clean.

**Tests to write:**
- Unit test for `DeleteProfileUseCase` cascade behavior (mock repository + mock guest invite repo)
- Integration test or DAO-level test for `deleteProfileCascade` transaction
- Widget test for the updated delete dialog content

**Risk:** Medium-High. The cascade delete touches a lot of tables but via one transaction method. The guest invite revocation has sequential async steps. Testing needs to verify that all tables are actually cleaned up.

---

### Session A3 (absorbed into A1)
The home screen sentinel fix (AUDIT-CA-004) is simple enough to include in A1. It's 4 line changes in `home_screen.dart`. Including it in A1 ensures the null-currentProfileId state is handled from the moment profiles move to the DB (where loading is async and currentProfileId starts null briefly).

---

## 6. Schema Impact

**No schema migration required.**

The `profiles` table already exists in schema v19 with all necessary columns. Profile data has been in SharedPreferences — we are simply switching the write path to use the existing DB table.

The `currentProfileId` selection will **remain in SharedPreferences** (only this value, not profile data). It is a UUID string with no PII. This avoids a schema v20 migration to add a `current_profile_id` column to `user_settings`. If a schema migration is desired for cleanliness in a future pass, it can be added independently.

**Confirming no v20 migration needed:**
- No new tables
- No new columns on existing tables
- No FK constraints being added (cascade is done in application code)

---

## 7. Risk Assessment

### Highest Risk: `Profile` class replacement

The local `Profile` class in `profile_provider.dart` is imported by:
- `add_edit_profile_screen.dart`
- `profiles_screen.dart`
- Both corresponding test files

After migration, these import the domain `Profile` entity. The field changes are:

| UI Profile field | Domain Profile field | Impact |
|------------------|---------------------|--------|
| `dateOfBirth: DateTime?` | `birthDate: int?` (epoch ms) | `add_edit_profile_screen.dart` must convert; profiles_screen.dart may display this field |
| `createdAt: DateTime` | `syncMetadata.syncCreatedAt: int` | UI doesn't display this — no impact |
| `id: String` | `id: String` | Same |
| `name: String` | `name: String` | Same |
| `notes: String` | `notes: String?` (nullable) | Minor — null-safe access needed |
| n/a | `clientId: String` | Required field — must provide UUID on create |
| n/a | `ownerId: String?` | Optional — leave null (local-only app, no user accounts) |
| n/a | `biologicalSex, dietType, ethnicity, dietDescription` | Default values on create; not shown in current form |

**Mitigation:** These are all bounded changes in 2 files. Dart type system will catch mismatches at compile time. All tests must pass before commit.

### Second Risk: ProfileNotifier async loading gap

After migration, `_load()` calls the repository (async DB read). Between app start and `_load()` completing, `state.profiles` is an empty list. This is the same behavior as today (SharedPreferences read is also async). `main.dart` shows `WelcomeScreen` when `state.profiles.isEmpty`, which is correct.

**Critical:** `home_screen.dart` currently falls back to 'test-profile-001' when `currentProfileId == null`. After A1, this fallback is removed. If a user navigates directly to HomeScreen while profiles are still loading, they'll briefly see the null guard state. This is acceptable and correct behavior — we show a loading indicator.

**Mitigation:** The home_screen sentinel fix in A1 must handle the loading case explicitly. Show a loading spinner while `state.isLoading == true`, show the "No profile" state when `!isLoading && currentProfileId == null`.

### Third Risk: Cascade delete transaction correctness

The `deleteProfileCascade` method soft-deletes 19 tables in a transaction. If any table name is misspelled or any column name is wrong, the transaction fails. This must be tested.

**Mitigation:** Write an integration test (in-memory Drift database) that creates a profile with data in several tables, calls `deleteProfileCascade`, and verifies all rows have `sync_deleted_at` set. Use the existing in-memory DB test pattern from `profile_dao_test.dart`.

### Fourth Risk: Existing SharedPreferences data loss

During development, engineers and testers may have profiles in SharedPreferences. After migration, `_load()` reads from the DB (which will be empty). All test data appears gone.

**Mitigation:** Implement a one-time migration in `_load()`: if DB returns empty profiles AND SharedPreferences has profile JSON, migrate to DB and clear SharedPreferences. This preserves dev/test continuity. This migration code can be removed in a future cleanup pass.

---

## 8. What Does NOT Need to Change

These files read `profileProvider` but only access `currentProfileId` (a String) or `currentProfile?.name` — both fields exist in the new state with the same types:

| File | Access pattern | Change needed? |
|------|---------------|----------------|
| `lib/main.dart` | `state.profiles.isEmpty` | NO — still `List<domain.Profile>` |
| `lib/presentation/screens/home/home_screen.dart` | `state.currentProfileId` | Only sentinel fix (AUDIT-CA-004) |
| `lib/presentation/screens/home/tabs/home_tab.dart` | `state.currentProfile?.name` | NO |
| `lib/presentation/screens/cloud_sync/cloud_sync_settings_screen.dart` | `state.currentProfileId` | NO |
| `lib/presentation/screens/cloud_sync/conflict_resolution_screen.dart` | `state.currentProfileId` | NO |
| `lib/presentation/screens/health/health_sync_settings_screen.dart` | `state.currentProfileId` | NO |

The entire data layer below `ProfileRepositoryImpl` is already correct. The sync adapter in `bootstrap.dart` is already correct. No changes needed to:
- `lib/data/datasources/local/daos/profile_dao.dart`
- `lib/data/repositories/profile_repository_impl.dart`
- `lib/domain/entities/profile.dart`
- `lib/domain/repositories/profile_repository.dart`
- `lib/core/bootstrap.dart` (profile repo wiring is already correct)
- Any of the 19 entity DAOs (no bulk-delete methods needed — cascade is done via transaction in database.dart)

---

## 9. Open Question for the Architect

**Q1 — `ownerId` strategy:** The domain `Profile` has an `ownerId: String?` field (FK to user_accounts). Currently there are no user accounts. When creating profiles via `CreateProfileUseCase`, should `ownerId` be:
- (a) `null` — since there's no auth system yet
- (b) a fixed device ID string — to enable per-device filtering in the future
- (c) a placeholder constant

The `ProfileDao.getAll()` method (no ownerId filter) is what we'd use to load all profiles. `getByOwner()` could be used in a future session once user accounts are introduced.

**My recommendation:** `ownerId = null` for now. `getAll()` for loading. Document in code that `ownerId` is populated in Phase 3 (cloud sync / user accounts).

**Q2 — `currentProfileId` persistence:** Plan is to keep `currentProfileId` in SharedPreferences (just a UUID string, not PII). Is this acceptable, or should it move to the `user_settings` DB table (requires schema v20)?

**My recommendation:** Keep in SharedPreferences. The ID itself has zero PII. A future cleanup could add a `current_profile_id` column to `user_settings` and remove this SharedPreferences usage.

**Q3 — Dev data migration:** Implement the one-time SharedPreferences→DB migration for existing dev profiles, or just let existing dev data reset? Since this is pre-launch, a reset is operationally fine. But if any team member has meaningful test data in SharedPreferences profiles, migration is preferred.

**My recommendation:** Implement the one-time migration — it's ~20 lines and prevents confusion during development.

---

## 10. Estimated File Change Count Per Session

### Session A1 (files to create or modify)
| File | Action |
|------|--------|
| lib/domain/usecases/profiles/create_profile_use_case.dart | CREATE |
| lib/domain/usecases/profiles/update_profile_use_case.dart | CREATE |
| lib/domain/usecases/profiles/delete_profile_use_case.dart | CREATE (stub) |
| lib/domain/usecases/profiles/get_profiles_use_case.dart | CREATE |
| lib/presentation/providers/di/di_providers.dart | MODIFY (add 4 providers) |
| lib/presentation/providers/profile/profile_provider.dart | REWRITE |
| lib/presentation/screens/profiles/add_edit_profile_screen.dart | MODIFY (field mapping + use case calls) |
| lib/presentation/screens/profiles/profiles_screen.dart | MODIFY (domain Profile fields + notifier API) |
| lib/presentation/screens/home/home_screen.dart | MODIFY (sentinel removal) |
| test/presentation/screens/profiles/profiles_screen_test.dart | MODIFY (notifier API change) |
| test/presentation/screens/profiles/add_edit_profile_screen_test.dart | MODIFY (field names) |
| test/unit/domain/usecases/profiles/ (new) | CREATE (4 use case tests) |

### Session A2 (files to create or modify)
| File | Action |
|------|--------|
| lib/data/datasources/local/database.dart | MODIFY (add deleteProfileCascade transaction) |
| lib/domain/repositories/profile_repository.dart | MODIFY (add cascadeDeleteProfileData method) |
| lib/data/repositories/profile_repository_impl.dart | MODIFY (implement cascadeDeleteProfileData) |
| lib/domain/usecases/profiles/delete_profile_use_case.dart | MODIFY (full cascade implementation) |
| lib/presentation/screens/profiles/profiles_screen.dart | MODIFY (delete dialog text update) |
| test/unit/data/datasources/local/daos/profile_dao_test.dart | MODIFY or add cascade test |
| test/unit/domain/usecases/profiles/delete_profile_use_case_test.dart | MODIFY (add cascade + invite revocation tests) |

---

## 11. Summary

This is a two-session change:

**A1** migrates the profile system from SharedPreferences to Drift/SQLCipher through proper use cases. It changes one provider file, two screen files, and adds four use case files. The Riverpod pattern stays the same (StateNotifier). The data layer is already ready.

**A2** adds cascade deletion — the most complex part. It adds a single database transaction method to AppDatabase that soft-deletes all health data for a profile in one atomic operation. The use case then calls this method and revokes guest invites.

Together these 2 sessions resolve 7 open audit findings (AUDIT-01-006, AUDIT-04-002, AUDIT-05-002, AUDIT-CA-001, AUDIT-CA-002, AUDIT-CA-004, AUDIT-CA-005) and fix a significant data safety issue.
