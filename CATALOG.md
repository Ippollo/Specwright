# My Skill Catalog

The collection of skills I've taught **Antigravity** in my `c:\Projects\agentic-toolkit` library, organized by category.

> **Note**: All skills are located in the root `skills/` folder. Categories below are logical groupings for my reference.

## Frontend

Skills related to UI/UX, visual design, and framework patterns.

- [frontend-design](./skills/frontend-design/SKILL.md): Patterns for bespoke, creative frontend interfaces with bold aesthetics.
- [design-system](./skills/design-system/SKILL.md): Comprehensive Design System intelligence with style database and Vercel guidelines.
- [react-best-practices](./skills/react-best-practices/SKILL.md): Modern patterns and performance tips for React applications.
- [vue-svelte-patterns](./skills/vue-svelte-patterns/SKILL.md): Vue and Svelte component patterns (composables, provide/inject, slots, runes).

## Backend

Skills related to server-side development and data management.

- [api-design-patterns](./skills/api-design-patterns/SKILL.md): **Modular** toolkit for designing REST, GraphQL, and Async APIs. Includes security, rate limiting, versioning patterns, and OpenAPI templates.
- [backend-performance](./skills/backend-performance/SKILL.md): Protocols for optimizing backend speed (Caching, Database, Async).
- [code-quality-sentinel](./skills/code-quality-sentinel/SKILL.md): Systematic refactoring methodology with language-agnostic process and framework-specific smell catalogs.
- [data-modeling](./skills/data-modeling/SKILL.md): Database schema design, relationship patterns, and migration workflows (SQL/NoSQL).
- [security-hardening](./skills/security-hardening/SKILL.md): Protocols for securing web apps (OWASP Top 10, Auth Patterns, Audit Workflows).

## AI / Machine Learning

Skills related to AI model integration and ML workflows.

- [gemini-api-dev](./skills/gemini-api-dev/SKILL.md): Gemini API development — current models, SDK quickstarts (Python/JS/Go/Java), function calling, structured output, multimodal, and official doc links.

## Architecture

Skills related to high-level system design.

- [system-design-architect](./skills/system-design-architect/SKILL.md): Guidelines for system architecture, scalability, and design documents.

## DevOps

Skills related to infrastructure, deployment, and version control.

- [deployment-pipeline](./skills/deployment-pipeline/SKILL.md): Protocols for CI/CD, containerization, and safe deployment strategies.
- [git-wizard](./skills/git-wizard/SKILL.md): Advanced Git workflows, conflict resolution, and version control.
- [firecrawl-cli](./skills/firecrawl-cli/SKILL.md): Advanced web scraping, crawling, and content extraction via command-line interface.

## Testing

Skills related to quality assurance and verification.

- [unit-testing-strategy](./skills/unit-testing-strategy/SKILL.md): Principles and patterns for Python (pytest) and TypeScript (Jest/Vitest) unit testing.
- [webapp-testing](./skills/webapp-testing/SKILL.md): Strategies for unit, integration, and end-to-end testing of web apps.

## Meta

Skills and workflows related to agent processes, governance, and library management.

- [/coach](./workflows/coach.md): **Start here if you're new!** Learning mode that teaches the toolkit while working.
- [/constitution](./workflows/constitution.md): Workflow for establishing persistent project principles and guardrails.
- [/investigate](./workflows/investigate.md): Deep codebase investigation to understand existing patterns before planning.
- [/new](./workflows/new.md): Workflow for initializing a new change folder with proposal templates.
- [/specify](./workflows/specify.md): Workflow for creating feature specifications with prioritized user stories.
- [/clarify](./workflows/clarify.md): Structured gap-filling workflow for refining specifications.
- [/work](./workflows/work.md): Pipeline orchestrator — executes tagged tasks from `tasks.md` in order: backend → design → security → enhance → test.
- [/review](./workflows/review.md): Specialist review pipeline — runs backend, design, security, and enhance agents to review and fix auto-proceeded work.
- [/commit](./workflows/commit.md): Stage, commit (conventional), and push changes. Always pushes.
- [/archive](./workflows/archive.md): Workflow for archiving completed changes and merging living specs.
- [documentation-standards](./skills/documentation-standards/SKILL.md): Comprehensive documentation protocols with templates for SPEC, CONSTITUTION, ADR, and quality checklists.
- [prompt-engineering](./skills/prompt-engineering/SKILL.md): Techniques and patterns for effective LLM prompting.
- [second-opinion](./skills/second-opinion/SKILL.md): Expert review protocol for stress-testing plans and decisions.
- [skill-builder](./skills/skill-builder/SKILL.md): Gap detection and interactive wizard for creating new skills.
- [skill-management](./skills/skill-management/SKILL.md): Governance rules for organizing and maintaining this skill library.

## Skill Relationships

Understanding how skills interact is key to effective usage:

- **Design Creativity vs. Systems**:
  - Use `frontend-design` for **bespoke, creative, or artistic** work where "breaking the grid" is desired.
  - Use `design-system` for **systematic, scalable, safe** designs that strictly follow established UI patterns (shadcn, tailwind).
  - _Do not mix these in the same component._

- **Component Patterns by Framework**:
  - Use `react-best-practices` for **React/Next.js** components (hooks, performance, patterns).
  - Use `vue-svelte-patterns` for **Vue/Svelte** components (composables, runes, slots).

- **Testing Layers**:
  - `unit-testing-strategy` covers the _code logic_ layer (TDD, functions).
  - `webapp-testing` covers the _user interaction_ layer (E2E, clicks, flows).

- **Documentation & Architecture**:
  - `system-design-architect` delegates ADRs to `documentation-standards` for the canonical template.

- **AI Integration**:
  - Use `gemini-api-dev` with `backend-architect` when building AI-powered services.
  - Use `gemini-api-dev` with `project-planner` when researching or scoping Gemini features.
  - Use `gemini-api-dev` with `debugger` when tracing Gemini API errors.
