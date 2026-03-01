---
description: Deploy application changes.
quick_summary: "Check CI/CD, verify pre-deploy checks, trigger deployment pipeline."
requires_mcp: []
recommends_mcp: [github, gcloud, firebase, observability]
---

# /deploy - Deployment Mode

**Goal**: Safe and automated deployment.

## Steps

// turbo-all

1.  **Invoke Agent**: Use the `sec-devops-engineer` agent.
    - Path: `../agents/sec-devops-engineer.md`
2.  **Execution**:
    - Agent checks CI/CD status.
    - Agent verifies pre-deployment checks.
    - Agent triggers deployment pipeline.
