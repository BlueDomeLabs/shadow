# Blue Dome Labs — Platform Vision

**Document:** VISION.md
**Last Updated:** 2026-03-06
**Author:** Reid Barcus, Founder & CEO — Blue Dome Labs
**Audience:** Potential partners, collaborators, and domain experts considering
building an app on the Ember platform

---

## The Problem Worth Solving

Most apps that track personal data fail for the same reason: logging is friction.
A health tracking app that requires three taps and a form to record a meal gets
abandoned within a week. A garden app that asks you to navigate menus to log a
watering event collects dust. The data never flows in, so the insights never flow out,
and the app becomes useless.

The second reason these apps fail is economics. Building a professional-grade mobile
app from scratch — one with encrypted storage, cloud sync, security, photo handling,
notifications, and AI integration — costs hundreds of thousands of dollars and takes
a year or more. Most great domain ideas never become apps because the infrastructure
cost is prohibitive.

Blue Dome Labs was built to solve both problems.

---

## What Blue Dome Labs Builds

Blue Dome Labs is a small, focused software company. We build data-driven personal
tracking apps for iOS and Android using a shared platform called Ember.

Ember is the infrastructure. It provides every capability a serious personal tracking
app needs — encrypted storage, cloud sync, security, photo and video handling,
notifications, AI-powered conversational logging, health platform integration, and more.
All of it is built, tested, and proven in production.

Shadow is the first app built on Ember. It is a personal health tracking app for people
managing chronic conditions. Shadow exists to prove the platform works and to push
every capability to its limits. It has been in development since early 2026 and ships
as a complete, production-ready iOS and Android application.

Every future Blue Dome Labs app — and every app built by a collaborating domain expert —
is built on Ember. The platform work is done once. The app-specific work is the only
remaining investment.

---

## The Ember Platform

Ember is a Flutter/Dart platform targeting iOS and Android. Here is what it provides
out of the box to every app built on it.

---

### Encrypted Local Storage

All user data is stored on-device in an AES-256 encrypted SQLite database
(SQLCipher). The encryption key is stored in the platform's native secure storage —
iOS Keychain on Apple devices, Android Keystore on Android devices. Data never leaves
the device unencrypted under any circumstances.

The database uses a sequential schema versioning system with forward-only migrations,
so apps can evolve their data model without losing existing user data. Every record
includes soft-delete support and a 30-day recovery window before permanent deletion.

---

### Cloud Sync

Users can optionally back up and sync their data to Google Drive (iOS and Android)
or iCloud (iOS only). Sync is bidirectional — the same account can be active on
multiple devices, and data stays consistent across all of them.

All data is encrypted before it leaves the device. The cloud never holds plaintext.

The sync architecture supports:
- **Full account sync** — all profiles and all data synchronized across devices
- **Single-profile sync** — share one profile with a trusted person (a caregiver,
  a health counselor, a family member) without exposing any other data
- **Conflict resolution** — when the same record is changed on two devices before
  they sync, the system detects the conflict and resolves it with configurable
  strategies (last-write-wins, keep-both, or user choice)
- **QR code device pairing** — a new device is added to an account by scanning
  a QR code on an existing device. No passwords, no account registration required.

---

### Security

Beyond encrypted storage, Ember provides a full application security layer:

- **PIN protection** — 6-digit PIN locks the app when not in use
- **Biometric authentication** — Face ID and fingerprint unlock
- **Auto-lock** — configurable idle timeout before the app locks itself
- **App switcher privacy** — app content is hidden in the iOS/Android task switcher
  so sensitive data is not visible when switching between apps

---

### Multi-Profile Management

A single app installation supports multiple independent profiles. Each profile has
completely isolated data — no cross-contamination is possible at the database level.

This enables the caregiver model: a health counselor, parent, or doctor runs one app
and manages profiles for each of their clients or family members. Switching profiles
is a single tap.

Guest access allows a profile owner to share a specific profile with another device
via a QR code invite. The guest device sees only that one profile. Access can be
revoked at any time by the host. Each invite is hardware-locked to a single device —
a QR code screenshot cannot be forwarded to a second device.

---

### Notifications

Ember's notification system is local-only — no server, no subscription, no privacy
risk. Notifications are scheduled entirely on-device and fire without internet access.

The system supports two scheduling modes for each notification category:
- **Anchor-event scheduling** — fires relative to named daily events (wake, breakfast,
  morning, lunch, afternoon, dinner, evening, bedtime), each configurable by the user
- **Interval scheduling** — fires on a repeating timer (every N hours)

Multiple pending notifications are stacked into a single "you have items to review"
notification, preventing notification fatigue. All specifics stay private — the
notification body never contains health data.

---

### AI-Powered Conversational Logging

This is Ember's most distinctive capability and the one that solves the friction problem
described at the opening of this document.

When the user taps a notification, the app opens to a voice interface. An AI assistant
(powered by the Anthropic Claude API) greets the user by name and works through all
pending items in natural conversation:

> "Good morning. Did you eat breakfast today?"
> "Yeah, oatmeal and coffee."
> "Got it — oatmeal and coffee. Your Vitamin D was due this morning — did you take it?"
> "Yes."
> "Perfect. You're all caught up. Your next check-in is this evening around six.
>  Have a beautiful day."

The assistant confirms each answer before logging it. Every confirmed item is written
to the correct database field through the existing use case layer. Nothing is bypassed.
Text input is always available as a fallback for situations where speaking is not
appropriate.

The assistant maintains a rolling memory of recent sessions and personalizes its
questions accordingly. It learns that you usually have coffee with breakfast, that you
tend to skip the journal prompt, that you prefer brief answers. Over time, sessions
get faster.

The conversational logging interface is fully domain-agnostic. The same infrastructure
that asks a Shadow user about their breakfast asks a gardener about their tomatoes or
a financial tracker user about their receipts. Only the prompts and the data model
change. The conversation engine, voice pipeline, and AI integration are shared by
every Ember app.

---

### Voice Pipeline

The voice interface uses on-device speech-to-text and text-to-speech engines —
Apple's AVSpeechSynthesizer on iOS and Android's native TTS engine on Android.
No third-party voice API is required. The feature works fully offline.

Every spoken response is displayed on screen simultaneously, providing an accessibility
fallback for users in environments where audio is not appropriate.

---

### Photo Capture and Processing

Ember provides a complete photo management pipeline:

- Capture from camera or import from photo library
- Automatic compression using native platform codecs (CoreImage on iOS,
  libjpeg on Android) — fast and battery-efficient
- EXIF metadata stripping — location data and device identifiers are removed
  before storage
- Encrypted storage with cloud sync
- Timeline view — photos are organized chronologically and can be compared
  side by side to track changes over time
- Per-area organization — photos are grouped by user-defined areas
  (a body location, a plant, a property, whatever the app requires)

---

### Video Capture and Processing

Video support is planned for a near-term release, extending the photo pipeline to
short video clips. This is particularly valuable in domains where motion or progression
over time is meaningful — a 10-second clip documents a wound, a skin condition, or a
plant's health in ways a photograph cannot.

The video pipeline will include the same encryption, cloud sync, and timeline
organization as photos, with appropriate handling for large file sizes (chunked
upload, local compression, storage management).

---

### Health Platform Data Import

On iOS, Ember can read data from Apple HealthKit — the centralized health data store
on iPhones that aggregates data from the Health app and compatible devices. On Android,
Ember reads from Google Health Connect.

Supported data types include: steps, heart rate, blood pressure, blood oxygen,
weight, and sleep data. Import is manual and user-controlled — Ember never reads
health platform data in the background without explicit user action.

Imported data is stored in a dedicated local table, isolated from manually-entered
data, and is never modified after import.

---

### Barcode and Label Scanning

Ember integrates with Open Food Facts (food products) and the NIH Dietary Supplement
Label Database (supplements) for barcode-based data lookup. Scanning a product
barcode populates nutritional information, ingredients, brand, and serving data
automatically.

For supplement labels that are not in the database, an AI-powered label scanner
reads the label photo and extracts structured data using the Anthropic Claude API.
The same pipeline can be adapted to any domain that involves labeled products.

---

### International Units

Ember handles unit localization across all measurement types:

- **Weight:** kg / lb
- **Food weight:** g / oz
- **Fluids:** ml / fl oz
- **Temperature:** °C / °F
- **Energy:** kcal / kJ
- **Macro display:** grams / percentages

Unit preferences are per-device and apply consistently across all data entry screens,
reports, and displays.

---

### Report Generation

Ember generates formatted PDF reports from stored data. Reports are configurable by
date range and data category, and are designed for use cases where the user needs to
share data with a professional — a doctor, a nutritionist, a specialist.

Reports include charts, tables, and optionally photos. All report generation happens
on-device with no server dependency.

---

### Intelligence System *(planned)*

A future release will add a pattern detection and correlation engine. The system will
analyze historical data to surface non-obvious relationships — which foods correlate
with symptom flare-ups, which activities improve sleep quality, which environmental
factors precede health events.

The intelligence system is fully domain-agnostic. The same pattern detection that finds
food-symptom correlations in a health app finds seasonal patterns in a gardening app
or spending patterns in a financial app.

---

## The Business Model

Blue Dome Labs apps are priced at approximately $12/year — accessible to individuals,
sustainable as a business.

Blue Dome Labs collaborates with domain experts on a revenue-share model. If you have
deep expertise in a domain — gardening, finance, fitness, nutrition, veterinary care,
or anything else where people benefit from tracking personal data over time — and you
want to bring that expertise to a professional mobile app without building the
infrastructure yourself, that is exactly the collaboration this platform is designed for.

You bring the domain knowledge: what data matters, what questions to ask, what insights
users need. Blue Dome Labs brings the platform: encrypted storage, sync, AI logging,
photo handling, notifications, security, and everything else described in this document.

Shadow is the proof that this works. It is a complete, production-quality app built
entirely on the Ember platform by a founder who is not a programmer, working with AI
as the engineering team.

---

## Contact

Reid Barcus
Founder & CEO, Blue Dome Labs
reid@bluedomecolorado.com
