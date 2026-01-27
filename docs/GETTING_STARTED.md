# Getting Started with Agentic Toolkit

Welcome! This guide will take you from installation to your first successfully archived feature in 10 minutes.

## 1. Verify Installation

Ensure the toolkit is linked to your project. If you haven't installed it yet:

**Windows (PowerShell):**

```powershell
iwr -useb https://raw.githubusercontent.com/Ippollo/skills/main/install.ps1 | iex
```

**macOS / Linux (Bash):**

```bash
curl -fsSL https://raw.githubusercontent.com/Ippollo/skills/main/install.sh | bash
```

Run `/new test-initialization` to verify. You should see a `changes/test-initialization/` folder created.

## 2. Set the Ground Rules

Every project needs a Constitution. This sets the guardrails for the AI.

```bash
/constitution
```

This creates `docs/CONSTITUTION.md`. Edit this file to include your tech stack preferences (e.g., "Always use TypeScript," "Prefer Vitest over Jest").

## 3. The 3-Phase Workflow

### Phase 1: Planning (`/new` & `/ff`)

Start a new feature called `user-profile`.

```bash
/new user-profile
```

For high-velocity work, use the Fast-Forward command to generate all planning docs:

```bash
/ff "Add user profile page with avatar upload and bio edit"
```

This generates:

- `changes/user-profile/specs/user-profile.md`
- `changes/user-profile/design.md`
- `changes/user-profile/tasks.md`

### Phase 2: Implementation

Open `changes/user-profile/tasks.md`. This is your source of truth.

Start implementing tasks. For UI tasks, use:

```bash
/design "Implement avatar upload component with glassmorphism"
```

For backend tasks, use:

```bash
/backend "Create API endpoint for profile updates"
```

### Phase 3: Verify & Archive

Once all tasks are marked `[x]`, verify the work:

```bash
/test "Profile updates and upload logic"
/final-polish
```

Finally, merge the change and cleanup:

```bash
/archive user-profile
```

The tool will move your specs to the root `./specs/` folder and delete the `changes/` subdirectory.

## Next Steps

- Check the [Quick Reference](./QUICK_REFERENCE.md) for all commands.
- See individual [Agent profiles](../agents/) to learn their specialties.
- Dive into the [Skill Catalog](../CATALOG.md) to see what the toolkit can do.
