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
- Typically follows `/specify` → `/plan` → `/work` → `/review` → `/final-polish` and user testing.

## Steps

// turbo-all

1. **Commit Phase**: Invoke `/commit` workflow.
   - Run `git status` and `git diff --stat` to summarize changes.
   - Stage all changes with `git add -A`.
   - Compose conventional commit message.
   - Commit and push.

2. **Deploy Phase**: Invoke `/deploy` workflow.
   - Auto-detect deploy method from project signals (firebase.json, vercel.json, package.json scripts, etc.).
   - Run pre-deploy checks (clean working directory, build passes).
   - Execute the detected deploy command.
   - Verify deployment succeeded (health check or exit status).
   - If no deploy method is detected, ask the user for the command.

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

## Reflection

After completion, briefly evaluate:
1. **What worked?** — Patterns, tools, or approaches that were effective.
2. **What was friction?** — Slowdowns, dead ends, or repeated mistakes.
3. **Update needed?** — If a reusable lesson emerged, append it to `mistakes.md` or suggest an update to the relevant skill/workflow. If nothing noteworthy, skip silently.

> This step is internal — do not present the reflection to the user unless it surfaces an actionable update.


