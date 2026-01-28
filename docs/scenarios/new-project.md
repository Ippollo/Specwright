# Scenario: Starting a Brand New Project

This guide walks through setting up a greenfield project with the agentic toolkit from day one.

## The Goal

Create a new web application with proper governance, architecture, and workflow from the start.

---

## Step 1: Establish Project Governance

Before writing any code, define the rules of the game.

```bash
/constitution
```

**What happens:**

- The agent interviews you about code quality, testing standards, UX requirements, performance constraints, and architecture preferences
- Creates `docs/CONSTITUTION.md` with your project's governing principles
- All future planning will reference these rules

**Example questions you'll answer:**

- "What's your minimum test coverage requirement?"
- "Are there performance budgets (bundle size, API response time)?"
- "What accessibility standards should we follow?"

---

## Step 2: Explore the Core Vision

Brainstorm the essential features and architecture.

```bash
/brainstorm "Core features for [your app name]"
```

**What happens:**

- The agent generates 3+ different architectural approaches
- Each option includes pros, cons, and effort estimates
- You get a recommendation with reasoning

**Example output:**

- **Option A**: Monolith with server-side rendering
- **Option B**: Microservices with separate frontend
- **Option C**: Serverless with static site generation

---

## Step 3: Start Your First Feature

Initialize a change folder for your MVP feature.

```bash
/new user-authentication
```

**What happens:**

- Creates `changes/user-authentication/` directory
- Copies the proposal template
- Prompts you to fill in the proposal

---

## Step 4: Define Requirements

Create detailed specifications for the feature.

```bash
/specify "Email/password auth with JWT tokens, password reset flow, and session management"
```

**What happens:**

- Creates `changes/user-authentication/specs/auth.md`
- Generates user stories with acceptance criteria
- Prioritizes requirements (P1/P2/P3)
- Flags areas needing clarification

---

## Step 5: Create the Implementation Plan

Generate the technical design and task breakdown.

```bash
/plan
```

**What happens:**

- Creates `changes/user-authentication/research.md` (technical investigation)
- Creates `changes/user-authentication/design.md` (architecture decisions)
- Creates `changes/user-authentication/tasks.md` (dependency-aware task list)

---

## Step 6: Build the Feature

Use specialized agents for targeted execution.

```bash
/backend "Implement JWT authentication endpoints"
/design "Create login and signup forms with validation"
/test "Auth flow unit and integration tests"
```

---

## Step 7: Finalize and Archive

Clean up and preserve the work.

```bash
/final-polish
/archive user-authentication
```

**What happens:**

- Runs pre-submission checklist
- Moves delta specs to `specs/` directory
- Archives the change folder
- Preserves the "why" behind your decisions

---

## Alternative: Fast-Forward Mode

For simpler features where you have a clear vision:

```bash
/new onboarding-tutorial
# Fill in the proposal.md
/ff
# Generates specs, design, and tasks in one pass
```

---

## Why This Workflow?

1. **Constitution First**: Prevents architectural drift and technical debt
2. **Brainstorm Before Commit**: Explores options before locking into an approach
3. **Isolated Changes**: Each feature lives in its own folder
4. **Audit Trail**: Future developers understand the reasoning behind decisions
5. **Quality Gates**: `/final-polish` catches issues before they ship

---

## Pro Tips

- **Don't skip `/constitution`**: It's tempting to jump straight to coding, but 30 minutes here saves weeks of refactoring
- **Use `/second-opinion`**: For critical architecture decisions, get a rigorous review
- **Start small**: Your first feature should be a thin vertical slice (e.g., "View user profile" not "Complete user management system")
