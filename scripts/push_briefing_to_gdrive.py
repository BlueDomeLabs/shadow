#!/usr/bin/env python3
# scripts/push_briefing_to_gdrive.py
#
# Uploads ARCHITECT_BRIEFING.md to the Shadow Architect Briefing Google Doc.
#
# Uses OAuth credentials from ~/.config/google-drive-mcp/ (same credentials
# used by the Google Drive MCP). No additional setup required.
#
# Exit codes:
#   0  — success
#   1  — upload failed (see stderr)
#   2  — briefing file not found

import datetime
import json
import re
import sys
import urllib.error
import urllib.parse
import urllib.request
from pathlib import Path

# ── Paths ─────────────────────────────────────────────────────────────────────
BRIEFING_FILE = Path("/Users/reidbarcus/Development/Shadow/ARCHITECT_BRIEFING.md")
TOKENS_FILE   = Path.home() / ".config/google-drive-mcp/tokens.json"
CREDS_FILE    = Path.home() / ".config/gcp-oauth.keys.json"

# Google Doc ID for "Shadow — Architect Briefing" in the shadow_app Drive folder
DOC_ID = "1dCOexVrJxnJX4vC8ItvL_twSvqBLC2Ro8oUkcG3m-8w"


def refresh_access_token() -> str:
    """Exchange the stored refresh token for a fresh access token."""
    with open(TOKENS_FILE) as f:
        tokens = json.load(f)
    with open(CREDS_FILE) as f:
        creds = json.load(f)["installed"]

    data = urllib.parse.urlencode({
        "client_id":     creds["client_id"],
        "client_secret": creds["client_secret"],
        "refresh_token": tokens["refresh_token"],
        "grant_type":    "refresh_token",
    }).encode()

    req = urllib.request.Request(
        "https://oauth2.googleapis.com/token",
        data=data,
        method="POST",
    )
    with urllib.request.urlopen(req) as resp:
        result = json.loads(resp.read())

    if "access_token" not in result:
        raise RuntimeError(f"Token refresh failed: {result}")

    # Persist the new access token so the MCP stays in sync
    tokens["access_token"] = result["access_token"]
    if "expiry_date" in result:
        tokens["expiry_date"] = result["expiry_date"]
    with open(TOKENS_FILE, "w") as f:
        json.dump(tokens, f, indent=2)

    return result["access_token"]


def get_doc_end_index(access_token: str) -> int:
    """Return the end index of the last element in the document body."""
    req = urllib.request.Request(
        f"https://docs.googleapis.com/v1/documents/{DOC_ID}",
        headers={"Authorization": f"Bearer {access_token}"},
    )
    with urllib.request.urlopen(req) as resp:
        doc = json.loads(resp.read())

    content = doc.get("body", {}).get("content", [])
    if not content:
        return 1
    return content[-1].get("endIndex", 1)


def update_doc(access_token: str, new_text: str) -> None:
    """Replace all content in the Google Doc with new_text."""
    end_index = get_doc_end_index(access_token)

    requests_list = []

    # Delete existing content (index 1 to end_index-1 is the editable range)
    if end_index > 2:
        requests_list.append({
            "deleteContentRange": {
                "range": {
                    "startIndex": 1,
                    "endIndex": end_index - 1,
                }
            }
        })

    # Insert new content at the start
    requests_list.append({
        "insertText": {
            "location": {"index": 1},
            "text": new_text,
        }
    })

    payload = json.dumps({"requests": requests_list}).encode()
    req = urllib.request.Request(
        f"https://docs.googleapis.com/v1/documents/{DOC_ID}:batchUpdate",
        data=payload,
        headers={
            "Authorization":  f"Bearer {access_token}",
            "Content-Type":   "application/json",
        },
        method="POST",
    )
    with urllib.request.urlopen(req) as resp:
        resp.read()  # consume response


def main() -> int:
    if not BRIEFING_FILE.exists():
        print(f"ERROR: Briefing file not found: {BRIEFING_FILE}", file=sys.stderr)
        return 2

    new_content = BRIEFING_FILE.read_text(encoding="utf-8")

    # Replace the "# Last Updated:" line with the current local timestamp
    timestamp = datetime.datetime.now().astimezone().strftime("%Y-%m-%d %H:%M:%S %Z")
    new_content = re.sub(
        r"^# Last Updated:.*$",
        f"# Last Updated: {timestamp}",
        new_content,
        count=1,
        flags=re.MULTILINE,
    )

    try:
        access_token = refresh_access_token()
        update_doc(access_token, new_content)
        print(f"OK: Uploaded {BRIEFING_FILE.name} to Google Doc {DOC_ID}")
        return 0
    except urllib.error.HTTPError as e:
        body = e.read().decode(errors="replace")
        print(f"ERROR: HTTP {e.code} — {body[:400]}", file=sys.stderr)
        return 1
    except Exception as e:
        print(f"ERROR: {e}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
