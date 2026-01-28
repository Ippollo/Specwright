# Firecrawl Quick Reference

## CLI Commands

### Scrape Single Page

```bash
firecrawl https://example.com --only-main-content
firecrawl https://example.com --only-main-content -o output.md
```

### Search Web

```bash
firecrawl search "AI tutorials" --limit 10
firecrawl search "tech news" --tbs qdr:d --pretty  # Last day
```

### Discover URLs

```bash
firecrawl map https://example.com
firecrawl map https://example.com --search "blog" -o urls.txt
```

### Crawl Site

```bash
firecrawl crawl https://example.com --limit 50 --wait --progress
firecrawl crawl https://example.com --max-depth 2 --wait -o results.json
```

### Check Credits

```bash
firecrawl credit-usage
```

## MCP Tools (After Antigravity Restart)

| Tool                     | Purpose                           |
| ------------------------ | --------------------------------- |
| `firecrawl_scrape`       | Single page with advanced options |
| `firecrawl_batch_scrape` | Multiple URLs at once             |
| `firecrawl_map`          | Discover all URLs on site         |
| `firecrawl_search`       | Search web by topic               |
| `firecrawl_crawl`        | Crawl entire site sections        |
| `firecrawl_extract`      | Structured data extraction        |

## Common Patterns

### Research Workflow

```bash
# 1. Search
firecrawl search "topic" --limit 10 -o search.json

# 2. Extract URLs
jq -r '.data.web[].url' search.json > urls.txt

# 3. Scrape all
cat urls.txt | while read url; do
  firecrawl "$url" --only-main-content -o "content/$(basename $url).md"
done
```

### Documentation Extraction

```bash
# 1. Map docs site
firecrawl map https://docs.example.com -o urls.txt

# 2. Scrape all pages
cat urls.txt | while read url; do
  firecrawl "$url" --only-main-content -o "docs/$(basename $url).md"
done
```

## Useful Flags

| Flag                  | Purpose                         |
| --------------------- | ------------------------------- |
| `--only-main-content` | Remove nav/footer (recommended) |
| `--wait-for 3000`     | Wait for JS rendering (3s)      |
| `--limit 50`          | Limit results/pages             |
| `--pretty`            | Pretty print JSON               |
| `-o file.md`          | Save to file                    |
| `--json`              | Force JSON output               |

## Credits

- **Current**: 900 remaining
- **Check**: `firecrawl credit-usage`
- **Shared**: CLI and MCP use same pool

## Documentation

- **Full CLI Guide**: `c:\Projects\agentic-toolkit\skills\firecrawl-cli\SKILL.md`
- **MCP Recommendations**: `c:\Projects\agentic-toolkit\docs\MCP_RECOMMENDATIONS.md`
- **Installation Summary**: `c:\Projects\agentic-toolkit\docs\FIRECRAWL_INSTALLATION.md`
