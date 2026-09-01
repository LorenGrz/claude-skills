#!/usr/bin/env bash
# Regenerate the flat symlink mirror that Claude Code reads
# (~/.claude/skills) from this categorised skill tree.
#
# Claude Code only discovers ~/.claude/skills/<name>/SKILL.md (direct children),
# so category folders live here in the source tree and the mirror stays flat.
#
# Safe to run repeatedly. Only touches symlinks that point into this tree;
# external symlinks (aws-skills, omarchy) and real dirs in the mirror are left
# alone.

set -euo pipefail

HUB="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MIRROR="${CLAUDE_SKILLS_MIRROR:-$HOME/.claude/skills}"

mkdir -p "$MIRROR"

created=0 updated=0 pruned=0

# 1. Link every skill found in the category tree.
while IFS= read -r skill_md; do
  dir="$(dirname "$skill_md")"        # <hub>/<category>/<skill>
  name="$(basename "$dir")"
  link="$MIRROR/$name"

  if [ -L "$link" ]; then
    [ "$(readlink "$link")" = "$dir" ] && continue
    rm -f "$link"; ln -s "$dir" "$link"; updated=$((updated+1))
  elif [ -e "$link" ]; then
    echo "skip $name: $link exists and is not a symlink" >&2
  else
    ln -s "$dir" "$link"; created=$((created+1))
  fi
done < <(find "$HUB" -mindepth 3 -maxdepth 3 -name SKILL.md)

# 2. Prune mirror symlinks that point into the hub but no longer resolve.
for link in "$MIRROR"/*; do
  [ -L "$link" ] || continue
  target="$(readlink "$link")"
  case "$target" in
    "$HUB"/*) [ -e "$link" ] || { rm -f "$link"; pruned=$((pruned+1)); } ;;
  esac
done

echo "mirror: $MIRROR"
echo "created $created, updated $updated, pruned $pruned"
