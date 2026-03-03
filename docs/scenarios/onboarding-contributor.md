# Scenario: Onboarding a New Contributor

This guide helps new team members get productive quickly on a project that already uses Specwright.

## The Goal

Enable a new contributor to understand the project structure, workflows, and make their first contribution within their first week.

---

## Day 1: Orientation

### Step 1: Read the Constitution

Understand the project's governing principles.

```bash
# Read the project constitution
cat docs/CONSTITUTION.md
```

**What to look for:**

- Code quality standards
- Testing requirements
- Performance constraints
- Architecture preferences

**Example takeaways:**

- "All new features require unit tests"
- "API response time must be <200ms p95"
- "We use TypeScript strict mode"

---

### Step 2: Review the Quick Reference

Get familiar with available workflows.

```bash
cat docs/QUICK_REFERENCE.md
```

**Key sections:**

- The Three Phases (Ideate, Plan, Execute)
- Workflow commands and when to use them
- Available agents and their purposes

---

### Step 3: Explore Existing Changes

See how others have used the toolkit.

```bash
# Look at archived changes
ls archive/

# Read a completed change folder
cat archive/dark-mode-support/proposal.md
cat archive/dark-mode-support/specs/theme.md
cat archive/dark-mode-support/design.md
```

**What you'll learn:**

- How proposals are written
- Level of detail in specs
- How design decisions are documented

---

## Day 2-3: First Investigation

### Step 4: Pick a "Good First Issue"

Choose something small and well-defined.

**Good first issues:**

- Add a new UI component (isolated, clear requirements)
- Fix a bug with a reproduction case
- Improve error messages
- Add missing tests

**Avoid:**

- Core architecture changes
- Features with unclear requirements
- Anything blocking other developers

---

### Step 5: Investigate the Codebase

Before making changes, understand the relevant code.

```bash
/investigate "How is [relevant feature] currently implemented?"
```

**Example:**

```bash
/investigate "How are form validations handled in the app?"
```

**Agent response:**

> "The app uses React Hook Form with Zod schemas. Validation logic is in `src/schemas/`, form components use `useForm()` hook, and error messages are displayed via `ErrorMessage` component."

---

## Day 3-4: First Contribution

### Step 6: Follow the Workflow

Use the toolkit for your first task.

```bash
# Initialize change folder
/new add-email-validation

# Create specification
/specify "Add email format validation to signup form with user-friendly error message"

# Generate plan
/plan

# Implement
/design "Add email validation to SignupForm component"

# Test
/test "Email validation on signup form"

# Finalize
/final-polish
/commit
/archive add-email-validation
```

---

### Step 7: Request Review

Get feedback from a senior team member.

```bash
# Before archiving, use second-opinion
/second-opinion "Is this email validation implementation consistent with our existing patterns?"
```

**Submit PR with links to artifacts:**

```markdown
## PR: Add Email Validation to Signup Form

**Change Folder:** `changes/add-email-validation/`

**Artifacts:**

- [Proposal](changes/add-email-validation/proposal.md)
- [Spec](changes/add-email-validation/specs/validation.md)
- [Design](changes/add-email-validation/design.md)
- [Tasks](changes/add-email-validation/tasks.md)

**Testing:**

- ✅ Unit tests added
- ✅ Manual testing completed
- ✅ Meets acceptance criteria
```

---

## Week 2: Building Confidence

### Step 8: Take on a Medium Task

Choose something more complex.

**Medium tasks:**

- New feature with multiple components
- Refactoring with cross-file changes
- Bug fix requiring investigation

---

### Step 9: Use Advanced Workflows

Explore specialized workflows.

```bash
# For complex features
/brainstorm "Approaches for implementing real-time notifications"

# For unclear requirements
/clarify

# For fast iteration
/specify "Quick description of the change"
/plan
```

---

## Common Questions from New Contributors

### "Do I really need to create a change folder for a typo fix?"

**Answer:** No. See `docs/scenarios/quick-fix.md` for guidance on when to skip the ceremony.

**Rule of thumb:**

- Typos, comments, docs → Just fix it
- One-line code changes → Use `/new` + `/specify` + `/plan`
- Multi-file changes → Full workflow

---

### "What if I disagree with the constitution?"

**Answer:** Discuss with the team. The constitution is a living document.

```bash
# Propose an update
/constitution "Update testing requirements to allow integration tests instead of unit tests for UI components"
```

---

### "The agent suggested something that doesn't match our patterns"

**Answer:** You're the human, you have final say. The toolkit is a guide, not a dictator.

**What to do:**

1. Override the suggestion
2. Document why in the design.md
3. Consider updating the constitution to prevent future mismatches

---

### "I'm stuck and don't know which workflow to use"

**Answer:** Use this decision tree:

```
What are you trying to do?
├─ Understand existing code → /investigate
├─ Fix a bug → /debug or /investigate
├─ Add a feature → /new → /specify → /plan
├─ Refactor code → /enhance
├─ Not sure → /brainstorm
└─ Quick fix → See quick-fix.md
```

---

## Onboarding Checklist

**Week 1:**

- [ ] Read `docs/CONSTITUTION.md`
- [ ] Read `docs/QUICK_REFERENCE.md`
- [ ] Explore 2-3 archived change folders
- [ ] Complete first contribution using full workflow
- [ ] Get PR reviewed and merged

**Week 2:**

- [ ] Take on a medium-complexity task
- [ ] Use `/brainstorm` or `/investigate` for exploration
- [ ] Pair with a senior developer on a complex feature
- [ ] Archive 2+ change folders

**Week 3:**

- [ ] Work independently on a feature
- [ ] Use `/second-opinion` for validation
- [ ] Help onboard the next new contributor

---

## Pro Tips for New Contributors

### 1. Don't Be Afraid to Ask

The toolkit helps, but humans are better at context.

```bash
# Ask the agent
/investigate "Why did we choose [approach X] in the auth system?"

# Ask your team
"Hey, I'm working on [feature]. The agent suggested [approach], does that match our patterns?"
```

---

### 2. Start with `/investigate`

Before making any change, understand the current state.

```bash
/investigate "What files would I need to modify to add [feature]?"
```

---

### 3. Use `/specify` + `/plan` for Learning

The planning workflow lets you see the full output quickly.

```bash
/new learning-example
/specify "Brief description of the change"
/plan
# Review the generated specs, design, and tasks
# Learn the expected structure
```

---

### 4. Read Other People's Change Folders

The best way to learn the team's standards.

```bash
# Find the most recent archived changes
ls -lt archive/ | head -5

# Read their artifacts
cat archive/recent-feature/proposal.md
cat archive/recent-feature/design.md
```

---

### 5. Contribute to the Toolkit Itself

Found a workflow that could be better? Improve it.

```bash
# Update a workflow
/enhance "Improve the /specify workflow to include accessibility requirements"

# Add a new scenario
# (You're reading one right now!)
```

---

## Anti-Patterns to Avoid

❌ **Skipping the constitution**

- **Result:** Building features that violate project standards

❌ **Not reading archived changes**

- **Result:** Reinventing patterns that already exist

❌ **Blindly following agent suggestions**

- **Result:** Code that doesn't match team conventions

❌ **Being afraid to ask questions**

- **Result:** Wasting time on wrong approaches
