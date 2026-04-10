---
description: Initialize a new change folder.
quick_summary: "Create changes/{slug}/ folder with proposal.md. Required starting point."
requires_mcp: []
recommends_mcp: []
---

# /new - New Change Workflow

**Goal**: Start a new feature or bug fix with its own isolated folder. **This is the required starting point for all project work (planning and execution).**

## When to Use

- **Always** before starting any new task, feature, or bug fix.
- To prevent changes from leaking into other active work folders.
- When you want a clean slate for planning.

## Scope Check — Update or New?

Before creating a new change, check if an active change already covers this work. Ask three questions:

| #   | Question                                                     | Update existing                           | Start new                                |
| --- | ------------------------------------------------------------ | ----------------------------------------- | ---------------------------------------- |
| 1   | **Same intent?** Same problem being solved?                  | Yes — same goal, refined execution        | No — fundamentally different work        |
| 2   | **>50% overlap?** Does new work overlap with existing scope? | Yes — it's a refinement                   | No — mostly new territory                |
| 3   | **Can original be "done" without this?**                     | No — this is part of the same deliverable | Yes — original is completable on its own |

**Rule of thumb:**

- **2–3 "Update" answers** → update the existing change's proposal/spec/tasks
- **2–3 "Start new" answers** → archive the old change (if complete) and `/new`
- If a change has grown so much the proposal is unrecognizable, it's new work

> This is guidance, not a gate. When ambiguous, ask the user.

## Steps

1. **Invoke Agent**: Use `project-planner` or current context.
2. **Context**:
   - Provide change name (e.g., `auth-fix`).
3. **Execution**:
   - Create `changes/{slug}/` directory.
   - Copy `templates/change/proposal-template.md` → `changes/{slug}/proposal.md`.
   - Create `project-context.md` from `templates/project-context-template.md` in the project root (if one doesn't already exist). Populate Repository fields from git.
4. **Completion**:
   - Prompt user to fill in the proposal.
   - Suggest `/specify` to define requirements, then `/plan` to generate the design and tasks.

## Usage

```bash
/new authentication-revamp
/new "Fix login redirect bug"
```

