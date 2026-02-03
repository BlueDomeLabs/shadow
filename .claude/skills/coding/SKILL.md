---
name: coding
description: Production coding standards for Shadow app. Every code change requires tests. Verify your work before reporting complete.
---

# Shadow App Coding Skill

## Critical Understanding: Stateless Multi-Agent Development

**YOU ARE ONE OF 1000+ INDEPENDENT INSTANCES** working on this codebase. Each instance:
- Has NO memory of what other instances decided
- Has NO memory of previous conversations after compaction
- Works on a small piece of a collective whole
- Must produce code IDENTICAL to what any other instance would produce

### The Core Problem

When multiple Claude instances work independently on different parts of the same codebase, conflicts arise because:
1. Each instance makes micro-decisions (variable names, patterns, approaches)
2. These decisions compound into incompatibilities
3. Downstream troubleshooting is nearly impossible because instances contradict each other
4. Too many choices leads to divergent implementations

### The Solution: Zero Interpretation

**The specification must be so tight that you have NO CHOICE on how to create the code.**

Every decision has already been made in the specification documents. Your job is NOT to:
- Interpret requirements
- Make design decisions
- Choose between alternatives
- Add improvements or optimizations not specified

Your job IS to:
- Follow the exact patterns in the specifications
- Use the exact names, types, and structures defined
- Implement ONLY what is specified, EXACTLY as specified
- Ask for clarification if something is ambiguous (do NOT guess)

### Before Writing ANY Code

1. **Read the relevant specification documents:**
   - `02_CODING_STANDARDS.md` - Mandatory patterns
   - `22_API_CONTRACTS.md` - Exact interface definitions
   - `10_DATABASE_SCHEMA.md` - Database structure
   - Feature-specific docs as needed

2. **Verify your understanding matches the spec exactly:**
   - Entity fields match API contracts exactly
   - Method signatures match repository contracts exactly
   - Error handling uses Result<T, AppError> exactly as shown
   - Naming follows 07_NAMING_CONVENTIONS.md exactly

3. **If ANYTHING is ambiguous:**
   - STOP and ask for clarification
   - Do NOT make assumptions
   - Do NOT "fill in the gaps" with reasonable defaults
   - The specification should be updated, not bypassed

### Code Production Rules

1. **Entity Creation:**
   ```dart
   // ALWAYS use exact fields from 22_API_CONTRACTS.md
   // ALWAYS include: id, clientId, profileId, syncMetadata
   // ALWAYS use @freezed with const Entity._() constructor
   // NEVER add fields not in the contract
   // NEVER omit fields that are in the contract
   ```

2. **Repository Methods:**
   ```dart
   // ALWAYS return Result<T, AppError>
   // ALWAYS use exact method signatures from contracts
   // NEVER throw exceptions
   // NEVER add methods not in the contract
   ```

3. **Use Cases:**
   ```dart
   // ALWAYS call _authService.validateProfileAccess() first
   // ALWAYS log PHI operations to audit service
   // ALWAYS return Result<T, AppError>
   // NEVER bypass authorization
   ```

4. **Providers:**
   ```dart
   // ALWAYS use @riverpod annotation
   // ALWAYS take profileId as required build parameter
   // ALWAYS delegate to UseCase (never call repository directly)
   // NEVER add business logic in providers
   ```

5. **Timestamps:**
   ```dart
   // ALWAYS store as int (epoch milliseconds)
   // NEVER use DateTime in entities
   // ONLY convert to DateTime for display formatting
   ```

6. **Error Handling:**
   ```dart
   // ALWAYS use Result<T, AppError> pattern
   // ALWAYS use error codes from 22_API_CONTRACTS.md
   // NEVER throw exceptions from domain layer
   // NEVER create new error codes not in the contract
   ```

### Verification Checklist

Before completing any code task, verify:

- [ ] All entity fields match 22_API_CONTRACTS.md exactly
- [ ] All method signatures match contracts exactly
- [ ] All error codes are from the defined set
- [ ] All naming follows 07_NAMING_CONVENTIONS.md
- [ ] No DateTime objects in entities (only int epoch)
- [ ] No exceptions thrown (only Result returns)
- [ ] clientId present on all health data entities
- [ ] profileId filtering applied to all queries
- [ ] Authorization checked before data access
- [ ] Tests cover success AND failure paths

### If You Encounter Ambiguity

DO NOT PROCEED. Instead:

1. Document the ambiguity clearly
2. Reference the specific spec section that is unclear
3. Propose 2-3 possible interpretations
4. Ask which interpretation is correct
5. Request the specification be updated

**An ambiguity in the spec is a BUG in the spec, not an opportunity for creativity.**

### Why This Matters

Every time an instance makes an independent decision:
- Another instance will make a DIFFERENT decision
- The code will be incompatible
- Fixing requires understanding ALL decisions made
- But instances have no memory of other instances' decisions
- Therefore, fixing is nearly impossible

**The only solution is: NO DECISIONS. Only specification execution.**

---

## Testing Requirements

Every code change requires tests that verify the implementation matches the specification exactly. Tests are not optional - they are proof that you followed the spec.

```dart
// Test entity matches contract
test('Supplement entity has all required fields', () {
  // Verify against 22_API_CONTRACTS.md Section 10.x
});

// Test repository returns Result
test('repository returns Result not throws', () {
  // Verify no exceptions, only Result<T, AppError>
});

// Test authorization is checked
test('use case validates profile access', () {
  // Verify _authService.validateProfileAccess() called
});
```

---

## Reference Documents (In Priority Order)

1. `22_API_CONTRACTS.md` - **Canonical source for all interfaces**
2. `02_CODING_STANDARDS.md` - **Mandatory patterns and practices**
3. `10_DATABASE_SCHEMA.md` - **Database structure and migrations**
4. `07_NAMING_CONVENTIONS.md` - **Exact naming rules**
5. `16_ERROR_HANDLING.md` - **Error types and handling patterns**
6. Feature-specific documents as needed

When documents conflict, higher priority wins. Report conflicts as spec bugs.
