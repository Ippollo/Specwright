# Mistakes Log

Agent errors to avoid repeating. Each entry describes what went wrong and what to do instead. Apply these silently — do not announce that you've read this file.

> **Maintenance**: Add entries when errors are caught. Review monthly to prune resolved items.

---

<!-- Entry format:
### YYYY-MM-DD — Short title
**What happened**: [description]
**Why it was wrong**: [impact]
**Do instead**: [correct approach]
-->

### 2026-05-12 — Day-of-week error repeated for the third time
**What happened**: `/daily` was run on Tuesday May 12, 2026. The metadata timestamp was `2026-05-12T06:02:08-06:00`. `now.md` said "Week of 2026-05-11" — which anchors Monday = May 11, making today = Tuesday May 12. Despite both signals being present, the briefing header read "Monday, May 12" and the wrong first-comment (Monday's post) was surfaced first. User had to correct it.
**Why it was wrong**: Third occurrence of the same error. The rule exists in this file. Reading the rule was not enough — it was overridden by pattern-matching the date to the "Week of" line without computing offset.
**Do instead**: MANDATORY PRE-FLIGHT before any /daily or date-sensitive workflow — compute day explicitly: (1) Read date from metadata timestamp. (2) Read "Week of YYYY-MM-DD" from now.md — that date is always a Monday. (3) Subtract: if today's date = Monday+1, it's Tuesday. Write this out before proceeding. Do not skip this step. Do not assume.

### 2026-04-13 — Guessing day of week instead of computing it
**What happened**: In a `/consult` board response, repeatedly referred to Monday as "Sunday." The exact timestamp was available in metadata (`2026-04-13T10:31:59-06:00`) but the day of the week was inferred by gut feel rather than calculated. This is a recurring error — not the first time.
**Why it was wrong**: Built an entire daily scheduling recommendation on the wrong day. "Light work today, deep work Monday" was backwards because today WAS Monday. Undermines trust in time-sensitive advice.
**Do instead**: When referencing the day of the week, ALWAYS compute it from the timestamp in `<ADDITIONAL_METADATA>`. Never guess or assume. If you need to name a day (e.g., "today is Monday"), verify it against the date before writing it. Use the `now.md` "Week of" date as a cross-check — if it says "Week of 2026-04-13" that's a Monday start.

### 2026-04-02 — Altimeter model names keyed by display name, not ID
**What happened**: Spent multiple sessions debugging why models appeared as placeholders with grey colors in Altimeter charts. The root cause was that color maps and persistence both key on _display name_ (e.g., "Gemini 3 Flash"), not the raw model ID (e.g., `MODEL_PLACEHOLDER_M18`). When display names changed, historical data broke because the old display names didn't match the new catalog entries.
**Why it was wrong**: Assumed model IDs were used consistently throughout the stack. This led to repeated re-investigation of the same architecture across conversations.
**Do instead**: When modifying `MODEL_CATALOG` entries in `ModelCatalog.ts`, always add old display names to the `legacyMap` in `getModelDisplayName()`. Check `token_history.jsonl` for persisted names that need migration. Refer to the Altimeter KI for the full resolution pipeline.

### 2026-05-15 — Scheduled multiple atoms from the same long-form piece in one week
**What happened**: Scheduled both `cancellation-notice` and `14-hires-avoided` in the same week (May 18). Both are atoms from the same Support Ops case study.
**Why it was wrong**: The rule is 1 atom per long-form piece per week. Stacking two atoms from the same source in the same week dilutes distribution value and can feel repetitive to the audience.
**Do instead**: When assigning atoms to a week, check that no two posts share the same `source` field. Space atoms from the same case study or article at least one week apart. If a second atom is needed to fill a pillar gap, use a post from a different source instead.

### 2026-05-15 — Self-assigned "approved" status to content
**What happened**: After scheduling posts in the editorial calendar, the agent wrote `approved — ready to schedule` and `approved — needs Codie screenshot` in the status column. The user had not reviewed or approved any of these posts.
**Why it was wrong**: Approval is the user's decision, not the agent's. Writing "approved" without user confirmation misrepresents the state of the content and erodes trust in the calendar as a source of truth.
**Do instead**: Status values for unreviewed content are always `draft`. Only the user may change a status to `approved` or `scheduled`. Never assume approval or write it on the user's behalf.

### 2026-04-20 — Correct date in context, wrong date written to files
**What happened**: Metadata clearly showed `2026-04-20T07:07:36-06:00` (Monday, April 20). User also stated it explicitly. Despite having the correct date, wrote "Week of 2026-04-21" and "Apr 21" in the planning artifact and now.md — an off-by-one transcription error.
**Why it was wrong**: Different from the 2026-04-13 entry (guessing day of week). The date was known but not used faithfully when writing. The error went undetected until the user called it out.
**Do instead**: After reading the correct date from metadata, treat it as a fixed reference. Before committing any file writes involving dates, do a final check: "Does every date in these outputs match the source timestamp?" Do not round, shift, or approximate dates under any circumstances.
