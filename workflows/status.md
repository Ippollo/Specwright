---
description: Show the state of an active change — artifacts, task progress, and next action.
quick_summary: "Scan changes/{slug}/ and report what exists, task progress, and what to do next."
requires_mcp: []
recommends_mcp: []
---

# /status - Change Status

**Goal**: Get a quick snapshot of where a change stands without re-reading every artifact.

## When to Use

- Resuming work after a break
- Checking how far along a change is before deciding next steps
- When juggling multiple active changes

## Steps

// turbo-all

1. **Locate change folder(s)**:
   - If a slug is provided, check `changes/{slug}/`.
   - If no slug, scan `changes/` for all active change folders.
   - If no changes exist, report "No active changes" and suggest `/new`.

2. **Scan artifacts** (for each change):
   - Check for existence of each artifact:

   | Artifact | Path                           | Status   |
   | -------- | ------------------------------ | -------- |
   | Proposal | `changes/{slug}/proposal.md`   | ✅ or ❌ |
   | Spec     | `changes/{slug}/specs/spec.md` | ✅ or ❌ |
   | Design   | `changes/{slug}/design.md`     | ✅ or ❌ |
   | Tasks    | `changes/{slug}/tasks.md`      | ✅ or ❌ |
   | Research | `changes/{slug}/research.md`   | ✅ or ❌ |

3. **Parse task progress** (if `tasks.md` exists):
   - Count total tasks: lines matching `- [ ]` or `- [x]`
   - Count completed: lines matching `- [x]`
   - Identify the first incomplete task
   - Calculate percentage complete

4. **Determine next action**:

   | State                        | Suggested Next Action                    |
   | ---------------------------- | ---------------------------------------- |
   | No proposal                  | Fill in `proposal.md`                    |
   | Proposal only                | `/specify` to create specs               |
   | Spec exists, no design/tasks | `/plan` to generate design and tasks     |
   | Tasks exist, 0% complete     | `/work` to start executing               |
   | Tasks partially complete     | `/work` to resume                        |
   | Tasks 100% complete          | `/finish` to commit, deploy, and archive |

5. **Present report**:

```
📋 Status: {slug}

Artifacts:
  ✅ proposal.md
  ✅ specs/spec.md
  ✅ design.md
  ✅ tasks.md

Progress: ██████████░░░░░░ 7/11 tasks (64%)
Next incomplete: 2.3 — /design — Add responsive breakpoints

💡 Suggested: /work to continue execution
```

## Multiple Changes

When no slug is provided and multiple change folders exist, show a compact summary:

```
📋 Active Changes:

  auth-revamp      ██████████████░░ 9/11 (82%)  → /work
  dark-mode        ████░░░░░░░░░░░░ 3/12 (25%)  → /work
  api-rate-limits  ░░░░░░░░░░░░░░░░ spec only    → /plan

💡 Specify a slug for details: /status auth-revamp
```

## Usage

```bash
# Status of a specific change
/status auth-revamp

# Overview of all active changes
/status
```
