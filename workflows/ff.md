---
description: Fast-forward: Generate all planning artifacts (proposal, specs, design, tasks) in one pass.
---

# /ff - Fast-Forward Planning

**Goal**: Skip the step-by-step artifact creation and generate all planning documents at once.

## Steps

1. **Invoke Agent**: Use the `project-planner` agent.
2. **Context**:
   - Load existing `changes/{slug}/proposal.md`.
   - Reference `docs/CONSTITUTION.md`.
3. **Execution**:
   - Generate `changes/{slug}/specs/` with delta specs using `templates/change/delta-spec-template.md`.
   - Generate `changes/{slug}/design.md` using `templates/change/design-template.md`.
   - Generate `changes/{slug}/tasks.md` using `templates/task-template.md`.
4. **Completion**:
   - Instruct user to review then move to implementation.

## Usage

```bash
/ff auth-system
/ff "Based on latest proposal"
```
