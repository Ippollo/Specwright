---
description: Pre-submission cleanup checklist.
quick_summary: "Remove debug artifacts, triage TODOs, prune dead code, sync docs, run final lint/test. Gatekeeper mode."
requires_mcp: []
recommends_mcp: [context7, github, sequential-thinking]
---

# Final Polish Workflow

> **Skill References**:
>
> - [code-quality-sentinel](../skills/code-quality-sentinel/SKILL.md)
> - [documentation-standards](../skills/documentation-standards/SKILL.md)

**Goal**: Ensure code is clean, documented, and ready to ship.

## When to Use

- You've finished implementation and reviews — now you need a clean handoff.
- You're about to run `/commit` and want confidence nothing embarrassing ships.
- Code is _correct_ but may still contain debug leftovers, stale TODOs, or doc drift.

> **Not a substitute for `/review`**. `/review` checks _correctness_ (backend, design, security, code quality). `/final-polish` checks _ship-readiness_ — it assumes the code already works.

## Steps

// turbo-all

1. **Invoke Agent**: Load the `code-custodian` agent (`../agents/code-custodian.md`).
   - Request **Gatekeeper Mode**.

2. **Phase 1 — Debug Artifacts**: Scan all changed files for development leftovers.
   - `console.log`, `console.debug`, `console.warn` (unless intentional logging)
   - `debugger` statements
   - `print()` calls used for debugging (Python)
   - Commented-out code blocks (more than 2 consecutive commented lines)
   - Test overrides: `.only()`, `.skip()`, `fdescribe`, `fit`, `xit`
   - Hardcoded `localhost` URLs or test credentials
   - **Action**: Remove or convert to proper logging. Report what was cleaned.

3. **Phase 2 — TODO / FIXME Triage**: Find all `TODO`, `FIXME`, `HACK`, and `XXX` comments in changed files.
   - If the TODO is resolved by the current work → **remove it**.
   - If the TODO is valid future work → **convert to a tracked issue** (comment with issue link) or confirm the user accepts it shipping.
   - Nothing ships with an unresolved, untracked TODO.
   - **Action**: Report each TODO and its disposition.

4. **Phase 3 — Unused Code**: Identify dead code introduced or exposed by the change.
   - Unused imports
   - Unreferenced variables, functions, or types
   - Unused dependencies in `package.json` / `requirements.txt`
   - Orphaned files (created but never imported)
   - **Action**: Remove dead code. Report what was pruned.

5. **Phase 4 — Documentation Sync**: Verify documentation matches the current code.
   - README: Do setup instructions, env vars, and commands still match?
   - CHANGELOG: Is the current change logged under `Unreleased` or the correct version?
   - `.env.example`: Are any new env vars reflected?
   - Inline comments: Do they still describe what the code actually does?
   - **Action**: Fix any drift. Report what was updated.

6. **Phase 5 — Final Lint & Test Gate**: Run the project's lint and test suite.
   - Run linter (`npm run lint`, `ruff check`, etc.) — zero warnings required.
   - Run full test suite — all tests must pass.
   - If either fails, **fix** the issues and re-run.
   - **Action**: Report pass/fail status.

7. **Phase 6 — Acceptance Verification**: Cross-reference the spec against test evidence.
   - Locate the spec's `§4 Success Criteria` and `§6 Acceptance Traceability` table.
   - For each criterion, verify the `Verification` column has a value (test file:function or manual description).
   - For each criterion, verify the `Status` column is ✅ (not ⏳ or blank).
   - If any criterion is uncovered: flag it as ⚠️ with a clear message (e.g., "SC-003 has no verification method").
   - **Action**: Update the traceability table with final status. Report coverage summary.
   - _If no spec or traceability table exists, skip this phase silently._

8. **Verdict**: Summarize findings from all six phases.
   - ✅ **Clean** — No issues found. Ready to commit.
   - 🔧 **Cleaned** — Issues found and resolved. Summary of what was changed.
   - ⚠️ **Needs User Input** — Items that require a decision (e.g., ambiguous TODOs, intentional debug logging, uncovered acceptance criteria).

9. **Handoff**: Based on verdict, suggest next steps:
   - ✅ / 🔧 → Proceed to `/commit`, then `/deploy` or `/archive`.
   - ⚠️ → User reviews flagged items and provides direction.

## Usage

```bash
# Full polish pass on the current change
/final-polish

# Polish a specific change folder
/final-polish auth-system
```

## Notes

- This workflow is **non-destructive to functionality** — it only removes artifacts and fixes docs, never changes behavior.
- For correctness and quality review (backend, design, security), use `/review` first.
- For refactoring and optimization, use `/enhance`.
