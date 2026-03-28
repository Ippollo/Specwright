---
description: Execute tasks from tasks.md by workflow tag, auto-advancing through the pipeline.
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
   c. **Execute each task** tagged for this stage, in order.
   d. **Mark complete**: Update `tasks.md` with `[x]` as each task finishes.
   e. **Run CHECKPOINTs**: If a checkpoint follows the completed tasks, run it.
   f. **Auto-advance**: Move to the next stage immediately.
7. **Completion**: When all stages are done, summarize what was accomplished.

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
