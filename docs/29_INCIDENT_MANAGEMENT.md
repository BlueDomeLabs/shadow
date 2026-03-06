# Shadow Incident Management

**Version:** 1.0
**Last Updated:** January 30, 2026
**Purpose:** Incident response, on-call rotation, and postmortem processes

---

## 1. Incident Severity Levels

### 1.1 Severity Definitions

| Severity | Definition | Examples | Response Time |
|----------|------------|----------|---------------|
| **SEV-1** | Complete outage or data loss | App crashes on launch, data corruption, PHI breach | Immediate |
| **SEV-2** | Major feature broken, degraded for all | Sync completely broken, can't log entries | 15 minutes |
| **SEV-3** | Feature broken for some users | Notifications not firing for subset | 1 hour |
| **SEV-4** | Minor issue, workaround exists | UI glitch, slow performance | 4 hours |

### 1.2 Severity Decision Tree

```
Is user health data at risk?
├── Yes → SEV-1
└── No → Can users use the core app?
         ├── No → SEV-1
         └── Yes → Is a major feature completely broken?
                  ├── Yes → SEV-2
                  └── No → Are many users affected?
                           ├── Yes → SEV-3
                           └── No → SEV-4
```

---

## 2. On-Call Rotation

### 2.1 Rotation Structure

```
Week 1: Team A Primary, Team B Secondary
Week 2: Team B Primary, Team C Secondary
Week 3: Team C Primary, Team D Secondary
... (rotating through all 6 feature teams)
```

**Rotation:**
- Primary: First responder, owns incident
- Secondary: Backup if primary unavailable
- Tertiary: Staff Engineer for escalation

### 2.2 On-Call Responsibilities

| Responsibility | Details |
|----------------|---------|
| **Monitor** | Check dashboards 3x during shift |
| **Respond** | Acknowledge alerts within SLA |
| **Communicate** | Update #shadow-incidents |
| **Resolve** | Drive to resolution or escalate |
| **Document** | Log actions in incident ticket |
| **Handoff** | Brief next on-call at shift end |

### 2.3 On-Call Schedule

| Period | Coverage | Expectation |
|--------|----------|-------------|
| Business hours (9-6) | Primary + team | Immediate response |
| After hours (6-10pm) | Primary | 30 min response |
| Night (10pm-9am) | Primary (pager) | SEV-1/2 only |
| Weekend | Primary (reduced) | SEV-1/2 only |

### 2.4 On-Call Compensation

| Tier | Compensation |
|------|--------------|
| On-call week | Flat stipend + comp time |
| Page answered | Per-page bonus |
| Incident worked | Hourly rate (after-hours) |
| Weekend incident | 2x hourly rate |

---

## 3. Incident Response

### 3.1 Response Workflow

```
Alert Triggered
      │
      ▼
Acknowledge (within SLA)
      │
      ▼
Assess Severity
      │
      ▼
┌─────┴─────┐
│           │
▼           ▼
SEV-1/2     SEV-3/4
    │           │
    ▼           ▼
Page secondary   Work during hours
Declare incident Track in ticket
Create war room  Update status
      │
      ▼
Investigate
      │
      ▼
Mitigate (stop bleeding)
      │
      ▼
Resolve (fix root cause)
      │
      ▼
Verify (confirm fixed)
      │
      ▼
Close Incident
      │
      ▼
Schedule Postmortem (SEV-1/2)
```

### 3.2 SEV-1/2 Response Protocol

**0-5 minutes:**
- Acknowledge page
- Join #shadow-incidents
- Post initial assessment

**5-15 minutes:**
- Declare incident formally
- Create incident ticket
- Page secondary if needed
- Start incident timeline

**15-30 minutes:**
- Identify scope
- Start mitigation
- Post update to stakeholders
- Consider feature flag rollback

**Every 30 minutes during incident:**
- Post status update
- Update ETA
- Evaluate escalation

### 3.3 Communication Template

```
🚨 INCIDENT DECLARED

Severity: SEV-2
Summary: Cloud sync failing for all users
Impact: Users cannot sync data across devices
Started: 2026-01-30 14:32 UTC
Status: Investigating

Current Actions:
- Checking Google Drive API status
- Reviewing error logs

Next Update: 15:00 UTC

Incident Commander: @alice
```

---

## 4. Incident Roles

### 4.1 Role Definitions

| Role | Responsibility | Who |
|------|----------------|-----|
| **Incident Commander (IC)** | Owns resolution, coordinates response | On-call primary |
| **Technical Lead** | Drives technical investigation | Senior engineer |
| **Scribe** | Documents timeline, actions | Volunteer or IC |
| **Communications** | Stakeholder updates | Eng Manager |

### 4.2 Incident Commander Duties

- Declare/close incident
- Assign roles
- Make decisions (or escalate)
- Ensure communication
- Call for help when needed
- Keep timeline updated
- Own postmortem scheduling

### 4.3 Escalation Path

```
On-Call Primary
      │ (15 min no progress)
      ▼
On-Call Secondary
      │ (15 min no progress)
      ▼
Staff Engineer
      │ (SEV-1 or no progress)
      ▼
Tech Lead
      │ (business impact)
      ▼
Engineering Director
      │ (company impact)
      ▼
Executive (CEO/CTO)
```

---

## 5. Postmortem Process

### 5.1 When Required

| Severity | Postmortem Required | Timeline |
|----------|---------------------|----------|
| SEV-1 | Always | Within 48 hours |
| SEV-2 | Always | Within 1 week |
| SEV-3 | If systemic | Within 2 weeks |
| SEV-4 | Optional | If valuable |

### 5.2 Postmortem Template

```markdown
# Postmortem: [Incident Title]

**Date:** 2026-01-30
**Severity:** SEV-2
**Duration:** 2 hours 15 minutes
**Author:** @incident-commander
**Reviewers:** @tech-lead, @staff-engineer

## Summary
Brief description of what happened and impact.

## Timeline
All times in UTC.

| Time | Event |
|------|-------|
| 14:32 | Alert triggered: Sync error rate > 5% |
| 14:35 | IC acknowledged, began investigation |
| 14:42 | Identified Google Drive API rate limiting |
| 14:55 | Implemented exponential backoff |
| 15:15 | Deployed fix to production |
| 15:45 | Error rate normalized |
| 16:47 | Incident closed |

## Root Cause
Our sync implementation was not rate-limited, causing us to exceed
Google Drive API quotas during peak usage.

## Impact
- Users affected: ~500
- Duration: 2 hours 15 minutes
- Data loss: None
- Revenue impact: None

## What Went Well
- Alert triggered quickly
- Team assembled within 10 minutes
- Fix deployed within 45 minutes of identification

## What Went Poorly
- No rate limiting in original implementation
- Took 20 minutes to identify root cause
- No runbook for Google Drive errors

## Action Items

| Action | Owner | Due Date | Status |
|--------|-------|----------|--------|
| Implement exponential backoff | @alice | Done | ✅ |
| Add rate limit monitoring | @bob | 2026-02-05 | 🔄 |
| Create Google Drive runbook | @charlie | 2026-02-10 | ⏳ |
| Add API quota alerts | @alice | 2026-02-07 | ⏳ |
| Load test sync with realistic traffic | @qa-lead | 2026-02-15 | ⏳ |

## Lessons Learned
1. Always implement rate limiting for external APIs
2. Load testing should include third-party API limits
3. Need better visibility into external dependency health
```

### 5.3 Postmortem Meeting

**Attendees:** IC, Tech Lead, affected team, optional observers
**Duration:** 1 hour max
**Agenda:**
1. Timeline review (15 min)
2. Root cause discussion (15 min)
3. Action item review (15 min)
4. Lessons learned (15 min)

**Rules:**
- Blameless (focus on systems, not people)
- Constructive (solutions, not complaints)
- Action-oriented (every finding needs an owner)
- Time-boxed (respect schedules)

---

## 6. Runbooks

### 6.1 Runbook Template

```markdown
# Runbook: [Issue Type]

**Last Updated:** 2026-01-30
**Owner:** @team-name

## Symptoms
- What alerts fire?
- What does the user see?
- What metrics indicate this issue?

## Likely Causes
1. Cause A (most common)
2. Cause B
3. Cause C

## Diagnosis Steps
1. Check X dashboard
2. Run Y query
3. Look for Z in logs

## Resolution Steps

### For Cause A
1. Step 1
2. Step 2
3. Step 3

### For Cause B
1. Step 1
2. Step 2

## Escalation
If not resolved in 30 minutes, escalate to @team-lead.

## Prevention
How to prevent this from recurring.

## Related
- Link to relevant docs
- Link to related runbooks
```

### 6.2 Required Runbooks

| Runbook | Owner |
|---------|-------|
| App Crash Investigation | Core Team |
| Sync Failures | Team Sync |
| Auth/OAuth Errors | Team Platform |
| Database Issues | Core Team |
| Notification Failures | Team Platform |
| Performance Degradation | Core Team |
| Feature Flag Emergency | All Leads |

---

## 7. Metrics & SLOs

### 7.1 Service Level Objectives

| Metric | SLO | Measurement |
|--------|-----|-------------|
| Availability | 99.9% | App launches successfully |
| Sync Success Rate | 99.5% | Syncs complete without error |
| Notification Delivery | 98% | Notifications delivered on time |
| P95 Response Time | <2s | Key user actions |
| Error Rate | <0.1% | Unhandled exceptions |

### 7.2 Error Budget

Monthly error budget = 100% - SLO

| SLO | Monthly Budget |
|-----|----------------|
| 99.9% | 43 minutes downtime |
| 99.5% | 3.6 hours issues |
| 98% | 14.4 hours issues |

When error budget exhausted:
- Freeze non-critical deployments
- Focus on reliability work
- Postmortem all incidents that month

### 7.3 Alerting

| Alert | Threshold | Severity |
|-------|-----------|----------|
| Error rate spike | >1% for 5 min | SEV-2 |
| Crash rate | >0.5% | SEV-1 |
| Sync failures | >5% for 10 min | SEV-2 |
| API latency | P95 >5s | SEV-3 |
| Memory usage | >300MB | SEV-3 |

---

## 8. Training

### 8.1 On-Call Training

Before joining rotation:
- [ ] Shadow on-call for 2 weeks
- [ ] Complete incident response training
- [ ] Review all runbooks
- [ ] Participate in incident drill
- [ ] Pass on-call certification quiz

### 8.2 Incident Drills

Quarterly game days:
- Simulated SEV-1 incident
- Practice response protocol
- Identify gaps in runbooks
- Build muscle memory

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-30 | Initial release |
