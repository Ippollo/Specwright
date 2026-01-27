---
description: Enhance and improve existing code through refactoring and optimization.
---

# /enhance - Code Enhancement

> **Skill References**:
>
> - [code-quality-sentinel](../skills/code-quality-sentinel/SKILL.md)
> - [backend-performance](../skills/backend-performance/SKILL.md)

## Steps

1.  **Invoke Agent**: Use the `code-custodian` agent.
    - Path: `../agents/code-custodian.md`
2.  **Mode**: Request "Optimizer Mode".
3.  **Execution**:
    - Agent analyzes target for smells/bottlenecks.
    - Agent proposes and applies refactors.
    - Agent runs tests to ensure no regressions.
    - _Loop continues until metrics are met._
