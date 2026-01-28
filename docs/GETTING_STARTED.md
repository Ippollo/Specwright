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

## 2. Set My Ground Rules

Every project needs a Constitution. This sets the guardrails for Antigravity.

```bash
/constitution
```

This creates `docs/CONSTITUTION.md`. I edit this file to include my tech stack preferences (e.g., "Always use TypeScript," "Prefer Vitest over Jest").

## 3. My 3-Phase Workflow

### Phase 1: Planning (`/new` & `/ff`)

I start a new feature:

```bash
/new user-profile
```

For high-velocity work, I use the Fast-Forward command to generate all planning docs:

```bash
/ff "Add user profile page with avatar upload and bio edit"
```

This generates:

- `changes/user-profile/specs/user-profile.md`
- `changes/user-profile/design.md`
- `changes/user-profile/tasks.md`

### Phase 2: Implementation

I open `changes/user-profile/tasks.md` as my source of truth.

For UI tasks, I use:

```bash
/design "Implement avatar upload component with glassmorphism"
```

For backend tasks, I use:

```bash
/backend "Create API endpoint for profile updates"
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
