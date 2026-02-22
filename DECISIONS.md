# Shadow - Decision Log

**This document records significant decisions made during development, written in plain language so Reid can understand why things were done a certain way.**

---

## How to Read This

Each entry has:
- **Date** - when the decision was made
- **What** - what was decided, in plain language
- **Why** - the reasoning behind it
- **Alternatives** - what else was considered
- **Impact** - what this means for the app or future work

---

## Decisions

### 2026-02-21: Anchor Event dropdown uses code definitions, not UI spec wording

**What:** The Supplement Edit Screen's "Anchor Event" dropdown shows: Morning, Breakfast, Lunch, Dinner, Bedtime, and Specific Time. The UI spec (Section 4.1) listed slightly different labels (including "Evening"), but the actual code enum only has 5 values: wake, breakfast, lunch, dinner, bed. We mapped wake→"Morning" and bed→"Bedtime", and handled "Specific Time" as a special option that switches the timing mode.

**Why:** The API Contracts document (22_API_CONTRACTS.md) is the canonical source of truth. The enum has no "Evening" value, so we can't show it. "Specific Time" in the spec is actually a timing type, not an anchor event — it means "take at a specific clock time" rather than "take relative to a meal or activity."

**Alternatives:** Could have added an "Evening" enum value, but that would change the data model without Reid's approval. Followed the rule: no decisions, follow the code specs exactly.

**Impact:** Users see 6 anchor event options. If "Evening" is wanted later, it requires adding a new enum value and database migration.

---

### 2026-02-17: Include client_secret in Google sign-in (no proxy server needed)

**What:** Added the Google client_secret to the token exchange requests in the app. The app was failing to sign in because Google was rejecting requests without it. Also updated the OAuth spec (Section 10) which incorrectly claimed the secret wasn't needed.

**Why:** Google's token exchange was returning "client_secret is missing" when the app tried to complete sign-in. Research confirmed that while Google's documentation says the secret is "optional" for Desktop apps, in practice their servers require it. The old app handled this through a separate proxy server, but that approach adds unnecessary complexity — Google themselves say desktop client secrets are "obviously not treated as a secret" since anyone could pull them from the app. No proxy server will be needed for the App Store either, since iOS apps don't use a client_secret at all (Apple verifies the app through the App Store).

**Alternatives:** Could have set up a proxy server like the old app. This would mean running and paying for a separate server permanently — if it goes down, nobody can sign in. For a desktop app where the secret isn't really secret, this adds cost and a point of failure for no real security benefit.

**Impact:** Sign-in should now work. The client_secret is embedded in the app for development with a fallback value. For production builds, it must be provided via a launch flag. The OAuth spec is updated to reflect how Google actually works.

---

### 2026-02-14: Added spec coverage for Phase 1c cloud sync sign-in

**What:** Updated two spec documents to cover the new code from Phase 1c (wiring the Cloud Sync Setup screen to real Google sign-in). Added Sections 16.9–16.12 to the API Contracts spec (covering the auth state, the auth notifier, the email getter, and the provider declarations). Added Section 13.2 to the UI Field Specifications (covering all four visual states of the setup screen: initial, loading, signed-in, and error).

**Why:** Reid requires specs and code to match 100%. The Phase 1c code introduced new components (auth state management, screen state changes) that weren't covered by existing specs. This was caught and Reid directed the spec update.

**Alternatives:** None — spec/code parity is a non-negotiable requirement.

**Impact:** The spec now fully documents the current Cloud Sync Setup screen behavior. The spec also notes that the current auth provider pattern (StateNotifier) is an interim approach that will be replaced with the standard @riverpod annotation pattern when the auth domain layer is built in a future phase.

---

### 2026-02-14: Streamlined the instance coordination system

**What:** Reduced the instruction documents for Claude instances from ~3,500 lines across 10 skill files down to ~400 lines across 7 skill files. Deleted 3 skills that weren't working (manager, team, major-audit). Removed all instructions that told instances to spawn sub-agents.

**Why:** Instances were ignoring protocols because there was too much to read. Two skill files explicitly told instances to spawn agents (which caused the inconsistency problems Reid experienced). Simpler instructions are more likely to be followed.

**Alternatives:** Could have kept all skills and just patched the agent references, but the volume of documentation was itself a problem - instances would skip reading it after context compaction.

**Impact:** Future instances get shorter, clearer instructions. The plan checklist is now embedded directly in CLAUDE.md so instances always know what to work on. Agent spawning is prohibited at every level.

---

### 2026-02-14: Used SharedPreferences for profile storage instead of the encrypted database

**What:** The profile management feature (creating profiles, switching between them) stores profile data in a simple local storage system (SharedPreferences) rather than the encrypted database used for health data.

**Why:** Profiles don't contain sensitive health information - they're just names and settings. Using the simpler storage system avoided needing to build the full database integration for profiles (which is complex and requires code generation). The health data itself is still fully encrypted.

**Alternatives:** Could have built the full domain-layer Profile entity with encrypted database storage. This is still planned for later (item 7 on the plan) and would be needed for cloud sync of profiles.

**Impact:** Profile management works now with minimal code. When cloud sync is built, profiles will need to be migrated to the encrypted database so they can sync across devices.

---

### 2026-02-14: Committed working code and deleted broken code from previous instance

**What:** A previous Claude instance had done extensive work (54 files) but never committed any of it and left 6 files in a broken state. We committed the 54 working files and deleted the 6 broken ones.

**Why:** The broken files referenced other files that didn't exist yet, causing errors throughout the project. They were incomplete work from agents that were terminated mid-task.

**Alternatives:** Could have tried to fix the broken files, but they were scaffolding for features not yet needed (Google Drive provider, iCloud provider, domain Profile entity). Better to build them properly when the time comes.

**Impact:** The project is clean and all 1986 tests pass. The features those files were scaffolding for are on the plan as future work items.
