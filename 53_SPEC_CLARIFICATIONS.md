# Shadow Specification Clarifications

**Version:** 1.0
**Last Updated:** February 2, 2026
**Purpose:** Track spec ambiguities and their resolutions for instance communication

---

## Purpose

When a Claude instance encounters an ambiguity in the specifications, it documents the ambiguity here. This allows:
1. The user to see what needs clarification
2. Other instances to know what is blocked
3. Resolution to be tracked

---

## Ambiguity Format

```markdown
## AMBIGUITY-YYYY-MM-DD-NNN: [Brief Title]

**Found in:** [Document name and section]
**Found by:** Instance during task [SHADOW-XXX]
**Issue:** [Clear description of the ambiguity]
**Possible interpretations:**
1. [Interpretation 1]
2. [Interpretation 2]
3. [Interpretation 3]

**Blocking:** [Task ID or "None"]
**Status:** AWAITING_CLARIFICATION | RESOLVED
**Resolution:** [If resolved, what was decided]
**Resolution Date:** [Date]
**Spec Updated:** [Yes/No - which document]
```

---

## Active Ambiguities

*None currently*

---

### RESOLVED-2026-02-03-001: BaseRepository Typedef Naming Conflict

**Found in:** 22_API_CONTRACTS.md Section 4.1
**Found by:** Instance during task IMPLEMENT-REPOSITORY-INTERFACES
**Issue:** The spec defined `typedef BaseRepository<T, ID> = EntityRepository<T, ID>` but a class named `BaseRepository<T>` already exists in `lib/core/repositories/base_repository.dart` (helper class with generateId, createSyncMetadata methods). These cannot coexist with the same name.

**Possible interpretations:**
1. Rename the typedef to avoid conflict
2. Rename the existing helper class
3. Move one to a different namespace

**Blocking:** IMPLEMENT-REPOSITORY-INTERFACES
**Status:** RESOLVED
**Resolution:** Renamed typedef from `BaseRepository` to `BaseRepositoryContract` in the spec. The existing helper class in core/repositories keeps its name since it's already in use.
**Resolution Date:** 2026-02-03
**Spec Updated:** Yes - 22_API_CONTRACTS.md Section 4.1

---

## Resolved Ambiguities

### EXAMPLE-2026-02-02-001: Notification Type Count

**Found in:** 01_PRODUCT_SPECIFICATIONS.md, 22_API_CONTRACTS.md, 37_NOTIFICATIONS.md
**Found by:** Audit process
**Issue:** Different documents showed different notification type counts (5, 21, 25)
**Possible interpretations:**
1. Use 5 simple types from database schema
2. Use 21 types from API contracts
3. Use 25 types with full granularity

**Blocking:** SHADOW-038 Notification Service
**Status:** RESOLVED
**Resolution:** Use 25 notification types as defined in 22_API_CONTRACTS.md Section 3.2. All other documents updated to reference this canonical source.
**Resolution Date:** 2026-02-02
**Spec Updated:** Yes - 01_PRODUCT_SPECIFICATIONS.md, 10_DATABASE_SCHEMA.md, 37_NOTIFICATIONS.md all updated to match 22_API_CONTRACTS.md

---

## How to Add a New Ambiguity

1. Create a new section with ID: `AMBIGUITY-{YYYY-MM-DD}-{NNN}`
2. Fill in all fields
3. Update `.claude/work-status/current.json` with blocked status if blocking your work
4. Ask the user for clarification
5. DO NOT proceed with implementation until resolved

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-02-02 | Initial release with resolved notification type example |
