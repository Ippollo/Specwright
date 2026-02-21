---
description: Design and implement UI components using Frontend Specialist.
quick_summary: "Create UI components with frontend-specialist agent. Checks design system."
requires_mcp: []
recommends_mcp: [context7, playwright, firebase, gcloud]
---

# /design - Design Mode

**Goal**: Create high-quality, system-compliant UI components.

## Steps

1.  **Invoke Agent**: Use the `frontend-specialist` agent.
    - Path: `../agents/frontend-specialist.md`
2.  **Context**: Provide the design requirement.
3.  **Execution**:
    - Agent checks Design System compatibility.
    - Agent plans component structure.
    - Agent implements code.
    - Agent verifies responsiveness.

## Task Filtering

When a `tasks.md` is present in the active change folder:

1. **Scan** `tasks.md` for incomplete tasks tagged with `/design`.
2. **Execute only** those tasks, in order.
3. **Mark each** `[x]` in `tasks.md` as it completes.
4. **Run CHECKPOINT** if one follows the completed tasks.
5. **Auto-advance**: When all `/design` tasks are done, proceed to the next pipeline stage (`/security`). Load the `sec-devops-engineer` agent and continue.
