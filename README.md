# Antigravity Agentic Toolkit

Comprehensive library of Skills, Agents, and Workflows for autonomous AI development.

## Project Status

> [!NOTE]
> This is a personal toolkit shared for the benefit of the community. It is provided "as-is," and I may not be actively maintaining it or responding to issues/pull requests. Feel free to use and adapt it for your own needs!

## Structure

- **[Agents](./agents/)**: Specialized personas (e.g., `project-planner`, `frontend-specialist`) that embody expert roles.
- **[Workflows](./workflows/)**: Standard operating procedures (e.g., `/plan`, `/debug`) for common tasks.
- **[Skills](./skills/)**: Atomic capabilities (e.g., `api-design-patterns`, `react-best-practices`) used by Agents.

## Installation

To add the toolkit to your current project, run the appropriate command in your terminal:

### Windows (PowerShell)

```bash
iwr -useb https://raw.githubusercontent.com/Ippollo/skills/main/install.ps1 | iex
```

### macOS / Linux (Bash)

```bash
curl -fsSL https://raw.githubusercontent.com/Ippollo/skills/main/install.sh | bash
```

## Global Setup (Developers)

If you want the workflows available in **every** project without manual installation, you can link your local repository to your global Antigravity configuration:

```powershell
./scripts/make-global.ps1
```

---

## 📖 User Guide

For a smooth experience, please refer to the documentation:

1.  **[Getting Started](./docs/GETTING_STARTED.md)**: 10-minute tutorial for new users.
2.  **[Quick Reference](./docs/QUICK_REFERENCE.md)**: One-page cheat sheet for all commands.
3.  **[MCP Recommendations](./docs/MCP_RECOMMENDATIONS.md)**: Recommended MCP servers for enhanced capabilities.
4.  **[Scenario: New Feature](./docs/scenarios/new-feature.md)**: Step-by-step big feature workflow.
5.  **[Scenario: Debugging](./docs/scenarios/debugging.md)**: Systematically finding and fixing bugs.

## 🚀 Recommended Flow

1.  **Initialize**: `/new feature-name`
2.  **Plan**: `/ff "Describe feature"`
3.  **Build**: Mark tasks `[x]` in the task list.
4.  **Finish**: `/archive feature-name`

---

## Catalog

See [CATALOG.md](./CATALOG.md) for a full index of available capabilities.
