# config/ — portable Claude Code configuration

Tracked here, symlinked into `~/.claude/` so Claude Code loads it:

```
~/.claude/CLAUDE.md  -> ~/.agents/skills/config/CLAUDE.md
~/.claude/rules      -> ~/.agents/skills/config/rules
~/.claude/hooks      -> ~/.agents/skills/config/hooks
```

Edit here, commit, push, then `git -C ~/projects/claude-skills pull` for the showcase clone.

**Not tracked** (machine-local / secret): `~/.claude/settings.json`, `settings.local.json`,
`.credentials.json`, `sessions/`, `projects/` (auto-memory + transcripts), logs, caches.

> Cowork sessions on the desktop skip a symlinked `~/.claude/rules/` that points outside
> the working dir. This setup targets the Claude Code CLI, where symlinked rules load fine.

## rules/

Path-scoped — each loads only when Claude touches a matching file.

| File | Loads on | Purpose |
|------|----------|---------|
| `typescript.md` | `**/*.ts(x)` | strict typing, boundary validation |
| `react.md` | `**/*.tsx`, `**/*.jsx` | no-`useEffect` doctrine, hooks own data-loading, frontend domain objects, Vitest+RTL (BookLibre patterns) |
| `nestjs.md` | Nest file suffixes | clean-architecture layering |
| `kotlin.md` | `**/*.kt(s)` | Spring Boot layered architecture (domain / service / controller / mapper), Kotest |
| `python.md` | `**/*.py` | uv/ruff/mypy, pydantic, agent-script reliability |
| `testing.md` | `*.test/spec.*` | behaviour over implementation |
| `security.md` | server + config files | authz binding, tokens, CSRF/CORS, input validation, secrets, error handling |

## hooks/ — wire into `~/.claude/settings.json`

```json
{
  "hooks": {
    "PreToolUse":  [{ "matcher": "Edit|Write|MultiEdit", "hooks": [{ "type": "command", "command": "bash ~/.claude/hooks/guard-omarchy.sh" }] }],
    "PostToolUse": [{ "matcher": "Edit|Write|MultiEdit", "hooks": [{ "type": "command", "command": "bash ~/.claude/hooks/format-file.sh", "statusMessage": "formatting" }] }],
    "Stop":        [{ "hooks": [{ "type": "command", "command": "bash ~/.claude/hooks/stop-git-status.sh" }] }],
    "InstructionsLoaded": [{ "hooks": [{ "type": "command", "command": "bash ~/.claude/hooks/log-instructions.sh", "async": true }] }]
  }
}
```

| Script | Event | Does |
|--------|-------|------|
| `guard-omarchy.sh` | PreToolUse | denies edits under `~/.local/share/omarchy/` |
| `format-file.sh` | PostToolUse | project formatter on the edited file: prettier → eslint `--fix` (TS), `ktlint -F` (Kotlin), `ruff` (Python) |
| `stop-git-status.sh` | Stop | shows uncommitted changes when in a git repo |
| `log-instructions.sh` | InstructionsLoaded | logs loaded rules/skills to `~/.claude/logs/instructions-loaded.log` |
