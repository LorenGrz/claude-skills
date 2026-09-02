# Loren Personal Claude Instructions

These instructions adapt Claude Code to Loren's current Codex workflow. Treat them as persistent personal preferences.

## Communication

- Answer in the user's language by default.
- For every user message written partly or fully in English, apply the `english-prompt-coach` skill: a 2-line-maximum `English note` (one main issue) plus a `Better` line with the prompt phrased correctly, written only in English.
- Do not correct code, commands, file paths, proper names, or clearly intentional informal shorthand.
- Keep explanations concise and practical.
- Use direct engineering language. Avoid cheerleading, vague reassurance, and unnecessary theory.

## Working Style

- Read the existing project before changing it.
- Prefer small, scoped changes that match the repository's current patterns.
- Use `rg` or `rg --files` first for searching.
- Do not overwrite, revert, or delete user changes unless explicitly asked.
- Before larger work, state the concrete outcome, expected files, and verification command.
- Prefer project-local dependencies and scripts over global installs.
- Use `pnpm` by default for JavaScript and TypeScript projects unless a project clearly uses another package manager.
- Add or keep scripts for `dev`, `test`, `lint`, `format`, and `typecheck` when the project needs them.
- Maintain a short `README.md` for learning projects with purpose, stack, commands, architecture decisions, lessons learned, and next steps.

## Roadmap

Loren's full-stack TypeScript learning order:

```text
JavaScript -> Node.js -> TypeScript -> React -> NestJS -> Supabase + WebSockets -> Next.js -> React Native
```

**Current stage (as of 2026-08-03):** NestJS + Supabase + WebSockets. React in-depth study completed. JavaScript, Node.js, and TypeScript foundations done. Next stages: Next.js → React Native.

- Keep roadmap tasks small and aligned to the current stage.
- Do not introduce later frameworks just to make a project look advanced.
- Current roadmap repo: `/home/loren/projects/roadmap`.
- Repository context file: `/home/loren/projects/roadmap/.agents/CONTEXT.md`.
- Long-term product track: Study Tracker / Developer Progress Tracker (StudyQuest).
- Portfolio work should explain problem solved, stack, architecture decisions, lessons learned, repository link, and live demo when available.

## Skills

When a task matches an existing skill, invoke it before acting (`/<name>` or let it auto-activate). Load only the skill needed for the task.

Skills auto-load from `/home/loren/.claude/skills` (flat symlinks). Source of truth is the categorised tree in `/home/loren/.agents/skills/<category>/<skill>/`, which is a git clone of github.com/LorenGrz/claude-skills. Workflow: edit in the hub, commit, `git push`, then `git -C /home/loren/projects/claude-skills pull` (that second clone is the public showcase). After adding/moving a skill run `/home/loren/.agents/skills/sync.sh` to refresh the mirror. AWS skills live in `/home/loren/projects/aws-skills`; Oracle APEX (`apexlang`) in `/home/loren/projects/oracle-skills` (`apex/apexlang`); Omarchy/diagnose-crash ship with Omarchy — all symlinked into the hub and gitignored there.

Path-scoped rules in `/home/loren/.claude/rules/` (`typescript`, `react`, `nestjs`, `testing`, `python`) load automatically when Claude touches matching files. Some skills also carry `paths:` frontmatter and surface on their own for the matching file types.

Routing (by skill name):

- PDF work: use MarkItDown first — `/home/loren/projects/markitdown/.venv/bin/markitdown`.
- React build/refactor: `react-scalable-frontend`. React review: `react-component-validator`.
- TypeScript quality: `typescript-code-quality`. Project scaffolding: `typescript-project-starter`.
- Roadmap planning: `roadmap-coach`. NestJS modules: `nest-module-generator`. Next.js SSR: `nextjs-ssr-frontend`.
- Persistence: `database-persistence-patterns`. API contracts: `api-contract-design`.
- Tests: `unit-test-generator` to write, `execute-test-suite` to run and fix.
- Debugging: `debug-assistant`. Docs: `code-documenter`. Regex: `regex-builder-explainer`. Commits: `conventional-commit-generator`.
- Security/auth: `auth-security-basics` only when relevant.
- Omarchy/Linux desktop: `omarchy` before editing terminal, Hyprland, Waybar, Mako, Walker, theme, or desktop config.
- AWS: `sam-deploy` (SAM), `lambda-patterns` (Lambda code), `iam-least-privilege` (IAM — always least privilege), `cost-optimizer` (cost review), `serverless-scanner` (migration analysis).
- Oracle APEX: `apexlang` for generating/editing APEX apps (`.apx`, page/app metadata, APEXlang workflows).

## Omarchy And System Config

- For end-user Omarchy customization, edit safe user config locations such as `~/.config/`, never Omarchy source under `~/.local/share/omarchy/`.
- If changing OS or desktop config, test locally first.
- Before pushing OS config changes, ask Loren to confirm the change works.
- Omarchy settings repo: `/home/loren/projects/omarchy-settings`.
- Do not push unrelated or pre-existing changes.

## Git

- Assume the worktree may already be dirty.
- Inspect `git status --short` before committing.
- Prefer non-interactive git commands: inline `-m` messages, never open an editor, never `-i`.
- Never use destructive commands like `git reset --hard` or checkout-based reverts unless Loren explicitly asks.
- Never `git push --force` to `main`/`master` or any shared branch.

### GitHub push workflow (always follow when pushing to main/master or handling a GitHub remote)

Detect the default branch first: `git symbolic-ref --short refs/remotes/origin/HEAD` (falls back to `main`; some repos use `master`). Use that name wherever `<default>` appears.

1. **`.gitignore` gate.** Before the first commit in a repo, make sure `.gitignore` exists and covers, at minimum:
   - dependencies: `node_modules/`, `.pnp*`, `.venv/`, `venv/`, `__pycache__/`, `*.py[cod]`
   - env & secrets: `.env`, `.env.*` (but `!.env.example`), `*.pem`, `*.key`, `*credentials*.json`, `*secret*.json`
   - build output: `dist/`, `build/`, `out/`, `.next/`, `.turbo/`, `coverage/`, `*.tsbuildinfo`
   - logs & caches: `*.log`, `.cache/`, `tmp/`
   - OS/editor: `.DS_Store`, `Thumbs.db`, `.idea/`, `.vscode/*` (but `!.vscode/extensions.json`)
   Base it on the github/gitignore template for the stack. If any of these are already tracked, untrack them: `git rm -r --cached <path>` then commit.

2. **Sync `<default>`:** `git checkout <default> && git pull origin <default>`.

3. **Resolve conflicts** if the pull reported any: fix the files, `git add <resolved>`, `git commit` (or `git merge --continue`). Only then continue.

4. **Branch:** `git checkout -b <type>/<slug>` where `<type>` is `feature`, `refactor`, or `fix` and `<slug>` is a short kebab-case summary.

5. **Verify the touched layer**, then **stage & commit.** Run the checks for what changed and fix failures before committing:
   - frontend (React/TS): `pnpm lint` (must pass at `--max-warnings 0`) and `pnpm test run`
   - backend (Kotlin/Spring): `./gradlew test`
   - other stacks: the project's own lint + typecheck + unit tests
   Then review `git status --short`; if unrelated changes are mixed in, ask Loren before continuing. Otherwise `git add .` then `git commit -m "<Conventional Commit subject>"`.

6. **Push the branch:** `git push -u origin <type>/<slug>`.

7. **Merge & clean up:**
   ```
   git checkout <default>
   git merge --no-ff <type>/<slug> -m "Merge <type>/<slug>"
   git push origin <default>
   git branch -d <type>/<slug>
   git push origin --delete <type>/<slug>
   ```
   `--no-ff` keeps each feature visible as its own merge in the tree.

If the repo has branch protection or a PR-based flow, stop after step 6 and open a PR with `gh pr create` instead of merging locally.

## Verification

- Run the smallest useful verification command for the change.
- If tests or installs need network access, explain the blocker and ask for permission when the tool requires it.
- Report what was changed, what was verified, and anything not verified.
