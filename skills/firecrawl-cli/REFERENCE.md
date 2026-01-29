# Firecrawl CLI - Reference Documentation

Extended documentation for the firecrawl-cli skill. Read only when detailed information is needed.

## Installation

```bash
npm install -g firecrawl-cli
```

Authentication: `fc-266fdc117aca438186e68329efce1920`

## Detailed Command Reference

### Scrape (Default Command)

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

### Search Command

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

### Map Command

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

### Crawl Command

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

---

## Common Workflows

### Research Workflow

1. **Search for relevant pages:**

```bash
firecrawl search "machine learning best practices 2024" --limit 10 --pretty -o search-results.json
```

2. **Extract URLs from results:**

```bash
jq -r '.data.web[].url' search-results.json > urls.txt
```

3. **Scrape all results:**

```bash
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
jq -r '.data[] | select(.url | contains("pricing")) | .markdown' competitor-data.json
```

---

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

---

## When to Use CLI vs MCP Server

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

---

## Troubleshooting

### Authentication Errors

```bash
# Re-authenticate if needed
firecrawl login
# Choose option 2 (Enter API key manually)
# Enter: fc-266fdc117aca438186e68329efce1920
```

### Rate Limiting

- Use `--delay` option to slow down requests
- Reduce `--max-concurrency` for crawls
- Check credit usage with `firecrawl credit-usage`

### Large Output

- Always use `-o` to save to file for large operations
- Use `--only-main-content` to reduce content size
- Limit results with `--limit` option

---

## Reference

- **Documentation**: https://docs.firecrawl.dev/sdks/cli
- **API Key Management**: https://www.firecrawl.dev/app/api-keys
- **Pricing**: https://www.firecrawl.dev/pricing
- **Open Source**: https://github.com/firecrawl/firecrawl-cli

## Notes

- Telemetry is enabled by default. Disable with `FIRECRAWL_NO_TELEMETRY=1`
- CLI and MCP server use the same API key and credit pool
- All operations count against your credit balance
