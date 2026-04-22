---
description: Run daily work session briefing and refresh Next Actions in now.md.
quick_summary: "Scan pipeline, projects, and weekly commitments. Refresh the Next Actions section in now.md. Present an energy-grouped briefing."
requires_mcp: []
recommends_mcp: []
---

# /daily - Daily Briefing Workflow

**Goal**: Refresh the **Next Actions** section in `now.md` and present a daily briefing, bridging the weekly plan to today's execution.

> **Inspiration**: Cal Newport's [Multiscale Planning](https://calnewport.com/deep-work/) — the daily scale is where strategy becomes action.

## Prerequisites

This workflow reads from multiple sources to build a unified action list:

- **Focus file**: `c:\HQ\now.md` — weekly commitments and the Next Actions section to refresh
- **Projects folder**: `c:\HQ\KB\10_Projects\` — action notes with frontmatter (`status`, `priority`, `energy`, `due`)
- **Income pipeline**: `c:\HQ\board\pipeline.md` — active job opportunities and their next actions
- **(Optional)** Content calendar or recurring task files for routine items

## When to Use

- At the start of a work session (morning, after lunch, evening)
- Whenever you need to figure out "what should I work on next?"

## Steps

// turbo-all

1. **Read Current State**:
   - Parse `now.md` for the existing **Next Actions** section and the **This Week** table.
   - Note which items are already checked off (`[x]`) — these move to **Done Today** or get cleared if from a previous day.

2. **Scan All Sources**:
   - **Pipeline** (`pipeline.md`): Extract concrete next actions from active opportunities (interviews, submissions, follow-ups with dates).
   - **Projects** (`10_Projects/`): Read frontmatter from all action notes. Surface items where `status: in-progress` or `status: waiting` with a `due` date approaching.
   - **Weekly commitments** (`now.md` This Week table): Surface any in-progress items not yet captured in Next Actions.
   - **(Optional)** Content calendar: Check for today's scheduled content actions.

3. **Refresh Next Actions in `now.md`**:
   - **Clear yesterday's Done section** — remove `[x]` items from previous days.
   - **Keep today's `[x]` items** in a `✅ Done Today` subsection.
   - **Add new items** discovered from pipeline, projects, or weekly commitments that aren't already listed.
   - **Remove stale items** — if a pipeline opportunity was closed or a project completed, remove it.
   - **Preserve manually-added items** — if the user added something by hand, don't remove it unless it's clearly done.
   - **Group by energy**:
     - 🔴 **Deep Work** (`energy: high`): Interviews, writing, coding, system design, networking outreach.
     - 🟢 **Light Work** (`energy: medium` or `energy: low`): Admin, scheduling, reviews, follow-ups.
   - **Include dates** — every item should have a date or frequency (today, daily, by [date], [specific date]).

4. **Present the Briefing**:
   - After updating `now.md`, output a concise summary to the conversation:

   ```markdown
   📋 Daily Briefing — [Date]

   🔴 Deep Work
   - [ ] [Task] (by [date])
   - [ ] [Task] (daily)

   🟢 Light Work
   - [ ] [Task] (today)
   - [ ] [Task] (by [date])

   📌 This Week: X/Y commitments complete
   📊 Pipeline: X interviewing, Y applied, Z awaiting response
   ```

5. **Run `/comment`**:
   - After the briefing, automatically execute the `/comment` workflow.
   - This surfaces today's LinkedIn first-comment (if a post is scheduled for today) so it's ready to paste immediately when the post goes live.
   - If no post is scheduled today, display: "No post scheduled for today — no first-comment needed."
   - Append the `/comment` output to the briefing, separated by a divider.

## Next Actions Format

The Next Actions section in `now.md` follows this structure:

```markdown
## Next Actions

<!-- Concrete, do-able tasks. Maintained by /daily. Add items anytime; /daily refreshes from pipeline, projects, and weekly commitments. -->

### 🔴 Deep Work
- [ ] Verb-first task description (by [date] or [frequency])

### 🟢 Light Work
- [ ] Verb-first task description (by [date] or [frequency])

### ✅ Done Today
- [x] Completed item
```

## Usage

```bash
/daily
```

## Key Principles

- **Persistent, not ephemeral**: The Next Actions section in `now.md` is the lasting artifact. The briefing output is just a summary of what changed.
- **Single source of truth**: If it's not in Next Actions, it's not on today's radar. All sources funnel into one list.
- **Energy mapping**: Tag items so the user can scan for what fits their current energy level.
- **Low maintenance**: The user can add items to Next Actions anytime (just ask). `/daily` handles the refresh, cleanup, and discovery of new items from pipeline/projects.
- **Connection to cascade**: Today's work should directly reflect the weekly commitments from the focus file.
