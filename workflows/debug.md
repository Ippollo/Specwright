---
description: Investigate and fix bugs using the four-phase Debugger agent (Root Cause → Pattern → Hypothesis → Implement).
quick_summary: "Systematic four-phase debugging: root cause investigation first, fix second. Uses debugger agent with Iron Law guard."
requires_mcp: []
recommends_mcp: [observability, context7, firebase, gcloud]
---

# /debug - Debugging Mode

**Goal**: Investigate, reproduce, and fix software defects.

## Steps

// turbo-all

1.  **Invoke Agent**: Use the `debugger` agent.
    - Path: `../agents/debugger.md`
2.  **Context**: Provide the bug report or error message.
3.  **Execution**:
    - **Phase 1**: Agent investigates root cause (reads errors, reproduces, traces data flow).
    - **Phase 2**: Agent analyzes patterns (working examples, differences).
    - **Phase 3**: Agent forms and tests a single hypothesis.
    - **Phase 4**: Agent implements fix at root cause, then applies `verification-gate`.
4.  **Completion**:
    - Agent confirms fix with evidence (test output, not just assertion).

## Usage

```bash
/debug "Login button does nothing on click"
/debug "API returns 500 when creating user"
```
