#!/bin/bash
# scripts/sync_briefing.sh
#
# Stop hook: pushes ARCHITECT_BRIEFING.md to Google Drive whenever its
# content has changed since the last successful upload.
#
# Detection: compares an MD5 hash of the current file against
# .last_sync_hash (written after each successful push). This approach
# is reliable regardless of git commit state and works across sessions.
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
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] Change detected (hash $CURRENT_HASH) — pushing Architect Briefing to Google Drive..." >> "$LOG_FILE"

  OUTPUT=$(python3 "$PYTHON_SCRIPT" 2>&1)
  EXIT_CODE=$?

  if [ $EXIT_CODE -eq 0 ]; then
    # Record the hash we just successfully pushed
    echo "$CURRENT_HASH" > "$HASH_FILE"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] SUCCESS: $OUTPUT" >> "$LOG_FILE"
  else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] FAILED (exit $EXIT_CODE): $OUTPUT" >> "$LOG_FILE"
    # Do not update HASH_FILE — next run will retry
  fi
else
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] No changes (hash unchanged) — skipping upload." >> "$LOG_FILE"
fi
