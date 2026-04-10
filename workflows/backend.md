---
description: Design APIs and server logic using Backend Architect.
quick_summary: "Design APIs, database schema, server logic. Uses backend-architect agent."
requires_mcp: []
recommends_mcp: [context7, firebase, gcloud]
---

# /backend - Backend Mode

**Goal**: Implement robust server-side logic and data models.

## Steps

// turbo-all

1.  **Invoke Agent**: Use the `backend-architect` agent.
    - Path: `../agents/backend-architect.md`
    - If implementing **AI/Gemini features**, also load: `../skills/gemini-api-dev/SKILL.md`
2.  **Context**: Provide the feature requirement.
3.  **Execution**:
    - Agent designs API contract.
    - Agent models database schema.
    - Agent implements logic with performance in mind.

## Task Filtering

When a `tasks.md` is present in the active change folder:

1. **Scan** `tasks.md` for incomplete tasks tagged with `/backend`.
2. **Execute only** those tasks, in order.
3. **Mark each** `[x]` in `tasks.md` as it completes.
4. **Run CHECKPOINT** if one follows the completed tasks.
5. **Auto-advance**: When all `/backend` tasks are done, proceed to the next pipeline stage (`/design`). Load the `frontend-specialist` agent and continue.

## Reflection

After completion, briefly evaluate:
1. **What worked?** — Patterns, tools, or approaches that were effective.
2. **What was friction?** — Slowdowns, dead ends, or repeated mistakes.
3. **Update needed?** — If a reusable lesson emerged, append it to `mistakes.md` or suggest an update to the relevant skill/workflow. If nothing noteworthy, skip silently.

> This step is internal — do not present the reflection to the user unless it surfaces an actionable update.


