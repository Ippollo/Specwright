---
description: Execute tasks from tasks.md.
quick_summary: "Orchestrate task execution by tag: backend → design → security → enhance → test."
requires_mcp: []
recommends_mcp: [context7, firebase, gcloud, playwright, sequential-thinking]
---

# /work - Pipeline Executor

**Goal**: Execute `tasks.md` tasks by workflow tag, auto-advancing through the full pipeline.

> [!TIP]
> Run `/analyze` before starting `/work` to verify spec → plan → tasks consistency. Catching misalignment now is much cheaper than mid-implementation rework.

## Pipeline Order

```
/backend → /design → /security → /enhance → /test
```

| Stage       | Agent                 | Purpose                            |
| ----------- | --------------------- | ---------------------------------- |
| `/backend`  | `backend-architect`   | Data models, APIs, hooks, services |
| `/design`   | `frontend-specialist` | UI components, pages, styling      |
| `/security` | `sec-devops-engineer` | Security audit and hardening       |
| `/enhance`  | `code-custodian`      | Refactoring, optimization, cleanup |
| `/test`     | _(current context)_   | End-to-end verification            |

## Steps

// turbo-all

1. **Locate tasks.md**: Find `tasks.md` in the active change folder (`changes/{slug}/tasks.md`).
2. **Load context**: Read `now.md` and `decisions.md` from project root (if they exist) for ambient context.
3. **Scan for incomplete tasks**: Parse all lines matching `- [ ] /tag — description`.
4. **Group by tag**: Organize tasks into pipeline stages.
5. **Skip empty stages**: If a tag has no tasks, skip to the next.
6. **For each stage** (in pipeline order):
   a. **Load the agent** for this stage (see table above).
   b. **Sanity check**: Before executing, briefly verify: "Do these tasks still make sense given what was built in earlier stages? Has anything changed upstream that invalidates or duplicates work?" If a task is now irrelevant, flag it and skip rather than blindly executing.
   c. **Scope discipline**: Touch only what the task requires. If you notice something worth improving outside the task scope, note it — don't fix it:
      ```
      NOTICED BUT NOT TOUCHING:
      - [thing] — [why it's out of scope for this task]
      → Want me to create a task for this?
      ```
   d. **Confusion management**: When encountering conflicting context or incomplete requirements mid-task, stop and surface it:
      ```
      CONFLICT: [what conflicts with what]
      Options:
      A) [approach] — [consequence]
      B) [approach] — [consequence]
      → Which approach?
      ```
      Do not guess. Wait for user direction.
   e. **Execute each task** tagged for this stage, in order.
   f. **Mark complete**: Update `tasks.md` with `[x]` as each task finishes.
   g. **Run CHECKPOINTs**: If a checkpoint follows the completed tasks, run it.
   h. **Auto-advance**: Move to the next stage immediately.
7. **Pre-completion verification**: Re-read `tasks.md` from disk. Scan for any items still marked `[ ]` or `[/]`. If incomplete items exist:
   - List them explicitly.
   - Do NOT proceed to completion — resume work on the remaining items.
   - If the remaining items are genuinely out of scope or blocked, flag them to the user before completing.
8. **Completion**: When all stages are done, summarize what was accomplished.

## Usage

```bash
# Execute the full pipeline from where you left off
/work

# Execute only a specific stage
/work backend
/work design

# Resume after a break (picks up from first incomplete task)
/work
```

## Handling `/debug`

`/debug` is **not** part of the standard pipeline. It is triggered:

- **Ad-hoc**: When you discover a bug during any stage, invoke `/debug` to investigate and fix.
- **Checkpoint failure**: If a CHECKPOINT fails, pause the pipeline and invoke `/debug`.
- After the debug is resolved, resume `/work` from where you left off.

## Agent Loading Reference

When advancing to a new stage, load the agent from its canonical path:

- `/backend` → `../agents/backend-architect.md`
- `/design` → `../agents/frontend-specialist.md`
- `/security` → `../agents/sec-devops-engineer.md`
- `/enhance` → `../agents/code-custodian.md`
- `/test` → Follow the `/test` workflow (`../workflows/test.md`)

## Reflection

After completion, briefly evaluate:
1. **What worked?** — Patterns, tools, or approaches that were effective.
2. **What was friction?** — Slowdowns, dead ends, or repeated mistakes.
3. **Update needed?** — If a reusable lesson emerged, append it to `mistakes.md` or suggest an update to the relevant skill/workflow. If nothing noteworthy, skip silently.

> This step is internal — do not present the reflection to the user unless it surfaces an actionable update.

