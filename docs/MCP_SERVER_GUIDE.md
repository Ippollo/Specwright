# MCP Server Guide

This document maps which MCP servers are recommended for each workflow and agent in the toolkit.

## How MCP Servers Work

MCP (Model Context Protocol) servers extend Antigravity's capabilities by connecting to external services and tools. However:

- **Static Configuration**: Servers are configured in `mcp_config.json` and loaded at startup
- **Can't be toggled dynamically**: You can't enable/disable them mid-session
- **Resource limits**: There's a limit of 100 MCP servers

## Strategy: Learn as You Go

Instead of enabling all servers upfront, this toolkit uses a **progressive discovery** approach:

1. **Documentation**: Each workflow/agent lists MCP requirements in frontmatter
2. **Coach Mode**: The `/coach` workflow mentions relevant servers when suggesting workflows
3. **Learn Over Time**: You'll naturally discover which servers match your work patterns

## Quick Reference

### Most Commonly Recommended

| Server                  | Use Cases                                    | Workflows/Agents                                                                       |
| ----------------------- | -------------------------------------------- | -------------------------------------------------------------------------------------- |
| **context7**            | Library API research, framework docs         | `/backend`, `/investigate`, `backend-architect`, `project-planner`                     |
| **sequential-thinking** | Complex planning, structured analysis        | `/brainstorm`, `/plan`, `/second-opinion`, `project-planner`                           |
| **github**              | Issue tracking, PR reviews, codebase context | `/investigate`, `debugger`, `code-custodian`, `project-planner`, `sec-devops-engineer` |
| **playwright**          | E2E testing, UI validation                   | `/test`, `qa-engineer`, `frontend-specialist`                                          |
| **firecrawl-mcp**       | Documentation scraping, competitive research | `/brainstorm`, `/investigate`, `project-planner`                                       |

### Deployment & Cloud

| Server                  | Use Cases               | Workflows/Agents                 |
| ----------------------- | ----------------------- | -------------------------------- |
| **gcloud**              | Google Cloud deployment | `/deploy`, `sec-devops-engineer` |
| **firebase-mcp-server** | Firebase services       | `/deploy`, `backend-architect`   |
| **observability**       | Logs and monitoring     | `/deploy`, `/debug`              |

## By Workflow

### Planning Phase

- `/new` → (none)
- `/brainstorm` → `sequential-thinking`, `firecrawl-mcp`
- `/specify` → (none)
- `/clarify` → (none)
- `/plan` → `sequential-thinking`
- `/investigate` → `github`, `context7`, `firecrawl-mcp`

### Building Phase

- `/work` → (none — orchestrates other workflows)
- `/design` → (none)
- `/backend` → `context7`
- `/enhance` → (none)
- `/review` → (none — orchestrates specialist agents)

### Verification Phase

- `/test` → `playwright`
- `/debug` → `observability`
- `/preview` → (none)
- `/final-polish` → (none)

### Deployment & Completion

- `/deploy` → `gcloud`, `firebase-mcp-server`, `observability`
- `/security` → (none)
- `/archive` → (none)

### Meta Workflows

- `/coach` → (none - coach references other workflows' needs)
- `/second-opinion` → `sequential-thinking`
- `/constitution` → (none)

## By Agent

| Agent                 | Recommended Servers                                          |
| --------------------- | ------------------------------------------------------------ |
| `project-planner`     | `github`, `sequential-thinking`, `context7`, `firecrawl-mcp` |
| `backend-architect`   | `firebase-mcp-server`, `context7`                            |
| `frontend-specialist` | `context7`, `playwright`                                     |
| `debugger`            | `github`                                                     |
| `code-custodian`      | `github`, `context7`                                         |
| `qa-engineer`         | `playwright`                                                 |
| `sec-devops-engineer` | `github`, `gcloud`                                           |

## Configuration Tips

### Minimal Setup (70% of use cases)

Enable these for general development work:

```json
{
  "mcpServers": {
    "context7": { ... },
    "sequential-thinking": { ... },
    "github": { ... }
  }
}
```

### Full-Stack Setup

Add these for complete web app development:

```json
{
  "mcpServers": {
    "context7": { ... },
    "sequential-thinking": { ... },
    "github": { ... },
    "playwright": { ... },
    "firecrawl-mcp": { ... }
  }
}
```

### Cloud Deployment Setup

Add cloud providers as needed:

```json
{
  "mcpServers": {
    "gcloud": { ... },
    "firebase-mcp-server": { ... },
    "observability": { ... }
  }
}
```

## Learning Path

1. **Week 1**: Start with just `context7` and `sequential-thinking`
2. **Week 2-3**: Add `github` if you work with repositories
3. **Week 4+**: Add specialized servers based on your actual workflows
   - Playwright for testing
   - Firecrawl for research-heavy projects
   - Cloud servers when deploying

**Remember**: You can always work without these servers. They're enhancements, not requirements.

## Technical Details

### Frontmatter Format

Every workflow and agent includes:

```yaml
---
description: ...
requires_mcp: [] # Hard requirements (currently none)
recommends_mcp: [...] # Recommended for best experience
---
```

This machine-readable format allows the `/coach` workflow to programmatically check requirements and guide you appropriately.
