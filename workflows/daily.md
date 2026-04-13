---
description: Run daily work session briefing and surface tasks.
quick_summary: "Read weekly commitments from your focus file, surface energy-appropriate tasks, present a daily briefing."
requires_mcp: []
recommends_mcp: []
---

# /daily - Daily Briefing Workflow

**Goal**: Prepare for the daily work session by surfacing the right tasks at the right energy level, bridging the weekly plan to today's execution.

> **Inspiration**: Cal Newport's [Multiscale Planning](https://calnewport.com/deep-work/) — the daily scale is where strategy becomes action.

## Prerequisites

This workflow reads from artifacts created by `/weekly`:

- **A focus file** (e.g., `now.md`) with a **This Week** table containing up to 5 weekly commitments
- **A project/tasks folder** (e.g., `10_Projects/`) with action notes containing frontmatter (`status`, `priority`, `energy`, `due`)
- **(Optional)** A content calendar or recurring task file for routine items

## When to Use

- At the start of a work session (morning, after lunch, evening)
- Whenever you need to figure out "what should I work on next?"

## Steps

// turbo-all

1. **Read Weekly Plan**:
   - Parse the focus file (`now.md` or equivalent) for the "This Week" table.
   - Note the current commitments and their status.

2. **Scan Tasks for Today**:
   - Cross-reference "This Week" items with action notes in the project folder.
   - Also look for any notes with `due: {today}` or overdue dates, and notes with `status: in-progress`.

3. **Check Recurring Items** (optional):
   - If a content calendar or recurring task file exists, scan for today's scheduled items.

4. **Filter and Group by Energy**:
   - Extract the `energy` frontmatter from the identified tasks.
   - Group the items into:
     - 🔴 **Deep Work** (`energy: high`): Writing, coding, system design, intense focus.
     - 🟢 **Light Work** (`energy: medium` or `energy: low`): Admin, emails, follow-ups, reviews.

5. **Present the Briefing**:
   - Output a concise daily plan to the terminal. Do NOT create or modify any notes.

   ```markdown
   📋 Daily Briefing — [Date]

   🔴 Deep Work
   - [ ] [Task Title] (priority, due)
   - [ ] [Task Title] (priority)

   🟢 Light Work
   - [ ] [Routine/Recurring item]
   - [ ] [Task Title] (overdue)

   📌 This Week's Commitments: X/5 in progress, Y completed
   ```

## Usage

```bash
/daily
```

## Key Principles

- **No New Notes**: This workflow does not create a daily journal note. It is a read-only briefing tool designed to reduce friction and get you straight into execution.
- **Energy Mapping**: Do high-energy work when you have the capacity. Save light work for the slumps.
- **Connection to Cascade**: Today's work should directly reflect the weekly commitments from your focus file.
