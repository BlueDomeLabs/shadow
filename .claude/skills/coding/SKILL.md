---
name: coding
description: Production coding standards for Shadow app. Every code change requires tests. Verify your work before reporting complete.
license: Internal use
---

# Shadow Coding Standards

## The 3 Rules

1. **Every code change needs a test** - No exceptions
2. **Verify before reporting complete** - Run tests, check the app
3. **Be honest about failures** - Report problems, don't hide them

---

## Rule 1: Tests With Every Change

| You Write | You Also Write |
|-----------|----------------|
| New class | New test file |
| New method | New test cases |
| Bug fix | Regression test that catches the bug |
| Modified method | Updated tests + new edge cases |

**No code is complete without tests.**

```bash
# Run before claiming done
flutter test
```

---

## Rule 2: Verify Before Reporting Complete

Before saying "done":

1. **Run tests** - `flutter test` must pass
2. **Run the app** - Verify behavior manually
3. **Check the actual files** - Tests exist, code is there

**Never claim tests pass without running them.**
**Never claim a feature works without trying it.**

### Factory Reset for Major Features

```bash
# Clear app data before testing new features
rm -rf ~/Library/Application\ Support/com.example.shadow/
flutter clean && flutter pub get
flutter run -d macos
```

---

## Rule 3: Be Honest About Failures

**Good reporting:**
- "15 tests pass, 2 fail with timeout issues"
- "Core implementation complete, edge case X needs attention"
- "Build fails with error: [actual error]"

**Bad reporting:**
- "All tests pass" (when you didn't run them)
- "Implementation complete" (when you haven't verified)
- "Fixed the bug" (when it's worked around)

---

## Code Standards (Quick Reference)

### Naming

| Type | Convention | Example |
|------|------------|---------|
| Variables | camelCase | `firstName`, `isLoading` |
| Classes | PascalCase | `ProfileRepository`, `SyncService` |
| Files | snake_case | `profile_repository.dart` |
| Database | snake_case | `user_profiles`, `sync_status` |

### Methods

| Pattern | Returns | If Not Found |
|---------|---------|--------------|
| `getProfile(id)` | `Profile` | **THROWS** |
| `findProfile(id)` | `Profile?` | Returns **null** |
| `getAllProfiles()` | `List<Profile>` | Returns **empty list** |

### Critical Checks

Before committing:

- [ ] No force unwrap `!` without null checks
- [ ] Images have `cacheWidth`/`cacheHeight`
- [ ] Icons have `semanticLabel`
- [ ] Queries filter `sync_deleted_at IS NULL`
- [ ] List methods have `limit`/`offset` params
- [ ] DateFormat uses locale
- [ ] No hardcoded secrets

---

## Test Naming Pattern

```dart
// Pattern: methodName_state_expected
test('getProfile_existingId_returnsProfile', () { });
test('getProfile_missingId_throwsNotFound', () { });
test('addProfile_validData_insertsAndMarksDirty', () { });
```

---

## Definition of Done

A task is done when:

- [ ] Code compiles without warnings
- [ ] Tests written and passing
- [ ] No regressions in existing tests

---

## API Contracts

All code must follow the exact signatures in `22_API_CONTRACTS.md`. If a method isn't defined there, ask before implementing.

Result type pattern:
```dart
Future<Result<Profile, AppError>> getProfile(String id);
```

Error codes must use constants from the contracts - no ad-hoc strings.

---

## When Stuck

1. Read the spec documents (01-34 in /Development/Shadow/)
2. Check `22_API_CONTRACTS.md` for exact method signatures
3. Check `25_DEFINITION_OF_DONE.md` for completion criteria
4. Ask the user before making assumptions
