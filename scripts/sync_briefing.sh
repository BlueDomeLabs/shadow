#!/bin/bash
# scripts/sync_briefing.sh
#
# Stop hook: pushes ARCHITECT_BRIEFING.md to Google Drive if it was
# modified since the last git commit (staged or unstaged changes).
#
# Wired as a Claude Code Stop hook in ~/.claude/settings.json.
# Logs every run to scripts/sync_briefing.log.

REPO="/Users/reidbarcus/Development/Shadow"
BRIEFING_FILE="$REPO/ARCHITECT_BRIEFING.md"
PYTHON_SCRIPT="$REPO/scripts/push_briefing_to_gdrive.py"
LOG_FILE="$REPO/scripts/sync_briefing.log"

# Ensure log directory exists
mkdir -p "$(dirname "$LOG_FILE")"

# ── Check for changes ─────────────────────────────────────────────────────────
# Detect whether ARCHITECT_BRIEFING.md has been modified since HEAD.
# Covers both uncommitted edits (diff HEAD) and the most recent commit (diff HEAD~1..HEAD).
UNCOMMITTED=$(git -C "$REPO" diff --name-only HEAD 2>/dev/null | grep -c "ARCHITECT_BRIEFING.md")
RECENT_COMMIT=$(git -C "$REPO" diff --name-only HEAD~1 HEAD 2>/dev/null | grep -c "ARCHITECT_BRIEFING.md")

if [ "$UNCOMMITTED" -gt 0 ] || [ "$RECENT_COMMIT" -gt 0 ]; then
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] Change detected — pushing Architect Briefing to Google Drive..." >> "$LOG_FILE"

  OUTPUT=$(python3 "$PYTHON_SCRIPT" 2>&1)
  EXIT_CODE=$?

  if [ $EXIT_CODE -eq 0 ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] SUCCESS: $OUTPUT" >> "$LOG_FILE"
  else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] FAILED (exit $EXIT_CODE): $OUTPUT" >> "$LOG_FILE"
  fi
else
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] No changes to Architect Briefing — skipping upload." >> "$LOG_FILE"
fi
