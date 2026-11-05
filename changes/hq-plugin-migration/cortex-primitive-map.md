# T1 — cortex Command-vs-Skill Map

**Task:** T1 (Phase 0). Locks how each cortex primitive ports to Claude Code, per spec §4 and
the resolved clarifications (FR-007, FR-008). Grounded in the live inventory (verified
2026-07-16).

## Rule applied

Workflows → **commands** (explicit `/name`, side-effecting procedures). Capabilities →
**skills** (model-invocable knowledge). One NL entry point (`cx-search`) also gets a
model-invocable skill, under a **distinct name** to avoid the command/skill collision Must-Not.

## Commands (9) — `cortex/commands/*.md`, namespaced `/hq-cortex:<name>`

| Command | Source workflow | Explicit-only? | Notes |
|---|---|---|---|
| `cx-capture` | `cortex/workflows/cx-capture.md` | yes | references config.md (keep fields) |
| `cx-connect` | `cx-connect.md` | yes | |
| `cx-file-artifact` | `cx-file-artifact.md` | yes | |
| `cx-harvest` | `cx-harvest.md` | yes | |
| `cx-inbox` | `cx-inbox.md` | yes | references config.md; writes `decisions` (see T6) |
| `cx-map` | `cx-map.md` | yes | |
| `cx-review` | `cx-review.md` | yes | |
| `cx-search` | `cx-search.md` | yes | also mirrored as a skill (below) |
| `cx-synthesize` | `cx-synthesize.md` | yes | |

## Skills (3) — `cortex/skills/<name>/SKILL.md`

| Skill | Source | Model-invocable? | Notes |
|---|---|---|---|
| `obsidian-conventions` | `cortex/skills/obsidian-conventions/` | yes (existing triggers) | capability; no name collision |
| `pkm-methodology` | `cortex/skills/pkm-methodology/` | yes (existing triggers) | capability; no name collision |
| `vault-search` | **new**, wraps `cx-search` logic | yes | the single NL allowlist entry (FR-008); triggers on "find my notes about X", "search my vault". **Distinct name** so it does not shadow the `cx-search` command. |

## Collision check

- Command names: `cx-*` (9). Skill names: `obsidian-conventions`, `pkm-methodology`,
  `vault-search`. **No overlap** → no skill shadows a command. ✓
- The one risk (`cx-search` command vs. a same-named skill) is avoided by naming the skill
  `vault-search`. ✓

## Consequences for later tasks

- **T11** creates `cortex/commands/` (move the 9 workflows) + `cortex/skills/vault-search/`.
- **T6** must confirm whether `cx-inbox` *writes* `decisions.md` (write-repoint) vs. mentions it.
- **T2/T12**: `cx-capture` + `cx-inbox` reference `config.md` — the generalized contract must
  retain the human-readable vault/inbox/daily-folder fields they point at.

**Status: T1 complete.**
