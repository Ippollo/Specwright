# Research: HQ → Plugins Migration

## Prior-Art Check (per /plan step 3)

| Source | Finding | Incorporated as |
|---|---|---|
| `KB/10_Projects/KB MCP - database driver for HQ plugins.md` | Option B (KB MCP) is logged, parked (p3), un-park trigger = "plugins stable on Option A + confident KB contract". | Confirms Option A now; design treats the config contract as the forward-compatible seam the future MCP slots into. |
| `cortex/config.md` | Existing vault-path externalization (path, name, inbox/daily folders, access method, read-only note). | The schema to **generalize** into the per-plugin config contract (FR-004). |
| `create-cowork-plugin`, `cowork-plugin-customizer` skills | Anthropic-provided skills for scaffolding a plugin and de-personalizing one before sharing. | Reuse `create-cowork-plugin` patterns for `plugin.json`; `cowork-plugin-customizer` is the Phase-4 sharing path, not needed for personal install. |
| `.claude/build-skills.ps1` | Generates `.claude/skills/*/SKILL.md` from `~/.gemini/.../global_workflows/` (symlinks → toolkit `workflows/*.md`). | **Two-copy architecture** (below) — the central mechanical constraint of Phase 1. |
| `me.md` reader grep | **Zero** skill readers. Only referenced by `AGENTS.md`/`CLAUDE.md` shared-context auto-load. | me.md move is low-risk; repoint = the retiring router only. |

## Key Discovery: the Generation Chain Was Broken (CORRECTED 2026-07-16)

> **This section originally claimed `global_workflows` entries were symlinks to canonical files.
> That was WRONG and was disproved at T3 kickoff. Corrected below; the fix is T2.5.**

**What was actually true:**

```
<toolkit>/workflows/<name>.md              ← canonical source
        │
        ├── 29 entries: SYMLINKED into global_workflows  (board, content-creator, cortex)
        └── 31 entries: COPIED into global_workflows     (ALL of specwright) ← drift risk
                │
~/.gemini/antigravity-ide/global_workflows/<name>.md
                │  (build-skills.ps1 read from HERE)
.claude/skills/<name>/SKILL.md              ← GENERATED
```

specwright was never registered per `AGENTS.md` rule 3 — its workflows were **copied**, not
symlinked. Those copies drifted. **5 workflows were provably stale**: `daily`, `enhance`,
`deploy`, `discover`, `ledger`. Consequences found in the live system:

- **`/daily` ran Apr-22 logic** — a Jun-16 canonical update (conditional pipeline filtering,
  "trust `status: done`", alternate pipeline display) had **never executed**.
- **`deploy`/`discover`/`enhance` referenced 7 deleted skills** (`backend-performance`,
  `deployment-pipeline`, `data-modeling`, `react-best-practices`, `vue-svelte-patterns`,
  `api-design-patterns`, `unit-testing-strategy`) — canonical had pruned them; the stale copies
  still pointed at nonexistent files.
- **`ledger`** still referenced `50_Finance/accounts/` instead of the newer Obsidian Bases.

**Resolution (T2.5, decided by Chris):** repoint `build-skills.ps1` to read the canonical
`<toolkit>/workflows/` dirs **directly**, deleting the middle layer from the chain:

```
<toolkit>/workflows/<name>.md  →  build-skills.ps1  →  .claude/skills/<name>/SKILL.md
```

`global_workflows` is left untouched (it serves Antigravity's cross-workspace access, not Claude
Code), so Antigravity is unaffected. Rejected alternatives: repairing the 31 symlinks (invests in
a layer Phase 4 deletes; needs Windows privilege) and hand-editing both copies (perpetuates drift).

**Now true — the repoint mechanic for Phase 1:** edit the canonical `<toolkit>/workflows/*.md`,
re-run `build-skills.ps1`, verify. Hand-editing `.claude/skills/` is still overwritten on rebuild.
Canonical is now authoritative **by construction**.

**Two layouts exist** and the script handles both:
- `<toolkit>/workflows/<name>.md` (flat — 59 workflows)
- `<toolkit>/workflows/<name>/<name>.md` (directory-style — only `challenge`, with an adjacent
  `lenses/` resource dir)

**Implication for Phase 2+:** pluginization *replaces* this pipeline — a plugin ships its
`commands/` directly, no build step. `hq-cortex` is the first toolkit to break free; the script
keeps generating the *other* toolkits until each is pluginized, then dies in Phase 4 (T16).

## Reader Surface (verified via grep, 2026-07-16)

| Moved file | Real readers (canonical workflow files) | Notes |
|---|---|---|
| `now.md` | `daily`, `weekly`, `work` (specwright) | 3 readers, clean. |
| `board/pipeline.md` | `daily`, `job-status`, `analyze-job`, `career-chat`, `consult`, `generate-resume` (board) + `content-status` | The specwright `/backend,/design,/test…` hits are the **dev-"pipeline"** word, NOT `board/pipeline.md` — exclude them. |
| `voice-guide.md` | `atomize`, `review-content`, `scout`, `write-article`, `write-case-study` (content-creator) | 5 readers, all content. |
| `decisions.md` | `archive`, `weekly`, `work` + `cx-inbox` | `cx-inbox` reference is cortex — verify it's a real read vs. mention. |
| `working-preferences.md` / `mistakes.md` | The specwright pipeline set (`backend,debug,design,enhance,finish,plan,review,security,test,work`) + `weekly` | Broad — these two are read by nearly every dev workflow as house rules. |
| `me.md` | none (skills) | Only `AGENTS.md`/`CLAUDE.md`. |

## Open Technical Questions (resolved or deferred)

- **Manifest key names/casing, collision rule** — documented in spec §8 from knowledge; verified
  empirically at first `hq-cortex` install-test (spec FR-015). Not a planning blocker.
- **`cx-inbox` → decisions.md** — confirm at repoint time whether it *writes* decisions or merely
  references it; affects whether it's a read-repoint or a write-repoint.
- **Symlink layer during transition** — since Phase 1 keeps `build-skills.ps1` alive, the
  `global_workflows` symlinks must keep resolving after canonical files are edited (they will —
  edits are in-place, not moves).

## Constraints Carried Into Design

1. Move + repoint in lockstep; never a move without its readers.
2. Edit canonical `workflows/*.md`, then rebuild — never hand-edit generated skills in Phase 1.
3. Read-only zones (`20_Journal`, `50_Finance`) enforced by the config contract (convention now,
   code later via the parked MCP).
4. Config contract must be forward-compatible with the future KB MCP (same logical operations:
   read/search/write/list).
