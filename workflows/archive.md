---
description: Archive a completed change and merge delta specs into specs/.
quick_summary: "Move changes/{slug}/ to archive/, merge specs. Run after all tasks complete."
requires_mcp: []
recommends_mcp: []
---

# /archive - Completion Workflow

**Goal**: Clean up the workspace and preserve architectural knowledge once a change is complete.

## When to Use

- All tasks in `tasks.md` are complete.
- The change has been tested and verified.
- You are finished with the specific feature folder and want to merge its specs.

## Steps

// turbo-all

1. **Invoke Agent**: Use `project-planner` or `code-custodian`.
2. **Verification**:
   - Ensure all tasks in `changes/{slug}/tasks.md` are checked off.
   - Use `docs/CONSTITUTION.md` to verify completion.
3. **Snapshot Spec**:
   - Get the current short commit hash (`git rev-parse --short HEAD`).
   - If `changes/{slug}/specs/` exists:
     - Copy spec files → `specs/{slug}.md` (living version, merged/overwritten).
     - Copy spec files → `specs/snapshots/{slug}--{short-hash}.md` (frozen snapshot).
   - The snapshot preserves the exact spec state at ship time for future reference.
4. **Execution**:
   - Move `changes/{slug}/` → `archive/YYYY-MM-DD-{slug}/`.
5. **Completion**:
   - Notify user that the change is archived, living specs updated, and snapshot preserved.

## Usage

```bash
/archive feature-name
```
