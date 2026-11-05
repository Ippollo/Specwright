# T2 — KB Access Contract (Option A)

**Task:** T2 (Phase 1 foundation). The per-plugin config contract every plugin reads KB paths
from. Generalized from `cortex/config.md`; shaped so the parked KB MCP (Option B) can replace it
behind the same logical interface with zero skill edits. Resolves FR-004; enables FR-005.

## 1. Purpose

One indirection layer between skills and the vault. Skills reference **logical locations**
(`{system}/now`, `{knowledge}/jobs/pipeline`), never absolute paths. The config resolves logical
→ physical. Swapping `access_method: filesystem` → `kb-mcp` later re-points every plugin at the
MCP without touching a single skill.

## 2. Config schema

Each plugin carries a `config.md` (human-readable; a `config.json` sibling is optional if a
plugin needs to parse it). Canonical fields:

| Field | Meaning | cortex value |
|---|---|---|
| `vault_root` | Absolute path to the vault — the **one** machine-specific value | `c:\HQ\KB` |
| `vault_name` | Vault display name | `KB` |
| `access_method` | `filesystem` now; `kb-mcp` after Option B | `filesystem` |
| `folders.*` | Logical-name → folder-name map (below) | see §3 |
| `read_only` | Folders skills MUST refuse to write | `[20_Journal, 50_Finance]` |

## 3. Logical folder map (the vault taxonomy)

| Logical name | Folder | Writable? |
|---|---|---|
| `inbox` | `00_Inbox` | yes |
| `projects` | `10_Projects` | yes |
| `journal` | `20_Journal` | **NO (read-only)** |
| `ideas` | `30_Ideas` | yes |
| `knowledge` | `40_Knowledge` | yes |
| `finance` | `50_Finance` | **NO (read-only)** |
| `system` | `99_System` | yes |

Sub-locations use `/`: `{knowledge}/jobs` → `40_Knowledge/jobs`, `{knowledge}/Personal` →
`40_Knowledge/Personal`.

## 4. Logical locations for the migrated root context (from FR-001)

| Logical location | Physical | Was |
|---|---|---|
| `{system}/now` | `KB/99_System/now.md` | root `now.md` |
| `{system}/decisions` | `KB/99_System/decisions.md` | root `decisions.md` |
| `{system}/working-preferences` | `KB/99_System/working-preferences.md` | `specwright/working-preferences.md` |
| `{system}/mistakes` | `KB/99_System/mistakes.md` | `specwright/mistakes.md` |
| `{system}/house-style` | `KB/99_System/house-style.md` | *new* (AGENTS rules 4–8) |
| `{knowledge}/Personal/me` | `KB/40_Knowledge/Personal/me.md` | root `me.md` |
| `{knowledge}/voice-guide` | `KB/40_Knowledge/voice-guide.md` | `content-creator/voice/voice-guide.md` |
| `{knowledge}/jobs/pipeline` | `KB/40_Knowledge/jobs/pipeline.md` | `board/pipeline.md` |
| `{knowledge}/jobs/pipeline-archive` | `KB/40_Knowledge/jobs/pipeline-archive.md` | `board/pipeline-archive.md` |

## 5. Protected-zone enforcement (FR-005)

> **Corrected 2026-07-16.** This section originally said "any write MUST refuse." That came from
> the migration spec's absolute phrasing (§2/§7) and was **stricter than the actual operating
> rule**. `vault-manual.md:25` and `CLAUDE.md` both say: *"AI must NEVER modify files in these
> directories **without explicit user instruction**."* Chris confirmed the explicit-instruction
> rule. The absolute reading would have made `cx-inbox`'s `meeting → 20_Journal` routing illegal.

**The rule — confirm-then-write, never silent:**

1. **Reads are always allowed** from any zone.
2. **Writes to a `read_only` zone are forbidden by default.** A skill MUST NOT write to
   `20_Journal` or `50_Finance` on its own initiative.
3. **The only escape hatch is explicit user instruction.** A write may proceed when the user has
   been shown the destination and has approved it (or directly instructed it).
4. **Read-only destinations MUST be surfaced distinctly.** When a skill presents proposed actions
   for approval, any action targeting a `read_only` zone must be visibly marked (e.g. `🔒`) so it
   cannot be rubber-stamped inside a batch. Silent inclusion defeats the rule.
5. **No blanket pre-approval.** Approval is per-operation and per-session; it does not carry to
   later writes.

**Compliance status of existing skills:**

| Skill | Behavior | Verdict |
|---|---|---|
| `cx-inbox` | Routes `tags:[meeting]` → `20_Journal`, but only via a batch table with a Destination column + explicit approval (steps 4–6; "User always decides") | **Compliant** — now also marks the destination `🔒` per rule 4 |
| cortex `Daily Notes Folder: 20_Journal` | Daily-note creation is user-invoked | Compliant under rule 3; revisit if any automation ever writes there unprompted |

**Limitation acknowledged:** under Option A this is convention, enforced per-skill. Code-level
enforcement is exactly why Option B (KB MCP) exists — it moves the guarantee into the driver,
where rule 2 can be mechanical and rule 3 an explicit tool parameter. Logged in
`KB/10_Projects/KB MCP - database driver for HQ plugins.md`.

## 6. Forward-compatibility with the KB MCP (Option B)

The logical operations map 1:1 onto the future MCP tools, so skills written against the contract
need no change when the driver arrives:

| Contract (filesystem) | Option B (kb-mcp) |
|---|---|
| resolve `{folder}/note` + read file | `read_note` |
| grep under `vault_root` | `search_notes` |
| resolve + write file (non-`read_only`) | `write_note` |
| list a logical folder | `list_folder` |

## 7. Backward-compatibility note

`cortex/config.md`'s existing human-readable fields (Vault Path, Inbox Folder, Daily Notes
Folder) are **retained** — the live `cx-capture` and `cx-inbox` skills reference them. The
generalized structure is *added*, not swapped.

**Status: T2 complete** (contract defined; `cortex/config.md` generalized as the first instance).
