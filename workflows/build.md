---
description: Full development pipeline from specification through review. Chains specify → plan → work → review → final-polish.
quick_summary: "One command to go from idea to reviewed code. Pauses for user approval at spec and plan stages."
requires_mcp: []
recommends_mcp:
  [
    context7,
    firebase,
    gcloud,
    playwright,
    sequential-thinking,
    github,
    firecrawl-mcp,
  ]
---

# /build - Full Development Pipeline

**Goal**: Execute the entire development lifecycle from specification to reviewed code in a single command.

## Pipeline

```
/specify → /clarify (if needed) → /plan → (user approves) → /analyze → /work → /review → /final-polish → done
```

| Stage           | What Happens                                                   | User Gate? |
| --------------- | -------------------------------------------------------------- | ---------- |
| `/specify`      | Generate behavioral specs and acceptance criteria              | ✅ Review  |
| `/clarify`      | Fill gaps if `[NEEDS CLARIFICATION]` markers found             | Auto       |
| `/plan`         | Generate design.md and tasks.md                                | ✅ Review  |
| `/analyze`      | Cross-artifact consistency check (spec → plan → tasks)         | Auto       |
| `/work`         | Execute pipeline: backend → design → security → enhance → test | Auto       |
| `/review`       | Specialist review: backend → design → security → enhance       | Auto       |
| `/final-polish` | Cleanup: debug artifacts, TODOs, dead code, docs, lint         | Auto       |

## Prerequisites

- An active change folder must exist (run `/new` first).

## Steps

// turbo-all

> [!IMPORTANT]
> **No skipping.** Every numbered step below is mandatory, without exception. An agent MUST NOT skip, abbreviate, or auto-complete any stage — including `/review` and `/final-polish` — regardless of perceived scope or time pressure. Proceeding to Step 7 without completing Steps 3–6 is a workflow violation.

0. **Constitution Check** _(first run only)_:
   - Check if `docs/CONSTITUTION.md` exists in the project.
   - If **missing**: Suggest running `/constitution` first to establish project rules. Explain that all agents (backend, frontend, security, etc.) reference the constitution to make consistent decisions.
   - If the user declines, proceed without it — but note the recommendation.
   - If **present**: Silently continue.

1. **Specification Phase**: Invoke `/specify` workflow.
   - Load the `project-planner` agent.
   - Generate `changes/{slug}/specs/spec.md`.
   - **Gate**: Notify user to review specs. Wait for approval.
   - If `[NEEDS CLARIFICATION]` markers exist, auto-invoke `/clarify` and loop.

2. **Planning Phase**: Invoke `/plan` workflow.
   - Load the `project-planner` agent.
   - Generate `research.md`, `design.md`, and `tasks.md`.
   - **Gate**: Notify user to review the plan. Wait for approval.

3. **Analysis Phase**: Invoke `/analyze` workflow.
   - Read spec, plan, and tasks artifacts.
   - Run consistency checks: coverage, constraint compliance, verify completeness, scope creep.
   - If ❌ failures found: pause, report to user, wait for fixes before continuing.
   - If ✅ or ⚠️ only: auto-proceed.

4. **[MANDATORY] Execution Phase**: Invoke `/work` workflow.
   - Auto-execute all tasks by pipeline tag: `/backend` → `/design` → `/security` → `/enhance` → `/test`.
   - No user gate — auto-proceeds through all stages.
   - Do NOT skip any `/work` sub-stages, even if the tasks.md appears to have no tasks for a given tag. Complete the full pipeline.

5. **[MANDATORY] Review Phase**: Invoke `/review` workflow.
   - Run specialist review pipeline: backend → design → security → enhance.
   - Auto-fix any issues found.
   - No user gate — auto-proceeds.
   - Do NOT skip this phase even if the Execution Phase had no issues.

6. **[MANDATORY] Polish Phase**: Invoke `/final-polish` workflow.
   - Remove debug artifacts, triage TODOs, prune dead code, sync docs, run lint/test.
   - Auto-fix any issues found.
   - No user gate — auto-proceeds.
   - Do NOT skip this phase regardless of prior phase outcomes.

7. **Completion**: Notify user with consolidated summary.
   - Present verdict from `/review` and `/final-polish`.
   - Suggest user testing, then `/finish` when satisfied.

## Usage

```bash
# Full pipeline from spec to polished code
/build

# Provide initial context for the spec
/build "Add real-time notifications with WebSocket support"
```

## Handling Failures

- **Spec rejected**: User provides feedback → re-run `/specify` with guidance.
- **Plan rejected**: User provides feedback → re-run `/plan` with guidance.
- **Build error during `/work`**: Auto-triggers `/debug`, then resumes pipeline.
- **Review finds critical issues**: `/review` fixes them in-place. If it flags ⚠️ Needs User Input, the pipeline pauses and notifies the user.

## Notes

- All individual workflows remain available for standalone use.
- `/build` is the recommended path for new features and significant changes.
- For small fixes where you already know what to change, use `/work` directly.
