---
description: Cross-artifact consistency check between spec, plan, and tasks. Run after /plan and before /work to catch misalignment early.
quick_summary: "Pre-implementation quality gate. Checks spec → plan → tasks consistency and flags gaps before code is written."
requires_mcp: []
recommends_mcp: [sequential-thinking]
---

# /analyze - Pre-Implementation Consistency Check

**Goal**: Verify that spec, plan, and tasks are internally consistent before implementation begins. Catch misalignment, gaps, and scope drift _before_ the agent writes a single line of code.

> [!IMPORTANT]
> Run this **after `/plan`** and **before `/work`**. It does not write code — it only reads and audits existing artifacts.

## What It Checks

| Check                       | Description                                                                                           |
| --------------------------- | ----------------------------------------------------------------------------------------------------- |
| **Spec → Plan coverage**    | Every P1 user story has a corresponding plan section. No stories are silently dropped.                |
| **Plan → Tasks coverage**   | Every significant plan decision maps to at least one task. Nothing is planned but unimplemented.      |
| **Constraint compliance**   | Tasks don't violate must-not or out-of-scope constraints defined in the spec.                         |
| **Verify completeness**     | Every task has a concrete `Verify:` step or CHECKPOINT. No open-ended tasks.                          |
| **Parallel markers**        | Tasks flagged `[P]` are genuinely independent (no hidden ordering dependency).                        |
| **Scope creep**             | Tasks exist that have no tracing back to any spec requirement. Flag for removal or explicit approval. |
| **Acceptance traceability** | Each SC-xxx success criterion is covered by at least one task's `(Traces: SC-xxx)` annotation.        |

## Steps

1. **Locate artifacts**: Read all three in the active change folder:
   - `changes/{slug}/specs/spec.md`
   - `changes/{slug}/plan.md` (or `design.md`)
   - `changes/{slug}/tasks.md`
2. **Run consistency checks**: Evaluate each check in the table above.
3. **Produce an analysis report**: For each check, output one of:
   - ✅ **Pass** — no issues found
   - ⚠️ **Warning** — minor gap, proceed with caution
   - ❌ **Fail** — blocking issue that should be resolved before `/work`
4. **List action items**: For each ⚠️ or ❌, provide a specific, actionable fix (e.g., "Add task to cover SC-003" or "Remove task 2.4 — no spec requirement traces to it").
5. **Completion**: Summarize overall readiness. If all checks pass, confirm it is safe to proceed with `/work`.

## Usage

```bash
# Run after /plan, before /work
/analyze

# Re-run after fixing issues flagged in a previous analysis
/analyze
```

## Key Principles

- **Read-only**: This workflow never modifies files. It only audits.
- **Block on failures**: A ❌ Fail should block `/work` until resolved. Don't skip.
- **Warnings are advisory**: A ⚠️ Warning should be acknowledged but may proceed.
- **Speed over depth**: This is a sanity check, not a formal audit. Aim for a fast, focused pass.

## Suggested Next Steps

- If all ✅: Proceed with `/work`
- If ⚠️ warnings: Acknowledge them, then `/work`
- If ❌ failures: Fix in spec/plan/tasks, then re-run `/analyze`
