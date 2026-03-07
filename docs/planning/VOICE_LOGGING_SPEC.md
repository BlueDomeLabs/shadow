# VOICE_LOGGING_SPEC.md
# Shadow — Conversational Voice Logging Assistant
# Phase 19 Feature Specification
# Status: APPROVED — All decisions resolved. Ready for Phase 19 implementation queue.
# Last Updated: 2026-03-07
# Author: The Architect

---

## Decisions Record

All five pre-spec decisions captured here as the authoritative record.

| # | Question | Decision |
|---|----------|----------|
| 1 | Text input fallback? | Yes — always available, no toggle required |
| 2 | Cross-session memory? | Yes — rolling window of recent sessions |
| 3 | Notification priority order | 1. Most recently triggered · 2. User-defined · 3. Time-sensitive/overdue · 4. Morning routine |
| 4 | Closing message scope | Per-profile — each profile has its own setting |
| 5 | Session length cap? | No — work through everything, no cutoff |

---

## Sequencing Requirement

**Phase 19 does not begin until all of the following are complete and Architect-verified:**

1. Groups A, B, and L audit findings (AUDIT_FINDINGS.md) fully resolved
2. Fluids Restructuring (FLUIDS_RESTRUCTURING_SPEC.md) fully complete — `bodily_output_logs`
   table and `LogBodilyOutputUseCase` must exist before Phase 19 implementation begins

```
[Groups A, B, L audit fixes] → [Fluids Restructuring] → [Phase 19: Voice Logging]
```

---

## 1. Architecture Overview

The Conversational Voice Logging Assistant is a self-contained subsystem that sits above
Shadow's existing use case layer. It does not bypass or replace any existing data flow —
it orchestrates calls to existing use cases through a conversational interface.

```
┌─────────────────────────────────────────────────────────────────┐
│                    VOICE LOGGING SUBSYSTEM                       │
│                                                                  │
│  ┌──────────────┐    ┌───────────────────┐    ┌──────────────┐  │
│  │ Notification │    │  Session Manager  │    │  Voice       │  │
│  │ Queue Builder│───▶│  (state machine)  │◀──▶│  Pipeline    │  │
│  └──────────────┘    └────────┬──────────┘    └──────────────┘  │
│                               │                                  │
│                    ┌──────────▼──────────┐                       │
│                    │  Claude API Client  │                       │
│                    │  (existing + ext.)  │                       │
│                    └──────────┬──────────┘                       │
│                               │                                  │
│                    ┌──────────▼──────────┐                       │
│                    │  Data Extractor     │                       │
│                    │  (use case router)  │                       │
│                    └──────────┬──────────┘                       │
│                               │                                  │
└───────────────────────────────┼─────────────────────────────────┘
                                │
              ┌─────────────────▼──────────────────┐
              │     EXISTING SHADOW USE CASES       │
              │  LogFood · LogFluids · LogSleep ·   │
              │  LogCondition · MarkIntakeTaken ·   │
              │  LogActivity · CreateJournalEntry · │
              │  LogFlareUp · (others)              │
              └────────────────────────────────────┘
```

### Component Responsibilities

**Notification Queue Builder** — Queries existing notification infrastructure at session
open to determine which items are pending for the current profile. Applies priority order.
Does not persist a separate queue table — the queue is built fresh each session.

**Session Manager** — The state machine governing a voice session from open to close.
Tracks which queue items have been answered, holds current conversation context,
coordinates between the voice pipeline and Claude API, manages the confirmation layer,
and calls the data extractor when an item is confirmed.

**Voice Pipeline** — Bidirectional voice I/O. Converts user speech to text (input to
Claude) and converts Claude's responses to speech (output to user). Displays text
simultaneously on screen. Text input field always available as fallback.

**Claude API Client** — The existing `AnthropicApiClient` extended to support
conversational logging sessions. Accepts a structured request containing profile context,
pending queue, recent session history, and conversation thread. Returns structured JSON
specifying the next question, any confirmed items ready to log, and session state signals.

**Data Extractor** — Receives confirmed item JSON from Claude. Routes each item to the
correct existing use case. Never writes to the database directly — always goes through
the domain use case layer.

**Voice Logging Settings** (per-profile) — Stored in a new `voice_logging_settings`
table. Controls closing message style and user-defined notification category priority.

**Voice Session History** — A rolling window of recent session turns stored in a new
`voice_session_history` table. Provides Claude with personalization context. Local-only,
not synced to Google Drive.

### Navigation Architecture

Phase 19 builds the AI assistant interface as the app's primary root route —
not a modal pushed over the existing tab navigation. When the user opens the
app, they arrive at the AI chat interface directly. The tab grid remains
accessible via a persistent bottom navigation element.

This is the permanent architecture, not a placeholder. The design decision is
final: the AI assistant is the home screen for Shadow and all future Ember apps.

The existing `HomeScreen` tab scaffold is demoted from the root route. Navigation
structure:
- Root route → `VoiceLoggingScreen` (AI assistant home)
- Persistent bottom nav → access to all existing tabs
- Notification tap → opens `VoiceLoggingScreen` with pending items queued

---

## 2. New Database Tables

Two new tables are required. Both are local-only (not synced to Google Drive).

### 2.1 voice_logging_settings

Per-profile voice logging configuration. One row per profile.

```
Table: voice_logging_settings
Schema version: v21 (added in Phase 19)
Sync: Local-only — not synced to Google Drive
```

| Column | Type | Description |
|--------|------|-------------|
| id | TEXT PK | UUID v4 — same as profileId (singleton per profile) |
| profile_id | TEXT NOT NULL | FK → profiles(id) |
| closing_style | INTEGER NOT NULL DEFAULT 1 | ClosingStyle enum: 0=none · 1=random · 2=fixed |
| fixed_farewell | TEXT | User's custom farewell phrase (used when closing_style=2) |
| category_priority_order | TEXT | JSON array of NotificationCategory int values defining user sort order. NULL = use system default |
| created_at | INTEGER NOT NULL | Epoch ms |
| updated_at | INTEGER | Epoch ms |

**ClosingStyle enum values:**

| Value | Name | Behavior |
|-------|------|----------|
| 0 | none | Session ends with "You're all caught up." + forward-looking note only |
| 1 | random | Claude generates a warm, varied farewell. No two consecutive sessions get the same phrase |
| 2 | fixed | Claude always ends with the exact phrase stored in `fixed_farewell` |

**Exemption from standard sync metadata:** `voice_logging_settings` is per-device
configuration (like `user_settings` and `notification_category_settings`). It does not
sync to Google Drive. Add to Section 2.7 exemption list in DATABASE_SCHEMA.md.

---

### 2.2 voice_session_history

Rolling log of conversation turns for cross-session personalization. One row per
conversational exchange (user turn + assistant turn = one row).

```
Table: voice_session_history
Schema version: v21 (added in Phase 19)
Sync: Local-only — not synced to Google Drive
Retention: Rolling 90-day window. Rows older than 90 days are deleted at session open.
```

| Column | Type | Description |
|--------|------|-------------|
| id | TEXT PK | UUID v4 |
| profile_id | TEXT NOT NULL | FK → profiles(id) |
| session_id | TEXT NOT NULL | UUID v4 identifying the parent session |
| turn_index | INTEGER NOT NULL | Position within session (0-based) |
| role | INTEGER NOT NULL | 0=assistant · 1=user |
| content | TEXT NOT NULL | The spoken/typed text for this turn |
| logged_item_type | INTEGER | LoggableItemType enum value if this turn resulted in a logged item. NULL otherwise |
| created_at | INTEGER NOT NULL | Epoch ms |

**Index:** `(profile_id, created_at DESC)` — supports efficient rolling window queries.

**Retention rule:** At the start of each new voice session, delete all rows for this
profile where `created_at < now - 90 days`. This is the only maintenance needed.

**Exemption from standard sync metadata:** Same rationale as `user_settings`. Device-local
personalization context. Add to Section 2.7 exemption list.

---

## 3. Notification Queue Builder

### 3.1 How the Queue is Built

At session open, `VoiceSessionQueueBuilder` queries the existing notification
infrastructure to determine what is pending for the active profile. It does not maintain
its own persistent queue. The pending state lives in the notification system.

**Query logic (executed in priority order):**

```
Step 1: Get all NotificationCategorySettings for the current profile
Step 2: For each category, determine if there is a pending unlogged item
        for today / the relevant time window
Step 3: Collect all pending items into a VoiceSessionQueue
Step 4: Sort by priority (see section 3.2)
Step 5: Return queue to Session Manager
```

**What "pending" means per category:**

| Category | Pending condition |
|----------|------------------|
| Food logging | No food_log entry in the current meal window (breakfast/lunch/dinner) |
| Fluids | Today's fluid total is below target |
| Sleep | No sleep_entry for last night |
| Medications/supplements | intake_log has status=pending for scheduled items due ≤ now |
| Condition logs | No condition_log for today for active tracked conditions |
| Journal | A journal notification fired and no journal_entry exists today |
| Activity | An activity notification fired and no activity_log exists today |
| Flare-up check | A flare-up is currently open (end not recorded) |
| Photos | A photo reminder notification fired with no photo_entry today for that area |

**Note on bowel/urination tracking:** `bowel_urine_logs` is deprecated (schema v1.8).
This item appears in the example conversation. Before Phase 19 implementation begins, Reid
must decide: (a) resurrect a dedicated table, (b) log via condition_logs, or (c) remove
from voice logging scope. This is a blocking decision for the data mapping table entry
below. Flagged as **OPEN DECISION #1**.

### 3.2 Priority Sort Order

Items are sorted before presentation to Claude using this precedence:

```
1. Most recently triggered (notification fired most recently → first)
2. User-defined order (category_priority_order in voice_logging_settings)
3. Time-sensitive / overdue items (past their scheduled window)
4. Morning routine items (natural daily flow: sleep → fluid → food → meds)
```

If `category_priority_order` is NULL, the system default order applies:
sleep → fluids → food → medications → supplements → conditions → flare-ups → journal → activity → photos.

### 3.3 Queue Item Data Model (in-memory)

```dart
class VoiceQueueItem {
  final String id;                    // UUID for this session item
  final LoggableItemType itemType;    // enum — see Section 7
  final String? entityId;             // For items tied to a specific entity (e.g. supplement ID)
  final String? entityName;           // Human-readable label ("Vitamin D", "Running")
  final int triggeredAt;              // Epoch ms when notification fired
  final bool isOverdue;               // Past scheduled window
  VoiceQueueItemStatus status;        // pending | answered | skipped
}

enum VoiceQueueItemStatus { pending, answered, skipped }
```

---

## 4. Session State Machine

A voice session progresses through these states:

```
IDLE
  │
  ▼  (notification tap or manual open)
OPENING
  │  Queue built. History loaded. System prompt assembled.
  │  Claude API called for greeting.
  ▼
GREETING
  │  Claude's greeting spoken/displayed.
  │  Microphone opens.
  ▼
ASKING ◀──────────────────────────────────────┐
  │  Claude asks about next pending item.       │
  │  User responds by voice or text.            │
  ▼                                             │
CONFIRMING                                      │
  │  Claude restates the answer and asks        │
  │  "Is that right?"                           │
  │                                             │
  ├── User confirms → LOGGING                   │
  │                      │                      │
  │                      ▼                      │
  │                   Data written              │
  │                   Item marked answered      │
  │                   More items? ─────────────▶┘
  │
  ├── User corrects → ASKING (same item, correction context passed to Claude)
  │
  ├── User defers ("not now", "later", "come back to that") →
  │     Item stays pending in notification system → ASKING (next item)
  │
  └── User explicitly skips ("skip", "skip it", "skip that one", "don't log that",
        "forget it", or equivalent clear dismissal) →
          Item marked skipped for this window → ASKING (next item)
          │
          ▼  (all items answered or skipped)
        CLOSING
          │  Claude delivers closing message.
          │  Session written to history.
          ▼
        IDLE
```

### State Transition Rules

- `ASKING → CONFIRMING` requires a user response of any kind (including "I don't know")
- `CONFIRMING → LOGGING` requires explicit affirmative ("yes", "right", "correct", "yep",
  "uh huh", or equivalent — Claude determines)
- `CONFIRMING → ASKING` (same item) when user says "no", "actually", "wait", or starts
  correcting
- `CONFIRMING → ASKING` (next item) when user explicitly says "skip" or "not now"
- Session can transition to CLOSING from any ASKING state if user says "I'm done",
  "that's all", or "stop"
- Any remaining unanswered items are left in the notification system as still pending

---

## 5. Claude API Contract

### 5.1 Using the Existing AnthropicApiClient

Phase 19 extends `AnthropicApiClient` (already implemented for food/supplement scanning)
with a new method: `conductVoiceSession()`. The same API key storage and error handling
patterns apply.

### 5.2 Request Structure

Each API call during a session sends the full conversation thread to date. Claude has no
memory between calls — the thread is the memory.

```json
{
  "model": "claude-opus-4-6",
  "max_tokens": 500,
  "system": "<system prompt — see 5.3>",
  "messages": [
    { "role": "user", "content": "<session_context_json>" },
    { "role": "assistant", "content": "<claude_previous_turn>" },
    { "role": "user", "content": "<user_latest_response>" }
  ]
}
```

The first user message in every session is a structured JSON block containing session
context (see 5.3). Subsequent user messages are the user's spoken/typed responses,
passed as plain text.

### 5.3 System Prompt Structure

The system prompt is assembled fresh at session open and does not change during the
session. It has five sections:

```
SECTION 1 — IDENTITY AND ROLE
You are Shadow, a friendly and efficient health logging assistant.
Your job is to help [profile name] log their health data through
natural conversation. You are warm but efficient — you respect their
time and do not over-explain.

SECTION 2 — CURRENT SESSION CONTEXT (injected at runtime)
Profile: [name], [age], [conditions if any]
Current time: [HH:MM, day of week]
Pending items: [JSON array of VoiceQueueItem — see 5.4]

SECTION 3 — RECENT HISTORY (injected at runtime)
Recent patterns from the last 14 days: [summary of voice_session_history
for this profile — last 14 days of sessions, condensed to key patterns
such as "Usually reports coffee and oatmeal for breakfast",
"Typically skips journal entries", "Logs water intake every morning"]

SECTION 4 — CONVERSATION RULES
- Work through each pending item in the order given. Do not skip items
  unless the user asks you to.
- After each answer, restate what you heard and ask for confirmation
  before logging. Keep the confirmation brief.
- If an answer is ambiguous, ask a single clarifying question.
- Do not ask multiple questions at once.
- Do not offer health advice, interpret trends, or comment on data.
  You are a logger, not a clinician.
- If the user says something outside the scope of logging, gently
  redirect: "I'll note that. Let's keep moving — [next item]."
- Use the user's name naturally but not on every turn.
- Match the user's energy — if they're brief, be brief.

SECTION 5 — OUTPUT FORMAT (CRITICAL)
You must always respond with a JSON object. No prose outside the JSON.

{
  "speak": "The text you want spoken aloud and displayed on screen.",
  "session_state": "asking | confirming | closing | idle",
  "confirmed_item": null | {
    "queue_item_id": "<id from pending items>",
    "item_type": "<LoggableItemType string>",
    "data": { <structured data for this item — see Section 7> }
  },
  "closing_cue": null | {
    "next_checkin_label": "this evening around 6" | "tomorrow morning" | etc.,
    "request_random_farewell": true | false
  }
}
```

### 5.4 Pending Items JSON (injected into first user message)

```json
{
  "session_id": "<uuid>",
  "pending_items": [
    {
      "id": "<queue_item_id>",
      "item_type": "food_breakfast",
      "entity_name": null,
      "is_overdue": false,
      "triggered_at": 1741234567890
    },
    {
      "id": "<queue_item_id>",
      "item_type": "supplement",
      "entity_name": "Vitamin D 2000 IU",
      "is_overdue": true,
      "triggered_at": 1741230000000
    }
  ]
}
```

### 5.5 Response Parsing Rules

- Always parse the `speak` field and route to TTS + display.
- If `confirmed_item` is non-null and `session_state = "confirming"` — do NOT log yet.
  Claude is still in confirmation phase. Wait for next user affirmation.
- If `confirmed_item` is non-null and the prior user message was an affirmation — log
  the item, mark queue item as answered, and advance.
- If `session_state = "closing"` — deliver closing message, then optionally request
  a random farewell from Claude if `closing_cue.request_random_farewell = true`.
- If Claude returns malformed JSON — display fallback UI message, log the error, do not
  crash. Session can attempt one retry before falling back to manual entry.

### 5.6 History Summary Generation

At session open, before building the system prompt, `VoiceHistoryService` reads the last
14 days of `voice_session_history` for the current profile and generates a plain-text
summary of user patterns. This summary is passed to Claude in Section 3 of the system
prompt. The summary is generated by a secondary Claude API call:

```
Prompt: "Here are the last 14 days of health logging conversation turns for a user.
Extract 3–5 brief behavioral patterns that would help a voice assistant personalize
its questions. Focus on recurring answers, preferred phrasing, and items the user
frequently skips. Return plain text only — no JSON, no headers."
```

This secondary call happens once per session, at session open, before the main
conversation begins. Result is cached in session memory only — not persisted.

---

## 6. Voice Pipeline

### 6.1 Recommended Flutter Packages

| Role | Package | Rationale |
|------|---------|-----------|
| Speech to text | `speech_to_text` (pub.dev) | Maintained, iOS + Android, no proprietary service required, works offline with on-device models |
| Text to speech | `flutter_tts` (pub.dev) | De facto standard, iOS AVSpeechSynthesizer + Android TTS, no API key required, works offline |

Both use the platform's native voice engines. No third-party voice API is required.
This keeps the feature fully offline-capable and avoids additional API costs.

### 6.2 Entry Points

**From notification tap:** Notification tap opens the app to `VoiceLoggingScreen` directly.
This is the standard foreground notification entry — no background microphone access
required. iOS and Android both allow foreground microphone from a tapped notification.

**From home screen:** A persistent mic icon in the home screen header opens
`VoiceLoggingScreen` manually at any time, even without pending notifications.

**VoiceLoggingScreen** is a full-screen modal pushed over the existing navigation stack.
It does not replace any tab or screen.

### 6.3 Screen Layout

```
┌─────────────────────────────────────┐
│  ✕                        [text mode]│  ← X closes session
│                                      │
│         Shadow's avatar / wave       │  ← animated while speaking
│                                      │
│  ┌──────────────────────────────────┐│
│  │  "Good morning Reid. Did you     ││  ← Claude's last turn displayed
│  │   eat breakfast today?"          ││     as large readable text
│  └──────────────────────────────────┘│
│                                      │
│  ┌──────────────────────────────────┐│
│  │  [microphone button — large]     ││  ← tap to speak
│  └──────────────────────────────────┘│
│                                      │
│  ┌──────────────────────────────────┐│
│  │  Type a response...          [→] ││  ← text fallback, always visible
│  └──────────────────────────────────┘│
│                                      │
│  ● ○ ○ ○ ○  (queue progress dots)   │  ← how many items remain
└─────────────────────────────────────┘
```

### 6.4 Microphone Permission Handling

Request microphone permission on first open of `VoiceLoggingScreen`. If denied:
- Text input is always available as fallback — session continues normally
- Display a soft prompt: "Microphone access is off. You can still type your answers."
- Do not re-request permission on subsequent sessions if previously denied

### 6.5 Audio Session Handling (iOS)

Configure `AVAudioSession` category as `playAndRecord` with `defaultToSpeaker` when
voice session opens. Restore to default when session closes or is backgrounded.

---

## 7. Data Mapping Table

Every loggable item, its queue item type identifier, and the use case it routes to.

| LoggableItemType | Description | Routes to | Key fields extracted |
|-----------------|-------------|-----------|----------------------|
| `food_breakfast` | Breakfast | `LogFoodUseCase` | meal_type=breakfast, food_name (freeform or matched), quantity_description |
| `food_lunch` | Lunch | `LogFoodUseCase` | meal_type=lunch, food_name, quantity_description |
| `food_dinner` | Dinner | `LogFoodUseCase` | meal_type=dinner, food_name, quantity_description |
| `food_snack` | Snack | `LogFoodUseCase` | meal_type=snack, food_name, quantity_description |
| `beverage` | Water and drinks | `LogFoodUseCase` | meal_type=beverage, food_item matched from seeded beverage items or freeform, quantity_description |
| `sleep` | Last night's sleep | `LogSleepUseCase` | bedtime (epoch ms), wake_time (epoch ms), quality (1–5) |
| `supplement` | Specific supplement | `MarkIntakeTakenUseCase` | supplement_id (from queue item entity_id), taken=true/false/snoozed |
| `medication` | Specific medication | `MarkIntakeTakenUseCase` | same as supplement |
| `condition_log` | Active condition check-in | `LogConditionUseCase` | condition_id (from queue item entity_id), severity (1–10), notes |
| `flare_up_end` | Close an open flare-up | `EndFlareUpUseCase` | flare_up_id (from queue item entity_id), end_time=now, severity, notes |
| `journal` | Journal entry | `CreateJournalEntryUseCase` | content (freeform), mood (1–5) |
| `activity` | Activity log | `LogActivityUseCase` | activity_id (from queue item entity_id), duration_minutes, intensity |
| `photo` | Body/wound photo | `CreatePhotoEntryUseCase` | photo_area_id — voice cannot capture photos. Claude asks user to take photo manually. Session pauses for photo capture. |
| `bodily_output_urine` | Urination event | `LogBodilyOutputUseCase` | output_type=urine, urine_condition (optional), urine_size (optional), notes |
| `bodily_output_bowel` | Bowel movement | `LogBodilyOutputUseCase` | output_type=bowel, bowel_condition (optional), bowel_size (optional), notes |
| `bodily_output_gas` | Gas / flatulence | `LogBodilyOutputUseCase` | output_type=gas, gas_severity (optional) |
| `bodily_output_menstruation` | Menstruation | `LogBodilyOutputUseCase` | output_type=menstruation, menstruation_flow |
| `bodily_output_bbt` | Basal body temperature | `LogBodilyOutputUseCase` | output_type=bbt, temperature_value, temperature_unit |
| `bodily_output_custom` | User-defined output type | `LogBodilyOutputUseCase` | output_type=custom, custom_type_label, notes |

**Note on freeform food entries:** When a user says "oatmeal and coffee," Claude extracts
individual items and structures them as separate `LogFoodUseCase` calls — oatmeal as
food_breakfast, coffee as a beverage. The data extractor handles the split. If a food
item is not in the database, it is logged as a freeform entry (food_name as free text,
no food_item_id).

**Note on bodily output voice questions:** Claude asks naturally and without clinical
stiffness. "Any bowel movements since last night?" or "Did you have a bowel movement
today?" — not "Please report your bowel output status." For gas: "Any gas today?" For
urine: "How's your urination been — anything unusual?" The confirmation layer keeps
it brief: "I'll log a bowel movement, normal consistency. Right?"

**Prerequisite dependency:** All `bodily_output_*` item types depend on the Fluids
Restructuring phase (FLUIDS_RESTRUCTURING_SPEC.md) being complete. `LogBodilyOutputUseCase`
does not exist until that phase ships.

---

## 8. Confirmation Layer

Every item goes through confirmation before being written. No exceptions.

### 8.1 Confirmation Format

Claude's confirmation turn should:
- Restate the answer concisely (not verbosely)
- Ask a simple yes/no

Examples:
- "Got it — oatmeal and coffee for breakfast. Is that right?"
- "I'll mark your Vitamin D as taken. Correct?"
- "Six hours of sleep, woke up around 7. Sound right?"

### 8.2 Correction Handling

If the user corrects the answer, Claude passes the correction back into the conversation
thread. The prior `confirmed_item` is discarded. Claude asks the question again with
the corrected answer pre-populated in the confirmation: "Ah — eggs and toast then.
Is that right?"

### 8.3 Ambiguous Answers

If Claude cannot confidently extract a loggable value from the user's response
(e.g. "I had something"), it asks a single targeted follow-up. It does not ask multiple
clarifying questions in one turn. If a second response is also ambiguous, Claude marks
the item as skipped with a note: "No worries — I'll leave that one for you to fill in
manually."

---

## 9. Closing Message System

### 9.1 All Closing Messages Include a Forward-Looking Note

Regardless of closing style, every session ends with a forward-looking note so the user
has a sense of continuity. Claude computes this from the next scheduled notification:

- "Your next check-in is this evening around 6."
- "I'll check back with you tomorrow morning."
- "You're all caught up until tomorrow."

### 9.2 Closing Style: none (0)

Session ends immediately after the last item is confirmed:
> "You're all caught up. Your next check-in is this evening around 6."

### 9.3 Closing Style: random (1)

Claude generates a warm, contextually appropriate farewell after the standard close.
The system prompt instructs Claude to avoid repeating a farewell used in the last
3 sessions for this profile (enforced via the session history summary).

Examples of appropriate farewells:
- "Have a beautiful day."
- "Go in peace."
- "Take good care of yourself."
- "Enjoy every moment."
- "Make it a good one."

Claude is not given a list to choose from. It generates one naturally, matching the tone
and length of the conversation. The goal is genuine warmth, not a canned phrase.

### 9.4 Closing Style: fixed (2)

After the standard forward-looking close, Claude appends the exact phrase from
`voice_logging_settings.fixed_farewell`. Claude does not paraphrase or modify it.

> "You're all caught up. Your next check-in is this evening around 6. [fixed_farewell]"

---

## 10. Settings UI Spec

### 10.1 Location

Voice Logging Settings appear as a new section in the existing Settings hub screen,
between Notifications and Security. Label: **Voice Logging**.

### 10.2 Voice Logging Settings Screen

**Screen title:** Voice Logging

**Section: Closing Message**

A segmented control or radio group with three options:
- No closing comment
- Random farewell (default)
- Custom farewell

When "Custom farewell" is selected, a text field appears:
- Label: "Your farewell phrase"
- Placeholder: "e.g. Go in peace."
- Max 60 characters

**Section: Notification Priority**

A reorderable list of notification categories. Drag to reorder. This list feeds
`voice_logging_settings.category_priority_order`.

Label above the list: "Shadow asks about items in this order."

Default order matches system default from Section 3.2.

**Section: Input Mode**

Label: "Default input"
Toggle: Voice / Text

When set to Text, the text input field is pre-focused and the microphone is not
auto-activated on session open. User can still tap the mic at any time.

This preference is stored in `voice_logging_settings` (add `default_input_mode` column —
0=voice, 1=text).

---

## 11. Edge Cases

### 11.1 User Does Not Respond

STT timeout: 15 seconds of silence after the microphone opens. Claude asks once:
"Still there? Take your time." After another 15 seconds of silence, session suspends:
"I'll pick this up when you're ready." Session state is NOT saved as answered — all
unanswered items remain pending in the notification system.

### 11.2 App Backgrounded Mid-Session

When app enters background, voice session pauses immediately:
- TTS stops
- Microphone releases
- Session state (current queue position, answered items) is preserved in memory

When app returns to foreground, a resume card is shown:
"You were in the middle of a check-in. [Resume] [Dismiss]"

If user taps Resume: session restores, Claude re-reads the last question.
If user taps Dismiss: all unanswered items remain pending. No data is lost.

If app is terminated (not just backgrounded), session state is lost. All items remain
pending in the notification system — they will reappear in the next session.

### 11.3 Claude API Unavailable

If the API call fails:
1. Display inline error: "Voice logging is temporarily unavailable."
2. Show "Log manually" button that deep-links to the relevant quick-entry screen.
3. All pending items remain pending — nothing is dropped.
4. Do not retry automatically. User can re-tap to try again.

### 11.4 Partial Session (User Ends Early)

If the user says "I'm done," "stop," or taps X before all items are answered:
- Items already confirmed and logged are saved (irreversible — standard use case behavior)
- Items explicitly skipped during the session are removed from the current notification
  window and will not resurface until the next scheduled window
- Items deferred ("not now") or not yet reached remain fully pending in the notification
  system and will resurface normally
- Session closes with an abbreviated closing: "Got it — I'll check back on the rest later."

**The defer vs. skip distinction is enforced throughout the session:**
- "Not now," "later," "come back to that," or any non-committal deferral = item stays
  pending. Claude does not treat this as a skip. The item will reappear next session.
- "Skip," "skip it," "don't log that," "forget it," or equivalent explicit dismissal =
  item is removed from the current notification window. Claude takes the user literally.
  This is intentional — "not now" means "ask me again," "skip" means "don't."

### 11.5 STT Misfire / Background Noise Triggering Response

Because STT is only active when the user explicitly taps and holds the microphone button,
accidental misfires are minimal. The confirmation layer is the safety net — any
misheard response must be confirmed before it is logged. Users can always correct
at the confirmation step.

### 11.6 Multiple Profiles

Voice logging always operates on the currently active profile (same as the rest of the
app). Profile switching mid-session is not supported. If the user needs to log for a
different profile, they close the session, switch profiles, and start a new session.

### 11.7 No Pending Items

If the notification queue builder finds no pending items at session open:
> "You're all caught up, [name]. Nothing to log right now. [forward-looking note]"

Session closes immediately. No API call needed.

### 11.8 Network Offline

The voice pipeline (STT/TTS) works offline using on-device engines. However, the
Claude API requires connectivity. If offline when the session opens, display:
"Voice logging needs an internet connection. You can still log manually." Provide
quick-entry shortcut. Do not open a broken session.

---

## 12. Ember Extraction Notes

This section identifies what is Shadow-specific vs. what belongs in Ember unchanged.

### Goes into Ember Unchanged (generic infrastructure)

| Component | What it does |
|-----------|-------------|
| `VoiceSessionStateMachine` | State machine, session lifecycle |
| `VoicePipeline` (STT/TTS) | Platform voice I/O |
| `VoiceHistoryService` | Rolling session history read/write |
| `voice_session_history` table | Schema, retention logic |
| `voice_logging_settings` table | Schema, settings UI pattern |
| `AnthropicApiClient.conductVoiceSession()` | API method signature and response parsing |
| Closing message system | All three styles |
| System prompt Sections 1, 4, 5 | Identity/rules/output format |
| VoiceLoggingScreen layout | Screen structure |

### Shadow-Specific (app-specific, parameterized in Ember)

| Component | Shadow-specific element | Ember parameterization |
|-----------|------------------------|----------------------|
| `VoiceSessionQueueBuilder` | Queries Shadow's notification categories | Ember apps provide their own `PendingItemProvider` interface |
| System prompt Section 2 | "Profile", "conditions" | Generic "user context" object |
| System prompt Section 3 | Health-specific history patterns | Generic behavioral pattern summary |
| Data Extractor | Routes to Shadow use cases | Ember apps register their own `LoggableItemHandler` map |
| Data mapping table | Shadow's 14 item types | Each Ember app defines its own item type registry |
| Notification categories | Shadow's 9 categories | Ember apps define their own |

### Ember Interface Contracts (to be spec'd during Ember build)

```dart
// App provides this — Ember calls it at session open
abstract class PendingItemProvider {
  Future<List<VoiceQueueItem>> getPendingItems(String profileId);
}

// App provides this — Ember calls it when an item is confirmed
abstract class LoggableItemHandler {
  Future<Result<void, AppError>> log(String itemType, Map<String, dynamic> data);
}
```

Shadow's implementations of these two interfaces constitute the entirety of what needs
to change when Ember is used for The Bookkeeper, Seeds, or any future app.

---

## 13. Open Decisions

These items must be resolved before Phase 19 implementation begins.

| # | Decision | Owner | Blocking? |
|---|----------|-------|-----------|
| 1 | Bowel/urination tracking | Reid ✓ | **RESOLVED** — first-class `bodily_output_logs` table. See FLUIDS_RESTRUCTURING_SPEC.md. |
| 2 | Voice sessions sync to Google Drive? | Reid ✓ | **RESOLVED** — local-only. |
| 3 | Skipped items — same-day follow-up or next window? | Reid ✓ | **RESOLVED** — next scheduled window. "Not now" = stays pending. "Skip" = removed from current window. Claude takes user literally. |
| 4 | Where do water/beverages live? | Reid ✓ | **RESOLVED** — `food_logs` via `FoodItem` records. meal_type=beverage. |
| 5 | Fluids tab / notification category name | Reid ✓ | **RESOLVED** — tab renamed to "Bodily Functions". Notification category renamed to `bodilyOutputs`. Completed in P-014/P-015. |

---

## 14. Schema Migration

Phase 19 requires schema v21 (current is v20). Migration adds two tables:

```
Migration 20 → 21:
  CREATE TABLE voice_logging_settings (...)
  CREATE TABLE voice_session_history (...)
  CREATE INDEX idx_voice_session_history_profile_created
    ON voice_session_history (profile_id, created_at DESC)
```

No existing tables are modified.

---

## Document Control

| Version | Date | Author | Notes |
|---------|------|--------|-------|
| 0.1 DRAFT | 2026-03-06 | Architect | Initial draft |
| 1.0 APPROVED | 2026-03-06 | Reid + Architect | All original open decisions resolved |
| 1.1 | 2026-03-06 | Architect | Fluids domain corrected: bodily outputs → bodily_output_logs, beverages → food_logs. Data mapping table fully updated. Sequencing updated to include Fluids Restructuring prerequisite. |
| 1.2 | 2026-03-07 | Architect | Closed decision #5 (Bodily Functions rename). Schema target corrected v20→v21. AI Home Screen navigation architecture added. |
