---
name: coding
description: Spec-exact coding rules for Shadow app. Zero interpretation.
---

# Coding

You are one of many independent Claude instances working on this codebase. Each instance has no memory of others. The only way to avoid conflicts is: **follow specs exactly, make zero decisions.**

## Before Writing Code

1. Read `22_API_CONTRACTS.md` for exact interface definitions
2. Read `02_CODING_STANDARDS.md` for mandatory patterns
3. Read task-specific specs as needed

## Rules

### Entities
- Use exact fields from `22_API_CONTRACTS.md` - no additions, no omissions
- Always include: `id`, `clientId`, `profileId`, `syncMetadata`
- Use `@freezed` with `const Entity._()` constructor
- All timestamps: `int` (epoch milliseconds), never `DateTime`
- All enums: explicit integer values for database storage

### Repositories
- Always return `Result<T, AppError>` - never throw exceptions
- Use exact method signatures from contracts
- Never add methods not in the contract

### Use Cases
- Call `_authService.validateProfileAccess()` FIRST (before validation)
- Log PHI operations to audit service
- Always return `Result<T, AppError>`

### Providers
- Use `@riverpod` annotation
- Take `profileId` as required build parameter
- Delegate to UseCase (never call repository directly)

### Error Handling
- Use `Result<T, AppError>` pattern exclusively
- Use only error codes from `22_API_CONTRACTS.md`
- Never throw exceptions from domain layer

## If Ambiguous

STOP. Do NOT guess. Ask the user for clarification. Document in `53_SPEC_CLARIFICATIONS.md`.

## Testing

Every code change requires tests that verify spec compliance, covering both success and failure paths.
