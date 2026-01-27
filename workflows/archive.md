---
description: Archive a completed change and merge delta specs into specs/.
---

# /archive - Completion Workflow

**Goal**: Clean up active change folders and update the living "source of truth" documentation.

## Steps

1. **Invoke Agent**: Use `project-planner` or `code-custodian`.
2. **Verification**:
   - Ensure all tasks in `changes/{slug}/tasks.md` are checked off.
   - Use `docs/CONSTITUTION.md` to verify completion.
3. **Execution**:
   - Move `changes/{slug}/` → `archive/YYYY-MM-DD-{slug}/`.
   - If `changes/{slug}/specs/` exists, merge those delta specs into the main project `specs/` directory.
4. **Completion**:
   - Notify user that the change is archived and living specs updated.

## Usage

```bash
/archive feature-name
```
