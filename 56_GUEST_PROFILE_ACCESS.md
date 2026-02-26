# 56 — Guest Profile Access (QR Code Invite System)
**Status:** COMPLETE — Phase 12 (a, b, c, d) implemented
**Target Phase:** After Phase 11
**Created:** 2026-02-21
**Completed:** 2026-02-24

---

## Overview

Shadow supports a "Guest Profile Access" system that allows the account owner (the "host") to invite another device (the "guest") to access a single profile via QR code. The guest device can read and write data for that one profile only. The host retains full control over all profiles and can revoke access at any time.

**Primary use case:** A health practitioner managing multiple patient profiles on their own account. Each patient receives a QR code invite giving them access only to their own profile on their personal phone. The practitioner sees all profiles on their own devices.

---

## Design Principles

- **No separate patient login.** Guests do not create accounts. All data runs under the host's Google account and Google Drive.
- **Host has total control.** Only the host can create, revoke, or expire invites. Guests cannot invite other devices.
- **Strict profile isolation.** A guest device can only see and interact with the one profile they were invited to. No settings, no other profiles, no account management.
- **Simple for the guest.** The guest experience is: scan QR code → app opens in guest mode → enter health data. Nothing else required.
- **Disclaimer required.** The app must display a disclaimer that Shadow is not a HIPAA-compliant clinical tool and is not intended for use as a medical records system.

---

## Host Experience

### Creating an Invite
1. Host navigates to a profile in the app
2. Opens profile settings or options menu
3. Taps "Invite Device" or "Share Profile Access"
4. App generates a QR code tied to that profile
5. Host shows QR code to guest (or screenshots and sends it)

### Managing Invites
- Host can see a list of active invites per profile (device name, date created, last sync)
- Host can revoke any invite at any time — guest device immediately loses access on next sync attempt
- Invites can have an optional expiry date set by the host
- Host can regenerate a new QR code (invalidating the old one) per profile
- Each active invite shows a **"Remove Device"** option. Tapping it requires a deliberate confirmation step (not a single tap). On confirmation, the token is immediately revoked. The host can then generate a new QR code for the same profile, allowing a replacement device to be added. This is the only supported path for a patient changing phones.

### Invite Settings (per profile)
- Invite name / label (e.g. "John's iPhone")
- Expiry date (optional)
- Read-write access (default) or read-only access (optional future enhancement)

---

## Guest Experience

### First Launch via QR Code
1. Guest opens camera or Shadow app
2. Scans QR code
3. App opens (or installs if not present) in Guest Mode
4. Guest sees only the invited profile — their name and tracking screens
5. No login required, no account creation

### Guest Mode Restrictions
- Can only see and edit the one invited profile
- Cannot access Settings
- Cannot see other profiles
- Cannot change sync configuration
- Cannot generate their own invites
- Cannot see the host's account information
- Bottom navigation shows only the tracking tabs (food, supplements, conditions, etc.) — no profile switcher, no account menu

### Guest Data Entry
- Guest enters health data exactly as a normal user would
- Data syncs to the host's Google Drive under the invited profile
- Host sees guest-entered data on their devices on next sync

---

## Technical Approach

### QR Code Token
- Each invite generates a unique, cryptographically secure token (UUID v4 or similar)
- Token is stored in the host's Google Drive alongside profile data
- QR code encodes: `shadow://invite?token=<TOKEN>&profile=<PROFILE_ID>`
- Token maps to: profile ID, host's Drive credentials scope, expiry date, revocation status

### One-Device Limit (Hard Enforcement)
- **A guest invite token may only be active on one device at a time.** This is a hard system limit, not a warning.
- If a second device attempts to scan an already-active QR code, the scan is **rejected entirely** and the second device is denied access. No exceptions.
- When a second device attempt is blocked, the host's app receives a notification: **"Someone attempted to access [Profile Name]'s profile from a second device. The attempt was blocked."** This gives the host immediate visibility if a QR code was accidentally shared with the wrong person.
- The only way to move access to a new device is for the host to explicitly revoke the current device first (via "Remove Device" in the invite management screen), then generate a new QR code.

### Guest Mode Activation
- App detects `shadow://invite` deep link on launch
- Validates token against host's Drive (token must exist and not be revoked/expired)
- **Checks that no other device has already activated this token.** If another device is already active, the scan is rejected with a message: "This invite is already in use on another device. Please contact your host for a new invite."
- Stores token locally on guest device (secure storage, same as OAuth credentials)
- Registers the device ID against the token in the host's Drive (marking the token as actively bound to this device)
- Sets app into Guest Mode — single profile, restricted navigation
- All subsequent syncs use the stored token to access only the invited profile's data in the host's Drive

### Token Validation
- On every sync, guest app validates token is still active
- If token is revoked or expired: guest app shows "Access Revoked" screen, local data is cleared, guest is prompted to contact the host for a new invite
- Tokens are checked against a `guest_invites` record in the host's Google Drive (a JSON file alongside the profile data)

### Data Storage
- No new backend required — everything stored in host's Google Drive
- New file in Drive: `shadow_app/invites/<PROFILE_ID>/invites.json`
- Contains array of active invite tokens with metadata
- Guest device only has access to the specific profile folder, not the full shadow_app folder

---

## New Spec Documents / Changes Required

### Database Changes
- New table: `guest_invites` — stores active invites on the host device
  - id, profile_id, token, label, created_at, expires_at (nullable), is_revoked, last_seen_at, active_device_id (nullable — set when a guest device activates the token, cleared on revocation)

### API Contracts Changes
- New use cases: CreateGuestInvite, RevokeGuestInvite, ListGuestInvites, ValidateGuestToken
- New entity: GuestInvite
- New input types: CreateGuestInviteInput, RevokeGuestInviteInput

### UI Changes
- Profile options menu: Add "Invite Device" option
- New screen: GuestInviteScreen — shows QR code, invite details, expiry options
- New screen: GuestInviteListScreen — shows all active invites for a profile
- Modified: App initialization — detect and handle `shadow://invite` deep link
- Modified: Navigation — Guest Mode hides profile switcher and account settings
- New screen: AccessRevokedScreen — shown when guest token is invalidated

### Cloud Sync Changes
- Guest sync only touches the specific profile folder in Drive
- Host sync writes invite status to Drive on revocation
- Guest device polls invite validity on each sync

---

## Disclaimer

The following disclaimer must be displayed to guest users on first launch and accessible from the guest mode info screen:

> "Shadow is a personal health tracking tool. It is not a HIPAA-compliant medical records system and is not intended for use as a clinical tool. Do not use Shadow to store or transmit protected health information (PHI) in a regulated medical context. By using this app, you acknowledge that data is stored in your host's personal Google Drive account and is subject to Google's terms of service."

---

## Implementation Notes

- This feature should be implemented AFTER Phase 11 (Profile repository and DAO) as it depends on the Profile entity being fully wired
- The QR code library for Flutter is `qr_flutter` (already a common Flutter package)
- Deep link handling requires configuration in `AndroidManifest.xml` and iOS `Info.plist`
- Guest Mode state should be stored in a `GuestModeProvider` that wraps the entire app navigation
- Test coverage should include: token generation, token validation, revocation, expiry, guest mode navigation restrictions, deep link handling

---

## Future Enhancements (Not in Scope for Initial Implementation)

- Read-only guest access (view but not edit)
- Guest activity log visible to host
- Push notifications to host when guest enters data
- Time-limited access windows (e.g. "active only between 8am-8pm")
