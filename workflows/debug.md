---
description: Investigate and fix bugs using the Debugger agent.
---

# /debug - Debugging Mode

**Goal**: Investigate, reproduce, and fix software defects.

## Steps

1.  **Invoke Agent**: Use the `debugger` agent.
    - Path: `../agents/debugger.md`
2.  **Context**: Provide the bug report or error message.
3.  **Execution**:
    - The agent will attempt to reproduce the issue.
    - The agent will analyze the root cause.
    - The agent will propose/apply a fix.
4.  **Completion**:
    - Agent confirms fix with verification test.

## Usage

```bash
/debug "Login button does nothing on click"
/debug "API returns 500 when creating user"
```
