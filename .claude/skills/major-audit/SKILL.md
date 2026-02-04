# Major Audit Skill

## Purpose

Monthly comprehensive review of Shadow's Coding Standards against current industry best practices from companies like Apple, Google, and other industry leaders.

## Invocation

- Command: `/major-audit`
- Frequency: Monthly (or on-demand)
- Duration: Extensive task - may span multiple sessions

---

## IMPLEMENTATION PLAN

**Status: NOT YET IMPLEMENTED**

This skill requires significant work to implement. The following is the plan for building out this capability.

---

### Phase 1: Research Framework Setup

**Objective:** Establish authoritative sources for best practices

**Tasks:**
1. Identify authoritative sources to monitor:
   - Apple Human Interface Guidelines
   - Apple Swift/iOS coding guidelines
   - Google Flutter/Dart style guide
   - Google Android development best practices
   - Effective Dart documentation
   - Flutter team's recommended patterns
   - Clean Architecture references (Robert Martin)
   - Enterprise mobile development standards

2. Create a reference document listing:
   - Source URLs
   - Last reviewed date
   - Key areas covered by each source
   - Update frequency of each source

3. Define comparison categories:
   - Naming conventions
   - Architecture patterns
   - Error handling
   - State management
   - Testing practices
   - Security standards
   - Performance guidelines
   - Accessibility requirements
   - Documentation standards
   - Code organization

**Deliverable:** `.claude/audit-config/best-practices-sources.md`

---

### Phase 2: Internal Standards Inventory

**Objective:** Catalog all internal coding standards

**Tasks:**
1. Inventory all standards documents:
   - 02_CODING_STANDARDS.md
   - 22_API_CONTRACTS.md
   - Any ADRs with coding implications
   - Project-specific conventions in CLAUDE.md

2. Extract and categorize each standard:
   - Create structured index of all rules
   - Tag each rule by category
   - Note the rationale for each rule (if documented)

3. Identify gaps in documentation:
   - Areas with no documented standard
   - Areas with vague or incomplete standards

**Deliverable:** `.claude/audit-config/internal-standards-index.md`

---

### Phase 3: Comparison Protocol

**Objective:** Define systematic comparison process

**Tasks:**
1. Design comparison checklist template:
   ```
   Category: [e.g., Error Handling]
   Internal Standard: [Our rule]
   External Best Practice: [Industry standard]
   Source: [Where we found it]
   Alignment: [Match / Partial / Mismatch / Gap]
   Recommendation: [Keep / Update / Add]
   Priority: [Critical / High / Medium / Low]
   ```

2. Define severity classifications:
   - Critical: Security, data integrity, crashes
   - High: Architecture, maintainability
   - Medium: Code quality, consistency
   - Low: Style preferences, minor improvements

3. Create update proposal template for recommending changes

**Deliverable:** `.claude/audit-config/comparison-protocol.md`

---

### Phase 4: Audit Execution Process

**Objective:** Define how to run the monthly audit

**Tasks:**
1. Pre-audit preparation:
   - Fetch latest versions of external guidelines (WebSearch/WebFetch)
   - Note any major announcements from Flutter/Dart team
   - Check for new Dart/Flutter version considerations

2. Systematic comparison:
   - Work through each category
   - Document findings in structured format
   - Flag items requiring attention

3. Prioritization:
   - Rank findings by severity
   - Consider implementation effort
   - Balance stability vs improvement

4. Report generation:
   - Executive summary
   - Detailed findings
   - Recommended actions
   - Timeline for updates

**Deliverable:** Monthly audit report template

---

### Phase 5: Update Integration Process

**Objective:** Define how to integrate approved changes

**Tasks:**
1. Change proposal workflow:
   - Document proposed change
   - Assess impact on existing code
   - Get user approval before implementation

2. Standards update process:
   - Update documentation
   - Update any affected specs
   - Update CLAUDE.md if needed

3. Code migration process:
   - Identify affected code
   - Plan migration approach
   - Execute with tests

4. Verification:
   - Confirm documentation updated
   - Confirm code complies
   - Confirm tests pass

**Deliverable:** `.claude/audit-config/update-workflow.md`

---

## Estimated Implementation Effort

| Phase | Effort | Dependencies |
|-------|--------|--------------|
| Phase 1: Research Framework | 2-3 hours | None |
| Phase 2: Internal Inventory | 1-2 hours | None |
| Phase 3: Comparison Protocol | 1 hour | Phase 1, 2 |
| Phase 4: Execution Process | 2 hours | Phase 3 |
| Phase 5: Update Integration | 1 hour | Phase 4 |

**Total setup:** ~8-10 hours across multiple sessions

**Monthly execution:** ~2-4 hours per audit

---

## Future Enhancements

- Automated monitoring for Flutter/Dart release notes
- Diff tracking between audit runs
- Integration with project tracker for scheduling
- Metrics dashboard showing standards compliance over time

---

## Notes

This skill is designed for strategic, monthly review - not for tactical, day-to-day compliance checking. For immediate spec compliance verification, use the `/compliance` skill instead.
