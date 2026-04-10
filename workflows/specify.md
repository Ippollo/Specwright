---
description: Create feature specifications.
quick_summary: "Create specs with P1/P2/P3 priorities and acceptance criteria. Define What/Why before How."
requires_mcp: []
recommends_mcp: [sequential-thinking, github, firecrawl-mcp]
---

# /specify - Feature Specification

**Goal**: Define the "What" and "Why" before committing to the "How".

## Steps

1. **Invoke Agent**: Use the `project-planner` agent.
2. **Context**:
   - Requires an active change folder (run `/new` first).
   - Reference `docs/CONSTITUTION.md` for architectural context.
   - Use `templates/change/delta-spec-template.md` and `templates/spec-template.md`.
3. **Execution**:
   - The agent will generate `changes/{slug}/specs/spec.md`.
   - Prioritize requirements (P1/P2/P3).
   - Use Given/When/Then for acceptance criteria.
   - Describe what's changing (delta) relative to current state.
   - Flag areas needing more detail with `[NEEDS CLARIFICATION]`.
   - Populate `## Constraints` with explicit Must / Must Not / Out of Scope items.
   - Populate `## Current State` with relevant existing files and patterns (prevents agent exploration costs).
   - Populate each Task entry with a concrete `**Verify:**` step (command or manual check).
   - **Scope Challenge**: If any P1 story seems low-value, premature, or should be deferred to P2, flag it in a `## Scope Questions` section with reasoning. Don't silently accept all requirements as equally important.
4. **Completion**:
   - Suggest next step: `/clarify` (if gaps exist) or `/plan`.

## Usage

```bash
/specify "Real-time chat notification system"
/specify "Offline-first sync for mobile app"
```

## Key Principles

- **No Tech Stack**: Focus on behavioral requirements, not implementation.
- **Independence**: Each P1 story should be a viable MVP slice.
- **Clarity over Speed**: Use this to catch design flaws early.
