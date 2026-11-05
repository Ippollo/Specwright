# Skill Catalog

The collection of skills in **Specwright**, organized by category.

> **Note**: All skills are located in the root `skills/` folder. Categories below are logical groupings for my reference.

## Frontend

Skills related to UI/UX, visual design, and framework patterns.

- [frontend-design](./skills/frontend-design/SKILL.md): Patterns for bespoke, creative frontend interfaces with bold aesthetics.
- [design-system](./skills/design-system/SKILL.md): Comprehensive Design System intelligence with style database and Vercel guidelines.

## Backend

Skills related to server-side development and data management.

- [code-quality-sentinel](./skills/code-quality-sentinel/SKILL.md): Systematic refactoring methodology with language-agnostic process and framework-specific smell catalogs.
- [security-hardening](./skills/security-hardening/SKILL.md): Pre-deployment security checklist (OWASP Top 10, Auth, Headers).

## AI / Machine Learning

Skills related to AI model integration and ML workflows.

- [gemini-api-dev](./skills/gemini-api-dev/SKILL.md): Gemini API development — current models, SDK quickstarts (Python/JS/Go/Java), function calling, structured output, multimodal, and official doc links.

## Research

Skills related to content analysis, research, and knowledge extraction.

- [youtube-review](./skills/youtube-review/SKILL.md): Extract and analyze YouTube video content from transcripts. Use when the user shares a YouTube URL for review, idea extraction, or comparison to existing systems.

## Architecture

Skills related to high-level system design.

- [system-design-architect](./skills/system-design-architect/SKILL.md): Guidelines for system architecture, scalability, and design documents.

## DevOps

Skills related to infrastructure, deployment, and version control.

- [git-wizard](./skills/git-wizard/SKILL.md): Advanced Git workflows, conflict resolution, and version control.
- [gws-cli](./skills/gws-cli/SKILL.md): Use when interacting with Google Workspace services (Drive, Docs, Sheets, Gmail) via command line. Covers file listing, folder navigation, document export, and content search. For Google Cloud infrastructure, use gcloud MCP instead.

## Testing

Skills related to quality assurance and verification.

- [webapp-testing](./skills/webapp-testing/SKILL.md): Strategies for unit, integration, and end-to-end testing of web apps.
- [verification-gate](./skills/verification-gate/SKILL.md): Evidence gate that prevents completion claims without fresh proof. Use before marking tasks done, committing, creating PRs, or expressing satisfaction with results.

## Meta

Skills and workflows related to agent processes, governance, and library management.

- [/coach](./commands/coach.md): **Start here if you're new!** Learning mode that teaches the toolkit while working.
- [/constitution](./commands/constitution.md): Workflow for establishing persistent project principles and guardrails.
- [/discover](./commands/discover.md): Scan project to identify relevant skills, detect gaps, and generate a project profile.
- [/investigate](./commands/investigate.md): Deep codebase investigation to understand existing patterns before planning.
- [/new](./commands/new.md): Workflow for initializing a new change folder with proposal templates.
- [/specify](./commands/specify.md): Workflow for creating feature specifications with prioritized user stories, constraints (Must/Must Not/Out of Scope), and current state context.
- [/clarify](./commands/clarify.md): Structured gap-filling workflow for refining specifications.
- [/plan](./commands/plan.md): Workflow for creating a detailed implementation plan with research, design, and dependency-aware tasks.
- [/analyze](./commands/analyze.md): Pre-implementation cross-artifact consistency check — verifies spec → plan → tasks alignment before any code is written.
- [/work](./commands/work.md): Pipeline orchestrator — executes tagged tasks from `tasks.md` in order: backend → design → security → enhance → test. Run `/analyze` first.
- [/review](./commands/review.md): Specialist review pipeline — runs backend, design, security, and enhance agents to review and fix auto-proceeded work.
- [/commit](./commands/commit.md): Stage, commit (conventional), and push changes. Always pushes.
- [/deploy](./commands/deploy.md): Project-aware deployment — auto-detects deploy method (Firebase, Vercel, gcloud, etc.) and runs pre/post-deploy checks.
- [/archive](./commands/archive.md): Workflow for archiving completed changes and merging living specs.
- [/status](./commands/status.md): Show the state of an active change — artifacts, task progress, and suggested next action.
- [/finish](./commands/finish.md): Ship and close — chains commit → deploy → archive in one command.
- [documentation-standards](./skills/documentation-standards/SKILL.md): Comprehensive documentation protocols with templates for SPEC, CONSTITUTION, ADR, and quality checklists.
- [prompt-engineering](./skills/prompt-engineering/SKILL.md): Foundational protocols for advanced reasoning, self-correction, and ensuring high-quality LLM outputs. Includes instruction architecture guidance for deciding when to use system prompts vs skills vs runtime context.
- [second-opinion](./skills/second-opinion/SKILL.md): Expert review protocol for stress-testing plans and decisions.
- [/build-skill](./commands/build-skill.md): Create or enhance Agent Skills — wraps the skill-builder with CREATE and MODIFY paths.
- [skill-builder](./skills/skill-builder/SKILL.md): Comprehensive tool for creating, modifying, and validating Agent Skills. Includes design principles, templates, governance rules, and exemplar references.

## Skill Relationships

Understanding how skills interact is key to effective usage:

- **Design Creativity vs. Systems**:
  - Use `frontend-design` for **bespoke, creative, or artistic** work where "breaking the grid" is desired.
  - Use `design-system` for **systematic, scalable, safe** designs that strictly follow established UI patterns (shadcn, tailwind).
  - _Do not mix these in the same component._


- **Documentation & Architecture**:
  - `system-design-architect` delegates ADRs to `documentation-standards` for the canonical template.

- **AI Integration**:
  - Use `gemini-api-dev` with `backend-architect` when building AI-powered services.
  - Use `gemini-api-dev` with `project-planner` when researching or scoping Gemini features.
  - Use `gemini-api-dev` with `debugger` when tracing Gemini API errors.

- **Verification Layer**:
  - `webapp-testing` defines **what to test** and **how to write tests**.
  - `verification-gate` enforces **that you actually ran them** before claiming success.
  - `debugger` invokes `verification-gate` in Phase 4 to confirm fixes with evidence.
