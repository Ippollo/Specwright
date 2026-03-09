---
description: Analyze toolkit usage telemetry — frequency, patterns, dead workflows, project distribution.
quick_summary: "Read telemetry/usage.jsonl and report which workflows and skills are used, how often, and where."
requires_mcp: []
recommends_mcp: []
---

# /stats - Toolkit Telemetry

**Goal**: Analyze Specwright usage data to surface insights about workflow adoption, skill usage, and productivity patterns.

## Data Source

Telemetry is logged automatically to `c:\Projects\specwright\telemetry\usage.jsonl`. Each line is a JSON object:

```json
{
  "ts": "2026-03-09T11:50:00-06:00",
  "workflow": "/work",
  "project": "job-hunter",
  "skill": null,
  "cwd": "c:\\Projects\\job-hunter"
}
```

| Field      | Description                                        |
| ---------- | -------------------------------------------------- |
| `ts`       | ISO 8601 timestamp of invocation                   |
| `workflow` | The slash command invoked (e.g., `/work`, `/plan`) |
| `project`  | Project name (derived from working directory)      |
| `skill`    | Skill loaded during the workflow, if any           |
| `cwd`      | Working directory at time of invocation            |

## Steps

// turbo-all

1. **Read the log**: Load `c:\Projects\specwright\telemetry\usage.jsonl`. If the file doesn't exist or is empty, report "No telemetry data yet" and suggest running some workflows first.

2. **Apply filters** (if provided):
   - `--project <name>`: Filter to a specific project
   - `--days <N>`: Only include the last N days (default: all data)
   - `--workflow <name>`: Filter to a specific workflow

3. **Generate report** with these sections:

### 3a. Usage Overview

```
📊 Toolkit Telemetry (last 30 days)
   Total invocations: 142
   Active projects: 4
   Date range: 2026-02-07 → 2026-03-09
```

### 3b. Workflow Frequency

Rank workflows by invocation count, with a simple bar chart:

```
🔧 Workflow Usage:
   /work      ████████████████████ 38
   /plan      ████████████████     32
   /debug     ████████████         24
   /build     ██████████           20
   /review    ████████             16
   /commit    ██████               12
   /status    ██                    4
```

### 3c. Dead Workflow Detection

List any workflows that exist in the toolkit but have **zero** invocations in the reporting period. Flag workflows unused for 30+ days.

```
⚠️ Unused Workflows (30+ days):
   /brainstorm    — last used 45 days ago
   /security      — never used
   /second-opinion — never used
```

### 3d. Project Distribution

```
📁 By Project:
   job-hunter   ████████████████████ 58 (41%)
   heirloom     ████████████████     45 (32%)
   specwright   ██████████           28 (20%)
   cortex       ████                 11 (8%)
```

### 3e. Skill Usage

If any log entries include a `skill` field, rank skills by usage:

```
🧠 Skills Loaded:
   code-quality-sentinel    12
   frontend-design           8
   security-hardening        5
   data-modeling             3
```

### 3f. Workflow Chains

Identify sequences of workflows invoked within a 2-hour window on the same project. Report the most common chains:

```
🔗 Common Chains:
   /plan → /work → /review              (8 times)
   /build (full pipeline)                (6 times)
   /debug → /work                        (4 times)
   /specify → /plan                      (3 times)
```

### 3g. Time Patterns (optional, if enough data)

Show usage by day of week and rough time-of-day buckets:

```
📅 By Day:
   Mon ████████  Tu ██████████  Wed ████████████
   Thu ██████    Fri ████████   Sat ██  Sun █

⏰ By Time:
   Morning (6-12)    ████████████████ 45
   Afternoon (12-18) ████████████████████ 62
   Evening (18-24)   ██████████ 28
   Night (0-6)       ████ 7
```

## Usage

```bash
# Full report
/stats

# Last 7 days only
/stats --days 7

# Filter to a specific project
/stats --project job-hunter

# Filter to a specific workflow
/stats --workflow /debug
```

## Notes

- Telemetry is local-only. The `usage.jsonl` file is gitignored and never leaves your machine.
- Log entries are appended by a global rule in the Antigravity user_global memory block.
- If the log gets large, you can safely truncate old entries — the file is append-only JSONL.
- This workflow does NOT log its own invocation (to avoid recursive telemetry noise).

## Next Steps

After reviewing stats:

- **Dead workflows** → Consider whether they need better discoverability or should be deprecated
- **Hot workflows** → Candidates for optimization or enhanced skill support
- **Missing skills** → If a workflow is heavily used but has no matching skill, run `/skill` to create one
