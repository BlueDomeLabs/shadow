# Shadow Engineering Onboarding Program

**Version:** 1.0
**Last Updated:** January 30, 2026
**Purpose:** Structured onboarding for new engineers to reach full productivity

---

## Overview

New engineers complete a 4-week structured onboarding program. The goal is independent contribution by Week 5.

---

## 1. Onboarding Timeline

### Week 1: Foundation

| Day | Focus | Activities | Deliverable |
|-----|-------|------------|-------------|
| **Day 1** | Welcome | Orientation, equipment setup, access provisioning | All accounts active |
| **Day 2** | Environment | Dev environment setup, clone repos, first build | Successful local build |
| **Day 3** | Codebase | Architecture walkthrough, codebase tour | Architecture quiz (pass) |
| **Day 4** | Process | Git workflow, PR process, CI/CD overview | Practice PR submitted |
| **Day 5** | Team | Meet team, attend ceremonies, shadow pairing | Week 1 retrospective |

### Week 2: Deep Dive

| Day | Focus | Activities | Deliverable |
|-----|-------|------------|-------------|
| **Day 6** | Specs 1-5 | Read Product Specs, Architecture, Roadmap | Spec quiz 1 (pass) |
| **Day 7** | Specs 6-13 | Read Testing, Naming, Widget Library, DB Schema | Spec quiz 2 (pass) |
| **Day 8** | Specs 14-21 | Read User Flows, Error Handling, Privacy, Monitoring | Spec quiz 3 (pass) |
| **Day 9** | Specs 22-27 | Read API Contracts, Governance, Review Checklist, DoD | Spec quiz 4 (pass) |
| **Day 10** | Integration | Connect specs to codebase, trace a feature end-to-end | Feature trace document |

### Week 3: Contribution

| Day | Focus | Activities | Deliverable |
|-----|-------|------------|-------------|
| **Day 11** | First Issue | Pick "good first issue", pair with mentor | Issue assigned |
| **Day 12** | Implementation | Write code with mentor guidance | Code written |
| **Day 13** | Testing | Write tests, verify coverage | Tests passing |
| **Day 14** | Review | Submit PR, respond to feedback | PR submitted |
| **Day 15** | Merge | Address reviews, merge first PR | First PR merged ✅ |

### Week 4: Independence

| Day | Focus | Activities | Deliverable |
|-----|-------|------------|-------------|
| **Day 16** | Second Issue | Pick slightly harder issue, less mentor help | Issue assigned |
| **Day 17-18** | Solo Work | Implement independently, ask questions as needed | Implementation complete |
| **Day 19** | Review | Submit PR, lead review response | PR submitted |
| **Day 20** | Graduation | Merge PR, onboarding retrospective, team celebration | Onboarding complete ✅ |

---

## 2. Onboarding Checklist

### 2.1 Before Day 1 (Manager)

- [ ] Equipment ordered and configured
- [ ] Accounts created: GitHub, Slack, Jira, Google Workspace
- [ ] Mentor assigned
- [ ] Calendar invites sent for first week
- [ ] Onboarding buddy assigned
- [ ] Welcome Slack message drafted
- [ ] "Good first issues" identified (3-5)

### 2.2 Day 1 Checklist (New Engineer)

- [ ] Complete HR onboarding
- [ ] Receive equipment
- [ ] Access email and calendar
- [ ] Join Slack channels
- [ ] Access GitHub organization
- [ ] Meet manager (30 min)
- [ ] Meet mentor (30 min)
- [ ] Meet onboarding buddy (lunch)
- [ ] Read company handbook

### 2.3 Week 1 Checklist

- [ ] Clone all repositories
- [ ] Complete local development setup
- [ ] Successful build on all platforms (iOS, Android, macOS)
- [ ] Run test suite successfully
- [ ] Complete architecture quiz (100% required)
- [ ] Attend team standup (3+ times)
- [ ] Attend sprint ceremony (planning or retro)
- [ ] Submit practice PR (documentation fix or typo)
- [ ] 1:1 with mentor (30 min)
- [ ] 1:1 with manager (30 min)

### 2.4 Week 2 Checklist

- [ ] Read all specification documents (01-27)
- [ ] Pass all spec quizzes (100% required)
- [ ] Complete feature trace exercise
- [ ] Shadow a code review
- [ ] Attend architecture review
- [ ] 1:1 with mentor
- [ ] Meet 3 engineers from other teams

### 2.5 Week 3-4 Checklist

- [ ] Complete first real PR (merged)
- [ ] Complete second PR (merged)
- [ ] Lead a code review (with mentor oversight)
- [ ] Present feature trace at team meeting
- [ ] Complete onboarding retrospective
- [ ] Schedule ongoing 1:1 cadence with manager
- [ ] Added to on-call rotation (shadow only for first month)

---

## 3. Specification Quizzes

### 3.1 Quiz Format

- 20 questions per quiz
- Multiple choice and short answer
- 100% required to pass
- Unlimited retakes with 24-hour wait
- Questions from specification documents

### 3.2 Sample Questions

**Architecture Quiz:**
```
Q: What layer contains Use Cases in Clean Architecture?
A: Domain Layer

Q: What must every repository method return?
A: Future<Result<T, AppError>>

Q: What is the first thing a Use Case must check?
A: Authorization (canRead/canWrite)
```

**API Contracts Quiz:**
```
Q: What error code is used when an entity is not found?
A: DatabaseError.codeNotFound (or 'DB_NOT_FOUND')

Q: What pattern must all entities use for immutability?
A: Freezed (@freezed annotation)

Q: List the 5 error categories in the error handling system.
A: DatabaseError, AuthError, NetworkError, ValidationError, SyncError
```

**Process Quiz:**
```
Q: What is the minimum number of approving reviews for a PR to merge?
A: 2

Q: What file must be updated when changing a repository interface?
A: 22_API_CONTRACTS.md (requires ADR)

Q: What command must be run before committing changes to entities?
A: dart run build_runner build --delete-conflicting-outputs
```

**Coding Standards Quiz (02_CODING_STANDARDS.md):**
```
Q: What are the 4 required fields for all health data entities?
A: id, clientId, profileId, syncMetadata

Q: What pattern must all domain operations use for error handling?
A: Result<T, AppError> - never throw exceptions for expected errors

Q: What 3 properties must every AppError subclass implement for recovery?
A: isRecoverable, recoveryAction, originalError

Q: What must every data source query include for soft delete filtering?
A: sync_deleted_at IS NULL

Q: What must SQL queries include to validate profile ownership?
A: JOIN profiles WHERE owner_id = ? (current user's ID)

Q: What encryption algorithm is required for sensitive data?
A: AES-256-GCM (NOT CBC)

Q: What test coverage percentage is required for all layers?
A: 100%

Q: Name 4 masking functions required for PII protection.
A: maskUserId, maskProfileId, maskDeviceId, maskIpAddress, maskEmail, maskPhone, maskToken (any 4)

Q: What columns must every syncable table have?
A: id, client_id, profile_id, sync_created_at, sync_updated_at, sync_deleted_at,
   sync_last_synced_at, sync_status, sync_version, sync_device_id, sync_is_dirty, conflict_data

Q: What 8 values does the RecoveryAction enum have?
A: none, retry, refreshToken, reAuthenticate, goToSettings, contactSupport, checkConnection, freeStorage
```

---

## 4. Mentor Program

### 4.1 Mentor Responsibilities

| Responsibility | Time Investment |
|----------------|-----------------|
| Daily check-in (Week 1-2) | 15 min/day |
| Weekly check-in (Week 3-4) | 30 min/week |
| Pair programming sessions | 2-3 hrs/week |
| Code review guidance | 1 hr/week |
| Answer questions | As needed |
| Onboarding feedback to manager | Weekly |

### 4.2 Mentor Qualifications

- Senior Engineer or above
- 6+ months on Shadow project
- Completed mentor training
- Capacity for mentorship (not overloaded)
- Track record of helpful code reviews

### 4.3 Mentor Training Topics

- Effective pair programming
- Giving constructive feedback
- Recognizing when to help vs. let struggle
- Escalating concerns early
- Cultural onboarding

---

## 5. Good First Issues

### 5.1 Criteria

Good first issues should be:
- Isolated (minimal dependencies)
- Well-defined (clear acceptance criteria)
- Low risk (not critical path)
- Educational (teaches something)
- Completable in 1-2 days

### 5.2 Examples

| Issue Type | Example | Learning |
|------------|---------|----------|
| Bug fix | "BBT input doesn't clear on save" | Widget lifecycle |
| Enhancement | "Add loading state to supplement list" | State management |
| Test | "Add unit tests for FluidsEntry validation" | Testing patterns |
| Documentation | "Update API docs for notification repository" | Documentation |
| Refactor | "Extract common dialog to shared widget" | Widget patterns |

### 5.3 Tagging

Issues are tagged in Jira:
- `good-first-issue` - Suitable for Week 3
- `good-second-issue` - Suitable for Week 4
- `needs-mentor` - Requires pairing

---

## 6. Environment Setup

### 6.1 Required Tools

```bash
# Install Flutter
brew install flutter

# Install additional tools
brew install cocoapods
brew install --cask android-studio

# Clone repositories
git clone git@github.com:shadow-health/shadow-app.git
git clone git@github.com:shadow-health/shadow-specs.git

# Setup Flutter
flutter doctor
flutter pub get

# Run code generation
dart run build_runner build --delete-conflicting-outputs

# Verify build
flutter build ios --debug
flutter build android --debug
flutter build macos --debug

# Run tests
flutter test
```

### 6.2 IDE Setup

**VS Code Extensions:**
- Dart
- Flutter
- Error Lens
- GitLens
- Bracket Pair Colorizer
- Better Comments

**Settings:**
```json
{
  "editor.formatOnSave": true,
  "editor.rulers": [80, 120],
  "dart.lineLength": 120,
  "dart.previewFlutterUiGuides": true
}
```

### 6.3 Git Configuration

```bash
# Configure git
git config --global user.name "Your Name"
git config --global user.email "your.email@company.com"

# Install pre-commit hooks
./scripts/install-hooks.sh

# Configure commit signing (optional but recommended)
git config --global commit.gpgsign true
```

---

## 7. 30-60-90 Day Goals

### 7.1 Day 30 (End of Onboarding)

- [ ] All onboarding checklists complete
- [ ] 2+ PRs merged
- [ ] All quizzes passed
- [ ] Comfortable with daily workflow
- [ ] Knows who to ask for help
- [ ] Attending all team ceremonies

### 7.2 Day 60

- [ ] 5+ PRs merged
- [ ] Completed a small feature independently
- [ ] Given helpful code reviews to others
- [ ] Presented at team meeting
- [ ] Identified improvement opportunity
- [ ] Shadow on-call rotation completed

### 7.3 Day 90

- [ ] 10+ PRs merged
- [ ] Owned a medium feature end-to-end
- [ ] Mentored another new engineer (informal)
- [ ] Contributed to team process improvement
- [ ] On-call rotation (with backup)
- [ ] Performance expectations met

---

## 8. Onboarding Feedback

### 8.1 Feedback Collection

| When | Type | Purpose |
|------|------|---------|
| Day 5 | Quick survey | Early issues |
| Day 20 | Retrospective | Improve program |
| Day 60 | Manager 1:1 | Progress check |
| Day 90 | Full review | Confirm success |

### 8.2 Retrospective Questions

1. What was most helpful in your onboarding?
2. What was most confusing or frustrating?
3. What information did you wish you had earlier?
4. How was your mentor experience?
5. What would you change for future new engineers?

### 8.3 Program Improvement

Onboarding feedback is reviewed monthly by:
- Engineering Manager
- Mentor representatives
- Recent new hires

Changes are made to:
- Checklist items
- Quiz questions
- Good first issues
- Documentation gaps
- Timeline adjustments

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-30 | Initial release |
