---
name: Firecrawl CLI
description: Advanced web scraping, crawling, and content extraction via command-line interface.
quick_summary: "Web scraping CLI. Commands: firecrawl <url>, firecrawl search, firecrawl map, firecrawl crawl"
---

# Firecrawl CLI Skill

Web scraping and content extraction through command-line commands. Designed for AI agents.

## Quick Reference

| Command                  | Use Case           | Example                                             |
| ------------------------ | ------------------ | --------------------------------------------------- |
| `firecrawl <url>`        | Scrape single page | `firecrawl https://example.com --only-main-content` |
| `firecrawl search`       | Search web         | `firecrawl search "AI tutorials" --limit 10`        |
| `firecrawl map`          | Discover URLs      | `firecrawl map https://example.com --search "blog"` |
| `firecrawl crawl`        | Crawl entire site  | `firecrawl crawl https://example.com --limit 50`    |
| `firecrawl credit-usage` | Check credits      | `firecrawl credit-usage`                            |

## Core Commands

### Scrape (Default)

```bash
# Clean content without nav/footer
firecrawl https://example.com --only-main-content

# Save to file
firecrawl https://example.com --only-main-content -o content.md

# Wait for JavaScript
firecrawl https://example.com --wait-for 3000
```

### Search

```bash
# Basic search
firecrawl search "web scraping tutorials" --limit 10

# Time-filtered (qdr:h=hour, qdr:d=day, qdr:w=week, qdr:m=month)
firecrawl search "tech news" --tbs qdr:d

# Search AND scrape results
firecrawl search "docs" --scrape --scrape-formats markdown --only-main-content
```

### Map (Discover URLs)

```bash
# Find all URLs on a site
firecrawl map https://example.com

# Filter by keyword
firecrawl map https://example.com --search "blog"

# Save to file
firecrawl map https://example.com -o urls.txt
```

### Crawl

```bash
# Crawl with limits (wait for completion)
firecrawl crawl https://example.com --limit 50 --max-depth 2 --wait

# Include/exclude paths
firecrawl crawl https://example.com --include-paths /docs --wait
firecrawl crawl https://example.com --exclude-paths /admin --wait
```

## Best Practices

1. **Always use `--only-main-content`** for cleaner output
2. **Set `--limit`** on crawls and searches to manage credits
3. **Use `-o` to save** large operations to files
4. **Check credits** with `firecrawl credit-usage` before large ops

## Global Options

- `-o <path>` - Save output to file
- `--pretty` - Pretty print JSON
- `--json` - Force JSON output
- `--help` - Show help

---

## Additional Resources

For detailed documentation, see:

- [REFERENCE.md](file:///c:/Projects/agentic-toolkit/skills/firecrawl-cli/REFERENCE.md) - Full examples, workflows, troubleshooting
- [Official Docs](https://docs.firecrawl.dev/sdks/cli) - Complete API reference
