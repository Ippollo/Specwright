# MCP Guide

MCP (Model Context Protocol) servers extend the AI assistant's capabilities by connecting to external services and tools. This is the single reference for which servers to enable, which tools to keep on, and how they map to workflows and agents.

> **Last reviewed**: 2026-04-13

---

## Quick Reference

| Server              | Enabled | Primary Use Case                      |
| ------------------- | :-----: | ------------------------------------- |
| context7            |   2/2   | Library API research, framework docs  |
| firebase            |  18/31  | Firebase service integration          |
| gcloud              |   1/1   | Google Cloud infrastructure           |
| github              |  8/26   | Repository context, issues, PRs       |
| playwright          |  10/22  | Browser automation & testing          |
| sequential-thinking |   1/1   | Complex reasoning                     |
| firecrawl-mcp       |  4/12   | Web scraping & extraction             |
| observability       |  6/13   | Cloud monitoring & logging            |
| **Total**           | **50**  |                                       |

### Servers — Off by Default

| Server           | Policy                           |
| ---------------- | -------------------------------- |
| `storage`        | Enable only for file upload work |
| `notebooklm-mcp` | Enable for deep research tasks   |

---

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
- `/serve` → (none)
- `/final-polish` → (none)

### Deployment & Completion

- `/deploy` → `gcloud`, `firebase-mcp-server`, `observability`
- `/security` → (none)
- `/archive` → (none)

### Meta Workflows

- `/coach` → (none — references other workflows' needs)
- `/second-opinion` → `sequential-thinking`
- `/constitution` → (none)

---

## By Agent

| Agent                 | Recommended Servers                                           |
| --------------------- | ------------------------------------------------------------- |
| `project-planner`     | `github`, `sequential-thinking`, `context7`, `firecrawl-mcp`  |
| `backend-architect`   | `firebase-mcp-server`, `context7`                             |
| `frontend-specialist` | `context7`, `playwright`                                      |
| `debugger`            | `github`                                                      |
| `code-custodian`      | `github`, `context7`                                          |
| `qa-engineer`         | `playwright`                                                  |
| `sec-devops-engineer` | `github`, `gcloud`                                            |

---

## Tool Enable/Disable Lists

### context7 — All On (2)

- `resolve-library-id`
- `query-docs`

---

### firebase — 18 of 31

**✅ Enable**

- `firebase_get_project`
- `firebase_list_projects`
- `firebase_get_sdk_config`
- `firebase_validate_security_rules`
- `firebase_get_security_rules`
- `firebase_read_resources`
- `firestore_delete_document`
- `firestore_get_documents`
- `firestore_list_collections`
- `firestore_query_collection`
- `storage_get_object_download_url`
- `auth_get_users`
- `auth_update_user`
- `remoteconfig_get_template`
- `realtimedatabase_get_data`
- `realtimedatabase_set_data`
- `developerknowledge_search_documents`
- `developerknowledge_get_document`

**❌ Disable** (admin/setup/infra — never needed mid-session)

- `firebase_login` / `firebase_logout`
- `firebase_list_apps`
- `firebase_create_project` / `firebase_create_app`
- `firebase_create_android_sha`
- `firebase_get_environment` / `firebase_update_environment`
- `firebase_init`
- `auth_set_sms_region_policy`
- `messaging_send_message`
- `remoteconfig_update_template`
- `developerknowledge_batch_get_documents`

---

### gcloud — All On (1)

- `run_gcloud_command`

---

### github — 8 of 26

**✅ Enable**

- `create_or_update_file`
- `get_file_contents`
- `push_files`
- `create_pull_request`
- `search_code`
- `search_issues`
- `get_issue`
- `get_pull_request`

**❌ Disable** (all other 18 tools)

- `create_repository`, `fork_repository`, `create_branch`
- `search_repositories`, `list_commits`, `list_issues`
- `create_issue`, `update_issue`, `add_issue_comment`
- `search_users`, `create_pull_request_review`, `merge_pull_request`
- `get_pull_request_files`, `get_pull_request_status`
- `update_pull_request_branch`, `get_pull_request_comments`
- `get_pull_request_reviews`, `list_pull_requests`

---

### playwright — 10 of 22

**✅ Enable**

- `browser_navigate`
- `browser_click`
- `browser_snapshot`
- `browser_take_screenshot`
- `browser_type`
- `browser_fill_form`
- `browser_wait_for`
- `browser_select_option`
- `browser_evaluate`
- `browser_console_messages`

**❌ Disable** (all 12 others)

- `browser_hover`, `browser_resize`, `browser_press_key`
- `browser_network_requests`, `browser_navigate_back`
- `browser_run_code`, `browser_handle_dialog`
- `browser_file_upload`, `browser_install`
- `browser_drag`, `browser_tabs`, `browser_close`

---

### sequential-thinking — All On (1)

- `sequentialthinking`

---

### firecrawl-mcp — 4 of 12

**✅ Enable**

- `firecrawl_scrape`
- `firecrawl_map`
- `firecrawl_search`
- `firecrawl_extract`

**❌ Disable** (crawl jobs, async agent, and CDP browser sessions)

- `firecrawl_crawl`, `firecrawl_check_crawl_status`
- `firecrawl_agent`, `firecrawl_agent_status`
- `firecrawl_browser_create`, `firecrawl_browser_execute`
- `firecrawl_browser_delete`, `firecrawl_browser_list`

---

### observability — 6 of 13

**✅ Enable**

- `list_log_entries`
- `list_log_names`
- `list_time_series`
- `list_alerts`
- `list_traces`
- `get_trace`

**❌ Disable** (admin/infrastructure/rarely-needed)

- `list_buckets`, `list_views`, `list_sinks`
- `list_log_scopes`, `list_metric_descriptors`
- `list_alert_policies`, `list_group_stats`

---

## When to Temporarily Enable

| Tool / Server                                      | Enable When                              |
| -------------------------------------------------- | ---------------------------------------- |
| `storage` (server)                                 | Working on file upload features          |
| `firecrawl_crawl` + `firecrawl_check_crawl_status` | Scraping entire multi-page doc sites     |
| `firecrawl_agent` + `firecrawl_agent_status`       | JS-heavy SPAs that `scrape` can't handle |
| `browser_file_upload`                              | Testing file upload E2E flows            |
| `browser_resize`                                   | Responsiveness debugging sessions        |
| `browser_network_requests`                         | Debugging API call sequences             |
| `list_group_stats`                                 | Investigating recurring error patterns   |
| `merge_pull_request`                               | Never — always merge in the browser      |

---

## Installation

### Core Servers

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

## Configuration Tips

### Minimal Setup (70% of use cases)

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

### Frontmatter Format

Every workflow and agent includes:

```yaml
---
description: ...
requires_mcp: [] # Hard requirements (currently none)
recommends_mcp: [...] # Recommended for best experience
---
```
