---
description: Deploy application changes.
requires_mcp: []
recommends_mcp: [gcloud, firebase-mcp-server, observability]
---

# /deploy - Deployment Mode

**Goal**: Safe and automated deployment.

## Steps

1.  **Invoke Agent**: Use the `sec-devops-engineer` agent.
    - Path: `../agents/sec-devops-engineer.md`
2.  **Execution**:
    - Agent checks CI/CD status.
    - Agent verifies pre-deployment checks.
    - Agent triggers deployment pipeline.
