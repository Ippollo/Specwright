---
description: comprehensive testing (Unit, Integration, E2E).
quick_summary: "Write and run tests (unit/integration/E2E). Uses qa-engineer agent."
requires_mcp: []
recommends_mcp: [playwright, context7, firebase, gcloud]
---

# /test - Testing Mode

**Goal**: Verify code quality and functionality.

## Steps

// turbo-all

1.  **Invoke Agent**: Use the `qa-engineer` agent.
    - Path: `../agents/qa-engineer.md`
2.  **Context**: Provide feature or bug fix to test.
3.  **Execution**:
    - Agent determines test strategy (Unit vs E2E).
    - Agent writes test cases.
    - Agent runs tests and reports coverage.

## Task Filtering

When a `tasks.md` is present in the active change folder:

1. **Scan** `tasks.md` for incomplete tasks tagged with `/test`.
2. **Execute only** those tasks, in order.
3. **Mark each** `[x]` in `tasks.md` as it completes.
4. **Run CHECKPOINT** if one follows the completed tasks.
5. **Complete**: `/test` is the final pipeline stage. When all `/test` tasks are done, summarize the full pipeline results.
