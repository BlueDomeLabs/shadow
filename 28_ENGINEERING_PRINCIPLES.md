# Shadow Engineering Principles

**Version:** 1.0
**Last Updated:** January 30, 2026
**Purpose:** Core values and principles that guide engineering decisions and culture

---

## Overview

These principles define how we work, make decisions, and treat each other. They are non-negotiable. Every engineer is expected to embody these principles.

---

## 1. Core Principles

### 1.1 Quality is Non-Negotiable

> "Move fast with stable infrastructure."

- We don't ship broken code
- We don't skip tests to meet deadlines
- We don't accumulate tech debt without a plan
- We fix bugs before building features
- We maintain 100% code coverage (see 02_CODING_STANDARDS.md Section 10.3)

**In Practice:**
- Definition of Done is enforced, not optional
- PRs without tests are rejected
- Quality Team has veto power on releases
- Tech debt is tracked and paid down quarterly

### 1.2 Users Trust Us with Their Health

> "We handle health data like it's our own family's."

- Privacy is a feature, not a constraint
- Security is everyone's responsibility
- We encrypt everything, everywhere
- We collect only what we need
- We never sell or share user data

**In Practice:**
- HIPAA compliance is mandatory
- Security review for all data-touching changes
- PII never appears in logs
- Privacy impact assessment for new features

### 1.3 Accessibility is Not Optional

> "If it's not accessible, it's not done."

- Every user deserves full functionality
- Screen readers work perfectly
- Keyboard navigation works everywhere
- Color is never the only indicator
- Touch targets are never too small

**In Practice:**
- Accessibility testing in Definition of Done
- Quarterly VoiceOver/TalkBack audits
- Accessibility champions on each team
- No exceptions for "we'll fix it later"

### 1.4 Ownership, Not Territory

> "Own the outcome, not just the code."

- You own it until it works in production
- You're responsible for monitoring and alerts
- You fix the bugs you introduce
- You help others with "your" code
- Code ownership is about accountability, not control

**In Practice:**
- On-call for your features
- No "that's not my code" responses
- Help is always given, never gatekept
- Knowledge sharing is expected

### 1.5 Explicit Over Implicit

> "If it's not documented, it doesn't exist."

- Write it down, don't assume
- Decisions need ADRs
- Interfaces need contracts
- Processes need documentation
- Meetings need agendas and notes

**In Practice:**
- API Contracts for all interfaces
- README in every module
- Meeting notes within 24 hours
- Decision log maintained

---

## 2. Technical Principles

### 2.1 Design for Failure

> "Assume everything will fail, then make it not matter."

- Networks are unreliable
- Servers go down
- Databases corrupt
- Users lose connectivity
- Plan for graceful degradation

**Applied:**
```dart
// GOOD: Handles failure explicitly
final result = await repository.getSupplements(profileId);
return result.when(
  success: (supplements) => SupplementList(supplements),
  failure: (error) => ErrorState(error.userMessage),
);

// BAD: Assumes success
final supplements = await repository.getSupplements(profileId);
return SupplementList(supplements); // What if it fails?
```

### 2.2 Make It Obvious

> "Code should be boring to read."

- No clever tricks
- No hidden side effects
- No magic strings or numbers
- Method names tell you what they do
- Variable names tell you what they are

**Applied:**
```dart
// GOOD: Obvious
Future<Result<FluidsEntry, AppError>> logFluidsEntry(LogFluidsEntryInput input)

// BAD: Clever but confusing
Future<dynamic> log(Map<String, dynamic> data)
```

### 2.3 Fail Fast

> "Find problems in development, not production."

- Compile-time errors over runtime errors
- Strong types over dynamic types
- Validation at the boundary
- Assertions in development
- Crash early, crash loudly (in dev)

**Applied:**
```dart
// GOOD: Fails at compile time if missing field
@freezed
class Supplement with _$Supplement {
  const factory Supplement({
    required String id,        // Compile error if omitted
    required String clientId,  // Required for database merging
    required String profileId, // Profile scope
    required String name,
    required SyncMetadata syncMetadata,
  }) = _Supplement;
}

// BAD: Fails at runtime
class Supplement {
  final Map<String, dynamic> data;  // Anything could be missing
}
```

### 2.4 One Way to Do Things

> "Consistency beats perfection."

- Follow established patterns
- Don't invent new approaches
- If you must deviate, ADR first
- Code should look like one person wrote it
- New team members should predict the code

**Applied:**
- All entities use Freezed
- All repositories return Result
- All use cases check authorization first
- All widgets use consolidated library

### 2.5 Test the Contract, Not the Implementation

> "Tests should survive refactoring."

- Test behavior, not internals
- Test public interfaces
- Mock at boundaries, not everywhere
- Tests are documentation
- If a test breaks during refactor, it was a bad test

**Applied:**
```dart
// GOOD: Tests behavior
test('returns error when BBT is out of range', () async {
  final result = await useCase(LogFluidsEntryInput(bbt: 110.0));
  expect(result.isFailure, isTrue);
  expect(result.errorOrNull, isA<ValidationError>());
});

// BAD: Tests implementation
test('calls _validateBBT with temperature', () {
  // Testing private method - will break on refactor
});
```

---

## 3. Collaboration Principles

### 3.1 Assume Positive Intent

> "They're not trying to make your life harder."

- Questions are for learning, not attacking
- Feedback is for improvement, not criticism
- Different approaches aren't wrong, just different
- Give the benefit of the doubt
- Ask before assuming

**In Practice:**
- "Help me understand..." not "Why did you..."
- "What if we tried..." not "You should have..."
- Slack messages aren't attacks
- Code review comments aren't personal

### 3.2 Strong Opinions, Loosely Held

> "Have conviction, but be open to new information."

- Form a position, defend it
- But change when convinced
- Disagree, then commit
- Don't fight battles twice
- The goal is the best solution, not being right

**In Practice:**
- Debate in reviews, not after merge
- Once decided, execute together
- Track disagreement in ADRs, not Slack
- Revisit decisions with new data, not old arguments

### 3.3 Teach, Don't Tell

> "Give them fishing skills, not fish."

- Explain the why, not just the what
- Point to documentation, then explain
- Ask leading questions
- Let people figure things out (with guardrails)
- Celebrate learning moments

**In Practice:**
- Code review: explain why, link to docs
- Pairing: let them type
- Questions: guide to answer, don't give it
- Mistakes: learning opportunities

### 3.4 Transparent by Default

> "Information should flow freely unless there's a reason."

- Share context proactively
- Document decisions publicly
- Surface problems early
- Celebrate wins visibly
- Bad news travels fast

**In Practice:**
- Public Slack channels over DMs
- Shared documents over private notes
- Status updates in standup
- Blockers announced immediately

### 3.5 Blameless Problem Solving

> "Fix the system, not the person."

- Incidents are system failures
- Everyone makes mistakes
- Shame is not a motivator
- Ask "what failed" not "who failed"
- Learn and improve

**In Practice:**
- Blameless postmortems
- Focus on timeline and facts
- Action items are process changes
- No naming in incident reports

---

## 4. Decision Principles

### 4.1 Reversible vs. Irreversible

> "Move fast on reversible decisions, slow on irreversible ones."

| Reversible (Fast) | Irreversible (Slow) |
|-------------------|---------------------|
| Variable naming | Database schema |
| UI layout | API contracts |
| Test approach | Architecture patterns |
| Documentation style | Security mechanisms |

### 4.2 Data Over Opinions

> "In God we trust, all others bring data."

- Opinions start discussions
- Data ends discussions
- Benchmark before optimizing
- Measure before claiming
- Experiment before committing

### 4.3 Bias for Action

> "A good plan today is better than a perfect plan tomorrow."

- Start with 80% solution
- Iterate based on feedback
- Ship to learn
- Prototype to decide
- Perfect is the enemy of done

**Except for:**
- Security (never rush)
- Privacy (never compromise)
- Data integrity (never risk)

---

## 5. Growth Principles

### 5.1 Always Be Learning

> "The day you stop learning is the day you start declining."

- Read code you didn't write
- Try approaches you wouldn't choose
- Learn from incidents (yours and others')
- Attend tech talks
- Teach to learn

### 5.2 Feedback is a Gift

> "Feedback is how we get better. Seek it out."

- Ask for feedback explicitly
- Receive feedback gracefully
- Give feedback kindly
- Act on feedback visibly
- Thank people for feedback

### 5.3 Lift Others Up

> "Your success is measured by the success of those around you."

- Senior engineers create senior engineers
- Share knowledge freely
- Celebrate others' wins
- Take time to mentor
- No knowledge hoarding

---

## 6. Principle Violations

### 6.1 How to Handle

When you see a principle violation:

1. **Assume positive intent** - They may not know
2. **Address privately first** - DM or 1:1
3. **Reference the principle** - Be specific
4. **Offer to help** - Not just criticize
5. **Escalate if pattern** - Manager for repeated issues

### 6.2 Examples

| Violation | Response |
|-----------|----------|
| PR without tests | "Hey, I noticed tests are missing. DoD requires them. Need help writing them?" |
| Accessibility skipped | "This needs semantic labels per our accessibility principle. I can pair on this if helpful." |
| Blame in postmortem | "Let's focus on the system failure, not the individual. What process allowed this?" |
| Knowledge hoarding | "This seems like valuable info. Can you document it for the team?" |

---

## 7. Principle Poster

Print this for team spaces:

```
┌─────────────────────────────────────────────────────────────────┐
│                   SHADOW ENGINEERING PRINCIPLES                  │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ⚙️  Quality is Non-Negotiable                                  │
│      We don't ship broken code.                                 │
│                                                                 │
│  🔒 Users Trust Us with Their Health                           │
│      Privacy and security in everything.                        │
│                                                                 │
│  ♿ Accessibility is Not Optional                               │
│      If it's not accessible, it's not done.                     │
│                                                                 │
│  🎯 Ownership, Not Territory                                    │
│      Own the outcome, help others.                              │
│                                                                 │
│  📝 Explicit Over Implicit                                      │
│      Write it down.                                             │
│                                                                 │
│  🤝 Assume Positive Intent                                      │
│      Give the benefit of the doubt.                             │
│                                                                 │
│  🔄 Blameless Problem Solving                                   │
│      Fix the system, not the person.                            │
│                                                                 │
│  🚀 Bias for Action                                             │
│      Start with 80%, iterate.                                   │
│                                                                 │
│  📈 Lift Others Up                                              │
│      Your success = their success.                              │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-30 | Initial release |
