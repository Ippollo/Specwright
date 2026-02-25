# My Workflow Setup

This is how I initialize new projects with **Antigravity** and my agentic toolkit.

## 1. Verify Installation

Ensure the toolkit is linked to the project. If not installed yet:

**Windows (PowerShell):**

```powershell
iwr -useb https://raw.githubusercontent.com/Ippollo/skills/main/install.ps1 | iex
```

**macOS / Linux (Bash):**

```bash
curl -fsSL https://raw.githubusercontent.com/Ippollo/skills/main/install.sh | bash
```

Run `/new test-initialization` to verify. You should see a `changes/test-initialization/` folder created.

## 2. New to Agentic Development? Start Here

If the toolkit feels overwhelming, enable **Coach mode**:

```bash
/coach on
```

Coach mode teaches you the toolkit while you work. It will:

- Explain workflows before suggesting them
- Guide you through the Planning → Building → Verifying phases
- Ask before taking complex actions
- Provide quick references for each command

As you learn, you'll naturally stop needing it. Turn it off with `/coach off`.

> **Tip**: You can skip to Section 3 below and let Coach mode guide you through setting up your first feature!

## 3. Set My Ground Rules

Every project needs a Constitution. This sets the guardrails for Antigravity.

```bash
/constitution
```

This creates `docs/CONSTITUTION.md`. I edit this file to include my tech stack preferences (e.g., "Always use TypeScript," "Prefer Vitest over Jest").

## 4. My 3-Phase Workflow

### Phase 1: Planning (`/new` → `/specify` → `/plan`)

I start a new feature:

```bash
/new user-profile
```

Then I define the requirements and generate the plan:

```bash
/specify "Add user profile page with avatar upload and bio edit"
/plan
```

This generates:

- `changes/user-profile/specs/user-profile.md`
- `changes/user-profile/design.md`
- `changes/user-profile/tasks.md`

### Phase 2: Implementation

I open `changes/user-profile/tasks.md` as my source of truth.

I use `/work` to auto-execute tasks through the pipeline:

```bash
/work
```

This auto-advances through: `/backend` → `/design` → `/security` → `/enhance` → `/test`, loading the right agent for each stage.

To run a specific stage only:

```bash
/work backend
/work design
```

### Phase 3: Verify & Archive

Once all tasks are marked `[x]`, I verify the work:

```bash
/test "Profile updates and upload logic"
/final-polish
```

Finally, I merge the change and cleanup:

```bash
/archive user-profile
```

The tool moves my specs to the root `./specs/` folder and deletes the `changes/` subdirectory.

## Next Steps

- Check the [Quick Reference](./QUICK_REFERENCE.md) for all commands.
- See individual [Agent profiles](../agents/) to learn their specialties.
- Dive into the [Skill Catalog](../CATALOG.md) to see what the toolkit can do.
