---
name: spec-review
description: Audit spec documents against Coding Standards. No agents - do this yourself.
---

# Spec Review

Audit specification documents against `02_CODING_STANDARDS.md` to ensure specs are consistent and compliant.

## When to Use

- Before major implementation phases
- After coding standards updates
- When spec drift is suspected

## Process

Work through these checks yourself, sequentially:

### 1. Entity Specifications (22_API_CONTRACTS.md)
For each entity, verify:
- Required fields: `id`, `clientId`, `profileId`, `syncMetadata`
- All timestamps are `int` (epoch milliseconds)
- All enums have explicit integer values
- Uses `@Freezed` annotation correctly
- Field naming is camelCase
- Optional fields use nullable types

### 2. Repository Specifications
For each repository, verify:
- All methods return `Result<T, AppError>`
- Has standard CRUD methods
- Has sync methods (`getModifiedSince`, `getPendingSync`)
- No raw exceptions in signatures

### 3. Use Case Specifications
For each use case, verify:
- Authorization check is FIRST
- Input classes use `@freezed`
- Returns `Result<T, AppError>`
- ID generation uses `Uuid().v4()` in use case

### 4. Error Handling
- All error codes from approved `AppError` hierarchy
- Error messages use localization keys
- No generic `catch (e)` without specific handling

### 5. Cross-Cutting
- File naming matches class naming (snake_case / PascalCase)
- Layer dependencies correct (presentation -> domain -> data)
- Test files match implementation naming

## Output

Report violations sorted by severity (Critical > High > Medium > Low).
For each violation: location, what's wrong, what it should be.

Report all findings directly to Reid. The Architect will review
and determine which items require action before implementation
proceeds.
