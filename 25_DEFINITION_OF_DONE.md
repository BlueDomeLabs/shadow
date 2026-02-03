# Shadow Definition of Done

**Version:** 1.0
**Last Updated:** January 30, 2026
**Purpose:** Explicit criteria for when work items are complete

---

## Overview

Work is NOT complete until ALL applicable criteria in this document are met. No exceptions. Partial completion does not count as done.

---

## 1. Task Definition of Done

A **task** (single unit of work) is done when:

### 1.1 Code Complete
- [ ] Implementation matches acceptance criteria exactly
- [ ] Code follows API Contracts (22_API_CONTRACTS.md)
- [ ] All methods use Result type (no exceptions thrown for expected errors)
- [ ] ProfileId filtering implemented on all data queries (MANDATORY per 02_CODING_STANDARDS.md Section 4.3)
- [ ] SQL queries include `sync_deleted_at IS NULL` for soft delete filtering
- [ ] Code passes `flutter analyze` with zero warnings
- [ ] Code formatted with `dart format`
- [ ] Generated files updated (`build_runner build`)

### 1.2 Tests Complete
- [ ] Unit tests written for all new logic
- [ ] Contract tests written for interface changes
- [ ] Widget tests written for UI changes
- [ ] All tests pass locally
- [ ] Coverage meets minimum threshold (100% per 02_CODING_STANDARDS.md Section 10.3)

### 1.3 Documentation Complete
- [ ] Dartdoc added to public APIs
- [ ] Complex logic has inline comments
- [ ] Spec documents updated if behavior changed

### 1.4 Review Complete
- [ ] PR created with descriptive title and complete description
- [ ] Link to issue/ticket included in PR
- [ ] Screenshots attached for UI changes
- [ ] Test coverage report included
- [ ] All checklist items in PR template checked
- [ ] At least 2 approving reviews received
- [ ] All reviewer comments addressed (no unresolved comments)
- [ ] CI pipeline passes

---

## 2. User Story Definition of Done

A **user story** is done when:

### 2.1 All Tasks Complete
- [ ] Every task in the story meets Task DoD

### 2.2 Acceptance Criteria Met
- [ ] All acceptance criteria from 01_PRODUCT_SPECIFICATIONS.md verified
- [ ] Each criterion tested and documented
- [ ] Edge cases handled (empty state, error state, loading state)

### 2.3 Feature Flag Ready
- [ ] Feature behind appropriate feature flag (if new feature)
- [ ] Flag documented in 19_FEATURE_FLAGS.md
- [ ] Rollout plan defined

### 2.4 Accessibility Verified
- [ ] Screen reader tested (VoiceOver/TalkBack)
- [ ] Keyboard navigation works (desktop)
- [ ] Touch targets meet 48x48 minimum
- [ ] Color contrast meets WCAG AA

### 2.5 Performance Verified
- [ ] No regression in app launch time
- [ ] Feature responsive (<200ms for user actions)
- [ ] Memory usage within limits (<200MB total)

### 2.6 Localization Complete
- [ ] All user-facing strings in ARB files
- [ ] Tested in at least one RTL language (if applicable)
- [ ] Pluralization rules correct

---

## 3. Epic Definition of Done

An **epic** (collection of user stories) is done when:

### 3.1 All Stories Complete
- [ ] Every user story meets Story DoD

### 3.2 Integration Complete
- [ ] Integration tests pass for all flows
- [ ] No regressions in existing features
- [ ] Cross-feature interactions verified

### 3.3 Documentation Complete
- [ ] User flows documented (14_USER_FLOWS.md updated)
- [ ] Architecture documented (04_ARCHITECTURE.md updated)
- [ ] Release notes drafted

### 3.4 QA Sign-off
- [ ] Full QA test pass completed
- [ ] No P0 or P1 bugs outstanding
- [ ] P2 bugs documented with timeline

### 3.5 Stakeholder Review
- [ ] Demo completed for stakeholders
- [ ] Feedback addressed or documented

---

## 4. Release Definition of Done

A **release** is done when:

### 4.1 All Epics Complete
- [ ] Every epic meets Epic DoD

### 4.2 Quality Gates Passed
- [ ] All automated tests pass (100%)
- [ ] Code coverage meets threshold (100% per 02_CODING_STANDARDS.md Section 10.3)
- [ ] Security scan passed (no critical/high)
- [ ] Performance benchmarks met

### 4.3 Compliance Verified
- [ ] Privacy policy updated (if data collection changed)
- [ ] HIPAA checklist completed (17_PRIVACY_COMPLIANCE.md)
- [ ] App Store requirements met (privacy labels, descriptions)

### 4.4 Release Artifacts Ready
- [ ] Release notes finalized
- [ ] Version number incremented
- [ ] Build artifacts created (iOS, Android, macOS)
- [ ] TestFlight/Play Store beta uploaded
- [ ] Beta testing completed with sign-off

### 4.5 Rollout Plan Approved
- [ ] Feature flag rollout plan documented
- [ ] Monitoring dashboards configured
- [ ] Alerts configured for new features
- [ ] Rollback procedure documented and tested

### 4.6 Team Sign-offs
- [ ] Tech Lead approval
- [ ] QA Lead approval
- [ ] Product Owner approval
- [ ] Security review (if applicable)

---

## 5. Feature-Specific DoD

### 5.1 New Entity (e.g., FluidsEntry)

- [ ] Entity class created with Freezed
- [ ] Generated files committed (.freezed.dart, .g.dart)
- [ ] Repository interface defined
- [ ] Repository implementation complete
- [ ] Local datasource implemented
- [ ] Database migration created
- [ ] Contract tests pass
- [ ] Unit tests for entity logic (95%+ coverage)
- [ ] Registered in dependency injection

### 5.2 New Use Case

- [ ] Use case class created following pattern
- [ ] Input class defined with all required fields
- [ ] Authorization check implemented (first line)
- [ ] Validation implemented (after auth)
- [ ] All error paths return appropriate Failure
- [ ] Unit tests for all paths (100% coverage)
- [ ] Contract tests for return types

### 5.3 New Screen

- [ ] Screen widget created following template
- [ ] Uses consolidated widgets (ShadowButton, etc.)
- [ ] All strings localized
- [ ] All colors from AppColors
- [ ] Loading state implemented
- [ ] Error state implemented
- [ ] Empty state implemented
- [ ] Accessibility verified
- [ ] Widget tests written (70%+ coverage)
- [ ] Navigation registered in router

### 5.4 New Widget

- [ ] Added to consolidated widget (not separate class)
- [ ] Documented in 09_WIDGET_LIBRARY.md
- [ ] Semantic labels required
- [ ] Minimum touch target enforced
- [ ] Widget tests written

### 5.5 Database Schema Change

- [ ] Migration script created
- [ ] Migration tested (up and down)
- [ ] Schema documented in 10_DATABASE_SCHEMA.md
- [ ] ADR created for schema change
- [ ] Core Team approval received

---

## 6. DoD Verification Checklist

Before marking any work item as done, answer these questions:

```
□ Can I demo this feature to a stakeholder right now?
□ If someone else pulled this code, would it work perfectly?
□ Are there any "I'll fix it later" items?
□ Would I be comfortable on-call when this ships?
□ Is there anything I'm hoping reviewers won't notice?
```

If the answer to any question is "no" or uncertain, the work is **NOT done**.

---

## 7. What "Done" is NOT

### NOT Done:
- "It works on my machine" (must work in CI)
- "Tests are passing" (must also be reviewed)
- "Code is written" (must be tested)
- "PR is approved" (must be merged and deployed to staging)
- "Feature flag is on for me" (must be validated at each rollout stage)
- "I think it's accessible" (must be tested with assistive technology)

### Common Traps:
- "I'll add tests later" → Not done
- "Documentation can wait" → Not done
- "It's behind a flag so it's fine" → Still must meet quality standards
- "It's just a small change" → Same criteria apply

---

## 8. Enforcement

### 8.1 PR Merge Blocks

PRs cannot be merged without:
- All required reviewers approved
- All CI checks passing
- All checklist items verified

### 8.2 Sprint Completion Rules

Stories cannot be marked complete in sprint reviews without:
- All acceptance criteria demonstrated
- All DoD checklist items signed off

### 8.3 Release Gate

Releases cannot proceed without:
- Tech Lead sign-off that all release DoD criteria met
- QA sign-off on test completion
- Product Owner sign-off on feature completeness

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-30 | Initial release |
