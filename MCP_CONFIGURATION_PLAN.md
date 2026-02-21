# MCP Configuration Plan — Shadow / Blue Dome Labs
**Created:** 2026-02-21
**Author:** Reid Barcus (via Claude on claude.ai)
**Status:** IN PROGRESS — Node.js version check pending

---

## Context

This plan was created during a session where Reid Barcus and Claude (claude.ai) worked together to:
1. Push the Shadow project to GitHub at `https://github.com/BlueDomeLabs/shadow.git`
2. Configure git identity as Reid Barcus / reid@bluedomecolorado.com
3. Plan MCP configuration for Claude Code's development workflow

MCPs (Model Context Protocol servers) give Claude Code live access to external tools and services while building. This plan documents which MCPs to install, where to configure them, and in what order.

---

## Architecture Decision

MCPs are configured at two levels:

### Project-Level (`/Users/reidbarcus/Development/Shadow`)
For tools specific to the Shadow app only.

### Root-Level (`/Users/reidbarcus`)
For tools that apply to every project Reid builds under Blue Dome Labs.

---

## Phase 1 — Project-Level MCPs (Shadow folder)
*Do these first. These are specific to Shadow.*

### 1.1 GitHub MCP (Project-Scoped)
- **Purpose:** Lets Claude Code create branches, commit, push, manage issues, and review history for the Shadow repo directly — without Reid relaying git commands manually.
- **Repo:** `https://github.com/BlueDomeLabs/shadow.git`
- **Requires:** Node.js, GitHub Personal Access Token with `repo` + `workflow` scopes
- **Status:** ⬜ NOT CONFIGURED

### 1.2 Flutter/Dart Documentation MCP
- **Purpose:** Gives Claude Code live access to current Flutter and Dart documentation so he's not relying on potentially outdated training data when building features.
- **Requires:** Node.js
- **Status:** ⬜ NOT CONFIGURED

---

## Phase 2 — Root-Level MCPs (`/Users/reidbarcus`)
*Do these after Phase 1. These apply to all future Blue Dome Labs projects.*

### 2.1 GitHub MCP (Global)
- **Purpose:** Global GitHub account access for Blue Dome Labs — managing repos, creating new projects, cross-repo operations.
- **Account:** BlueDomeLabs GitHub (reid@bluedomecolorado.com)
- **Requires:** Node.js, GitHub Personal Access Token
- **Status:** ✅ CONFIGURED and working — verified live by listing BlueDomeLabs repositories successfully

### 2.2 Filesystem MCP
- **Purpose:** Gives Claude Code smarter, structured navigation of the entire Development folder — useful when cross-referencing spec docs, managing multiple projects, etc.
- **Requires:** Node.js
- **Status:** ⬜ NOT CONFIGURED

---

## Phase 3 — Future MCPs (Configure when development reaches these features)

### 3.1 Google Drive MCP
- **Purpose:** Direct access to Google Drive for cloud sync development — Claude Code can read/write Drive files while building the sync feature.
- **When:** When resuming cloud sync implementation (see handoff doc)
- **Note:** Google OAuth is already partially implemented in Shadow. This MCP supports the development workflow, not the app itself.
- **Status:** ⬜ FUTURE

### 3.2 Firebase MCP
- **Purpose:** If Shadow adds Firebase as a backend database, this lets Claude Code query and manage the database directly while building features.
- **When:** If/when Firebase is adopted
- **Status:** ⬜ FUTURE — decision not yet made

---

## Installation Prerequisites

Before any MCP can be installed, verify:

- [ ] Node.js is installed — run `node --version` (need v18 or higher)
- [ ] npm is available — run `npm --version`
- [x] GitHub PAT with `repo` + `workflow` + `read:org` scopes exists — rotated on 2026-02-21, no expiration, stored in Mac Keychain under 'GitHub PAT' / 'BlueDomeLabs'

---

## Installation Process (for each MCP)

MCPs are added to `~/.claude.json` under the relevant project path in the `mcpServers` object. The format is:

```json
"mcpServers": {
  "mcp-name": {
    "command": "npx",
    "args": ["-y", "@package/name"],
    "env": {
      "API_KEY": "your-key-here"
    }
  }
}
```

Claude Code handles the actual file editing. Reid relays commands between claude.ai (architect) and Claude Code (executor).

---

## Current Session State (if resuming)

When resuming this work in a new session, tell Claude on claude.ai:

> "We are resuming MCP configuration for the Shadow project. We have already pushed Shadow to GitHub at https://github.com/BlueDomeLabs/shadow.git. Git identity is configured. Zero MCPs are currently configured. We were about to check Node.js version and then configure the GitHub MCP at the project level. The plan is stored in MCP_CONFIGURATION_PLAN.md in the project root. Please read it and continue from where we left off."

---

## Completed Steps This Session

- [x] Reviewed `.gitignore` — confirmed correct Flutter configuration with OAuth credentials protected
- [x] Reviewed `lib/` structure — confirmed clean architecture (core/data/domain/presentation)
- [x] Reviewed `.claude/settings.json` — confirmed agent-spawning hooks, no MCPs configured
- [x] Reviewed `.claude.json` — confirmed zero MCPs at any level, clean slate
- [x] Created GitHub account for Blue Dome Labs (reid@bluedomecolorado.com)
- [x] Created `shadow` repository at `https://github.com/BlueDomeLabs/shadow.git`
- [x] Initialized git, committed pending changes, connected remote
- [x] Generated GitHub PAT with `repo` + `workflow` scopes
- [x] Successfully pushed all Shadow code to GitHub
- [x] Configured git identity: Reid Barcus / reid@bluedomecolorado.com
- [x] Reviewed handoff doc — noted pending spec updates, UI fixes, cloud sync and reports unimplemented
- [x] Decided to configure MCPs before resuming development

---

## Notes

- The majority of previous Claude Code sessions ran in `/Users/reidbarcus` (root), not the Shadow project folder. Future sessions should run in the project folder `/Users/reidbarcus/Development/Shadow` for Shadow work.
- Claude Code account is currently logged in as `reidbarcus@gmail.com` — consider migrating to `reid@bluedomecolorado.com` for Blue Dome Labs professionalism (not urgent, not blocking).
- autoUpdates is set to `false` in `.claude.json` — consider enabling so Claude Code stays current.
