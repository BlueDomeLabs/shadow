# Shadow Team Operations

**Version:** 1.0
**Last Updated:** January 30, 2026
**Purpose:** Meeting cadence, communication protocols, and coordination mechanisms

---

## 1. Organizational Structure

### 1.1 Team Hierarchy

```
Engineering Director
├── Tech Lead - Core Platform (3 engineers)
│   └── Core Team: Entities, repositories, use cases, database
│
├── Tech Lead - Features (48 engineers across 6 teams)
│   ├── Team Conditions (8 engineers)
│   ├── Team Supplements (8 engineers)
│   ├── Team Nutrition (8 engineers)
│   ├── Team Wellness (8 engineers)
│   ├── Team Sync (8 engineers)
│   └── Team Platform (8 engineers)
│
├── Tech Lead - UI/UX (4 engineers)
│   └── Design System, Widget Library, Accessibility
│
├── Tech Lead - Quality (4 engineers)
│   └── Test Infrastructure, CI/CD, Release Engineering
│
├── Engineering Manager - Operations (2 engineers)
│   └── On-call, Monitoring, Incident Response
│
└── Staff Engineers (3 - cross-cutting)
    └── Architecture, Performance, Security
```

### 1.2 Roles and Responsibilities

| Role | Count | Responsibilities |
|------|-------|------------------|
| Engineering Director | 1 | Strategy, hiring, cross-team coordination |
| Tech Lead | 4 | Technical direction, code quality, team growth |
| Staff Engineer | 3 | Architecture decisions, complex problems, mentoring |
| Engineering Manager | 1 | Operations, processes, people management |
| Senior Engineer | 30 | Feature ownership, code review, mentoring |
| Engineer | 40 | Feature implementation, testing |
| Associate Engineer | 20 | Learning, pair programming, small features |

### 1.3 Team Composition (Per Feature Team)

```
Feature Team (8 engineers)
├── Senior Engineer (Team Lead) - 1
├── Senior Engineers - 2
├── Engineers - 3
└── Associate Engineers - 2
```

---

## 2. Meeting Cadence

### 2.1 Daily Ceremonies

| Meeting | Time | Duration | Attendees | Purpose |
|---------|------|----------|-----------|---------|
| Team Standup | 9:00 AM | 15 min | Feature team | Blockers, daily plan |
| Cross-team Sync | 9:30 AM | 15 min | Team leads | Dependencies, escalations |

**Standup Format:**
```
1. What I completed yesterday
2. What I'm working on today
3. Blockers (if any)
4. Help needed (if any)
```

**Rules:**
- Start on time, end on time
- No problem-solving in standup (schedule follow-ups)
- Remote-first (video on, muted unless speaking)
- Async updates acceptable if timezone conflict

### 2.2 Weekly Ceremonies

| Meeting | Day | Duration | Attendees | Purpose |
|---------|-----|----------|-----------|---------|
| Sprint Planning | Monday | 2 hr | Feature team | Plan sprint work |
| Backlog Refinement | Wednesday | 1 hr | Team + PO | Clarify upcoming work |
| Architecture Review | Thursday | 1 hr | Leads + Staff | ADRs, design reviews |
| Demo & Retro | Friday | 1.5 hr | Feature team | Show work, improve process |

### 2.3 Bi-weekly Ceremonies

| Meeting | Duration | Attendees | Purpose |
|---------|----------|-----------|---------|
| All-Hands Engineering | 1 hr | All engineers | Announcements, demos, Q&A |
| Tech Lead Sync | 1 hr | Tech leads + Director | Cross-team planning |
| 1:1s | 30 min | Manager + Report | Career, feedback, blockers |

### 2.4 Monthly Ceremonies

| Meeting | Duration | Attendees | Purpose |
|---------|----------|-----------|---------|
| Architecture Deep Dive | 2 hr | All interested | Technical education |
| Blameless Postmortem Review | 1 hr | Leads + affected | Learn from incidents |
| Technical Debt Review | 1 hr | Leads + Staff | Prioritize debt paydown |
| Security Review | 1 hr | Security + Leads | Audit findings, updates |

### 2.5 Quarterly Ceremonies

| Meeting | Duration | Attendees | Purpose |
|---------|----------|-----------|---------|
| OKR Planning | Half day | Leads + Director | Set quarterly objectives |
| Team Health Survey | Async | All engineers | Anonymous feedback |
| Skills Assessment | 1 hr each | Manager + Engineer | Career development |

---

## 3. Communication Channels

### 3.1 Slack Channel Structure

```
#shadow-announcements      (read-only, company-wide)
#shadow-engineering        (all engineers, general discussion)
#shadow-engineering-leads  (tech leads + managers)
#shadow-architecture       (design discussions, ADRs)
#shadow-incidents          (active incidents only)
#shadow-releases           (release coordination)
#shadow-ci-cd              (build notifications)
#shadow-on-call            (on-call coordination)

#team-conditions           (team-specific)
#team-supplements
#team-nutrition
#team-wellness
#team-sync
#team-platform
#team-core
#team-ui
#team-quality

#help-flutter              (technical help)
#help-database
#help-testing
#help-accessibility
```

### 3.2 Communication Escalation

```
Level 1: Team Slack Channel
    │     Response: < 4 hours
    │
Level 2: Direct Message to Team Lead
    │     Response: < 2 hours
    │
Level 3: #shadow-engineering-leads
    │     Response: < 1 hour
    │
Level 4: Engineering Director DM
    │     Response: < 30 minutes
    │
Level 5: Phone/PagerDuty (incidents only)
          Response: < 15 minutes
```

### 3.3 Communication Norms

| Type | Channel | Response Time |
|------|---------|---------------|
| Question (non-urgent) | Team Slack | Within same day |
| Question (urgent) | DM + thread | Within 2 hours |
| Blocker | Standup mention + DM | Same day resolution |
| Incident | #shadow-incidents + PagerDuty | Immediate |
| FYI/Announcement | Team Slack | No response needed |
| Decision needed | Meeting or async doc | Within 48 hours |
| Code review | GitHub + Slack ping | Within 24 hours |

---

## 4. Decision-Making Framework

### 4.1 Decision Types

| Type | Examples | Who Decides | Process |
|------|----------|-------------|---------|
| **Team** | Implementation approach, test strategy | Team consensus | Discussion in standup/refinement |
| **Technical** | Library choice, pattern adoption | Tech Lead + Staff | ADR + Architecture Review |
| **Architectural** | New entity design, API contracts | Staff + Director | ADR + multiple reviews |
| **Process** | Sprint length, meeting changes | Eng Manager + leads | Proposal + retro discussion |
| **Strategic** | Roadmap, hiring, major rewrites | Director + stakeholders | OKR planning |

### 4.2 RAPID Decision Framework

For significant decisions, use RAPID:

| Role | Responsibility |
|------|----------------|
| **R**ecommend | Proposes solution, gathers input |
| **A**gree | Must agree (veto power) |
| **P**erform | Will implement the decision |
| **I**nput | Consulted for expertise |
| **D**ecide | Makes final call if no consensus |

**Example: Adding a New Database Table**

| Role | Person |
|------|--------|
| Recommend | Feature team engineer |
| Agree | Core Team lead (veto on schema) |
| Perform | Feature team |
| Input | DBA, Staff engineer |
| Decide | Core Team lead |

### 4.3 Disagreement Resolution

```
1. Discussion
   └── Engineers discuss in channel/meeting

2. Data
   └── Gather evidence, prototypes, benchmarks

3. Tech Lead Decision
   └── If consensus not reached, Tech Lead decides

4. Staff Engineer Escalation
   └── For cross-team or architectural disagreements

5. Director Final Call
   └── Rare - used only when significant impact
```

---

## 5. Dependency Management

### 5.1 Dependency Types

| Type | Example | Handling |
|------|---------|----------|
| **Intra-team** | Feature A needs Feature B | Handled in sprint planning |
| **Cross-team** | Team Wellness needs Core entity | Cross-team sync + tracking |
| **External** | Waiting on design/product | Escalate to Product Owner |
| **Technical** | Blocked by bug/infrastructure | Escalate to appropriate team |

### 5.2 Dependency Tracking

```yaml
# dependencies.yml - Updated weekly by Tech Leads

dependencies:
  - id: DEP-001
    blocker: "FluidsEntry entity definition"
    blocked_team: Team Wellness
    blocking_team: Core Team
    owner: "@core-lead"
    status: in_progress
    eta: 2026-02-05
    notes: "Schema finalized, implementation this sprint"

  - id: DEP-002
    blocker: "Notification deep linking"
    blocked_team: Team Wellness
    blocking_team: Team Platform
    owner: "@platform-lead"
    status: not_started
    eta: 2026-02-15
    notes: "Scheduled for Sprint 12"
```

### 5.3 Cross-team Dependency Protocol

```
1. Identify dependency during planning
         │
2. Create dependency ticket (DEP-XXX)
         │
3. Discuss in Cross-team Sync
         │
4. Blocking team adds to their backlog
         │
5. Track in dependencies.yml
         │
6. Weekly status in Cross-team Sync
         │
7. Escalate if at risk (48 hr before needed)
```

---

## 6. Risk Management

### 6.1 Risk Categories

| Category | Examples | Owner |
|----------|----------|-------|
| Technical | Performance, scalability, security | Staff Engineers |
| Schedule | Dependencies, complexity, availability | Tech Leads |
| Quality | Test coverage, bug rate, tech debt | Quality Team |
| People | Turnover, skill gaps, burnout | Eng Manager |
| External | Third-party APIs, App Store policies | Product + Eng |

### 6.2 Risk Register

```yaml
# risks.yml - Reviewed monthly

risks:
  - id: RISK-001
    category: technical
    description: "Drift database migration complexity"
    probability: medium
    impact: high
    mitigation: "Prototype migration with sample data first"
    owner: "@core-lead"
    status: monitoring

  - id: RISK-002
    category: schedule
    description: "Notification system depends on 3 teams"
    probability: high
    impact: medium
    mitigation: "Define interfaces first, parallelize work"
    owner: "@platform-lead"
    status: mitigating
```

### 6.3 Risk Response

| Risk Level | Response |
|------------|----------|
| Low (green) | Monitor, review monthly |
| Medium (yellow) | Active mitigation, review weekly |
| High (red) | Escalate to Director, daily tracking |
| Critical | All-hands focus until resolved |

---

## 7. Knowledge Management

### 7.1 Documentation Hierarchy

```
/docs
├── specifications/          # Product specs (01-25)
├── adr/                     # Architecture Decision Records
├── runbooks/                # Operational procedures
├── onboarding/              # New engineer materials
├── tutorials/               # How-to guides
└── rfcs/                    # Request for Comments (proposals)
```

### 7.2 Knowledge Sharing

| Activity | Frequency | Format |
|----------|-----------|--------|
| Tech Talks | Bi-weekly | 30 min presentation + Q&A |
| Brown Bags | Weekly | Informal lunch learning |
| Pair Programming | Daily | Encouraged for complex work |
| Code Review | Every PR | Async with discussion |
| Architecture Deep Dive | Monthly | 2 hr workshop |
| External Conference | Quarterly | Attendance + trip report |

### 7.3 Documentation Requirements

| Artifact | When Required | Owner |
|----------|---------------|-------|
| ADR | Any architectural decision | Proposing engineer |
| Runbook | Any new operational procedure | Implementing team |
| README | Every new module/package | Creating engineer |
| API docs | Every public interface | Implementing engineer |
| Tutorial | Every new developer workflow | Quality team |

---

## 8. Metrics & Reporting

### 8.1 Team Health Metrics

| Metric | Target | Measurement |
|--------|--------|-------------|
| Sprint Velocity | Stable ±20% | Points completed/sprint |
| Sprint Commitment | >85% | Completed/committed |
| Cycle Time | <5 days | Ticket start to done |
| PR Review Time | <24 hours | PR open to first review |
| PR Merge Time | <48 hours | PR open to merge |
| Bug Escape Rate | <5% | Bugs found post-release |
| Test Coverage | >85% | Overall code coverage |

### 8.2 Reporting Cadence

| Report | Frequency | Audience | Owner |
|--------|-----------|----------|-------|
| Sprint Report | Weekly | Team + stakeholders | Team Lead |
| Quality Report | Weekly | Engineering | Quality Lead |
| Velocity Trends | Bi-weekly | Leads | Eng Manager |
| OKR Progress | Monthly | All engineering | Director |
| Incident Report | Per incident | All engineering | On-call |

### 8.3 Dashboard

```
┌─────────────────────────────────────────────────────────────────┐
│                    Shadow Engineering Dashboard                  │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Sprint Progress                    Team Velocity               │
│  ████████████████░░░░ 78%          ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄    │
│  12 of 16 stories done              Avg: 45 pts | This: 48 pts │
│                                                                 │
│  PR Stats (This Week)               Build Health               │
│  ├── Open: 12                       ├── Main: ✅ Passing        │
│  ├── Avg Review Time: 18 hrs        ├── Develop: ✅ Passing     │
│  └── Avg Merge Time: 32 hrs         └── Coverage: 87%          │
│                                                                 │
│  Dependencies                       Risks                       │
│  ├── 🟢 On Track: 4                 ├── 🟢 Low: 3              │
│  ├── 🟡 At Risk: 1                  ├── 🟡 Medium: 2           │
│  └── 🔴 Blocked: 0                  └── 🔴 High: 0             │
│                                                                 │
│  On-Call Status: @alice (primary) @bob (secondary)             │
│  Active Incidents: 0                                            │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-30 | Initial release |
