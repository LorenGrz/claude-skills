#!/usr/bin/env bash
# Stop: if the working dir is a git repo with uncommitted changes, surface them.
set -uo pipefail

cat >/dev/null 2>&1 || true  # drain stdin

git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0
changes="$(git status --short 2>/dev/null)"
[ -n "$changes" ] || exit 0

count="$(printf '%s\n' "$changes" | grep -c . || true)"
jq -n --arg s "$changes" --arg n "$count" \
  '{systemMessage: ("Uncommitted changes (" + $n + "):\n" + $s)}'
exit 0
