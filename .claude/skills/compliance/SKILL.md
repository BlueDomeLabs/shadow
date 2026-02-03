---
name: compliance
description: MANDATORY pre-completion checklist. Run before claiming any work is done to verify spec compliance, tests pass, and status file is updated.
---

# Shadow Compliance Verification Skill

## MANDATORY: Run Before Claiming Work Complete

**Never tell the user work is complete without running this checklist.**

---

## Pre-Completion Checklist

### 1. Run All Tests

```bash
flutter test
```

**Expected:** All tests passing

If tests fail:
- Fix the code (if code violates spec)
- Fix the test (if test is wrong - verify against spec first)
- Do NOT claim complete with failing tests

---

### 2. Run Static Analysis

```bash
flutter analyze
```

**Expected:** No issues found

If issues found:
- Fix all errors
- Fix all warnings
- Infos are acceptable but prefer to fix

---

### 3. Verify Code Formatting

```bash
dart format --set-exit-if-changed lib/
```

**Expected:** Exit code 0 (already formatted)

If files changed:
- Review the formatting changes
- Commit the formatted code

---

### 4. Entity Field Verification

Open `22_API_CONTRACTS.md` and compare your entity:

```
□ All fields from contract present
□ No extra fields added
□ Field types match exactly
□ Field names match exactly
□ Required fields marked as required
□ Optional fields marked as nullable
□ id field present (String)
□ clientId field present (String)
□ profileId field present (String) - unless entity-level exception
□ syncMetadata field present (SyncMetadata)
```

---

### 5. Repository Method Verification

Compare your repository against `22_API_CONTRACTS.md`:

```
□ All methods from contract implemented
□ No extra methods added
□ Method names match exactly
□ Parameter types match exactly
□ Return type is Result<T, AppError>
□ No exceptions thrown (only Result returns)
```

---

### 6. Timestamp Verification

```
□ All timestamps stored as int (epoch milliseconds)
□ No DateTime objects in entity fields
□ DateTime only used for display formatting
□ Conversions use proper utility functions
```

---

### 7. Error Code Verification

Check all AppError usages:

```
□ All error codes from approved list in 22_API_CONTRACTS.md
□ No custom error codes invented
□ Error messages are localization keys
□ Recovery actions specified where applicable
```

---

### 8. Test Coverage Verification

```
□ Tests exist for success paths
□ Tests exist for failure paths
□ Tests verify spec compliance (not just "it works")
□ Authorization tests verify profile access checked
□ Edge cases from spec are tested
```

---

### 9. Authorization Verification

If the code accesses health data:

```
□ UseCase calls _authService.validateProfileAccess() first
□ Repository queries filter by profileId
□ PHI operations logged to audit service
□ No data leakage between profiles possible
```

---

### 10. Update Work Status File

Update `.claude/work-status/current.json`:

```json
{
  "lastInstanceId": "<your-instance-id>",
  "lastAction": "completed",
  "taskId": "SHADOW-XXX",
  "status": "complete",
  "timestamp": "<current-iso-timestamp>",
  "filesModified": [
    "lib/domain/entities/your_entity.dart",
    "lib/domain/repositories/your_repository.dart",
    "test/domain/entities/your_entity_test.dart"
  ],
  "testsStatus": "passing",
  "complianceStatus": "verified",
  "notes": "Completed [description]. Verified against 22_API_CONTRACTS.md Section X. All tests passing. Next: [suggestion for next task]."
}
```

---

## Quick Compliance Checklist

```
□ flutter test                    → All passing
□ flutter analyze                 → No issues
□ dart format --set-exit-if-changed lib/ → Exit 0
□ Entity fields match spec EXACTLY
□ Repository methods match spec EXACTLY
□ All timestamps are int (not DateTime)
□ All error codes from approved list
□ Tests cover success AND failure paths
□ Authorization checked where required
□ Status file updated with status="complete"
```

---

## Common Compliance Failures

### Entity has extra field
**Problem:** You added a field not in the contract.
**Fix:** Remove it. Only spec fields allowed.

### Repository throws exception
**Problem:** Code uses `throw` instead of `Result.failure()`.
**Fix:** Replace with `return Result.failure(AppError.xxx(...))`.

### DateTime in entity
**Problem:** Entity field is `DateTime` instead of `int`.
**Fix:** Change to `int` (epoch milliseconds).

### Test doesn't verify spec
**Problem:** Test checks behavior but not spec compliance.
**Fix:** Add assertions that verify exact contract compliance.

### Missing profileId filter
**Problem:** Query doesn't filter by profile.
**Fix:** Add `WHERE profile_id = ?` to query.

### Custom error code
**Problem:** Invented error code not in 22_API_CONTRACTS.md.
**Fix:** Use approved error code from contract.

---

## After Compliance Verification

Once all checks pass:
1. Commit your work to the repository
2. Update the status file
3. You may now tell the user the work is complete

If any check fails:
1. Fix the issue
2. Re-run the failed check
3. Do NOT claim complete until all pass

---

## Automated Compliance Script

If available, also run:

```bash
dart run scripts/verify_spec_compliance.dart
```

**Expected:** `COMPLIANT: 0 errors, 0 warnings`
