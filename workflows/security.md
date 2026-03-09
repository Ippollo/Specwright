---
description: Perform multi-pass security audits and hardening.
quick_summary: "4-phase security audit: map attack surface → trace data flows → hunt by vulnerability class → verify findings. Uses sec-devops agent."
requires_mcp: []
recommends_mcp: [context7, firebase, gcloud, sequential-thinking]
---

# /security - Security Audit Mode

**Goal**: Systematically audit and secure the application using a multi-pass methodology.

## Skills

- [security-audit](../skills/security-audit/SKILL.md) — Vulnerability hunting methodology (offensive)
- [security-hardening](../skills/security-hardening/SKILL.md) — Prevention patterns and checklists (defensive)

## Steps

// turbo-all

1.  **Invoke Agent**: Use the `sec-devops-engineer` agent.
    - Path: `../agents/sec-devops-engineer.md`

2.  **Load Skill**: Read the [security-audit](../skills/security-audit/SKILL.md) skill for the full multi-pass protocol.

3.  **Phase 1 — Attack Surface Mapping**:
    - Enumerate all entry points (HTTP routes, APIs, WebSockets, CLI, queues)
    - Enumerate all data stores (databases, files, caches, external APIs)
    - Identify auth boundaries and trust boundaries
    - **Output**: Write `attack_surface.md` in the active change folder

4.  **Phase 2 — Data Flow Tracing**:
    - Read [data-flow-tracing.md](../skills/security-audit/references/data-flow-tracing.md) for methodology
    - For each entry point, trace user input through the call graph to every sink
    - Document source → sanitization → sink paths
    - **Output**: Write `data_flows.md` in the active change folder

5.  **Phase 3 — Vulnerability Hunting**:
    - Read [hunting-patterns.md](../skills/security-audit/references/hunting-patterns.md) for search patterns
    - Apply per-class reasoning chains from SKILL.md against the data flows
    - Test each vulnerability class decision tree against the mapped data flows
    - **Output**: Write `findings.md` with candidate vulnerabilities

6.  **Phase 4 — Verification & Reporting**:
    - For each candidate finding, construct proof-of-concept reasoning
    - Classify severity (Critical/High/Medium/Low) and confidence (High/Medium/Low)
    - Generate remediation recommendations
    - **Output**: Write `security_report.md` using the structured findings format from SKILL.md

7.  **Hardening** (if applicable):
    - Apply fixes for verified findings using `security-hardening` skill patterns
    - Update the security report with applied fixes

## Task Filtering

When a `tasks.md` is present in the active change folder:

1. **Scan** `tasks.md` for incomplete tasks tagged with `/security`.
2. **Execute only** those tasks, in order.
3. **Mark each** `[x]` in `tasks.md` as it completes.
4. **Run CHECKPOINT** if one follows the completed tasks.
5. **Auto-advance**: When all `/security` tasks are done, proceed to the next pipeline stage (`/enhance`). Load the `code-custodian` agent and continue.
