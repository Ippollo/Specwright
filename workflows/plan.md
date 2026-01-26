---
description: Create project plan using project-planner agent. No code writing - only plan file generation.
---

# /plan - Project Planning Mode

**Goal**: Create a detailed implementation plan.

## Steps

1.  **Invoke Agent**: Use the `project-planner` agent.
    - Path: `../agents/project-planner.md`
2.  **Context**: Provide the user's request.
3.  **Execution**:
    - The agent will analyze the request.
    - The agent will generate `docs/PLAN-{slug}.md`.
4.  **Completion**:
    - Agent notifies user of the plan file.
    - Agent suggests next steps (e.g., "Review plan, then run /create").

## Usage

```bash
/plan "Build a new login page with JWT"
/plan "Refactor the backend for performance"
```
