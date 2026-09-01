---
name: codex-workflows
description: Reuse Loren's Codex and local agent workflows. Use when work involves existing Codex skills, roadmap projects, Omarchy config, PDFs, screenshots, browser checks, security reviews, TypeScript/React/NestJS code, or migration from Codex to Claude.
---

# Codex Workflows Adapter

Use this skill to adapt Claude Code to Loren's existing Codex setup without duplicating stale instructions.

## First Step

Identify the task category, then read only the relevant source skill files before acting.

Skill roots:

- `/home/loren/.codex/skills`
- `/home/loren/.agents/skills`
- `/home/loren/.local/share/omarchy/default/omarchy-skill/SKILL.md`

## Routing

- New JS/TS project or standard scripts: `/home/loren/.agents/skills/typescript-project-starter/SKILL.md`
- Roadmap planning or learning project scope: `/home/loren/.agents/skills/roadmap-coach/SKILL.md`
- React frontend implementation/refactor: `/home/loren/.agents/skills/react-scalable-frontend/SKILL.md`
- React component lifecycle review: `/home/loren/.agents/skills/react-component-validator/SKILL.md`
- TypeScript quality: `/home/loren/.agents/skills/typescript-code-quality/SKILL.md`
- API contracts: `/home/loren/.agents/skills/api-contract-design/SKILL.md`
- Auth/security implementation: `/home/loren/.agents/skills/auth-security-basics/SKILL.md`
- Security review by explicit request: `/home/loren/.codex/skills/security-best-practices/SKILL.md`
- NestJS module generation: `/home/loren/.agents/skills/nest-module-generator/SKILL.md`
- Persistence/database work: `/home/loren/.agents/skills/database-persistence-patterns/SKILL.md`
- Docker-backed local environment: `/home/loren/.agents/skills/run-docker-environment/SKILL.md`
- Test-suite execution and fix loop: `/home/loren/.agents/skills/execute-test-suite/SKILL.md`
- Repository context maintenance: `/home/loren/.agents/skills/repository-context-maintainer/SKILL.md`
- Omarchy desktop/system config: `/home/loren/.local/share/omarchy/default/omarchy-skill/SKILL.md`
- PDFs: `/home/loren/.codex/skills/pdf/SKILL.md`
- Browser automation: `/home/loren/.codex/skills/playwright/SKILL.md` or browser plugin skill if installed.

## Rules

- Load skills progressively. Do not paste every skill into context.
- Prefer local project scripts and local dependencies.
- Preserve user changes. Do not revert unrelated files.
- For Omarchy config, test first and ask before pushing to `/home/loren/projects/omarchy-settings`.
- For roadmap work, keep the next step small and aligned with the sequence:

```text
JavaScript -> Node.js -> TypeScript -> React -> NestJS -> Supabase + WebSockets -> Next.js -> React Native
```

## Startup Check For Roadmap Repo

When working in `/home/loren/projects/roadmap`, read:

- `/home/loren/projects/roadmap/README.md`
- `/home/loren/projects/roadmap/.agents/CONTEXT.md`
- `pnpm-workspace.yaml` if package installation or workspace behavior is involved.

Remember: `node_modules/` must stay untracked.
