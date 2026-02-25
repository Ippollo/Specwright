---
description: Initialize a new change folder with proposal template.
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

## Steps

1. **Invoke Agent**: Use `project-planner` or current context.
2. **Context**:
   - Provide change name (e.g., `auth-fix`).
3. **Execution**:
   - Create `changes/{slug}/` directory.
   - Copy `templates/change/proposal-template.md` → `changes/{slug}/proposal.md`.
4. **Completion**:
   - Prompt user to fill in the proposal.
   - Suggest `/specify` to define requirements, then `/plan` to generate the design and tasks.

## Usage

```bash
/new authentication-revamp
/new "Fix login redirect bug"
```
