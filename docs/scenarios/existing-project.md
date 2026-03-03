# Scenario: Adopting the Toolkit on an Existing Project

This guide shows how to retrofit Specwright onto a project that's already underway.

## The Goal

Integrate structured workflows and governance into an existing codebase without disrupting active development.

---

## Step 1: Understand the Current State

Before imposing new structure, learn what already exists.

```bash
/investigate "What are the current architectural patterns, testing practices, and code organization?"
```

**What happens:**

- The agent reads your codebase
- Identifies existing patterns (state management, API design, component structure)
- Documents current practices and technical debt
- Provides a summary of findings

**Example findings:**

- "Uses Redux for state, but some components bypass it with local state"
- "Test coverage is ~40%, mostly unit tests, no E2E"
- "API responses aren't consistently typed"

---

## Step 2: Create a Constitution from Reality

Document the _actual_ rules your project follows (or should follow).

```bash
/constitution "Based on the investigation, codify our current best practices and aspirational standards"
```

**What happens:**

- Creates `docs/CONSTITUTION.md`
- Balances current reality with desired improvements
- Sets guardrails for future work

**Example sections:**

- **Code Quality**: "Prefer TypeScript strict mode, allow gradual migration"
- **Testing**: "New features require tests, legacy code can be tested incrementally"
- **Architecture**: "Continue using Redux, but new features should use Redux Toolkit"

---

## Step 3: Set Up the Change Folder Structure

Initialize the `changes/` directory for future work.

```bash
# Create the directory manually or let /new do it
/new improve-error-handling
```

**What happens:**

- Creates `changes/improve-error-handling/` with proposal template
- Establishes the pattern for future features
- Keeps new work isolated from existing code

---

## Step 4: Choose Your First Retrofit Task

Pick a small, low-risk feature to test the workflow.

**Good first tasks:**

- Add a new page or component (isolated, low risk)
- Improve error messages (clear scope, easy to verify)
- Add missing tests (doesn't change behavior)

**Avoid:**

- Large refactorings (too much change at once)
- Core architecture changes (high risk for first attempt)
- Anything blocking other developers

---

## Step 5: Run the Full Workflow

Use the complete toolkit flow for your first task.

```bash
/specify "Standardize error messages across the app with user-friendly copy and error codes"
/plan
/design "Create ErrorBoundary component and error message catalog"
/test "Error handling and display"
/archive improve-error-handling
```

---

## Step 6: Establish Team Norms

Document how the team should use the toolkit going forward.

**Add to your project README:**

```markdown
## Development Workflow

All new features and fixes should follow this process:

1. Run `/new [feature-name]` to create a change folder
2. Use `/specify` for complex features, `/specify` + `/plan` for simple ones
3. Implement using `/design`, `/backend`, etc.
4. Run `/final-polish` before submitting PR
5. Run `/archive` after merging

See `docs/scenarios/new-feature.md` for a detailed example.
```

---

## Step 7: Gradual Adoption

Don't force the entire team to switch overnight.

**Phase 1 (Week 1-2):**

- You use the toolkit for your own work
- Share results in standups
- Invite others to try `/investigate` for debugging

**Phase 2 (Week 3-4):**

- Encourage `/new` for all new features
- Optional: Use `/specify` for complex work
- Archive completed changes

**Phase 3 (Month 2+):**

- Full adoption: All features go through the workflow
- Update team documentation
- Onboard new contributors with the toolkit

---

## Common Challenges

### "Our project structure doesn't match the toolkit's assumptions"

**Solution:** The toolkit is flexible. You can:

- Keep your existing `src/` structure
- Use `changes/` only for planning artifacts
- Customize the templates in `templates/` to match your conventions

### "We already have a planning process (Jira, Linear, etc.)"

**Solution:** The toolkit complements, not replaces, project management tools:

- Use Jira for tracking _what_ to build
- Use the toolkit for _how_ to build it
- Link change folders to Jira tickets in the proposal

### "The team thinks this is too much ceremony"

**Solution:** Start with `/specify` + `/plan` for a streamlined process:

- Generates all artifacts in a few steps
- Still provides structure without slowing down

---

## Pro Tips

- **Don't retrofit everything**: Only use the toolkit for _new_ work, leave legacy code alone
- **Lead by example**: Use it yourself first, let results speak
- **Customize templates**: Adapt `templates/` to match your team's language and standards
- **Use `/investigate` liberally**: It's the lowest-friction entry point for skeptical teammates
