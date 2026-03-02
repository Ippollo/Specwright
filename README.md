# Antigravity Agentic Toolkit

My personal library of Skills, Agents, and Workflows for **Antigravity** (my AI coding assistant).

## About

> [!NOTE]
> This is the toolkit I built for my own workflow with Antigravity. It works great for me, and it might for you too — fork it, adapt it, make it yours.

## Structure

- **[Agents](./agents/)**: Specialized personas (e.g., `project-planner`, `frontend-specialist`) that embody expert roles.
- **[Workflows](./workflows/)**: Standard operating procedures (e.g., `/plan`, `/debug`) for common tasks.
- **[Skills](./skills/)**: Atomic capabilities (e.g., `api-design-patterns`, `react-best-practices`) used by Agents.

## Setup

There are three ways to use this toolkit. Pick the one that fits your workflow.

### ⭐ Option 1: Add as a Workspace Folder (Recommended)

The simplest and most reliable approach. In VS Code:

1. **File → Add Folder to Workspace...**
2. Select your local clone of this toolkit (e.g., `c:\Projects\agentic-toolkit`)
3. Save the workspace when prompted

> [!TIP]
> This is the recommended method because the toolkit folder becomes a trusted part of your workspace — **no "Allow access" permission prompts**, always up to date, and Antigravity sees all workflows, agents, and skills immediately.

Repeat this for each project workspace where you want the toolkit available.

### Option 2: Global Setup

To make workflows available in **every** project without adding a folder each time, link the local repository to the global Antigravity configuration:

```powershell
./scripts/make-global.ps1
```

### Option 3: Per-Project Install

To copy the toolkit into a single project:

**Windows (PowerShell):**

```bash
iwr -useb https://raw.githubusercontent.com/Ippollo/skills/main/install.ps1 | iex
```

**macOS / Linux (Bash):**

```bash
curl -fsSL https://raw.githubusercontent.com/Ippollo/skills/main/install.sh | bash
```

> [!NOTE]
> Per-project installs create a local copy. You won't get updates automatically — re-run the installer to pull the latest version.

---

## 🎓 New to the Toolkit?

If you're just getting started with agentic development, the toolkit can feel overwhelming. **Start with Coach mode:**

```
/coach on
```

Coach mode teaches you the toolkit as you work:

- 🎓 Explains _why_ workflows exist before suggesting them
- 🧭 Suggests the right workflow at the right time
- 🚦 Tracks your progress (Planning → Building → Verifying → Done)
- 🤝 Asks before taking complex actions

As you learn, you'll naturally stop needing it. Turn it off anytime with `/coach off`.

---

## 📖 My Workflow

For reference on how I use this toolkit:

1.  **[Getting Started](./docs/GETTING_STARTED.md)**: How I set up new projects.
2.  **[Quick Reference](./docs/QUICK_REFERENCE.md)**: One-page cheat sheet for all commands.
3.  **[MCP Recommendations](./docs/MCP_RECOMMENDATIONS.md)**: My MCP server setup for Antigravity.
4.  **[Scenario: New Feature](./docs/scenarios/new-feature.md)**: My step-by-step feature workflow.
5.  **[Scenario: Debugging](./docs/scenarios/debugging.md)**: How I systematically find and fix bugs.

## 🚀 Recommended Flow

1.  **Initialize**: `/new feature-name`
2.  **Plan**: `/specify "Describe feature"` → `/plan`
3.  **Build**: `/work` — auto-executes tasks by tag: `backend → design → security → enhance → test`
4.  **Commit**: `/commit` — stage, commit (conventional), and push
5.  **Finish**: `/archive feature-name`

---

## Catalog

See [CATALOG.md](./CATALOG.md) for a full index of available capabilities.
