#!/usr/bin/env bash
# Regenerate the flat symlink mirror that Claude Code reads
# (~/.claude/skills) from the categorised skill tree.
#
# Claude Code only discovers ~/.claude/skills/<name>/SKILL.md (direct children),
# so category folders live in the source tree and the mirror stays flat.
#
# Source of truth: ~/.agents/skills  (override with SKILLS_HUB)
# Mirror:          ~/.claude/skills   (override with CLAUDE_SKILLS_MIRROR)
#
# Safe to run repeatedly. Only touches symlinks that point into the hub;
# external symlinks (aws-skills, omarchy) and real dirs are left alone.

set -euo pipefail

HUB="${SKILLS_HUB:-$HOME/.agents/skills}"
MIRROR="${CLAUDE_SKILLS_MIRROR:-$HOME/.claude/skills}"

[ -d "$HUB" ] || { echo "hub not found: $HUB" >&2; exit 1; }
mkdir -p "$MIRROR"

created=0 updated=0 pruned=0

# 1. Link every skill found two levels deep in the hub (<category>/<skill>/SKILL.md).
while IFS= read -r skill_md; do
  dir="$(dirname "$skill_md")"
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
  case "$(readlink "$link")" in
    "$HUB"/*) [ -e "$link" ] || { rm -f "$link"; pruned=$((pruned+1)); } ;;
  esac
done

echo "hub:    $HUB"
echo "mirror: $MIRROR"
echo "created $created, updated $updated, pruned $pruned"
