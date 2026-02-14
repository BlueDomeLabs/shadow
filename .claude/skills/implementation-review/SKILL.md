---
name: implementation-review
description: Verify code matches specs exactly. No agents - do this yourself.
---

# Implementation Review

Compare implementations against `22_API_CONTRACTS.md`. Code must EXACTLY match specs.

## When to Use

- After completing implementation work
- When deviations are suspected
- Before releases

## Process

Work through these checks yourself, sequentially:

### 1. Entity Implementations
Compare each entity in `lib/domain/entities/` against `22_API_CONTRACTS.md`:
- Field names match exactly (including casing)
- Field types match exactly
- Required vs optional matches
- Annotations correct
- Default values match

### 2. Repository Implementations
Compare `lib/domain/repositories/` and `lib/data/repositories/` against contracts:
- Method names match exactly
- Method signatures match (parameters, types, return types)
- Returns `Result<T, AppError>` (never throws)

### 3. Use Case Implementations
Compare `lib/domain/usecases/` against contracts:
- Input class fields match
- Authorization check is FIRST
- Validation logic matches spec
- Return types match

### 4. DAO Implementations
Compare `lib/data/datasources/local/daos/` against `10_DATABASE_SCHEMA.md`:
- Table columns match
- All 9 sync metadata columns present
- CRUD methods wrap in `Result<T, AppError>`

## Deviation Handling

For each deviation found:

| Situation | Action |
|-----------|--------|
| Code violates coding standards | **Fix code** to match spec |
| Code is objectively better AND standards-compliant | **Update spec** to match code |
| Unclear which is correct | **Ask user** for decision |

## After Review

1. Run `flutter test` and `flutter analyze`
2. Save report to `.claude/audit-reports/YYYY-MM-DD-implementation-review.md`
