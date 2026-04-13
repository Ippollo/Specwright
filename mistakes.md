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

### 2026-04-13 — Guessing day of week instead of computing it
**What happened**: In a `/consult` board response, repeatedly referred to Monday as "Sunday." The exact timestamp was available in metadata (`2026-04-13T10:31:59-06:00`) but the day of the week was inferred by gut feel rather than calculated. This is a recurring error — not the first time.
**Why it was wrong**: Built an entire daily scheduling recommendation on the wrong day. "Light work today, deep work Monday" was backwards because today WAS Monday. Undermines trust in time-sensitive advice.
**Do instead**: When referencing the day of the week, ALWAYS compute it from the timestamp in `<ADDITIONAL_METADATA>`. Never guess or assume. If you need to name a day (e.g., "today is Monday"), verify it against the date before writing it. Use the `now.md` "Week of" date as a cross-check — if it says "Week of 2026-04-13" that's a Monday start.

### 2026-04-02 — Altimeter model names keyed by display name, not ID
**What happened**: Spent multiple sessions debugging why models appeared as placeholders with grey colors in Altimeter charts. The root cause was that color maps and persistence both key on _display name_ (e.g., "Gemini 3 Flash"), not the raw model ID (e.g., `MODEL_PLACEHOLDER_M18`). When display names changed, historical data broke because the old display names didn't match the new catalog entries.
**Why it was wrong**: Assumed model IDs were used consistently throughout the stack. This led to repeated re-investigation of the same architecture across conversations.
**Do instead**: When modifying `MODEL_CATALOG` entries in `ModelCatalog.ts`, always add old display names to the `legacyMap` in `getModelDisplayName()`. Check `token_history.jsonl` for persisted names that need migration. Refer to the Altimeter KI for the full resolution pipeline.

