# Antigravity Agentic Toolkit

My personal library of Skills, Agents, and Workflows for **Antigravity** (my AI coding assistant).

## About

> [!NOTE]
> This is the toolkit I use with Antigravity. It's not intended as a general-purpose community project, though others are welcome to reference it and adapt it for their own needs.

## Structure

- **[Agents](./agents/)**: Specialized personas (e.g., `project-planner`, `frontend-specialist`) that embody expert roles.
- **[Workflows](./workflows/)**: Standard operating procedures (e.g., `/plan`, `/debug`) for common tasks.
- **[Skills](./skills/)**: Atomic capabilities (e.g., `api-design-patterns`, `react-best-practices`) used by Agents.

## Installation

To add my toolkit to a new project, run the appropriate command in your terminal:

### Windows (PowerShell)

```bash
iwr -useb https://raw.githubusercontent.com/Ippollo/skills/main/install.ps1 | iex
```

### macOS / Linux (Bash)

```bash
curl -fsSL https://raw.githubusercontent.com/Ippollo/skills/main/install.sh | bash
```

## Global Setup

To make my workflows available in **every** project without manual installation, link the local repository to the global Antigravity configuration:

```powershell
./scripts/make-global.ps1
```

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
2.  **Plan**: `/ff "Describe feature"`
3.  **Build**: Mark tasks `[x]` in the task list.
4.  **Finish**: `/archive feature-name`

---

## Catalog

See [CATALOG.md](./CATALOG.md) for a full index of available capabilities.
