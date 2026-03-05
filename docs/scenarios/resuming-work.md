# Scenario: Resuming Stale Work

This guide helps you pick up a half-finished change folder after days, weeks, or months away.

## The Goal

Quickly get back into context and continue work on a paused feature without starting from scratch.

---

## Step 1: Assess What Exists

Start by checking what artifacts are already in the change folder.

```bash
# Quick status report (recommended)
/status your-feature-name

# Or check all active changes at once
/status
```

`/status` will show you which artifacts exist, how many tasks are complete, and suggest your next action.

**Common states:**

| Files Present                       | Status                | Next Step                     |
| ----------------------------------- | --------------------- | ----------------------------- |
| `proposal.md` only                  | Planning started      | Run `/specify` then `/plan`   |
| `proposal.md` + `specs/`            | Requirements done     | Run `/plan`                   |
| `specs/` + `design.md` + `tasks.md` | Planning complete     | Start implementation          |
| Everything + code changes           | Partially implemented | Review tasks, continue coding |

---

## Step 2: Refresh Your Memory

Read the existing artifacts to rebuild context.

```bash
# Read the proposal
/investigate "Summarize the proposal, specs, and design for [feature-name]"
```

**What happens:**

- The agent reads all artifacts in the change folder
- Provides a concise summary of:
  - What problem you're solving
  - What approach you chose
  - What's been done so far
  - What's left to do

---

## Step 3: Check for Drift

If the project has changed since you paused, verify your plan is still valid.

```bash
/investigate "Has the codebase changed in ways that affect [feature-name]?"
```

**Common drift scenarios:**

### Someone else added a similar feature

- **Solution:** Review their implementation, decide if you should merge efforts or pivot

### Dependencies were updated

- **Solution:** Check if your design assumptions still hold (e.g., API changes)

### Requirements changed

- **Solution:** Update `specs/` before continuing

---

## Step 4: Update the Plan (If Needed)

If drift occurred, refresh the artifacts.

```bash
# Update specifications
/specify "Revised requirements based on new context"

# Regenerate design and tasks
/plan
```

---

## Step 5: Resume Implementation

Pick up where you left off using the task list.

```bash
# Review tasks.md to see what's done
# Continue with the next incomplete task

/design "Implement the next UI component"
# or
/backend "Complete the API endpoint"
```

---

## Step 6: Verify Nothing Broke

If code was partially written, ensure it still works.

```bash
/test "Run existing tests and verify partial implementation"
```

---

## Real-World Example

### Scenario: Abandoned "Dark Mode" Feature

**Timeline:**

- **3 months ago:** Started `/new dark-mode-support`, created proposal and specs
- **Today:** Returning to finish it

**Step-by-step:**

```bash
# 1. Check what exists
cd changes/dark-mode-support
ls
# Output: proposal.md, specs/theme.md, design.md, tasks.md

# 2. Rebuild context
/investigate "Summarize the dark mode feature plan"
```

**Agent response:**

> "The plan is to add a theme toggle in the navbar using CSS variables. The design calls for:
>
> - ThemeProvider context component
> - Toggle button with smooth transitions
> - LocalStorage persistence
> - System preference detection
>
> Tasks.md shows 5 tasks, none marked complete."

```bash
# 3. Check for drift
/investigate "Has theming or styling changed since this was planned?"
```

**Agent response:**

> "Yes, the project migrated from plain CSS to Tailwind CSS 2 months ago. The CSS variable approach in design.md won't work anymore."

```bash
# 4. Update the plan
/plan "Revise dark mode implementation to use Tailwind's dark mode instead of CSS variables"
```

**Agent response:**

> "Updated design.md and tasks.md to use Tailwind's `dark:` prefix and `next-themes` library."

```bash
# 5. Resume implementation
/design "Implement ThemeProvider using next-themes"

# 6. Verify
/test "Theme toggle and persistence"

# 7. Finish
/final-polish
/archive dark-mode-support
```

---

## Common Challenges

### "I don't remember why I made certain decisions"

**Solution:** This is why we write specs and design docs. Read them.

If they're unclear:

```bash
/investigate "Why did we choose [approach X] over [approach Y] in the design?"
```

The agent will analyze the artifacts and explain the reasoning.

---

### "The tasks.md is outdated"

**Solution:** Regenerate it.

```bash
/plan "Refresh tasks based on current specs and design"
```

---

### "I have uncommitted code changes"

**Solution:** Review what you started.

```bash
# Check git status
git status

# Review the changes
git diff

# Decide:
# - Keep them: commit or continue working
# - Discard them: git restore .
# - Unsure: use /investigate to analyze the partial work
```

---

## Pro Tips

- **Start with `/status`**: The fastest way to rebuild context when returning to a project
- **Always read `proposal.md` first**: It's the "why" behind everything
- **Check git history**: See what you committed before pausing
- **Use `/second-opinion`**: If you're unsure whether to continue or restart, get a review
- **Update timestamps**: Add a "Resumed: [date]" note to proposal.md for future reference
- **Don't feel bad about restarting**: If the plan is stale, sometimes `/new` is faster than salvaging

---

## Decision Tree

```
How long has it been?
├─ < 1 week → Just read tasks.md and continue
├─ 1-4 weeks → Read all artifacts, check for drift
└─ > 1 month → Full context rebuild + drift check

Has the codebase changed significantly?
├─ Yes → Update specs and regenerate plan
└─ No → Continue with existing plan

Is there partial code?
├─ Yes → Review and decide to keep or discard
└─ No → Start fresh from tasks.md
```

---

## Anti-Patterns to Avoid

❌ **Jumping straight to coding without reading artifacts**

- **Result:** Implementing the wrong thing or duplicating work

❌ **Ignoring drift**

- **Result:** Building a feature that doesn't fit the current codebase

❌ **Feeling obligated to use stale plans**

- **Result:** Wasting time on an outdated approach when starting fresh would be faster
