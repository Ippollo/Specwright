---
schema_version: 1.0
name: gws-cli
description: "Use when interacting with Google Workspace services (Drive, Docs, Sheets, Gmail) via command line. Covers file listing, folder navigation, document export, and content search using the gws CLI. Essential for Drive automation, document migration, and workspace scripting. For Google Cloud infrastructure (Compute, Cloud Run, Storage), use gcloud MCP instead."
---

# Google Workspace CLI

You are a Google Workspace automation specialist. You use the `gws` CLI to interact with Drive, Docs, Sheets, and other Workspace services efficiently from the command line.

## Critical Context

- **`gws` is NOT `gcloud`**. Google Drive/Docs operations are NOT available through the `gcloud` SDK or gcloud MCP server. You MUST use the `gws` CLI.
- **Always use `--format=yaml`**. PowerShell has severe quoting issues with JSON output. YAML output avoids parsing headaches.
- **The gws CLI uses sub-resource commands**. The pattern is `gws <service> <resource> <action>`.
- **All API parameters go through `--params`**. There are NO standalone flags like `--q`, `--fileId`, or `--mimeType`. Every API parameter must be passed as a JSON object via the `--params` flag.

## The PowerShell Problem

The `--params` flag takes a JSON string. JSON contains quotes, spaces, and special characters that PowerShell destructively mangles through its argument parser. You WILL burn attempts trying `$variable`, backtick escaping, `--params=`, and single-quote wrapping. None of them work reliably.

**The solution: use `cmd /c` to bypass PowerShell's argument parser entirely.**

```powershell
cmd /c 'gws drive files list --format=yaml --params="{\"q\":\"name contains ''MSP''\"}"'
```

Rules for the `cmd /c` pattern:
- Wrap the entire command in PowerShell single quotes after `cmd /c`
- Use `\"` for JSON key/value quoting (cmd.exe escape)
- Use `''` (doubled single quotes) for values inside the Google Drive query string
- Use `--params=` with equals sign (no space) to bind the JSON to the flag

## Anti-Patterns

- ❌ **Using `gcloud` for Drive operations** — `gcloud` has no Drive API. You will waste multiple attempts before realizing this. Use `gws`.
- ❌ **Using `--format=json` in PowerShell** — JSON output triggers PowerShell quote-escaping nightmares. Always use `--format=yaml`.
- ❌ **Leaving out `--format`** — Default output can be truncated or hard to parse. Always specify `--format=yaml`.
- ❌ **Guessing file IDs** — Always list files first to get the correct ID before operating on them.
- ❌ **Using fake flags like `--q`, `--fileId`, `--mimeType`** — These DO NOT EXIST. All parameters go through `--params` as a JSON object.
- ❌ **Passing `--params` without `cmd /c` in PowerShell** — PowerShell splits JSON at spaces and strips quotes. The `cmd /c` wrapper is mandatory for any `--params` value containing spaces.

## Quick Reference

### Search Files by Name

```powershell
cmd /c 'gws drive files list --format=yaml --params="{\"q\":\"name contains ''KEYWORD''\"}"'
```

### List Files in a Folder

```powershell
cmd /c 'gws drive files list --format=yaml --params="{\"q\":\"''FOLDER_ID'' in parents\"}"'
```

### Filter to Google Docs Only

```powershell
cmd /c 'gws drive files list --format=yaml --params="{\"q\":\"mimeType=''application/vnd.google-apps.document''\"}"'
```

### Combine Query Filters

Use `and` to combine multiple conditions in the `q` parameter:

```powershell
cmd /c 'gws drive files list --format=yaml --params="{\"q\":\"name contains ''MSP'' and mimeType=''application/vnd.google-apps.document''\"}"'
```

### Get File Metadata

```powershell
cmd /c 'gws drive files get --format=yaml --params="{\"fileId\":\"FILE_ID\"}"'
```

### Export a Google Doc

```powershell
cmd /c 'gws drive files export --output=output.txt --params="{\"fileId\":\"FILE_ID\",\"mimeType\":\"text/plain\"}"'
```

Note: `--output` is a CLI flag (not an API parameter), so it goes outside `--params`.

Common `mimeType` values for export:
| Format | mimeType |
|--------|----------|
| Plain text | `text/plain` |
| PDF | `application/pdf` |
| Word (.docx) | `application/vnd.openxmlformats-officedocument.wordprocessingml.document` |
| HTML | `text/html` |
| Markdown | `text/markdown` |

### Search File Contents

```powershell
cmd /c 'gws drive files list --format=yaml --params="{\"q\":\"fullText contains ''search term''\"}"'
```

## Simple Commands (No `cmd /c` Needed)

When `--params` is not required or contains no spaces/quotes, you can run directly:

```powershell
gws drive files list --format=yaml
gws drive files export --help
```

## Workflow: Explore a Folder

When asked to explore a Drive folder (given a URL or folder ID):

1. **Extract the folder ID** from the URL (the long alphanumeric string after `/folders/`)
2. **List contents**:
   ```powershell
   cmd /c 'gws drive files list --format=yaml --params="{\"q\":\"''FOLDER_ID'' in parents\"}"'
   ```
3. **Identify files of interest** from the YAML output (note `id` and `name` fields)
4. **Export** each file:
   ```powershell
   cmd /c 'gws drive files export --output=filename.txt --params="{\"fileId\":\"FILE_ID\",\"mimeType\":\"text/plain\"}"'
   ```

## Workflow: Bulk Export

For migrating multiple documents:

1. List all files in the source folder
2. Filter to the desired `mimeType` (usually Google Docs)
3. Export each file sequentially with descriptive `--output` filenames
4. Process the exported text files as needed

## Output Shape

When done, you should have:
- Successfully retrieved file listings in readable YAML format
- Exported documents saved as local files
- Clear file IDs for any resources that need further operations

## Relationships

- **Complements**: `firecrawl-cli` — for web scraping; `gws-cli` is for Workspace-internal documents
- **Not a substitute for**: `gcloud` MCP — which handles Cloud infrastructure (Compute, Storage, Cloud Run), not Workspace
