---
description: Perform security audits and hardening.
quick_summary: "Audit OWASP Top 10, recommend/apply security patches. Uses sec-devops agent."
requires_mcp: []
recommends_mcp: []
---

# /security - Security Mode

**Goal**: Audit and secure the application.

## Steps

1.  **Invoke Agent**: Use the `sec-devops-engineer` agent.
    - Path: `../agents/sec-devops-engineer.md`
2.  **Context**: Provide scope (codebase or specific feature).
3.  **Execution**:
    - Agent performs vulnerability scan (conceptual).
    - Agent checks against OWASP Top 10.
    - Agent recommends/applies hardening patches.
