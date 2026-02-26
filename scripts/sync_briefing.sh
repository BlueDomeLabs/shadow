#!/bin/bash
# scripts/sync_briefing.sh
#
# RETIRED 2026-02-26 — Google Drive sync discontinued.
# Briefing now synced via GitHub only.
# Retained for historical reference.
#
# Stop hook: pushes ARCHITECT_BRIEFING.md to Google Drive whenever its
# content has changed since the last successful upload.
#
# Detection: compares an MD5 hash of the current file against
# .last_sync_hash (written after each successful push). This approach
# is reliable regardless of git commit state and works across sessions.
#
# Version stamp: before each push, increments the NNN counter in the
# "# Briefing Version: YYYYMMDD-NNN" line. The YYYYMMDD resets to today
# when the date changes; NNN increments within a day.
#
# Wired as a Claude Code Stop hook in ~/.claude/settings.json.
# Logs every run to scripts/sync_briefing.log.

REPO="/Users/reidbarcus/Development/Shadow"
BRIEFING_FILE="$REPO/ARCHITECT_BRIEFING.md"
PYTHON_SCRIPT="$REPO/scripts/push_briefing_to_gdrive.py"
LOG_FILE="$REPO/scripts/sync_briefing.log"
HASH_FILE="$REPO/scripts/.last_sync_hash"

# Ensure log directory exists
mkdir -p "$(dirname "$LOG_FILE")"

# Bail if the briefing file doesn't exist
if [ ! -f "$BRIEFING_FILE" ]; then
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: $BRIEFING_FILE not found — skipping." >> "$LOG_FILE"
  exit 1
fi

# ── Compute current content hash ─────────────────────────────────────────────
CURRENT_HASH=$(md5 -q "$BRIEFING_FILE" 2>/dev/null || md5sum "$BRIEFING_FILE" | awk '{print $1}')

# ── Read last synced hash ────────────────────────────────────────────────────
if [ -f "$HASH_FILE" ]; then
  LAST_HASH=$(cat "$HASH_FILE")
else
  LAST_HASH=""
fi

# ── Compare and push if changed ──────────────────────────────────────────────
if [ "$CURRENT_HASH" != "$LAST_HASH" ]; then

  # ── Increment version stamp before pushing ─────────────────────────────────
  TODAY=$(date '+%Y%m%d')

  # Read the current version stamp line, e.g. "# Briefing Version: 20260225-003"
  CURRENT_VERSION_LINE=$(grep "^# Briefing Version:" "$BRIEFING_FILE" | head -1)

  if [ -n "$CURRENT_VERSION_LINE" ]; then
    # Extract the date part and NNN counter
    VERSION_DATE=$(echo "$CURRENT_VERSION_LINE" | sed 's/.*: \([0-9]*\)-.*/\1/')
    VERSION_NNN=$(echo "$CURRENT_VERSION_LINE"  | sed 's/.*-\([0-9]*\)$/\1/')

    if [ "$VERSION_DATE" = "$TODAY" ]; then
      # Same day — increment NNN
      NEW_NNN=$(printf "%03d" $((10#$VERSION_NNN + 1)))
    else
      # New day — reset to 001
      NEW_NNN="001"
    fi

    NEW_VERSION="${TODAY}-${NEW_NNN}"

    # Write the incremented stamp back into the file (in-place)
    sed -i '' "s/^# Briefing Version:.*$/# Briefing Version: ${NEW_VERSION}/" "$BRIEFING_FILE"
  else
    # No stamp found — insert today-001
    NEW_VERSION="${TODAY}-001"
  fi

  echo "[$(date '+%Y-%m-%d %H:%M:%S')] Change detected — incrementing to Briefing Version ${NEW_VERSION} and pushing..." >> "$LOG_FILE"

  OUTPUT=$(python3 "$PYTHON_SCRIPT" 2>&1)
  EXIT_CODE=$?

  if [ $EXIT_CODE -eq 0 ]; then
    # Record the hash of the file as it was just pushed
    PUSHED_HASH=$(md5 -q "$BRIEFING_FILE" 2>/dev/null || md5sum "$BRIEFING_FILE" | awk '{print $1}')
    echo "$PUSHED_HASH" > "$HASH_FILE"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✅ Pushed Briefing Version ${NEW_VERSION}" >> "$LOG_FILE"
  else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ❌ Push FAILED for Briefing Version ${NEW_VERSION} (exit $EXIT_CODE): $OUTPUT" >> "$LOG_FILE"
    # Do not update HASH_FILE — next run will retry (and will NOT re-increment NNN)
  fi
else
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] No changes (hash unchanged) — skipping upload." >> "$LOG_FILE"
fi
