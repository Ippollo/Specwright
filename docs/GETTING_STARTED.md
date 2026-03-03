# My Workflow Setup

This is how I initialize new projects with **Antigravity** and **Specwright**.

## 1. Add the Toolkit to Your Workspace

The fastest way to get started is to add the toolkit as a workspace folder:

1. **File → Add Folder to Workspace...**
2. Select your local clone of this toolkit (e.g., `c:\Projects\agentic-toolkit`)
3. Save the workspace when prompted

This gives Antigravity full access to all workflows, agents, and skills — with **no permission prompts**.

> [!TIP]
> If you don't have the toolkit cloned locally yet, grab it first:
>
> ```bash
> git clone https://github.com/Ippollo/Specwright.git specwright
> ```

**Alternative: Per-project install** — If you prefer a self-contained copy inside your project, run the install script instead. See the [README](../README.md#option-3-per-project-install) for details.

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

### Phase 1: Planning (`/new` → `/specify` → `/plan` → `/analyze`)

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

Before writing any code, I run a consistency check:

```bash
/analyze
```

This audits that the spec, plan, and tasks are aligned — catching scope drift or missing coverage before the pipeline starts.

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

Then I commit and push:

```bash
/commit
```

Finally, I merge the change and cleanup:

```bash
/archive user-profile
```

The tool snapshots your specs, moves them to the root `./specs/` folder, and deletes the `changes/` subdirectory.

## Next Steps

- Check the [Quick Reference](./QUICK_REFERENCE.md) for all commands.
- See individual [Agent profiles](../agents/) to learn their specialties.
- Dive into the [Skill Catalog](../CATALOG.md) to see what the toolkit can do.
