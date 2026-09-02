#!/usr/bin/env bash
# PreToolUse (Edit|Write|MultiEdit): block writes to Omarchy source.
# CLAUDE.md: never edit Omarchy source under ~/.local/share/omarchy/.
set -euo pipefail

payload="$(cat)"
f="$(printf '%s' "$payload" | jq -r '.tool_input.file_path // .tool_input.path // empty')"
[ -n "$f" ] || exit 0

case "$f" in
  "$HOME"/.local/share/omarchy/*|/home/*/.local/share/omarchy/*)
    jq -n --arg f "$f" '{
      hookSpecificOutput: {
        hookEventName: "PreToolUse",
        permissionDecision: "deny",
        permissionDecisionReason: ("Omarchy source is off-limits (CLAUDE.md). Edit user config under ~/.config/ instead. Blocked: " + $f)
      }
    }'
    exit 0
    ;;
esac
exit 0
