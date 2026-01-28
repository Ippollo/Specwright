# MCP Server Recommendations

This guide documents recommended Model Context Protocol (MCP) servers for the agentic toolkit. MCP servers extend agent capabilities by providing access to external tools and data sources.

## Quick Reference

| MCP Server                           | Primary Use Case                 | Recommended For             |
| ------------------------------------ | -------------------------------- | --------------------------- |
| **GitHub**                           | Repository context, issues, PRs  | All agents                  |
| **Sequential Thinking**              | Complex reasoning                | Planning workflows          |
| **Context 7**                        | Up-to-date library documentation | Code-focused agents         |
| **Exa / Firecrawl**                  | Deep internet research           | Research workflows          |
| **Postgres** (Aiven/Neon/pg-aiguide) | Database schema access           | Backend development         |
| **Playwright**                       | Browser automation & testing     | Frontend/QA                 |
| **Firebase**                         | Firebase service integration     | Backend (if using Firebase) |
| **Cloudflare / AWS / GCP**           | Cloud infrastructure             | DevOps                      |
| **Filesystem**                       | Secure file operations           | Debugging                   |

---

## By Agent

### Project Planner

**Recommended:**

- **GitHub**: Fetch issues and PRs for context
- **Sequential Thinking**: Break down complex plans
- **Context 7**: Research library capabilities and versions
- **Exa / Firecrawl**: Deep internet research for technical feasibility

**Why:** Planning requires comprehensive context from multiple sources.

---

### Backend Architect

**Recommended:**

- **Firebase**: Query Firebase schemas and services
- **Context 7**: Get accurate API documentation for libraries
- **Postgres** (Aiven/Neon/pg-aiguide): Real-time database schema access

**Why:** Backend work requires accurate API docs and schema validation.

---

### Frontend Specialist

**Recommended:**

- **Context 7**: Latest framework documentation (React, Next.js, etc.)
- **Playwright**: Inspect live UI and validate visual changes

**Why:** Frontend frameworks evolve rapidly; up-to-date docs prevent deprecated patterns.

---

### Debugger

**Recommended:**

- **GitHub**: Link bugs to existing issues
- **Filesystem**: Safely read log files

**Why:** Debugging requires tracing issues across code and logs.

---

### QA Engineer

**Recommended:**

- **Playwright**: Run and validate E2E tests

**Why:** Automated testing requires browser control.

---

### Security & DevOps Engineer

**Recommended:**

- **GitHub**: Audit CI/CD pipelines
- **Cloudflare / AWS / GCP**: Manage cloud infrastructure

**Why:** DevOps automation requires direct cloud provider access.

---

### Code Custodian

**Recommended:**

- **GitHub**: Review PRs and check merge status
- **Context 7**: Check migration guides for library upgrades

**Why:** Code quality requires understanding changes and upgrade paths.

---

## By Workflow

### `/brainstorm`

**Recommended:**

- **Sequential Thinking**: Structure complex ideation
- **Exa**: Find similar products and solutions

**Why:** Ideation benefits from structured thinking and market research.

---

### `/investigate`

**Recommended:**

- **GitHub**: Fetch issue history for technical context
- **Context 7**: Understand library capabilities
- **Exa**: Deep research beyond code

**Why:** Investigation requires multiple information sources.

---

### `/plan`

**Recommended:**

- **Sequential Thinking**: Break down complex plans step-by-step

**Why:** Planning benefits from structured, methodical thinking.

---

## Installation

MCP servers are configured in your AI client (Cursor, Claude Code, etc.). Refer to each server's documentation for setup instructions.

### Official Servers

- **GitHub**: [github.com/modelcontextprotocol/servers](https://github.com/modelcontextprotocol/servers)
- **Context 7**: [mcpservers.org/servers/upstash/context7-mcp](https://mcpservers.org/servers/upstash/context7-mcp)
- **Playwright**: [mcpservers.org](https://mcpservers.org)
- **Postgres (Aiven)**: [mcpservers.org](https://mcpservers.org)
- **Postgres (Neon)**: [mcpservers.org](https://mcpservers.org)

### Community Servers

- **Exa**: [mcpservers.org](https://mcpservers.org)
- **Firecrawl**: [mcpservers.org](https://mcpservers.org)

---

## Not Recommended

| MCP Server     | Reason                                                                |
| -------------- | --------------------------------------------------------------------- |
| **NotebookLM** | Browser automation overhead; agents have native research capabilities |
| **SQLite**     | No official servers; agents can read SQLite files directly            |

---

## Building Custom MCP Servers

If you need integration with proprietary tools or specialized workflows not covered by existing servers, you can build your own MCP server. Refer to the official MCP documentation:

- **MCP Specification**: [modelcontextprotocol.io/specification](https://modelcontextprotocol.io/specification)
- **TypeScript SDK**: [github.com/modelcontextprotocol/typescript-sdk](https://github.com/modelcontextprotocol/typescript-sdk)
- **Python SDK**: [github.com/modelcontextprotocol/python-sdk](https://github.com/modelcontextprotocol/python-sdk)

---

## Tips

1. **Start with essentials**: GitHub, Sequential Thinking, and Context 7 cover most use cases.
2. **Add as needed**: Install specialized servers (Postgres, Playwright) only if you use those technologies.
3. **Use rules**: Configure your AI client to auto-invoke Context 7 for code generation (e.g., "Always use Context7 when generating code").
