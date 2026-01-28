---
description: Deep codebase investigation to understand existing patterns before planning.
requires_mcp: []
recommends_mcp: [github, context7, firecrawl-mcp]
---

# /investigate - Codebase Investigation

**Goal**: Analyze existing code to understand patterns, dependencies, and constraints.

## When to Use

- You need to understand how something currently works
- You're debugging or tracing an issue
- You're evaluating technical feasibility

## Contrast with /brainstorm

| `/brainstorm`             | `/investigate`        |
| ------------------------- | --------------------- |
| High-level ideation       | Technical deep-dive   |
| Compares abstract options | Analyzes actual code  |
| No codebase reading       | Reads and traces code |

## Steps

1. **Invoke Agent**: Use `project-planner` or current context.
2. **Execution**:
   - Search and read relevant source files.
   - Trace data flows and dependencies.
   - Document findings (patterns, risks, constraints).
3. **Completion**:
   - Summarize technical findings.
   - Suggest `/new [name]` when ready to proceed.

## Recommended MCP Servers

- **GitHub**: Fetch issue history for technical context.
- **Context 7**: Understand library capabilities and APIs.
- **Firecrawl**: Scrape documentation pages and extract structured data beyond codebase.

## Usage

```bash
/investigate "How is authentication currently handled?"
/investigate "Why is page load slow?"
/investigate "What touches the payments module?"
```
