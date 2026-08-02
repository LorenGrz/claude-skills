# claude-skills

Personal Claude Code skill library for Lorenzo Graizzaro. These skills are loaded on demand by Claude when working on specific task types, providing consistent patterns, rules, and workflows across projects.

## All skills

| Skill | Purpose |
|-------|---------|
| [`api-contract-design`](./api-contract-design/SKILL.md) | REST API contract design, OpenAPI, versioning |
| [`auth-security-basics`](./auth-security-basics/SKILL.md) | Auth, authorization, token handling, secrets across NestJS/Next.js/React |
| [`code-review-safety`](./code-review-safety/SKILL.md) | Code review safety checklist — security, correctness, test coverage |
| [`database-persistence-patterns`](./database-persistence-patterns/SKILL.md) | PostgreSQL, MongoDB, Redis patterns in TypeScript |
| [`execute-test-suite`](./execute-test-suite/SKILL.md) | Running test suites, interpreting failures, fixing flaky tests |
| [`nest-module-generator`](./nest-module-generator/SKILL.md) | Generating NestJS modules with correct structure and patterns |
| [`nextjs-ssr-frontend`](./nextjs-ssr-frontend/SKILL.md) | Next.js SSR/SSG patterns, App Router, data fetching |
| [`omarchy`](./omarchy/SKILL.md) | Hyprland/Waybar/Omarchy desktop customization on Arch Linux |
| [`react-component-validator`](./react-component-validator/SKILL.md) | Reviewing React components for correctness and best practices |
| [`react-native-mobile`](./react-native-mobile/SKILL.md) | React Native development patterns |
| [`react-scalable-frontend`](./react-scalable-frontend/SKILL.md) | Scalable React architecture — component design, state, routing |
| [`repository-context-maintainer`](./repository-context-maintainer/SKILL.md) | Keeping CONTEXT.md and project documentation up to date |
| [`roadmap-coach`](./roadmap-coach/SKILL.md) | Full-stack TS learning roadmap planning and task sizing |
| [`run-docker-environment`](./run-docker-environment/SKILL.md) | Docker Compose setup, debugging containers, dev environments |
| [`team-architect-agent`](./team-architect-agent/SKILL.md) | Multi-agent architecture design role |
| [`team-implementer-agent`](./team-implementer-agent/SKILL.md) | Multi-agent implementation role |
| [`team-reviewer-agent`](./team-reviewer-agent/SKILL.md) | Multi-agent code review role |
| [`typescript-code-quality`](./typescript-code-quality/SKILL.md) | TypeScript strict mode, type safety, tsconfig, code quality |
| [`typescript-project-starter`](./typescript-project-starter/SKILL.md) | Scaffolding JS/TS projects with pnpm, scripts, and tooling |

## Notes

- **Omarchy**: the authoritative version of this skill lives at `~/.local/share/omarchy/default/omarchy-skill/SKILL.md` (distributed with Omarchy). The copy here is for backup reference only — on a fresh machine with Omarchy installed, use the upstream version.
- **AWS skills**: managed separately at [`LorenGrz/aws-skills`](https://github.com/LorenGrz/aws-skills).

## Setup on a new machine

```bash
# Clone to the standard skills location
git clone https://github.com/LorenGrz/claude-skills ~/.agents/skills

# Or to a different location and update CLAUDE.md
git clone https://github.com/LorenGrz/claude-skills ~/projects/claude-skills
# Then update ~/.claude/CLAUDE.md:
# Loren local skills: /home/<user>/projects/claude-skills
```

### CLAUDE.md routing snippet

```md
Skill roots:
- Loren local skills: `/home/loren/.agents/skills`
- Omarchy skill: `/home/loren/.local/share/omarchy/default/omarchy-skill/SKILL.md`
```
