---
name: Firecrawl CLI
description: Advanced web scraping, crawling, and content extraction via command-line interface. Designed specifically for AI agents.
---

# Firecrawl CLI Skill

## Overview

The Firecrawl CLI provides powerful web scraping and content extraction capabilities through simple command-line commands. It's designed specifically for AI agents like Antigravity and can be used alongside or instead of the Firecrawl MCP server.

**Key Capabilities:**

- Scrape single or multiple web pages
- Search the web and scrape results
- Map entire websites to discover URLs
- Crawl sites with depth and path controls
- Extract structured data
- Output to files or pipe to other tools

## Installation

Already installed globally:

```bash
npm install -g firecrawl-cli
```

Authentication is configured with API key: `fc-266fdc117aca438186e68329efce1920`

## Quick Reference

| Command                  | Use Case           | Example                                                 |
| ------------------------ | ------------------ | ------------------------------------------------------- |
| `firecrawl <url>`        | Scrape single page | `firecrawl https://example.com --only-main-content`     |
| `firecrawl search`       | Search web         | `firecrawl search "AI tutorials" --limit 10`            |
| `firecrawl map`          | Discover URLs      | `firecrawl map https://example.com --search "blog"`     |
| `firecrawl crawl`        | Crawl entire site  | `firecrawl crawl https://example.com --limit 50 --wait` |
| `firecrawl credit-usage` | Check credits      | `firecrawl credit-usage`                                |

## Core Commands

### 1. Scrape (Default Command)

Extract content from a single URL.

**Basic Usage:**

```bash
# Simple scrape (outputs markdown)
firecrawl https://example.com

# Recommended: clean output without nav/footer
firecrawl https://example.com --only-main-content

# Save to file
firecrawl https://example.com --only-main-content -o content.md
```

**Advanced Options:**

```bash
# Get HTML instead of markdown
firecrawl https://example.com --html -o page.html

# Wait for JavaScript rendering (3 seconds)
firecrawl https://example.com --wait-for 3000

# Multiple formats (returns JSON)
firecrawl https://example.com --format markdown,links,screenshot --pretty

# Include/exclude specific HTML tags
firecrawl https://example.com --include-tags article,main
firecrawl https://example.com --exclude-tags nav,footer
```

**Available Formats:**

- `markdown` - Clean markdown (default)
- `html` - Rendered HTML
- `rawHtml` - Raw HTML source
- `links` - All links on page
- `screenshot` - Page screenshot
- `json` - Structured JSON

### 2. Search

Search the web and optionally scrape results.

**Basic Usage:**

```bash
# Simple search
firecrawl search "web scraping tutorials"

# Limit results
firecrawl search "AI news" --limit 10

# Pretty print JSON
firecrawl search "machine learning" --pretty -o results.json
```

**Advanced Options:**

```bash
# Search specific sources
firecrawl search "AI" --sources web,news,images

# Category filters
firecrawl search "react hooks" --categories github
firecrawl search "machine learning" --categories research,pdf

# Time-based filtering
firecrawl search "tech news" --tbs qdr:h  # Last hour
firecrawl search "tech news" --tbs qdr:d  # Last day
firecrawl search "tech news" --tbs qdr:w  # Last week
firecrawl search "tech news" --tbs qdr:m  # Last month

# Location-based search
firecrawl search "restaurants" --location "Berlin,Germany" --country DE

# Search AND scrape results
firecrawl search "documentation" --scrape --scrape-formats markdown --only-main-content
```

**Time Filter Values:**

- `qdr:h` - Last hour
- `qdr:d` - Last day
- `qdr:w` - Last week
- `qdr:m` - Last month
- `qdr:y` - Last year

### 3. Map

Discover all URLs on a website.

**Basic Usage:**

```bash
# Discover all URLs
firecrawl map https://example.com

# Output as JSON
firecrawl map https://example.com --json --pretty -o urls.json

# Save as text (one URL per line)
firecrawl map https://example.com -o urls.txt
```

**Advanced Options:**

```bash
# Filter URLs by search query
firecrawl map https://example.com --search "blog"

# Limit number of URLs
firecrawl map https://example.com --limit 500

# Include subdomains
firecrawl map https://example.com --include-subdomains

# Control sitemap usage
firecrawl map https://example.com --sitemap include  # Use sitemap
firecrawl map https://example.com --sitemap skip     # Skip sitemap
firecrawl map https://example.com --sitemap only     # Only use sitemap

# Ignore query parameters (dedupe URLs)
firecrawl map https://example.com --ignore-query-parameters
```

### 4. Crawl

Crawl entire sites or sections with depth control.

**Basic Usage:**

```bash
# Start crawl (returns job ID immediately)
firecrawl crawl https://example.com

# Wait for completion
firecrawl crawl https://example.com --wait

# Wait with progress indicator
firecrawl crawl https://example.com --wait --progress
```

**Check Status:**

```bash
# Check crawl status using job ID
firecrawl crawl <job-id>
```

**Advanced Options:**

```bash
# Limit depth and pages
firecrawl crawl https://example.com --limit 100 --max-depth 3 --wait

# Include only specific paths
firecrawl crawl https://example.com --include-paths /blog,/docs --wait

# Exclude specific paths
firecrawl crawl https://example.com --exclude-paths /admin,/login --wait

# Include subdomains
firecrawl crawl https://example.com --allow-subdomains --wait

# Crawl entire domain
firecrawl crawl https://example.com --crawl-entire-domain --wait

# Rate limiting
firecrawl crawl https://example.com --delay 1000 --max-concurrency 2 --wait

# Custom polling and timeout
firecrawl crawl https://example.com --wait --poll-interval 10 --timeout 300

# Save results
firecrawl crawl https://example.com --wait --pretty -o results.json
```

### 5. Credit Usage

Check remaining API credits.

```bash
# View credit usage
firecrawl credit-usage

# JSON output
firecrawl credit-usage --json --pretty
```

## Common Workflows

### Research Workflow

1. **Search for relevant pages:**

```bash
firecrawl search "machine learning best practices 2024" --limit 10 --pretty -o search-results.json
```

2. **Extract URLs from results:**

```bash
# Using jq to extract URLs
jq -r '.data.web[].url' search-results.json > urls.txt
```

3. **Scrape all results:**

```bash
# Read URLs and scrape each one
cat urls.txt | while read url; do
  firecrawl "$url" --only-main-content -o "scraped/$(echo $url | md5sum | cut -d' ' -f1).md"
done
```

### Documentation Extraction

1. **Discover all docs pages:**

```bash
firecrawl map https://docs.example.com --search "api" -o api-urls.txt
```

2. **Scrape all discovered pages:**

```bash
cat api-urls.txt | while read url; do
  firecrawl "$url" --only-main-content -o "docs/$(basename $url).md"
done
```

### Competitive Analysis

1. **Crawl competitor site:**

```bash
firecrawl crawl https://competitor.com --limit 50 --max-depth 2 --wait --pretty -o competitor-data.json
```

2. **Extract specific information:**

```bash
# Extract pricing pages
jq -r '.data[] | select(.url | contains("pricing")) | .markdown' competitor-data.json
```

### Site Discovery

1. **Map entire site:**

```bash
firecrawl map https://example.com --json --pretty -o site-map.json
```

2. **Filter by section:**

```bash
# Find all blog posts
jq -r '.[] | select(contains("/blog/"))' site-map.json
```

## Global Options

All commands support these options:

- `--output <path>` or `-o <path>` - Save output to file
- `--pretty` - Pretty print JSON output
- `--json` - Force JSON output format
- `--help` - Show help for command

## Output Handling

### Format Behavior

- **Single format**: Returns content directly (e.g., markdown text)
- **Multiple formats**: Returns JSON object with all formats
- **JSON flag**: Forces JSON output regardless of format

### Piping to Other Tools

```bash
# Extract URLs from search results
firecrawl search "tutorials" --json | jq -r '.data.web[].url'

# Get titles from search results
firecrawl search "AI" --json | jq -r '.data.web[] | "\(.title): \(.url)"'

# Extract links and process with jq
firecrawl https://example.com --format links | jq '.links[].url'

# Count URLs from map
firecrawl map https://example.com | wc -l
```

## Best Practices

### When to Use CLI vs MCP Server

**Use CLI when:**

- You need to pipe output to files or other tools
- You want to script batch operations
- You need shell-level control (loops, conditionals)
- You're building workflows that combine multiple tools

**Use MCP Server when:**

- You want native tool invocation in conversations
- You need structured error handling
- You prefer the agent to manage tool selection
- You want batch operations with status tracking

### Performance Tips

1. **Use `--only-main-content`** for cleaner, smaller output
2. **Limit crawl depth** with `--max-depth` to avoid excessive requests
3. **Use `--limit`** to cap number of pages/results
4. **Save to files** with `-o` to avoid overwhelming console output
5. **Check credits** regularly with `firecrawl credit-usage`

### Cost Management

- **Current credits**: 900 remaining
- **Monitor usage**: Run `firecrawl credit-usage` before large operations
- **Use limits**: Always set `--limit` on crawls and searches
- **Prefer map over crawl**: Map only discovers URLs, crawl fetches content

## Troubleshooting

### Common Issues

**Authentication errors:**

```bash
# Re-authenticate if needed
firecrawl login
# Choose option 2 (Enter API key manually)
# Enter: fc-266fdc117aca438186e68329efce1920
```

**Rate limiting:**

- Use `--delay` option to slow down requests
- Reduce `--max-concurrency` for crawls
- Check credit usage with `firecrawl credit-usage`

**Large output:**

- Always use `-o` to save to file for large operations
- Use `--only-main-content` to reduce content size
- Limit results with `--limit` option

## Examples

### Quick Scrape

```bash
# Get clean markdown from a page
firecrawl https://docs.firecrawl.dev --only-main-content -o firecrawl-docs.md
```

### Full Site Crawl

```bash
# Crawl docs site with limits
firecrawl crawl https://docs.example.com --limit 50 --max-depth 2 --wait --progress -o docs.json
```

### Site Discovery

```bash
# Find all blog posts
firecrawl map https://example.com --search "blog" -o blog-urls.txt
```

### Research Workflow

```bash
# Search and scrape results
firecrawl search "machine learning best practices 2024" --scrape --scrape-formats markdown --pretty -o research.json
```

### Combine with Other Tools

```bash
# Extract URLs from search results
jq -r '.data.web[].url' search-results.json

# Get titles from search results
jq -r '.data.web[] | "\(.title): \(.url)"' search-results.json

# Count URLs from map
firecrawl map https://example.com | wc -l
```

## Reference

- **Documentation**: https://docs.firecrawl.dev/sdks/cli
- **API Key Management**: https://www.firecrawl.dev/app/api-keys
- **Pricing**: https://www.firecrawl.dev/pricing
- **Current Credits**: 900 remaining

## Notes

- Telemetry is enabled by default. Disable with `FIRECRAWL_NO_TELEMETRY=1`
- CLI and MCP server use the same API key and credit pool
- All operations count against your credit balance
- Open source: https://github.com/firecrawl/firecrawl-cli
