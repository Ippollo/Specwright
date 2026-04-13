---
description: Create project plan and priorities for the upcoming week.
quick_summary: "Retro last week, rank tasks from your project folder, cap at 5 commitments, write to your focus file."
requires_mcp: []
recommends_mcp: [sequential-thinking]
---

# /weekly - Weekly Planning Workflow

**Goal**: Bridge the gap between strategic quarterly priorities and daily execution by selecting up to 5 high-impact commitments for the week.

> **Inspiration**: Cal Newport's [Multiscale Planning](https://calnewport.com/deep-work/) — the weekly plan is the engine that connects quarterly strategy to daily execution.

## Prerequisites

This workflow assumes the following exist in your workspace:

- **A focus file** (e.g., `now.md`) with:
  - A **Strategic Priorities** section listing your top 2-3 quarterly goals
  - A **This Week** table for weekly commitments
- **A project/tasks folder** (e.g., `10_Projects/`) containing action notes with frontmatter:
  ```yaml
  type: action
  status: todo | in-progress | done | parked
  priority: p1 | p2 | p3
  energy: high | medium | low
  due: YYYY-MM-DD        # optional
  project: project-name  # optional — for filtering by strategic alignment
  ```
- **Obsidian 1.12+** with CLI enabled (if using vault-based tasks)

## When to Use

- End of the week (Friday afternoon) or start of the week (Monday morning) to set intentions for the upcoming week.

## Steps

// turbo-all

1. **Retrospective**:
   - Read the focus file (`now.md` or equivalent). Find the "This Week" table.
   - For each item, ask the user: "Did this complete, roll over, or get dropped?"
   - Ask: "What blocked you? One adjustment for next week?"
   - Document the retro briefly for the user.

2. **Housekeeping Sweep**:
   - Review what changed this week — commits, new workflows/skills, conversation walkthroughs, structural changes.
   - Surface anything that warrants capture in one of three living documents:
     - **Decision log** (`decisions.md`): Any cross-toolkit architectural choices, tool selections, process changes, or reversals of prior decisions made this week.
     - **Working preferences** (`working-preferences.md`): Any new interaction patterns, conventions, or process preferences that emerged during the week.
     - **Mistakes log** (`mistakes.md`): Any agent errors caught this week that should be documented to prevent recurrence. Also check if existing entries are now resolved and can be pruned.
   - Present findings to the user as a short list: "Here's what I think should be captured." The user approves, edits, or skips.
   - Write approved entries to the appropriate files before proceeding.

3. **Pull Candidates**:
   - Scan the project folder for action notes with `status: todo` or `status: in-progress`.
   - If the focus file has a "Strategic Priorities" section, filter to tasks whose `project:` field maps to one of those priorities.
   - Non-strategic tasks are deprioritized unless they are specifically requested or extremely urgent (`p1` + `due`).

4. **Rank & Cap**:
   - Sort the remaining candidates by:
     1. In-progress from last week (rollovers)
     2. Priority (`p1` > `p2` > `p3`)
     3. Due date (soonest first)
   - Take the top items, capped at **5 commitments**.

5. **Present the Draft Plan**:
   - Show the 5 proposed commitments to the user with their `project`, `priority`, `energy`, and `due` date.
   - Warn the user if they try to exceed 5 commitments.

6. **User Confirmation**:
   - The user approves, swaps, or adds items to the list. Ensure the final list does not exceed 5.

7. **Write Back to Focus File**:
   - Clear the old "This Week" table and replace it with the new accepted commitments in the following format:

   ```markdown
   ## This Week — p0 Actions

   > Week of YYYY-MM-DD. Review every Monday.

   | Action | Target | Status |
   |---|---|---|
   | [Project] Action Title (energy) | Due Date | todo / in-progress |
   ```

## Usage

```bash
/weekly
```

## Key Principles

- **Do Fewer Things**: The hard cap of 5 commitments forces prioritization. This operationalizes Cal Newport's "slow productivity" — do fewer things, do them well.
- **Outcomes over Tasks**: Focus on outcomes that signal "done."
- **Alignment**: Every weekly commitment should trace back to a strategic priority if possible.
- **Retro First**: Start by reviewing what happened last week. Learn before you plan.
