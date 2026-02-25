# Scenario: Quick Fix (Skip the Ceremony)

Not every change needs the full workflow. This guide shows when and how to move fast.

## The Goal

Fix a small bug or make a trivial change without the overhead of specs, design docs, and task breakdowns.

---

## When to Use Quick Fix Mode

✅ **Use this for:**

- Typo fixes (UI copy, comments, documentation)
- Dependency version bumps
- Configuration tweaks (environment variables, build settings)
- Simple bug fixes with obvious solutions
- Hotfixes for production issues

❌ **Don't use this for:**

- New features (even small ones)
- Refactorings that touch multiple files
- Bug fixes where the root cause is unclear
- Anything that changes user-facing behavior

**Rule of thumb:** If you can describe the fix in one sentence and implement it in one file, it's a quick fix.

---

## The Quick Fix Workflow

### Option 1: No Change Folder (Fastest)

For truly trivial changes, skip the toolkit entirely.

```bash
# Just make the edit directly
# Example: Fix typo in README
```

**When to use:**

- Documentation fixes
- Comment corrections
- Obvious one-line changes

---

### Option 2: Minimal Planning (Recommended)

For small fixes that still benefit from structure.

```bash
/new fix-login-button-color
# Edit the proposal.md with a one-line description
/specify "Fix login button using wrong color"
/plan
# Implement the fix
/archive fix-login-button-color
```

**What happens:**

- Creates the change folder (for audit trail)
- Generates minimal specs and tasks
- Preserves the "why" without ceremony

**Example proposal:**

```markdown
## Problem

Login button is using `#FF0000` instead of brand color `#4A90E2`

## Solution

Update `LoginButton.css` line 23

## Verification

Visual check in dev environment
```

---

### Option 3: Debug-Only Mode

For bugs where you need investigation but not full planning.

```bash
/investigate "Why is the search bar not responding on mobile?"
# Agent finds the issue
/new fix-mobile-search
# Make the fix directly (skip /specify and /plan)
/test "Mobile search interaction"
/archive fix-mobile-search
```

---

## Hotfix Workflow (Production Emergency)

When production is broken and you need to move _fast_.

### Step 1: Immediate Fix

```bash
# Make the fix directly in your codebase
# Deploy immediately
```

### Step 2: Document After (Within 24 hours)

```bash
/new hotfix-payment-timeout
# Fill in proposal.md with:
# - What broke
# - Root cause
# - What you changed
# - Why this was the right fix
/archive hotfix-payment-timeout
```

**Why document after?**

- Preserves institutional knowledge
- Prevents the same bug from recurring
- Helps during post-mortems

---

## Examples

### Example 1: Typo in Error Message

**Before:**

```javascript
throw new Error("Faild to authenticate user");
```

**Fix:**

```javascript
throw new Error("Failed to authenticate user");
```

**Workflow:** None. Just fix it.

---

### Example 2: Wrong Color Constant

**Before:**

```css
.primary-button {
  background: #ff5733; /* Should be brand blue */
}
```

**Fix:**

```css
.primary-button {
  background: #4a90e2; /* Brand blue */
}
```

**Workflow:**

```bash
/new fix-button-color
# Quick proposal
/specify "Fix button color to brand blue"
/plan
# Make the change
/archive fix-button-color
```

---

### Example 3: Production Crash

**Issue:** API endpoint returning 500 due to null pointer.

**Immediate action:**

```javascript
// Add null check
if (!user) {
  return res.status(404).json({ error: "User not found" });
}
```

**Deploy immediately.**

**Follow-up (next day):**

```bash
/new hotfix-user-null-check
# Document in proposal.md:
# - Error logs
# - Root cause (missing validation)
# - Fix applied
# - Future prevention (add validation middleware)
/archive hotfix-user-null-check
```

---

## Decision Tree

```
Is production broken?
├─ Yes → Fix immediately, document later
└─ No → Continue...

Is it a one-line change in one file?
├─ Yes → Just fix it (no toolkit)
└─ No → Continue...

Is the solution obvious and low-risk?
├─ Yes → Use /new + /specify + /plan
└─ No → Use full workflow (see new-feature.md)
```

---

## Pro Tips

- **When in doubt, use `/new`**: It's fast but still creates an audit trail
- **Don't skip `/archive`**: Even quick fixes deserve documentation
- **Use `/test` for hotfixes**: Production bugs often have edge cases you missed
- **Set a threshold**: Agree with your team on what counts as "quick fix" vs "feature"

---

## Anti-Patterns to Avoid

❌ **"This is urgent, I'll document it later"** (and never do)

- **Solution:** Use the hotfix workflow—fix first, document within 24 hours

❌ **"It's just a small change"** (that breaks 3 other features)

- **Solution:** If you're not 100% sure of the impact, use `/investigate` first

❌ **"I'll skip tests because it's obvious"** (famous last words)

- **Solution:** At least run manual verification, ideally use `/test`
