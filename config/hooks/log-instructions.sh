#!/usr/bin/env bash
# InstructionsLoaded: append which instruction files (CLAUDE.md, rules, skills)
# were loaded, for debugging why a rule/skill did or didn't activate.
set -uo pipefail

log="$HOME/.claude/logs/instructions-loaded.log"
payload="$(cat)"
ts="$(date -Is)"

{
  printf '=== %s ===\n' "$ts"
  printf '%s' "$payload" | jq -r '
    (.session_id // "?") as $sid
    | "session: \($sid)",
      (.cwd // .workingDirectory // empty | "cwd: \(.)"),
      (( .instructions // .files // .loadedFiles // [] )
        | if type=="array" then (.[] | "  " + (.path // .file // tostring))
          else "  " + tostring end)
  ' 2>/dev/null || printf '%s\n' "$payload"
  printf '\n'
} >> "$log" 2>/dev/null || true
exit 0
