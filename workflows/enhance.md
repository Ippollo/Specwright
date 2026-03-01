---
description: Enhance and improve existing code through refactoring and optimization.
quick_summary: "Refactor, optimize, remove code smells. Uses code-custodian agent."
requires_mcp: []
recommends_mcp: [context7, firebase, gcloud]
---

# /enhance - Code Enhancement

> **Skill References**:
>
> - [code-quality-sentinel](../skills/code-quality-sentinel/SKILL.md)
> - [backend-performance](../skills/backend-performance/SKILL.md)

## Steps

// turbo-all

1.  **Invoke Agent**: Use the `code-custodian` agent.
    - Path: `../agents/code-custodian.md`
2.  **Mode**: Request "Optimizer Mode".
3.  **Execution**:
    - Agent analyzes target for smells/bottlenecks.
    - Agent proposes and applies refactors.
    - Agent runs tests to ensure no regressions.
    - _Loop continues until metrics are met._

## Task Filtering

When a `tasks.md` is present in the active change folder:

1. **Scan** `tasks.md` for incomplete tasks tagged with `/enhance`.
2. **Execute only** those tasks, in order.
3. **Mark each** `[x]` in `tasks.md` as it completes.
4. **Run CHECKPOINT** if one follows the completed tasks.
5. **Auto-advance**: When all `/enhance` tasks are done, proceed to the next pipeline stage (`/test`). Run the test workflow and continue.
