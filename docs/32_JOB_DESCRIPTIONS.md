# Shadow Engineering Job Descriptions

**Version:** 1.0
**Last Updated:** January 30, 2026
**Purpose:** Hiring specifications for all engineering roles

---

## 1. Hiring Summary

### 1.1 Headcount by Phase

| Phase | Weeks | New Hires | Total |
|-------|-------|-----------|-------|
| Phase 0 | 1-2 | 3 (Core Team) | 3 |
| Phase 1 | 3-6 | 8 (UI + Quality) | 11 |
| Phase 2 | 7-12 | 48 (Feature Teams) | 59 |
| Phase 3+ | 13+ | 41 (Remaining + Staff) | 100 |

### 1.2 Role Distribution

| Role | Count | Level |
|------|-------|-------|
| Engineering Director | 1 | Director |
| Tech Lead | 4 | E4/Staff |
| Staff Engineer | 3 | E4 |
| Engineering Manager | 1 | M1 |
| Senior Engineer | 30 | E3 |
| Engineer | 40 | E2 |
| Associate Engineer | 20 | E1 |
| Quality Engineer | 4 | E2-E3 |

---

## 2. Core Team Roles (Hire Week 1)

### 2.1 Senior Engineer, Core Platform (3 positions)

**Team:** Core Team
**Reports to:** Tech Lead - Core Platform
**Level:** E3 (Senior)

#### Job Summary
Design and implement the foundational architecture for Shadow, including entities, repositories, database layer, and shared services. Your work enables all feature teams.

#### Responsibilities
- Implement Clean Architecture patterns (entities, repositories, use cases)
- Design and maintain the Drift database schema
- Create Result type and error handling infrastructure
- Build shared services (encryption, logging, device info)
- Define API contracts for all repository interfaces
- Write contract tests verifying interface compliance
- Review PRs from feature teams touching core code
- Mentor engineers on architectural patterns

#### Requirements
**Must Have:**
- 5+ years software engineering experience
- 3+ years Flutter/Dart experience
- Experience with Clean Architecture or similar
- Strong SQL and database design skills
- Experience with code generation (build_runner, freezed)
- History of building foundational/platform code
- Excellent written communication (for documentation)

**Nice to Have:**
- Experience with SQLCipher or encrypted databases
- Healthcare/HIPAA experience
- Riverpod experience
- Drift ORM experience

#### Technical Assessment
1. Design a repository pattern for a health entity (whiteboard)
2. Implement Result type with error handling (live coding)
3. Review a PR with intentional issues (code review)

#### Interview Process
1. Recruiter screen (30 min)
2. Technical phone screen (60 min)
3. Onsite: System design (60 min)
4. Onsite: Live coding (60 min)
5. Onsite: Code review exercise (45 min)
6. Onsite: Values/culture (45 min)

---

## 3. UI Team Roles (Hire Week 3)

### 3.1 Senior Engineer, Design Systems (1 position)

**Team:** UI Team
**Reports to:** Tech Lead - UI/UX
**Level:** E3 (Senior)

#### Job Summary
Own the Shadow design system and consolidated widget library. Ensure consistent, accessible UI components across the entire application.

#### Responsibilities
- Build and maintain consolidated widget library (15 core widgets)
- Implement earth tone theme and AppColors
- Ensure WCAG 2.1 Level AA compliance for all widgets
- Create widget documentation with usage examples
- Review all UI-related PRs for consistency
- Partner with design on component specifications
- Conduct accessibility audits
- Train feature teams on widget usage

#### Requirements
**Must Have:**
- 4+ years Flutter experience
- Deep understanding of Flutter widget lifecycle
- Experience building reusable component libraries
- Strong accessibility knowledge (WCAG, VoiceOver, TalkBack)
- Eye for design consistency
- Experience with theming and design tokens

**Nice to Have:**
- Experience with Storybook or widget catalogs
- Animation and motion design experience
- Previous design system ownership

---

### 3.2 Engineer, UI Components (3 positions)

**Team:** UI Team
**Reports to:** Senior Engineer, Design Systems
**Level:** E2 (Engineer)

#### Job Summary
Build accessible, reusable UI components following the design system. Implement complex widgets like charts and pickers.

#### Responsibilities
- Implement widget variants (buttons, inputs, cards)
- Build specialized widgets (BBT chart, flow picker, time selector)
- Write widget tests for all components
- Ensure semantic labels and accessibility
- Document widget APIs and usage
- Support feature teams with widget integration

#### Requirements
**Must Have:**
- 2+ years Flutter experience
- Understanding of widget composition
- Experience with custom painting/charts
- Accessibility awareness
- Testing experience (widget tests)

**Nice to Have:**
- Experience with fl_chart or similar
- Animation experience
- Previous component library work

---

## 4. Feature Team Roles (Hire Weeks 7-12)

### 4.1 Senior Engineer, Team Lead (6 positions)

**Teams:** Conditions, Supplements, Nutrition, Wellness, Sync, Platform
**Reports to:** Tech Lead - Features
**Level:** E3 (Senior)

#### Job Summary
Lead a feature team of 8 engineers. Own a vertical slice of the application from UI to data layer.

#### Responsibilities
- Lead technical direction for your domain
- Break down features into implementable tasks
- Conduct code reviews for team PRs
- Ensure team follows API contracts and patterns
- Mentor E1 and E2 engineers on your team
- Coordinate with other teams on dependencies
- Participate in architecture reviews
- Own on-call rotation for your domain

#### Requirements
**Must Have:**
- 5+ years software engineering experience
- 2+ years Flutter experience
- Previous tech lead or team lead experience
- Strong mentoring track record
- Experience with full-stack feature development
- Excellent communication skills

**Specific to Team:**
| Team | Additional Requirements |
|------|------------------------|
| Conditions | Experience with photo/image handling |
| Supplements | Experience with scheduling/calendar logic |
| Nutrition | Experience with search/filtering |
| Wellness | Experience with data visualization |
| Sync | Experience with distributed systems, conflict resolution |
| Platform | Experience with push notifications, deep linking |

---

### 4.2 Engineer, Feature Development (24 positions)

**Teams:** 4 per feature team
**Reports to:** Senior Engineer, Team Lead
**Level:** E2 (Engineer)

#### Job Summary
Build features end-to-end within your domain. Implement screens, providers, use cases, and tests.

#### Responsibilities
- Implement assigned features following specs
- Write use cases with Result type pattern
- Build screens using consolidated widgets
- Write unit and widget tests
- Participate in code reviews
- Update documentation for changes
- Participate in on-call rotation

#### Requirements
**Must Have:**
- 2+ years software engineering experience
- 1+ years Flutter experience
- Understanding of state management
- Experience with async programming
- Testing experience

**Nice to Have:**
- Experience with Riverpod
- Experience with code generation
- Mobile app deployment experience

---

### 4.3 Associate Engineer (12 positions)

**Teams:** 2 per feature team
**Reports to:** Senior Engineer, Team Lead
**Level:** E1 (Associate)

#### Job Summary
Learn and contribute to feature development with mentorship. Focus on smaller tasks and bug fixes while building skills.

#### Responsibilities
- Complete assigned tasks with mentor guidance
- Fix bugs in your team's domain
- Write tests for existing code
- Participate in code reviews (as learner)
- Ask questions and learn patterns
- Document learnings for future engineers

#### Requirements
**Must Have:**
- CS degree or equivalent experience
- Basic Flutter/Dart knowledge
- Eagerness to learn
- Good communication skills
- Ability to ask for help

**Nice to Have:**
- Personal Flutter projects
- Internship experience
- Open source contributions

---

## 5. Quality Team Roles (Hire Week 5)

### 5.1 Senior Quality Engineer (2 positions)

**Team:** Quality Team
**Reports to:** Tech Lead - Quality
**Level:** E3 (Senior)

#### Job Summary
Own test infrastructure, CI/CD pipelines, and release engineering. Ensure quality gates are enforced.

#### Responsibilities
- Maintain CI/CD pipelines (GitHub Actions)
- Build integration test framework
- Create and maintain contract test suite
- Define and enforce coverage thresholds
- Manage beta and production releases
- Conduct release readiness reviews
- Train teams on testing practices

#### Requirements
**Must Have:**
- 4+ years QA/SDET experience
- Experience with Flutter testing (unit, widget, integration)
- CI/CD pipeline experience (GitHub Actions preferred)
- Experience with test automation frameworks
- Release management experience

**Nice to Have:**
- Mobile app store release experience
- Experience with code coverage tools
- Performance testing experience

---

### 5.2 Quality Engineer (2 positions)

**Team:** Quality Team
**Reports to:** Senior Quality Engineer
**Level:** E2 (Engineer)

#### Job Summary
Build and maintain test automation. Support feature teams with testing best practices.

#### Responsibilities
- Write integration tests for user flows
- Maintain test data generators
- Monitor test health and fix flaky tests
- Support teams with testing questions
- Participate in bug bashes
- Document testing patterns

#### Requirements
**Must Have:**
- 2+ years QA experience
- Flutter testing experience
- Understanding of test pyramid
- Debugging skills

---

## 6. Leadership Roles

### 6.1 Tech Lead, Core Platform (1 position)

**Team:** Core Team
**Reports to:** Engineering Director
**Level:** E4 (Staff)

#### Job Summary
Own technical direction for Shadow's foundation. Lead the Core Team and guide architectural decisions.

#### Responsibilities
- Define and evolve Shadow architecture
- Lead ADR process and architecture reviews
- Own API contracts and interface definitions
- Manage Core Team (3 engineers)
- Coordinate with all feature teams
- Resolve technical disputes
- Represent engineering in planning

#### Requirements
**Must Have:**
- 8+ years software engineering experience
- 4+ years Flutter experience
- Previous architect or tech lead role
- Experience defining APIs and contracts
- Track record of cross-team leadership
- Excellent written documentation skills

---

### 6.2 Engineering Manager, Operations (1 position)

**Reports to:** Engineering Director
**Level:** M1

#### Job Summary
Own engineering operations, processes, and team health. Manage on-call, incidents, and operational excellence.

#### Responsibilities
- Own on-call rotation and incident process
- Manage postmortem process
- Define and track engineering metrics
- Own team health surveys and action items
- Coordinate cross-team processes
- Manage operations team (2 engineers)
- Partner with Tech Leads on career development

#### Requirements
**Must Have:**
- 5+ years engineering experience
- 2+ years people management experience
- Experience with incident management
- Strong process improvement skills
- Excellent communication skills
- Experience with engineering metrics

---

### 6.3 Staff Engineer (3 positions)

**Reports to:** Engineering Director
**Level:** E4 (Staff)

#### Job Summary
Cross-cutting technical leadership. Own specific domains (Architecture, Performance, Security) across all teams.

#### Responsibilities
- Solve hardest technical problems
- Define patterns for your domain
- Review cross-team technical decisions
- Mentor senior engineers toward staff
- Represent domain in architecture reviews
- Write RFCs and ADRs for major changes

#### Requirements
**Must Have:**
- 8+ years software engineering experience
- Deep expertise in assigned domain
- Cross-team influence experience
- Strong written communication
- Mentoring track record

**Domain-Specific:**

| Domain | Additional Requirements |
|--------|------------------------|
| Architecture | System design, API design, Clean Architecture |
| Performance | Profiling, optimization, mobile performance |
| Security | Encryption, HIPAA, mobile security |

---

## 7. Interview Rubrics

### 7.1 Technical Assessment (All Roles)

| Criteria | 1 (No Hire) | 2 (Weak) | 3 (Hire) | 4 (Strong Hire) |
|----------|-------------|----------|----------|-----------------|
| Problem Solving | Cannot approach problem | Needs heavy guidance | Solves with minor hints | Elegant solution independently |
| Code Quality | Messy, bugs | Works but poor style | Clean, follows patterns | Exemplary, teaches patterns |
| Testing | No testing mention | Basic tests | Comprehensive tests | TDD, edge cases |
| Communication | Cannot explain | Unclear explanation | Clear explanation | Teaches concept |

### 7.2 Values Assessment (All Roles)

| Value | Questions |
|-------|-----------|
| Quality | "Tell me about a time you pushed back on shipping something not ready" |
| Ownership | "Describe a time you owned a problem outside your job description" |
| Collaboration | "How do you handle disagreement with a teammate's approach?" |
| Growth | "What's something you learned recently and how did you learn it?" |

---

## 8. Onboarding Assignments

### 8.1 First Week Mentor Assignments

| New Hire Role | Mentor Role | Mentor Team |
|---------------|-------------|-------------|
| Core Engineer | Existing Core Engineer | Core |
| UI Engineer | Senior UI Engineer | UI |
| Feature Engineer | Team Lead | Their feature team |
| Quality Engineer | Senior Quality Engineer | Quality |

### 8.2 First Task Assignments

| Role | First Task | Complexity |
|------|-----------|-----------|
| Associate Engineer | Bug fix or test addition | Low |
| Engineer | Small feature or enhancement | Medium |
| Senior Engineer | Medium feature with design | Medium-High |
| Staff Engineer | Architecture review or ADR | High |

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-30 | Initial release |
