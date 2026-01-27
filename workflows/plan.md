---
description: Create project plan and research using project-planner agent. No code writing.
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
    - Agent generates `changes/{slug}/design.md`.
    - Agent generates `changes/{slug}/tasks.md` with dependency-aware tasks.
4.  **Completion**:
    - Agent notifies user of generated files.
    - Agent suggests review, then moving to implementation.

## Usage

```bash
/plan "Build feature based on SPEC-auth-v1"
/plan "Refactor backend for performance"
```
