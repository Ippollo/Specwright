# Recommended MCP Settings

This document defines the **always-on** MCP tool configuration for the agentic toolkit.
Keep exactly these 50 tools enabled to cover all workflows without manual toggling.

> **Last reviewed**: 2026-02-23 — based on analysis of all 23 workflows and 7 agents.

---

## Summary

| Server                | Tools Enabled | Notes                                 |
| --------------------- | :-----------: | ------------------------------------- |
| `context7`            |     2 / 2     | All tools on                          |
| `firebase`            |    18 / 31    | 13 admin/setup tools disabled         |
| `gcloud`              |     1 / 1     | Single tool; always on                |
| `github`              |    8 / 26     | 18 tools disabled                     |
| `playwright`          |    10 / 22    | 12 tools disabled                     |
| `sequential-thinking` |     1 / 1     | All tools on                          |
| `firecrawl-mcp`       |    4 / 12     | 8 tools disabled                      |
| `observability`       |    6 / 13     | 7 admin/infrastructure tools disabled |
| **Total**             |    **50**     |                                       |

### Servers — Off by Default

| Server           | Policy                           |
| ---------------- | -------------------------------- |
| `storage`        | Enable only for file upload work |
| `notebooklm-mcp` | Not referenced by any workflow   |

---

## Tool Lists

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

**❌ Disable** (all other 18 tools — create/fork/branch/merge operations and PR social layer)

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
