---
name: verification-gate
description: "Use when about to claim work is complete, fixed, or passing — before marking tasks done, committing, creating PRs, or expressing satisfaction with results. Requires running verification commands and presenting evidence before making any success claims. Triggers on completion language: 'done', 'fixed', 'all tests pass', 'ready to merge', or any positive assessment of work state."
---

# Verification Gate

> **Role**: Evidence Enforcement Officer.
> **Philosophy**: Evidence before claims, always.
> **Critical Rule**: If you haven't run the verification command in this response, you cannot claim it passes.

## The Iron Law

```
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
```

"Fresh" means: run in **this response**, not a previous one. Prior results are stale.

## The Gate Function

Before claiming ANY status or expressing satisfaction:

1. **IDENTIFY**: What command proves this claim?
2. **RUN**: Execute the full command (fresh, complete — not partial)
3. **READ**: Full output. Check exit code. Count failures.
4. **VERIFY**: Does the output confirm the claim?
   - **NO** → State actual status with evidence
   - **YES** → State claim WITH evidence
5. **ONLY THEN**: Make the claim

Skipping any step is a verification failure.

## Common Claims

| Claim | Requires This Evidence | NOT Sufficient |
|---|---|---|
| "Tests pass" | Test command output showing 0 failures | Previous run, "should pass", code looks right |
| "Linter clean" | Linter output showing 0 errors | Partial check, extrapolation from tests |
| "Build succeeds" | Build command exit code 0 | Linter passing, "it compiled last time" |
| "Bug fixed" | Original symptom reproduced and now passes | Code changed so it "should" be fixed |
| "Task complete" | All task acceptance criteria verified | Code written, "looks good to me" |
| "Requirements met" | Line-by-line checklist against spec | Tests passing (tests may not cover all requirements) |

## Red Flags — STOP and Apply Gate

You are about to violate this skill if you catch yourself:

- Using **"should"**, **"probably"**, **"seems to"**, **"likely"**
- Expressing satisfaction before verification ("Great!", "Perfect!", "Done!")
- About to commit, push, or create a PR without verification
- Relying on a previous run's results
- Thinking "just this once" or "this is too simple to verify"
- Feeling confident (confidence ≠ evidence)
- Trusting another agent's success report without checking

## Anti-Rationalization

| Excuse | Reality |
|---|---|
| "Should work now" | Run the verification |
| "I'm confident" | Confidence ≠ evidence |
| "Just this once" | No exceptions |
| "Linter passed" | Linter ≠ test suite ≠ build |
| "The code looks correct" | Looking ≠ running |
| "I'm tired / running low on context" | Exhaustion ≠ excuse |
| "It's a trivial change" | Trivial changes still break things |
| "Agent said it's done" | Verify independently |

## When to Apply

**ALWAYS before:**
- Any completion claim ("done", "fixed", "passing", "ready")
- Any expression of satisfaction about work state
- Marking a task `[x]` in task lists
- Committing, pushing, creating PRs
- Moving to the next task
- Reporting results to the user

## Key Patterns

**Tests:**
```
✅ [Run test command] → [Output: 34/34 pass] → "All 34 tests pass"
❌ "Tests should pass now" (no evidence)
```

**Build:**
```
✅ [Run build] → [Output: exit 0, no errors] → "Build succeeds"
❌ "Linter passed so build should be fine" (different tools)
```

**Requirements:**
```
✅ Re-read spec → Create checklist → Verify each item → Report coverage
❌ "Tests pass, so requirements are met" (tests may not cover all requirements)
```

## Integration

- **Complements**: `unit-testing-strategy`, `webapp-testing` — these define what to test; this skill enforces that you actually run the tests
- **Complements**: `code-quality-sentinel` — quality checks are meaningless without verification
- **Works with**: All workflows that mark tasks complete (`/work`, `/build`, `/finish`)
