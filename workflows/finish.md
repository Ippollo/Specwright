---
description: Complete a change by committing, deploying, and archiving in one step.
quick_summary: "Chains /commit → /deploy → /archive. The final step after user testing."
requires_mcp: []
recommends_mcp: [github, gcloud, firebase, observability]
---

# /finish - Completion Pipeline

**Goal**: Ship and close out a change in one command: commit, deploy, and archive.

## Pipeline

```
/commit → /deploy → /archive
```

| Stage      | What Happens                                 | User Gate? |
| ---------- | -------------------------------------------- | ---------- |
| `/commit`  | Stage all changes, conventional commit, push | Auto       |
| `/deploy`  | Verify CI/CD, trigger deployment pipeline    | Auto       |
| `/archive` | Move change folder to archive, merge specs   | Auto       |

## Prerequisites

- Code is tested and ready to ship.
- Typically follows `/build` and user testing.

## Steps

// turbo-all

1. **Commit Phase**: Invoke `/commit` workflow.
   - Run `git status` and `git diff --stat` to summarize changes.
   - Stage all changes with `git add -A`.
   - Compose conventional commit message.
   - Commit and push.

2. **Deploy Phase**: Invoke `/deploy` workflow.
   - Load the `sec-devops-engineer` agent.
   - Verify CI/CD status and pre-deployment checks.
   - Trigger deployment pipeline.

3. **Archive Phase**: Invoke `/archive` workflow.
   - Verify all tasks in `tasks.md` are complete.
   - Move `changes/{slug}/` → `archive/YYYY-MM-DD-{slug}/`.
   - Merge delta specs into main `specs/` directory.
   - Notify user that change is complete.

## Usage

```bash
# Commit, deploy, and archive the current change
/finish

# Finish a specific change folder
/finish auth-system
```

## Notes

- `/commit` remains available standalone for intermediate saves and WIP commits.
- `/finish` is the final step — use it only when you're confident the change is ready to ship.
- For changes that don't need deployment (e.g., docs-only), you can still use `/commit` + `/archive` individually.
