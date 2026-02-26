---
description: Pre-submission cleanup and verification checklist
quick_summary: "Remove debug logs/TODOs, verify docs, run final lint/test. Gatekeeper mode."
requires_mcp: []
recommends_mcp: [context7, github, sequential-thinking]
---

# Final Polish Workflow

> **Skill References**:
>
> - [code-quality-sentinel](../skills/code-quality-sentinel/SKILL.md)
> - [documentation-standards](../skills/documentation-standards/SKILL.md)

**Goal**: Ensure code is clean, documented, and ready for release.

## Steps

1.  **Invoke Agent**: Use the `code-custodian` agent.
    - Path: `../agents/code-custodian.md`
2.  **Mode**: Request "Gatekeeper Mode".
3.  **Execution**:
    - Agent removes debug logs and TODOs.
    - Agent verifies documentation matches code.
    - Agent runs final lint/test checks.
4.  **Handoff**:
    - If verified, Agent explicitly notifies user:
      > "Code verified. Ready to commit via `/commit`, then deploy via `/deploy` or archive via `/archive`".
