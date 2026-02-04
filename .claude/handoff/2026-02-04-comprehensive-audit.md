# Handoff Document: Comprehensive Audit Task

**Created:** 2026-02-04
**From Instance:** data-layer-019
**For:** Next Claude Instance

---

## PRIORITY TASK FOR NEXT SESSION

**Run a comprehensive audit of the entire Shadow project.**

This audit was triggered because a previous Claude instance was found to have deviated from specifications. We need to verify:
1. Coding Standards are at Apple/Google quality level
2. All specs comply with Coding Standards
3. All implementations EXACTLY match specs

---

## WHAT HAPPENED THIS SESSION

1. **Discovered spec deviations** in Supplement use cases:
   - `CreateSupplementInput` had `@Default` where spec said `required`
   - `CreateSupplementUseCase` had `id: ''` where spec said `Uuid().v4()`
   - `UpdateSupplementUseCase` and `ArchiveSupplementUseCase` weren't updating `syncMetadata`

2. **Fixed the deviations** to match specs EXACTLY

3. **Created new skills** to prevent future drift:
   - `/major-audit` - Monthly external best practices review
   - `/spec-review` - Verify specs comply with Coding Standards
   - `/implementation-review` - Verify code matches specs EXACTLY
   - `/manager` - Instance self-monitoring (now a core skill)

4. **Updated skill structure** - Now 6 core skills + 3 audit skills

---

## TASK: COMPREHENSIVE AUDIT

### Step 1: Read the Audit Skills

Before starting, read these skill documents:
- `.claude/skills/major-audit/SKILL.md`
- `.claude/skills/spec-review/SKILL.md`
- `.claude/skills/implementation-review/SKILL.md`

These contain the PLANS for implementation but are NOT YET IMPLEMENTED.

### Step 2: Execute Audit in Order

```
1. /major-audit (or manual equivalent)
   → Review 02_CODING_STANDARDS.md against industry best practices
   → Use WebSearch to check current Flutter/Dart/Apple/Google standards
   → Document any gaps or outdated standards

2. /spec-review (or manual equivalent)
   → Verify 22_API_CONTRACTS.md complies with Coding Standards
   → Extract and compile all code examples from specs
   → Document any spec violations

3. /implementation-review (or manual equivalent)
   → Compare ALL implementation files to specs
   → For each file, verify EXACT match
   → Fix any deviations (or update spec if implementation is better)
```

### Step 3: Generate Audit Report

Create: `.claude/audit-reports/2026-02-04-comprehensive-audit.md`

Include:
- Summary of each audit phase
- All issues found
- All fixes applied
- Recommendations

### Step 4: Project Status Summary

After audit, document:
- What has been accomplished in the project
- What is remaining
- Current state of each subsystem

---

## FILES CREATED THIS SESSION

**New Skills:**
- `.claude/skills/major-audit/SKILL.md`
- `.claude/skills/spec-review/SKILL.md`
- `.claude/skills/implementation-review/SKILL.md`
- `.claude/skills/manager/SKILL.md` (updated to be core skill)

**Removed:**
- `.claude/skills/audit/` (superseded by specific audit skills)

**Implementation Fixes:**
- `lib/domain/usecases/supplements/supplement_inputs.dart`
- `lib/domain/usecases/supplements/create_supplement_use_case.dart`
- `lib/domain/usecases/supplements/update_supplement_use_case.dart`
- `lib/domain/usecases/supplements/archive_supplement_use_case.dart`
- `test/unit/domain/usecases/supplements/supplement_usecases_test.dart`

---

## CURRENT SKILL INVENTORY

### 6 Core Skills (Every Session)
| Skill | When |
|-------|------|
| `/startup` | FIRST - every session |
| `/coding` | When writing code |
| `/manager` | Mid-session self-review |
| `/compliance` | Before claiming complete |
| `/team` | Always (mindset) |
| `/handoff` | Session ending |

### 3 Audit Skills (Quality Assurance)
| Skill | When |
|-------|------|
| `/major-audit` | Monthly |
| `/spec-review` | After standards change, before major work |
| `/implementation-review` | After implementation, when deviation found |

---

## CRITICAL CONTEXT

### Why This Audit Matters

A previous instance made "interpretations" instead of following specs EXACTLY:
- Added `@Default` values not in spec
- Delegated ID generation to repository instead of use case
- Skipped syncMetadata updates

This caused the user to question which instance got us off track. The audit will:
1. Find any other deviations
2. Establish baseline compliance
3. Prevent future drift

### The User's Expectations

The user expects:
- Apple/Google quality level standards
- Specs that are complete and implementable
- Code that EXACTLY matches specs
- No "interpretations" or "improvements" without spec changes

### The Baton

You are receiving the baton. The relay race continues. Don't drop it.

---

## VERIFICATION COMMANDS

Before starting new work, verify current state:

```bash
flutter test
flutter analyze --fatal-infos --fatal-warnings
cat .claude/work-status/current.json
```

All tests should pass. Analyzer should be clean.

---

## QUESTIONS FOR USER (if needed)

If you encounter ambiguity during the audit:
1. Document in `53_SPEC_CLARIFICATIONS.md`
2. Ask user before proceeding
3. Do NOT interpret - wait for clarification
