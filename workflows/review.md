---
description: Post-hoc quality review for agent auto-proceeded work.
quick_summary: "Specialist agents review and fix auto-proceeded work: backend → design → security → enhance."
requires_mcp: []
recommends_mcp: [context7, firebase, gcloud, playwright, sequential-thinking]
---

# /review - Specialist Review Pipeline

**Goal**: Audit auto-proceeded work by running each specialist agent in review mode. Same pipeline as `/work`, but reviewing instead of building.

## When to Use

- The agent auto-proceeded on an implementation plan and you want to verify quality.
- You returned from a break and want to audit what changed.
- You want expert-level review without reading every diff yourself.

## Review Pipeline

```
/backend review → /design review → /security review → /enhance review → verdict
```

| Stage       | Agent                 | Reviews For                                             |
| ----------- | --------------------- | ------------------------------------------------------- |
| `/backend`  | `backend-architect`   | API design, data models, edge cases, input validation   |
| `/design`   | `frontend-specialist` | UI patterns, accessibility, responsiveness, consistency |
| `/security` | `sec-devops-engineer` | Auth flaws, OWASP issues, data exposure                 |
| `/enhance`  | `code-custodian`      | Code smells, performance, naming, duplication           |

## Steps

// turbo-all

1. **Identify Scope**: Locate the auto-proceeded work.
   - Check the active change folder (`changes/{slug}/`) for the implementation plan and `tasks.md`.
   - If no change folder exists, identify modified files from the most recent agent session.
   - Produce a brief summary of what files changed and what was implemented.

2. **Backend Review**: Load the `backend-architect` agent (`../agents/backend-architect.md`).
   - Review data models and type definitions for correctness and completeness.
   - Check API contracts and service layer for edge cases.
   - Verify input validation and error handling.
   - **Fix** any issues found. Report what was changed.

3. **Design Review**: Load the `frontend-specialist` agent (`../agents/frontend-specialist.md`).
   - Review UI components for pattern consistency with the existing codebase.
   - Check responsiveness and accessibility.
   - Verify design system compliance (spacing, colors, typography).
   - **Fix** any issues found. Report what was changed.

4. **Security Review**: Load the `sec-devops-engineer` agent (`../agents/sec-devops-engineer.md`).
   - Audit against OWASP Top 10 where applicable.
   - Check for data exposure, auth/authz gaps, and unsafe inputs.
   - Review any new external service integrations.
   - **Fix** any issues found. Report what was changed.

5. **Enhance Review**: Load the `code-custodian` agent (`../agents/code-custodian.md`).
   - Check for code smells, duplication, and naming inconsistencies.
   - Identify performance concerns (unnecessary re-renders, missing memoization, N+1 queries).
   - Verify code follows existing project conventions.
   - **Fix** any issues found. Report what was changed.

6. **Consolidated Verdict**: Combine findings from all four reviews into a single summary.
   - ✅ **Looks Good** — All reviews pass, no changes needed. Ready for `/commit`.
   - 🔧 **Fixed** — Issues found and resolved. Summary of what was changed.
   - ⚠️ **Needs User Input** — Issues found that require a decision from the user.
   - 🔍 **Hindsight Check**: Now that implementation is complete, were the original design decisions sound? Flag any approach that should be reconsidered for v2.

7. **Handoff**: Based on verdict, suggest next steps:
   - ✅ / 🔧 → Proceed to `/commit`, then `/deploy` or `/archive`.
   - ⚠️ → User reviews flagged items and provides direction.

## Skipping Stages

If the auto-proceeded work only touched certain areas, skip irrelevant reviews:

- Backend-only change (types, hooks, services) → skip `/design` review.
- CSS/component-only change → skip `/backend` review.
- Always run `/security` and `/enhance` — they apply universally.

## Usage

```bash
# Full specialist review of the most recent auto-proceeded work
/review

# Review a specific change folder
/review auth-system

# Skip to a specific review stage
/review design
```

## Notes

- Each specialist **reviews and fixes** in a single pass — no separate follow-up step needed.
- For pre-release cleanup (debug logs, TODOs), use `/final-polish` instead.
