---
name: coding
description: Control document reading list. Invoke before writing any
  code. Also invoked during /startup so every cold instance reads the
  current standards before working.
---

## Overview

Read every document in this list fully before writing any code.
These are the control documents — code must comply with all of them.

When a new control document is added to the project, it gets added
to this list. This skill is the single place that defines what
"knows the standards" means.

---

## Control Documents

### 1. docs/specs/03_API_CONTRACTS.md
Exact interface definitions. Method signatures, return types, entity
fields, error codes. Code must match these exactly — no deviations.

### 2. docs/standards/01_CODING_STANDARDS.md
Mandatory patterns. Result types, error handling, timestamp rules,
enum conventions, repository patterns, use case structure.

### 3. docs/standards/02_TESTING_STRATEGY.md
Test coverage requirements, patterns, naming conventions, hygiene
rules. Every code change requires tests. No exceptions.

### 4. docs/standards/03_NAMING_CONVENTIONS.md
File naming, class naming, method naming, database naming. All
naming must follow these conventions exactly.

---

## When This Skill Is Invoked

- During /startup — every cold instance reads the control documents
  before doing any work
- In any prompt that involves writing code — the Architect includes
  /coding explicitly
- Not invoked for research-only or docs-only prompts

---

## Adding New Control Documents

When a new standard or spec is established that all code must comply
with, add it to this list. The skill is the registry — if it is not
here, instances will not know to read it.
