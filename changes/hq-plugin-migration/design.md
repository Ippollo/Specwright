# Design: HQ → Plugins Migration

## Technical Approach

Two layers end-state (plugins + KB), reached in four phases. The design's spine is the
**KB access contract** (Option A) — a per-plugin config that every skill reads paths from,
generalized from `cortex/config.md` and shaped so the future KB MCP (Option B) can replace it
without touching skills.

### The KB Access Contract (Option A)

A per-plugin `config.md` (or `config.json`) carrying:

```
vault_root:      c:\HQ\KB          # the one machine-specific value
vault_name:      KB
folders:         { inbox: 00_Inbox, projects: 10_Projects, journal: 20_Journal,
                   ideas: 30_Ideas, knowledge: 40_Knowledge, finance: 50_Finance,
                   system: 99_System }
read_only:       [ 20_Journal, 50_Finance ]   # skills MUST refuse writes here
access_method:   filesystem        # future value: "kb-mcp"
```

Skills reference **logical locations** (`{knowledge}/jobs/pipeline`) resolved through config,
never absolute literals. This is the seam: swapping `access_method: kb-mcp` later re-points every
plugin at the MCP with zero skill edits, and moves read-only enforcement from convention to code.

### Phase-1 Repoint Mechanic (the critical path)

Because of the two-copy architecture (`research.md`), each repoint is a **three-step atom**:

1. Edit the canonical `<toolkit>/workflows/<name>.md` to read the KB path (via config).
2. `pwsh -File .\.claude\build-skills.ps1` to regenerate `.claude/skills/`.
3. Verify the live skill (`/daily` etc.) reads the new location.

Never hand-edit `.claude/skills/`. Move the *data file* and repoint *all* its readers within the
same task, then rebuild once at the end of the task.

### Phase-2 Pluginization Shape (hq-cortex reference)

```
hq-cortex/
  .claude-plugin/plugin.json     # name, version, description, author
  commands/                      # 9 cx-*.md  (was workflows/, explicit slash)
  skills/
    obsidian-conventions/SKILL.md
    pkm-methodology/SKILL.md
    cx-search/SKILL.md           # the ONE model-invocable NL entry point
  config.md                      # the KB access contract
  agents/  templates/  scripts/  # carried over as-is
```

`cx-search` appears **both** as a command (`/hq-cortex:cx-search`, explicit) and as a
model-invocable skill (NL "find my notes about X"). Naming: give the skill a distinct `name` to
avoid the command/skill collision (Must-Not) — e.g. skill `name: vault-search` triggering on
search phrasing, command stays `cx-search`.

## Architecture Decisions

### Decision: Option A (config paths) now, MCP-compatible seam

**Choice**: Ship a per-plugin `config.md` contract with logical folder names + read-only list.
**Reasoning**: Fastest to migrate; the logical-location indirection means the parked KB MCP
(Option B) drops in later behind the same interface without re-editing skills.
**Alternatives considered**: (a) Build the KB MCP now — rejected: bigger lift, blocks the
migration on server work, and the read/write contract isn't proven until the folder layout
settles post-move. (b) Leave absolute paths, just relocate the root — rejected: doesn't achieve
independence or shareability; every plugin still machine-bound.

### Decision: Repoint build-skills.ps1 at canonical toolkits (T2.5) — REVISED 2026-07-16

> **Supersedes the original "edit canonical + rebuild" decision, which was based on a false
> premise.** That decision assumed `global_workflows` symlinked to canonical. It doesn't: 29
> entries are symlinks, **31 are copies** (all of specwright), and 5 had drifted. Under the old
> chain, editing canonical and rebuilding would have read the *stale copy* and **silently
> discarded the edit** — invalidating T3–T8, whose targets (`daily`, `weekly`, `work`) are all
> copies.

**Choice**: `build-skills.ps1` now reads the canonical `<toolkit>/workflows/` dirs directly,
removing `global_workflows` from the chain. `global_workflows` itself is left untouched.
**Reasoning**: The symlink registry exists for *Antigravity's* cross-workspace access
(`AGENTS.md` rule 3), not for Claude Code — which merely piggybacked on it as a flat merged dir.
Removing the dependency (a) makes canonical authoritative by construction, (b) eliminates the
drift class at its root rather than patching one instance, (c) needs no Windows symlink
privilege, and (d) pulls Phase-4 decoupling forward at near-zero cost. Leaving `global_workflows`
in place means Antigravity behaves exactly as before — no regression.
**Alternatives considered**: (a) Convert the 31 copies to symlinks — rejected: invests labor in a
layer Phase 4 deletes, and needs dev-mode/admin. (b) Hand-edit canonical *and* the global copy in
each task — rejected: perpetuates the drift bug across 31 files and relies on discipline.
**Consequences**: canonical wins everywhere (Chris consented). Verified outcome — 60/60 skills
regenerated, set identical, 55 byte-identical; 5 corrected: `/daily` gained the dormant June
logic, `deploy`/`discover`/`enhance` dropped refs to 7 deleted skills, `ledger` moved to Obsidian
Bases. Collision policy: domain toolkits precede specwright (the routing fallback), reproducing
the pre-existing `analyze-job → board` resolution, now reported rather than silent.

### Decision: Don't hand-edit generated skills (unchanged)

**Choice**: Never hand-edit `.claude/skills/`; edit canonical and rebuild.
**Reasoning**: `.claude/skills/` is generated and wiped on each build; hand-edits are lost.
**Alternatives considered**: Freeze the build and hand-edit skills — rejected: canonical and
generated would silently diverge, exactly the drift `cowork-operating-layer.md` C2 warns about
(and precisely what just bit `/daily` for two months).

### Decision: `cx-search` dual-surface (command + distinct-named skill)

**Choice**: Ship `cx-search` as an explicit command AND a separately-named model-invocable skill.
**Reasoning**: FR-008 wants NL search; the Must-Not forbids command/skill name collision (skill
would shadow the command). Distinct names give both surfaces without collision.
**Alternatives considered**: Single model-invocable skill named `cx-search` — rejected: collides
with the command name; explicit `/cx-search` muscle-memory would resolve to the skill unpredictably.

### Decision: Full root-context move in Phase 1 (per clarify)

**Choice**: Move all 8 items (incl. `me.md`, house-style) in Phase 1.
**Reasoning**: Owner's call — one migration pass over lazy/staged. Simpler mental model; the
extra churn (me.md has no live reader) is accepted.
**Alternatives considered**: Minimal move (live-readers only) — considered in /clarify, rejected
by Chris in favor of a single pass.

## Data Flow

**Before:** skill → hardcoded `c:\HQ\<toolkit>\file.md` (root-coupled).
**After Phase 1:** skill → `config.vault_root` + logical folder → `KB/<folder>/note.md`.
**After Phase 4:** plugin command → config (or KB MCP) → KB. No root, no router, no build step.

Read-only guard sits in the access layer: any resolve of `20_Journal`/`50_Finance` for a *write*
is refused before the file op.

## File Changes (Phase 1 + hq-cortex; P2/P3 coarse)

- `KB/99_System/` — **new notes**: `now.md`, `decisions.md`, `working-preferences.md`,
  `mistakes.md`, `house-style.md` (AGENTS rules 4–8).
- `KB/40_Knowledge/Personal/me.md`, `KB/40_Knowledge/voice-guide.md`,
  `KB/40_Knowledge/jobs/pipeline.md` + `pipeline-archive.md` — **new**.
- `<toolkit>/workflows/*.md` — **edit** readers (now→daily/weekly/work; pipeline→board set +
  daily + content-status; voice→content set; decisions→archive/weekly/work/cx-inbox;
  working-prefs+mistakes→specwright dev set + weekly).
- `.claude/skills/*` — **regenerated** via `build-skills.ps1` (not hand-edited).
- `AGENTS.md` / `CLAUDE.md` — **edit** shared-context refs (me/now/decisions → KB); full removal
  in Phase 4.
- `cortex/config.md` — **generalize** into the contract; add read-only list + logical folders.
- `cortex/.claude-plugin/plugin.json` — **new**; `cortex/workflows/` → `cortex/commands/`;
  `cortex/skills/cx-search/` — **new** model-invocable skill.
- Old root files (`me.md`, `now.md`, `decisions.md`, `board/pipeline*.md`,
  `specwright/working-preferences.md`, `specwright/mistakes.md`, `content-creator/voice/`) —
  **delete after** readers verified on KB (not before).

## Verification Strategy (per success criterion)

| SC | Method |
|---|---|
| SC-001 | `grep -ri "c:\\HQ\\(now\|me\|decisions)"` over `*/workflows` → 0 live readers; run `/daily`,`/weekly`,`/status` green |
| SC-002 | Attempt a write to `20_Journal`/`50_Finance` via the contract → refused |
| SC-003 | `grep -ri "c:\\HQ" cortex` → 0 |
| SC-004 | Install `hq-cortex`; run `/hq-cortex:cx-search` + the vault-search skill in Code **and** Cowork |
| SC-005 | Checklist file exists under the change folder |
| SC-006 | Install each plugin with siblings absent; commands run |
| SC-007 | Root removed + marketplace install; workflows run |
