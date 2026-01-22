# Skill Catalog

This catalog lists all available skills in the `c:/Projects/skills` library, organized by category.

> **Note**: All skills are located in the root `skills/` folder. Categories below are logical groupings.

## Frontend

Skills related to UI/UX, visual design, and framework patterns.

- [frontend-design](./frontend-design/SKILL.md): Patterns for bespoke, creative frontend interfaces with bold aesthetics.
- [design-system](./design-system/SKILL.md): Comprehensive Design System intelligence with style database and Vercel guidelines.
- [react-best-practices](./react-best-practices/SKILL.md): Modern patterns and performance tips for React applications.
- [vue-svelte-patterns](./vue-svelte-patterns/SKILL.md): Vue and Svelte component patterns (composables, provide/inject, slots, runes).

## Backend

Skills related to server-side development and data management.

- [api-design-patterns](./api-design-patterns/SKILL.md): **Modular** toolkit for designing REST, GraphQL, and Async APIs. Includes security, rate limiting, versioning patterns, and OpenAPI templates.
- [backend-performance](./backend-performance/SKILL.md): Protocols for optimizing backend speed (Caching, Database, Async).
- [code-quality-sentinel](./code-quality-sentinel/SKILL.md): Systematic refactoring methodology with language-agnostic process and framework-specific smell catalogs.
- [data-modeling](./data-modeling/SKILL.md): Database schema design, relationship patterns, and migration workflows (SQL/NoSQL).
- [security-hardening](./security-hardening/SKILL.md): Protocols for securing web apps (OWASP Top 10, Auth Patterns, Audit Workflows).

## Architecture

Skills related to high-level system design.

- [system-design-architect](./system-design-architect/SKILL.md): Guidelines for system architecture, scalability, and design documents.

## DevOps

Skills related to infrastructure, deployment, and version control.

- [deployment-pipeline](./deployment-pipeline/SKILL.md): Protocols for CI/CD, containerization, and safe deployment strategies.
- [git-wizard](./git-wizard/SKILL.md): Advanced Git workflows, conflict resolution, and version control.

## Testing

Skills related to quality assurance and verification.

- [unit-testing-strategy](./unit-testing-strategy/SKILL.md): Principles and patterns for Python (pytest) and TypeScript (Jest/Vitest) unit testing.
- [webapp-testing](./webapp-testing/SKILL.md): Strategies for unit, integration, and end-to-end testing of web apps.

## Meta

Skills related to agent processes, governance, and library management.

- [documentation-standards](./documentation-standards/SKILL.md): Comprehensive documentation protocols with decision tree, templates for README/Changelog/ADR/Gotchas, and quality checklists.
- [prompt-engineering](./prompt-engineering/SKILL.md): Techniques and patterns for effective LLM prompting.
- [second-opinion](./second-opinion/SKILL.md): Expert review protocol for stress-testing plans and decisions.
- [skill-builder](./skill-builder/SKILL.md): Gap detection and interactive wizard for creating new skills.
- [skill-management](./skill-management/SKILL.md): Governance rules for organizing and maintaining this skill library.

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
