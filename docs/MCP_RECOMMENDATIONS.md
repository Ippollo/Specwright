# My MCP Setup

This documents the MCP servers I use with **Antigravity** (my AI coding assistant). MCP servers extend agent capabilities by providing access to external tools and data sources.

## Quick Reference

| MCP Server              | Primary Use Case                 | When I Use It            |
| ----------------------- | -------------------------------- | ------------------------ |
| **Firebase**            | Firebase service integration     | Core                     |
| **Context7**            | Up-to-date library documentation | All code-focused work    |
| **GitHub**              | Repository context, issues, PRs  | Collaboration & research |
| **Sequential Thinking** | Complex reasoning                | Planning workflows       |
| **Firecrawl**           | Web scraping & extraction        | Research workflows       |
| **Playwright**          | Browser automation & testing     | Frontend/QA              |
| **GCloud**              | Google Cloud infrastructure      | Deployment & DevOps      |
| **Observability**       | Cloud monitoring & logging       | Debugging production     |
| **Storage**             | Cloud Storage operations         | File/asset management    |

---

## By Agent

### Project Planner

**I enable:**

- **GitHub**: Fetch issues and PRs for context
- **Sequential Thinking**: Break down complex plans
- **Context7**: Research library capabilities and versions
- **Firecrawl**: Scrape documentation, extract structured data from multiple sources

**Why:** Planning requires comprehensive context from multiple sources.

---

### Backend Architect

**I enable:**

- **Firebase**: Query Firebase schemas and services (core to my projects)
- **Context7**: Get accurate API documentation for libraries
- **GCloud**: Manage cloud infrastructure and deployments

**Why:** Backend work requires accurate API docs and infrastructure access.

---

### Frontend Specialist

**I enable:**

- **Context7**: Latest framework documentation (React, Next.js, etc.)
- **Playwright**: Inspect live UI and validate visual changes

**Why:** Frontend frameworks evolve rapidly; up-to-date docs prevent deprecated patterns.

---

### Debugger

**I enable:**

- **GitHub**: Link bugs to existing issues
- **Observability**: Check production logs and metrics

**Why:** Debugging requires tracing issues across code, logs, and infrastructure.

---

### QA Engineer

**I enable:**

- **Playwright**: Run and validate E2E tests

**Why:** Automated testing requires browser control.

---

### Security & DevOps Engineer

**I enable:**

- **GitHub**: Audit CI/CD pipelines
- **GCloud**: Manage cloud infrastructure
- **Observability**: Monitor security events

**Why:** DevOps automation requires direct cloud provider access.

---

### Code Custodian

**I enable:**

- **GitHub**: Review PRs and check merge status
- **Context7**: Check migration guides for library upgrades

**Why:** Code quality requires understanding changes and upgrade paths.

---

## By Workflow

### `/brainstorm`

**I enable:**

- **Sequential Thinking**: Structure complex ideation
- **Firecrawl**: Extract content from competitor sites or documentation

**Why:** Ideation benefits from structured thinking and market research.

---

### `/investigate`

**I enable:**

- **GitHub**: Fetch issue history for technical context
- **Context7**: Understand library capabilities
- **Firecrawl**: Scrape multiple documentation pages or extract structured data

**Why:** Investigation requires multiple information sources.

---

### `/plan`

**I enable:**

- **Sequential Thinking**: Break down complex plans step-by-step

**Why:** Planning benefits from structured, methodical thinking.

---

## Installation

MCP servers are configured in `mcp_config.json` for Antigravity. Each server can be enabled/disabled with the `disabled` flag.

### My Core Servers

- **Firebase**: `npx -y firebase-tools@latest mcp`
- **Context7**: `npx -y @upstash/context7-mcp --api-key YOUR_KEY`
- **GitHub**: `npx -y @modelcontextprotocol/server-github`

### Google Cloud Servers

- **GCloud**: `npx -y @google-cloud/gcloud-mcp`
- **Observability**: `npx -y @google-cloud/observability-mcp`
- **Storage**: `npx -y @google-cloud/storage-mcp`

### Other Servers

- **Firecrawl**: `npx -y firecrawl-mcp` (requires API key)
- **Playwright**: `npx -y @playwright/mcp@latest`
- **Sequential Thinking**: `npx -y @modelcontextprotocol/server-sequential-thinking`

---

## When to Use Firecrawl

Firecrawl extends the built-in `read_url_content` tool with advanced scraping capabilities. Use Firecrawl when you need:

### Core Tools

| Tool                     | Use When                                                                               | Don't Use When                              |
| ------------------------ | -------------------------------------------------------------------------------------- | ------------------------------------------- |
| `firecrawl_scrape`       | Single page extraction with advanced options (wait for JS, mobile view, specific tags) | Simple static page (use `read_url_content`) |
| `firecrawl_batch_scrape` | Multiple known URLs need content extraction                                            | Single URL or unknown URLs                  |
| `firecrawl_map`          | Discovering all URLs on a site before scraping                                         | You already know the URLs                   |
| `firecrawl_search`       | Finding pages across the web by topic                                                  | You know the exact URL                      |
| `firecrawl_crawl`        | Analyzing entire site sections with content                                            | Just discovering URLs (use `map`)           |
| `firecrawl_extract`      | Structured data extraction with schemas                                                | Unstructured content                        |

### Decision Tree

```
Do you know the exact URL(s)?
├─ Yes, one URL
│  ├─ Simple static page → use read_url_content
│  └─ Needs JS rendering/advanced options → use firecrawl_scrape
├─ Yes, multiple URLs → use firecrawl_batch_scrape
└─ No
   ├─ Need to discover URLs on a site → use firecrawl_map
   ├─ Need to search the web → use firecrawl_search or search_web
   └─ Need full site analysis → use firecrawl_crawl (with limits!)
```

### Common Workflows

**Research Workflow** (`/investigate`, `/brainstorm`):

1. `firecrawl_search` - Find relevant pages
2. `firecrawl_batch_scrape` - Extract content from top results
3. Analyze and synthesize findings

**Documentation Extraction**:

1. `firecrawl_map` - Discover all docs pages
2. `firecrawl_batch_scrape` - Extract content from relevant sections
3. `firecrawl_extract` - Pull structured data (API endpoints, parameters)

**Competitive Analysis**:

1. `firecrawl_crawl` - Analyze competitor site structure
2. `firecrawl_extract` - Extract pricing, features, etc.

---

## Building Custom MCP Servers

If you need integration with proprietary tools or specialized workflows not covered by existing servers, you can build your own MCP server. Refer to the official MCP documentation:

- **MCP Specification**: [modelcontextprotocol.io/specification](https://modelcontextprotocol.io/specification)
- **TypeScript SDK**: [github.com/modelcontextprotocol/typescript-sdk](https://github.com/modelcontextprotocol/typescript-sdk)
- **Python SDK**: [github.com/modelcontextprotocol/python-sdk](https://github.com/modelcontextprotocol/python-sdk)

---

## Tips

1. **Start with essentials**: Firebase, Context7, and GitHub cover most of my use cases.
2. **Add as needed**: Enable specialized servers (Playwright, GCloud) only when working on related tasks.
3. **Use rules**: Configure Antigravity to auto-invoke Context7 for code generation.
