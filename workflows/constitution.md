---
description: Establish project-wide development principles and governing guidelines.
quick_summary: "Create/update docs/CONSTITUTION.md with project rules and principles."
requires_mcp: []
recommends_mcp: []
---

# /constitution - Project Governance

**Goal**: Define the "rules of the game" for the project.

## Steps

1. **Invoke Agent**: Use the `project-planner` agent (or current context).
2. **Context**:
   - Read `docs/CONSTITUTION.md` if it exists.
   - Read `templates/constitution-template.md` for structure.
3. **Execution**:
   - The agent will interview the user about core principles.
   - Focus on: Code Quality, Testing, UX/A11y, Performance, and Architecture.
   - The agent will generate or update `docs/CONSTITUTION.md`.
4. **Completion**:
   - Notify user that all subsequent planning will follow these rules.
   - Recommend moving to `/brainstorm` or `/specify`.

## Usage

```bash
/constitution
/constitution "Update performance requirements"
```

## Key Principles

- **Global Scope**: Once set, the constitution applies to all features.
- **Immutable Guardrail**: If a future plan violates the constitution, it must be flagged.
- **Living Document**: Can be updated as the project evolves.
