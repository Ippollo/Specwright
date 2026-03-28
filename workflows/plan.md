---
description: Create project plan and research using project-planner agent. No code writing.
quick_summary: "Generate research.md, design.md, tasks.md using project-planner agent."
requires_mcp: []
recommends_mcp:
  [sequential-thinking, github, context7, firecrawl-mcp, firebase, gcloud]
---

# /plan - Project Planning Mode

**Goal**: Create a detailed implementation plan and research document.

## Steps

1.  **Invoke Agent**: Use the `project-planner` agent.
    - Path: `../agents/project-planner.md`
2.  **Context**:
    - Provide user's request.
    - Reference `docs/CONSTITUTION.md` (principles).
    - Reference `changes/{slug}/specs/` (requirements).
3.  **Execution**:
    - Agent analyzes against principles and requirements.
    - Agent performs technical research.
    - Agent generates `changes/{slug}/research.md`.
    - Agent generates `changes/{slug}/design.md` — includes **Alternatives Considered** section (at least one rejected approach with reasoning and trade-offs).
    - Agent generates `changes/{slug}/tasks.md` with dependency-aware, **workflow-routed** tasks.
    - Each task is tagged with its executing workflow (`/backend`, `/design`, `/enhance`, `/test`, `/debug`, `/security`).
    - Agent records significant architectural decisions in `design.md`'s Architecture Decisions section.
4.  **Completion**:
    - Agent notifies user of generated files.
    - Agent suggests review, then `/analyze` to verify spec → plan → tasks consistency before `/work`.

## Usage

```bash
/plan "Build feature based on SPEC-auth-v1"
/plan "Refactor backend for performance"
```

## Recommended MCP Servers

- **Sequential Thinking**: Break down complex plans step-by-step.
