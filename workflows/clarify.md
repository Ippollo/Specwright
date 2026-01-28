---
description: Structured gap-filling workflow for specifications.
requires_mcp: []
recommends_mcp: []
---

# /clarify - Specification Refinement

**Goal**: Resolve ambiguities and fill gaps in feature specifications.

## Steps

1. **Invoke Agent**: Use `project-planner` or current context.
2. **Context**:
   - Read from `changes/{slug}/specs/`.
3. **Execution**:
   - Identify all `[NEEDS CLARIFICATION]` tags or vague sections.
   - Ask the user targeted, sequential questions.
   - Update `changes/{slug}/specs/spec.md` with answers.
   - Remove clarification tags as they are resolved.
4. **Completion**:
   - Notify user when the spec is "Plan Ready".
   - Suggest `/plan`.

## Usage

```bash
/clarify chat-notifications
/clarify "Review all FR-xxx requirements"
```

## Key Principles

- **Sequential Q&A**: Don't overwhelm the user; ask one or two things at a time.
- **Audit Trail**: Ensure decisions are documented directly in the spec file.
- **Blocking**: A plan shouldn't start until P1 clarifications are resolved.
