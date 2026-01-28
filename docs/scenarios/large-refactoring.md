# Scenario: Large Refactoring

This guide shows how to tackle multi-phase refactorings that touch many files and require careful planning.

## The Goal

Refactor a significant portion of the codebase (e.g., state management migration, API redesign, component library upgrade) without breaking existing functionality.

---

## Step 1: Understand the Current State

Before changing anything, deeply understand what exists.

```bash
/investigate "Map out the current [system/pattern] implementation, dependencies, and usage patterns"
```

**What to document:**

- How many files are affected
- What other systems depend on this
- Current pain points and technical debt
- Risk areas (high-traffic code, complex logic)

**Example investigation:**

> "The app uses Redux with 47 slice files, 23 connected components, and 12 middleware functions. The auth slice is tightly coupled to 8 other slices."

---

## Step 2: Get a Second Opinion on Approach

Large refactorings are risky. Validate your strategy before committing.

```bash
/brainstorm "Approaches for migrating from Redux to Zustand while maintaining backward compatibility"
```

**Agent provides options:**

- **Option A**: Big-bang migration (rewrite everything at once)
- **Option B**: Strangler fig pattern (gradual replacement)
- **Option C**: Adapter layer (run both systems in parallel)

```bash
/second-opinion "We're planning to use the strangler fig pattern. What are the risks?"
```

**Agent reviews:**

- Identifies potential pitfalls
- Suggests mitigation strategies
- Validates or challenges assumptions

---

## Step 3: Break Into Phases

Don't try to do everything in one change folder.

```bash
/new refactor-state-phase1-setup
```

**Phase 1: Setup**

- Add new library
- Create adapter/compatibility layer
- Set up testing infrastructure
- **No behavior changes**

```bash
/new refactor-state-phase2-auth
```

**Phase 2: Migrate Auth**

- Convert auth slice to new system
- Update connected components
- Verify with tests
- **One domain at a time**

```bash
/new refactor-state-phase3-user-data
```

**Phase 3: Migrate User Data**

- Convert user slice
- Update dependencies
- Continue pattern...

---

## Step 4: Plan Each Phase Independently

Treat each phase as its own feature.

```bash
# For Phase 1
cd changes/refactor-state-phase1-setup
/specify "Set up Zustand alongside Redux with compatibility layer"
/plan
```

**Key planning principles:**

- **Incremental**: Each phase should be deployable
- **Reversible**: Have a rollback plan
- **Testable**: Verify nothing breaks
- **Isolated**: Minimize cross-phase dependencies

---

## Step 5: Implement with Safeguards

Use the toolkit's verification tools heavily.

```bash
/enhance "Add Zustand store with Redux adapter"
/test "Verify auth still works with both systems"
/second-opinion "Review the adapter implementation for edge cases"
```

---

## Step 6: Archive Each Phase

Don't wait until the entire refactoring is done.

```bash
/final-polish
/archive refactor-state-phase1-setup
```

**Why archive incrementally:**

- Preserves decision-making context
- Allows rollback to specific phases
- Reduces cognitive load
- Provides progress milestones

---

## Real-World Example: API Redesign

### The Problem

Current API uses REST with inconsistent response formats. Want to migrate to GraphQL.

### The Plan

**Phase 1: GraphQL Setup**

```bash
/new api-redesign-phase1-graphql-setup
/specify "Add Apollo Server alongside existing REST API, no client changes yet"
/plan
/backend "Set up GraphQL server with schema for User type"
/test "GraphQL endpoint returns data"
/archive api-redesign-phase1-graphql-setup
```

**Phase 2: Migrate User Queries**

```bash
/new api-redesign-phase2-user-queries
/specify "Convert user profile page to use GraphQL, keep REST as fallback"
/plan
/backend "Implement User queries in GraphQL schema"
/design "Update UserProfile component to use Apollo Client"
/test "User profile works with GraphQL, fallback to REST on error"
/archive api-redesign-phase2-user-queries
```

**Phase 3: Migrate Mutations**

```bash
/new api-redesign-phase3-user-mutations
# ... continue pattern
```

**Phase N: Remove REST**

```bash
/new api-redesign-final-cleanup
/specify "Remove REST endpoints and fallback logic"
/plan
/backend "Delete deprecated REST routes"
/test "Full regression test suite"
/archive api-redesign-final-cleanup
```

---

## Common Challenges

### "The refactoring touches too many files"

**Solution:** Break it down further.

If a phase touches >20 files, it's too big. Split it:

- By feature domain (auth, user, products)
- By layer (data layer, UI layer, business logic)
- By risk (low-risk first, high-risk last)

---

### "We can't deploy partial refactorings"

**Solution:** Use feature flags.

```javascript
const USE_NEW_STATE = process.env.FEATURE_NEW_STATE === "true";

function getUser() {
  if (USE_NEW_STATE) {
    return zustandStore.getUser();
  }
  return reduxStore.getState().user;
}
```

Deploy each phase behind a flag, enable gradually.

---

### "Tests are breaking constantly"

**Solution:** Invest in test infrastructure first.

```bash
/new refactor-test-infrastructure
/specify "Add integration tests for critical paths before refactoring"
/test "Create baseline test suite"
/archive refactor-test-infrastructure
```

Then refactor with confidence.

---

## Pro Tips

### 1. Create a Refactoring Roadmap

Document all phases upfront in a master plan.

```markdown
# Refactoring Roadmap: State Management Migration

## Phases

1. ✅ Setup (archived)
2. 🚧 Auth migration (in progress)
3. ⏳ User data migration (planned)
4. ⏳ Products migration (planned)
5. ⏳ Cleanup (planned)

## Success Criteria

- [ ] All tests passing
- [ ] No performance regression
- [ ] Redux fully removed
- [ ] Bundle size reduced by 15%
```

### 2. Use `/enhance` Instead of `/design` or `/backend`

The `/enhance` workflow is specifically designed for refactoring.

```bash
/enhance "Extract user validation logic into reusable utility"
```

### 3. Pair `/second-opinion` with Each Phase

Before archiving a phase, get a review.

```bash
/second-opinion "Does this phase introduce any technical debt or coupling issues?"
```

### 4. Maintain a Rollback Plan

Document how to undo each phase.

```markdown
## Rollback Plan (Phase 2)

If GraphQL user queries fail in production:

1. Set `FEATURE_GRAPHQL_USERS=false`
2. Deploy immediately (REST fallback activates)
3. Investigate GraphQL errors
4. Fix and re-enable
```

### 5. Celebrate Milestones

Large refactorings take weeks or months. Acknowledge progress.

```bash
# After each archived phase
git tag refactor-state-phase2-complete
```

---

## Decision Tree

```
How many files affected?
├─ < 10 → Single change folder, use /enhance
├─ 10-50 → 2-3 phases
└─ > 50 → 5+ phases

Can you deploy incrementally?
├─ Yes → Use strangler fig pattern
└─ No → Use feature flags

Is there test coverage?
├─ Yes → Proceed with refactoring
└─ No → Add tests first (separate phase)

Is the new approach proven?
├─ Yes → Proceed
└─ No → Spike first (prototype in a branch)
```

---

## Anti-Patterns to Avoid

❌ **"Let's refactor everything at once"**

- **Result:** Merge conflicts, broken builds, impossible code reviews

❌ **"We'll add tests after the refactoring"**

- **Result:** No safety net, bugs slip through

❌ **"This is just cleanup, we don't need planning"**

- **Result:** Scope creep, missed edge cases, incomplete refactoring

❌ **"We can't ship until the entire refactoring is done"**

- **Result:** Long-lived branches, merge hell, delayed value
