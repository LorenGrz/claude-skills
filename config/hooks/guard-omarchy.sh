#!/usr/bin/env bash
# PreToolUse (Edit|Write|MultiEdit | replace_file_content|write_to_file): block writes to Omarchy source.
# CLAUDE.md: never edit Omarchy source under ~/.local/share/omarchy/.
set -euo pipefail

payload="$(cat)"
is_antigravity="$(printf '%s' "$payload" | jq -r '.toolCall // empty' 2>/dev/null)"
f="$(printf '%s' "$payload" | jq -r '.toolCall.args.TargetFile // .toolCall.args.AbsolutePath // .tool_input.file_path // .tool_input.path // empty' 2>/dev/null)"

allow() {
  if [ -n "$is_antigravity" ]; then
    echo '{"decision": "allow"}'
  fi
  exit 0
}

[ -n "$f" ] || allow

case "$f" in
  "$HOME"/.local/share/omarchy/*|/home/*/.local/share/omarchy/*)
    jq -n --arg f "$f" '{
      decision: "deny",
      reason: ("Omarchy source is off-limits (CLAUDE.md). Edit user config under ~/.config/ instead. Blocked: " + $f),
      hookSpecificOutput: {
        hookEventName: "PreToolUse",
        permissionDecision: "deny",
        permissionDecisionReason: ("Omarchy source is off-limits (CLAUDE.md). Edit user config under ~/.config/ instead. Blocked: " + $f)
      }
    }'
    exit 0
    ;;
esac

allow
