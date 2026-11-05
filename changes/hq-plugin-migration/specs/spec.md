# Feature Specification: HQ → Plugins Migration

**Created**: 2026-07-16
**Status**: ✅ Complete (T1–T16, 2026-07-18) — see `HANDOFF.md` for remaining owner follow-ups
**Spec Level**: SDD (Spec-Driven Development)

---

## 0. Definition-of-Done amendment — the "two surfaces" requirement (2026-07-16)

The kickoff/DoD said each plugin must be "verified working in both Cowork and Code." Verified at
T13 that **this is not achievable for a filesystem-vault plugin under Option A**: Cowork runs in a
sandboxed Linux VM with no access to the local Windows filesystem, so a plugin whose commands read
`c:\HQ\KB` (like hq-cortex) cannot function there — packaging fixes visibility, not function.

**Amended DoD (Chris-approved 2026-07-16):** each KB-reading plugin is "done" when **verified on
Code**. The **Cowork surface is deferred to Option B (KB MCP)** — the parked project whose entire
purpose (spec §3.3) is to give both surfaces one vault channel; un-parking it lights up all five
plugins at once. This is not a gap in any plugin's build — it's an infrastructure dependency the
spec always located in Option B. (A plugin with *no* local-file dependency could still be
Cowork-verified; none of the five KB-reading plugins qualify.) See `pluginization-checklist.md`
"two-surface reality" and memory `cowork-skills-scope`.

## 1. Goal & Context

- **Problem**: HQ is a monorepo root (`AGENTS.md` router + symlink registry +
  `build-skills.ps1`) that ties together per-toolkit repos whose skills hard-code `c:\HQ\`
  paths (~229 refs) and silently share root context (`me.md`, `now.md`, `decisions.md`,
  voice guide). This coupling makes each toolkit un-shareable, un-installable on its own, and
  bound to one machine's directory layout.
- **User**: Chris (single operator). Also any future person who installs one plugin without
  the rest.
- **Value**: Two clean layers — independent plugins (pure logic) + KB (system of record).
  Each plugin installs and runs standalone in both Cowork and Code. HQ dissolves.

**Design source**: `hq-plugin-migration-spec.md` (root). Launch checklist:
`hq-plugin-migration-KICKOFF.md`. Path precedent: `cortex/config.md`.

**Independence rule (hard line)**: a plugin may depend on *itself*, on *KB*, and on *user
config* — **never on another plugin**. Shared needs are read from KB.

---

## 2. User Scenarios (Prioritized)

### Story 1: KB becomes the data layer (Priority: P1)

- **Journey**: Root context and pipeline move into the KB vault; every live skill that read
  them from `c:\HQ\` root is repointed to KB *in the same change*, so `/daily`, `/weekly`,
  `/status`, and content/board workflows keep working with zero downtime.
- **Value**: P1 — this is the enabling move. Until shared state lives in KB, no plugin can be
  independent. It's also the riskiest (touches the running system), so it goes first and
  proves the guardrail-first sequencing.
- **Acceptance Scenarios**:
  - **Given** `now.md` has moved into KB, **When** the `/daily` logic runs, **Then** it reads
    focus/projects/pipeline from KB and refreshes Next Actions with no reference to a root
    `c:\HQ\now.md`.
  - **Given** the migration is mid-flight, **When** any moved file is relocated, **Then** its
    readers are repointed in the same commit (no reader left pointing at a moved path).
  - **Given** the KB access layer is in place, **When** any skill attempts to write
    `KB/20_Journal/` or `KB/50_Finance/`, **Then** it is prevented/refused.

### Story 2: hq-cortex packaged as the reference plugin (Priority: P1)

- **Journey**: `cortex` gains a `plugin.json`, normalized frontmatter, workflows converted to
  commands and capabilities to skills, and its ~60 `c:\HQ\` refs de-hardcoded to config. It
  installs and runs in **both Cowork and Code**. The steps are captured as a reusable checklist.
- **Value**: P1 — proves the entire model end-to-end (manifest, command/skill split,
  de-hardcoding, cross-surface install). Cortex is the smallest toolkit (2 skills, 9 `cx-*`
  workflows) and owns KB, so it's the safest first pluginization. Everything after Story 2 is
  repetition of a known-good pattern.
- **Acceptance Scenarios**:
  - **Given** `hq-cortex` is installed as a plugin, **When** Chris invokes a namespaced command
    (e.g. `/hq-cortex:cx-search`), **Then** it runs and finds notes in the configured vault.
  - **Given** no `c:\HQ\` literal remains in cortex, **When** the vault path is changed in
    config, **Then** cortex operates against the new path with no code edits.
  - **Given** the plugin is installed in Cowork, **When** the same commands/skills are
    exercised there, **Then** behavior matches Code.
  - **Given** Story 2 is complete, **When** the next plugin is started, **Then** a written
    checklist exists that lists every step performed here.

### Story 3: Remaining four toolkits pluginized (Priority: P2)

- **Journey**: Apply the Story-2 checklist to `hq-content` (~37 refs), `hq-board` (~113,
  heaviest), `hq-specwright` (~28; `changes/` stays plugin-local), and `hq-operator` (reads KB
  only; owns `/daily` + `/weekly` + `/status` + multiscale planning).
- **Value**: P2 — repetition, not new design. Deferred until the reference pattern is proven.
- **Acceptance Scenarios**:
  - **Given** each plugin is installed standalone (siblings absent), **When** its commands run,
    **Then** they work using only itself + KB + config (no sibling dependency).
  - **Given** `hq-operator` is installed without pipeline/working-prefs/mistakes present,
    **When** `/daily` or `/weekly` runs, **Then** it uses those sources if present and skips
    them cleanly if absent.

### Story 4: HQ decommissioned (Priority: P3)

- **Journey**: Remove routing, symlink registry, `build-skills.ps1`, `AGENTS.md`. Each plugin
  to its own repo; register a personal marketplace. KB stands alone. Retire `c:\HQ\`.
- **Value**: P3 — cleanup, only safe once all five plugins are live and verified.
- **Acceptance Scenarios**:
  - **Given** all five plugins are installed from the marketplace, **When** `c:\HQ\` root is
    removed, **Then** every workflow still functions (nothing depended on the root).

---

## 3. Constraints

### Must

- **Move data and repoint readers together.** Every file relocation and its consumer updates
  land in the same step — never a move without repointing.
- **Preserve read-only zones.** `KB/20_Journal/` and `KB/50_Finance/` must never be written by a
  plugin or skill **on its own initiative**. Writes require explicit user instruction with the
  destination surfaced (`🔒`) first — see FR-005. Enforced at the KB access layer (Option A:
  convention + config; in-code enforcement is Option B, deferred).
- **Keep plugins independent.** Shared needs resolve via KB, never by reaching into a sibling
  plugin's files.
- **Test every plugin on Code** before considering it done. (~~both surfaces~~ — amended §0:
  Cowork deferred to Option B for KB-reading plugins.)
- **Use Option A** (per-plugin config paths, generalized from `cortex/config.md`) for KB access.
- **Follow existing conventions**: skill frontmatter shape already in use (`name`,
  `description`, optional `disable-model-invocation`/`triggers`); Obsidian filename-based link
  resolution (moves need no link rewrites).

### Must Not

- **Must not** build the KB MCP server (Option B) in this change — it's parked as a future KB
  project.
- **Must not** touch `altimeter/` (Antigravity IDE token-monitor extension, not a workflow
  toolkit).
- **Must not** pluginize or relocate `ledger/` in this change (deferred decision).
- **Must not** introduce a command/skill name collision within a plugin (skill wins on
  collision — a converted command would be shadowed).
- **Must not** modify unrelated code or the read-only KB zones.

### Not Doing (and Why)

- **KB MCP server (Option B)** — deferred; ship config-path Option A first, revisit once
  plugins are live.
- **`ledger/` migration** — decision deferred (6th plugin vs. standalone vs. fold into KB
  finance) until the reference plugin proves out.
- **`altimeter/`** — not a workflow toolkit; out of scope entirely.
- **Connector/scheduled-task setup** (Todoist/Gmail/Calendar, morning-brief schedule) — Cowork
  app-side configuration, not code (`cowork-operating-layer.md` §B).
- **Todoist ↔ vault two-way sync** (`cowork-operating-layer.md` C3) — separate future ticket.
- **Closing the board-reads-voice gap** — board doesn't read the voice guide today (existing
  gap). Not a migration step; revisit cheaply during hq-board pluginization (T10) or as its own
  change. (Clarified 2026-07-16.)

---

## 4. Functional Requirements

- **FR-001**: Move **all** root context into KB per spec §3.1 in Phase 1 (clarified: full
  move, not lazy). Destinations (clarified — now + meta cluster in `99_System/`):

  | Source | KB destination |
  |---|---|
  | `me.md` | `KB/40_Knowledge/Personal/` |
  | `now.md` | `KB/99_System/` |
  | `decisions.md` | `KB/99_System/` |
  | `specwright/working-preferences.md` | `KB/99_System/` |
  | `specwright/mistakes.md` | `KB/99_System/` |
  | house-style note (new; AGENTS rules 4–8) | `KB/99_System/` |
  | `content-creator/voice/voice-guide.md` | `KB/40_Knowledge/` |

  `vault-manual.md` stays vault-scoped (`KB/99_System/`, already vault doc).
- **FR-002**: Move `board/pipeline.md` + `board/pipeline-archive.md` into
  `KB/40_Knowledge/jobs/`, collapsing the daily/weekly cross-toolkit dependency.
- **FR-003**: Repoint every reader of a moved file to its new KB location in the same change
  (`/daily`, `/weekly`, `/status`, content skills reading voice guide, board skills reading
  pipeline).
- **FR-004**: Establish the Option A KB-access contract — a per-plugin config carrying the
  vault root + access method, generalized from `cortex/config.md`; skills read paths from
  config, not literals.
- **FR-005** (**corrected 2026-07-16**): Protect `KB/20_Journal/` and `KB/50_Finance/` under the
  **explicit-instruction rule**: reads always allowed; writes forbidden by default; the sole
  exception is a user-approved write whose destination was surfaced first (marked `🔒`, never
  rubber-stampable in a batch; approval is per-operation, never blanket).
  > *Was: "cannot be written by the access layer" — an absolute ban inherited from this spec's own
  > §2/§7 phrasing, which is **stricter than the actual operating rule**. `vault-manual.md:25` and
  > `CLAUDE.md` both permit writes on explicit user instruction. Chris confirmed the
  > explicit-instruction rule. The absolute reading would have made `cx-inbox`'s
  > `meeting → 20_Journal` routing illegal. §2/§7's wording is superseded by this FR.*
- **FR-006**: Add a `plugin.json` manifest to `hq-cortex`; normalize skill frontmatter.
- **FR-007**: Convert cortex workflows → commands (`commands/*.md`, explicit) and capabilities
  → skills (`skills/<name>/SKILL.md`, model-invocable), per spec §4.
- **FR-008**: Natural-language allowlist = **`cx-search` only** (clarified). It is the single
  model-invocable entry point ("find my notes about X"); everything else — including the daily
  brief, `/status`, and pipeline read — stays an **explicit slash command**. (Chris deliberately
  kept the daily brief explicit despite the kickoff floating it as a candidate.)
- **FR-009**: De-hardcode all `c:\HQ\` refs in cortex (~60) to config-driven paths.
- **FR-010**: Install-test `hq-cortex` in both Cowork and Code; confirm command + skill
  invocation on both.
- **FR-011**: Produce a written, repeatable pluginization checklist from Story 2.
- **FR-012**: Repeat FR-006–FR-011 for hq-content, hq-board, hq-specwright, hq-operator.
- **FR-013**: `hq-operator` treats pipeline/working-prefs/mistakes as **optional** KB sources
  (use if present, skip cleanly if absent) and owns `/daily`, `/weekly`, `/status`.
- **FR-014**: Decommission HQ — remove routing, symlink registry, `build-skills.ps1`,
  `AGENTS.md`; each plugin to its own repo; register a personal marketplace; retire `c:\HQ\`.
- **FR-015**: Primitives documented in §8 from current knowledge (clarified: proceed on
  knowledge, no agent spawn). Adjust in T8 if reality differs. The one uncertain item
  (skill-wins-on-collision) is neutralized by design — the Must-Not forbids name collisions
  regardless, so correctness doesn't depend on which one wins.
- **FR-016**: KB destinations resolved — see the FR-001 table (clarified).

### Edge Cases

- A reader is missed during a move → its next run fails on a stale `c:\HQ\` path. (Mitigation:
  grep-audit for `c:\HQ\` refs after each move; FR-003.)
- A converted command shares a name with an existing skill → skill silently shadows the
  command (Must Not / collision).
- `hq-operator` installed on a machine with no pipeline/working-prefs → must degrade
  gracefully, not error (FR-013).
- Cowork vs. Code surface divergence → a plugin passes in Code but a command doesn't surface in
  Cowork (or vice-versa). (Mitigation: two-surface test gate.)
- Obsidian link resolution after a move — resolves by filename, so no link rewrites needed
  *unless* two notes collide on filename in the new location.

---

## 5. Current State

- **Top-level toolkits**: `KB/` (vault), `cortex/`, `board/`, `content-creator/`,
  `specwright/`, plus out-of-scope `altimeter/` and `ledger/`.
- **Invocability today**: `.claude/skills/` holds **61 skills, zero commands**. Every workflow
  was converted to a skill with `disable-model-invocation: true` (emulating commands via
  skills). No `plugin.json` / marketplace exists yet — plugin packaging is greenfield.
- **cortex** is already its own git repo: `skills/` (obsidian-conventions, pkm-methodology),
  `workflows/` (9 `cx-*`), `agents/`, `templates/`, and `config.md` (the Option A precedent:
  vault path, name, inbox/daily folders, access method).
- **Path-ref counts** (`c:\HQ\` occurrences to de-hardcode): board 113, **cortex ~60**
  (60 across 15 files incl. 3 scripts; ~51 in md workflow/skill files), content 37,
  specwright 28. Toolkit→toolkit coupling ≈ zero (only historical refs in
  `specwright/archive/`).
- **Cross-cutting readers**: `/daily` + `/weekly` read `now.md` + `KB/10_Projects/` **and**
  `board/pipeline.md`; content skills read `content-creator/voice/voice-guide.md`; `/weekly`
  housekeeping writes `decisions.md`, `specwright/working-preferences.md`,
  `specwright/mistakes.md`.
- **`/weekly`** currently lives in `specwright/workflows/weekly.md` + `.claude/skills/weekly/`
  → moves to `hq-operator`.
- **Existing patterns to follow**: `cortex/config.md` (config schema to generalize);
  skill frontmatter shape in `cortex/skills/*/SKILL.md`; `.claude/build-skills.ps1` (the
  generation step being retired). No `CONSTITUTION.md` exists yet.

---

## 6. Tasks

> P1 tasks (T1–T9) are detailed for the first milestone. P2/P3 (T10–T12) are coarse and get
> broken down during `/plan` or a follow-up `/specify`.

### T1: Classify command-vs-skill for cortex (Phase 0)

**What:** Map each cortex primitive per the resolved rules — all 9 `cx-*` workflows → commands;
`obsidian-conventions` + `pkm-methodology` → skills; `cx-search` also exposed as the one
model-invocable skill (NL allowlist, FR-008). Primitives already documented in §8 (FR-015).
**Files:** notes / spec confirmation
**Verify:** Manual: every cortex `cx-*` mapped to command or skill; `cx-search` flagged
model-invocable; no name collisions.

### T2: Design the Option A config contract

**What:** Generalize `cortex/config.md` into a per-plugin config schema (vault root + access
method + read-only zones). Resolves FR-004.
**Files:** `cortex/config.md`, a config schema/README
**Verify:** Manual: schema documents vault root, folders, access method, and read-only zones;
a skill can resolve a vault path from it.

### T3: ~~Decide KB destination folders~~ — RESOLVED in /clarify

Destinations fixed in the FR-001 table (me → `40_Knowledge/Personal/`; now + decisions +
working-prefs + mistakes + house-style → `99_System/`; voice → `40_Knowledge/`; pipeline →
`40_Knowledge/jobs/`). No task remains; folded into T4–T6.

### T4: Move identity/focus/decisions into KB + repoint readers

**What:** Relocate `me.md`, `now.md`, `decisions.md` into their KB targets; repoint every
reader in the same step. Resolves FR-001 (partial), FR-003.
**Files:** the three files + each reader
**Verify:** `grep -ri "c:\\HQ\\(me\|now\|decisions)"` returns no stale reader refs; `/daily`
reads `now.md` from KB.

### T5: Move voice guide, working-prefs, mistakes; create house-style note

**What:** Relocate voice guide + working-prefs + mistakes into KB; author the house-style note
(AGENTS rules 4–8); repoint readers. Resolves FR-001 (rest), FR-003.
**Files:** three source files + new house-style note + readers (content skills, `/weekly`)
**Verify:** Content skill reads voice guide from KB; `/weekly` housekeeping writes to KB
targets; house-style note contains the no-corporate-speak / links-in-comments / `$`-escape /
voice rules.

### T6: Move pipeline into KB + repoint daily/weekly/job-status

**What:** Move `board/pipeline.md` + `pipeline-archive.md` → `KB/40_Knowledge/jobs/`; repoint
`/daily`, `/weekly`, `/job-status`. Resolves FR-002.
**Verify:** `/daily` and `/job-status` read pipeline from KB; `grep -ri "board\\pipeline"`
shows no stale readers.

### T7: Enforce read-only zones in the access layer

**What:** Ensure the Option A access contract prevents writes to `KB/20_Journal/` and
`KB/50_Finance/`. Resolves FR-005.
**Verify:** Manual: attempted write to either zone is refused/blocked per the contract.

### T8: Pluginize hq-cortex (manifest + command/skill split + de-hardcode)

**What:** Add `plugin.json`; normalize frontmatter; convert 9 workflows → commands, keep 2
capability skills; de-hardcode ~60 `c:\HQ\` refs → config. Resolves FR-006, FR-007, FR-009.
**Files:** `cortex/` (manifest, commands/, skills/)
**Verify:** `grep -ri "c:\\HQ" cortex` returns 0; `plugin.json` validates; commands namespaced.

### T9: Cross-surface install-test + write the checklist

**What:** Install `hq-cortex` in Code and Cowork; exercise a command + a skill on each; write
the repeatable pluginization checklist. Resolves FR-010, FR-011.
**Verify:** `/hq-cortex:cx-search` (or equiv.) runs in both surfaces; checklist file exists
listing every step from T8–T9.

### T10: Pluginize hq-content, hq-board, hq-specwright, hq-operator (P2)

**What:** Apply the T8–T9 checklist to each remaining toolkit. Resolves FR-012, FR-013.
**Verify:** Each installs standalone (siblings absent) and passes on both surfaces; hq-operator
degrades cleanly without optional sources.

### T11: Marketplace + own-repo split (P3)

**What:** Move each plugin to its own repo; register a personal marketplace. Resolves FR-014
(partial).
**Verify:** Each plugin installs from the marketplace.

### T12: Retire HQ root (P3)

**What:** Remove routing, symlink registry, `build-skills.ps1`, `AGENTS.md`; retire `c:\HQ\`.
Resolves FR-014 (rest).
**Verify:** With root removed and plugins installed from marketplace, all workflows still run.

---

## 7. Success Criteria

- **SC-001**: After Phase 1, `grep -ri "c:\\HQ\\(now\|me\|decisions)"` finds no live *reader*
  still pointing at a moved root file, and `/daily`/`/weekly`/`/status` run green.
- **SC-002** (corrected): No skill writes to `KB/20_Journal/` or `KB/50_Finance/` on its own
  initiative; any such write is surfaced (`🔒`) and user-approved first. Verified by auditing every
  skill that targets those zones.
- **SC-003** (corrected): cortex contains **exactly one** `c:\HQ` reference — `config.md`'s
  `vault_root` value — and zero elsewhere. All command/skill vault paths use the `{vault_root}`
  token (resolved from config) and plugin-own-file paths use `{plugin_root}`. The absolute-zero
  wording was impossible: Option A's whole design puts the one machine-specific path in config.
  > Verified: 1 ref (config.md:7); 55 `{vault_root}` + 5 `{plugin_root}` tokens; all 9 generated
  > skills `c:\HQ`-free.
- **SC-004**: `hq-cortex` installs and a command + a skill run successfully in **both** Cowork
  and Code.
- **SC-005**: A written pluginization checklist exists, sufficient to repeat on the other four
  plugins without re-deriving the process.
- **SC-006** (P2): Each of the five plugins runs standalone with siblings absent (independence
  rule holds).
- **SC-007** (P3): With `c:\HQ\` root retired and plugins installed from the marketplace, all
  workflows still function.

---

## 8. Technical Context

**Claude Code plugin primitives** (documented from current knowledge per FR-015; verify/adjust
in T8):

- **Plugin manifest**: `.claude-plugin/plugin.json` at the plugin root — `name`, `version`,
  `description`, `author`, optional component-path overrides. Components default to `commands/`,
  `skills/`, `agents/`, `hooks/`, plus optional `mcpServers`.
- **Commands**: `commands/*.md` (markdown, optional frontmatter: `description`, `argument-hint`,
  `allowed-tools`, `model`). Explicit invocation only. Support `$ARGUMENTS`/`$1..$N`, `!` bash,
  `@` file refs. → the destination for HQ's workflows.
- **Skills**: `skills/<name>/SKILL.md` (frontmatter: `name`, `description`, optional
  `allowed-tools`, `disable-model-invocation`). Model-invocable by description unless disabled;
  may bundle supporting files. → the destination for capabilities (obsidian-conventions,
  pkm-methodology) and the one NL entry point (`cx-search`).
- **Marketplace**: `.claude-plugin/marketplace.json` lists plugins; add via
  `/plugin marketplace add <path|repo>`, install via `/plugin install <name>@<marketplace>`
  (Phase 4 / T11).
- **Namespacing**: plugin commands/skills are namespaced `/plugin-name:name`.
- **Collision**: assume skill-wins-on-name-collision (per spec §4); the Must-Not forbids
  collisions within a plugin, so this is avoided by design rather than relied upon.

**Config**: Option A — generalized `cortex/config.md` schema (vault root, folders, access
method, read-only zones).

**Uncertainty to close in T8**: exact manifest key names/casing and whether the collision rule
holds in this build. Neither blocks the spec; both surface at first install-test.

---

## 9. Acceptance Traceability

| ID     | Criterion                                             | Verification | Task | Status |
| ------ | ----------------------------------------------------- | ------------ | ---- | ------ |
| SC-001 | No live reader on moved root files; daily/weekly green | Whole-repo fixed-string sweep of all 8 moved paths → 0 live readers; all four workflows resolve every declared source; all 60 skills' KB paths resolve on disk | T10 | ✅ |
| SC-002 | No unprompted writes to protected zones                 | Audit every skill targeting `20_Journal`/`50_Finance`: none writes unprompted; each surfaces `🔒` + requires approval | T9, T10 | ✅ |
| SC-003 | One `c:\HQ` ref in cortex (config `vault_root` only)    | `grep -rF 'c:\HQ' cortex` → 1 (config.md:7); commands/skills use `{vault_root}`/`{plugin_root}` | T12 | ✅ |
| SC-004 | hq-cortex runs on Code (Cowork = Option-B follow-on)    | ✅ Code: `claude plugin validate` + live `/hq-cortex:cx-search` against the real vault + 3 skills registered namespaced. Cowork deferred — see DoD note below. | T13 | ✅ (Code) |
| SC-005 | Repeatable checklist exists                            | `pluginization-checklist.md` present under the change folder | T13 | ⏳ |
| SC-006 | Each plugin runs standalone                            | Install each plugin with siblings absent; commands run; operator degrades cleanly | T14 | ⏳ |
| SC-007 | Workflows survive HQ retirement                        | Root removed + marketplace install; all workflows still run | T16 | ⏳ |

---

## Clarifications — resolved 2026-07-16 (/clarify)

Audit trail of the scope challenge + `[NEEDS CLARIFICATION]` resolutions:

1. **Phase 1 breadth → move EVERYTHING (spec §3.1).** All 8 root-context items migrate in
   Phase 1, including `me.md` and the new house-style note. (Chris chose the single-pass move
   over the minimal/lazy option.) → drives FR-001; subsumes former scope-Q2 (house-style is
   built in Phase 1, not deferred).

2. **KB destinations → now + meta cluster in `99_System/`.** `now.md`, `decisions.md`,
   `working-preferences`, `mistakes`, and the house-style note all land in `99_System/`;
   `me.md` → `40_Knowledge/Personal/`; voice → `40_Knowledge/`; pipeline → `40_Knowledge/jobs/`.
   `10_Projects/` stays for real projects only. → FR-001 table; closed T3.

3. **Primitive verification → proceed on current knowledge** (no agent spawn). Documented in
   §8; adjust at first install-test (T8). → FR-015.

4. **NL allowlist → `cx-search` only.** Sole model-invocable entry point; daily brief, `/status`,
   and pipeline read stay explicit slash commands. → FR-008.

5. **Board-reads-voice gap → deferred, not bundled.** An existing gap (board doesn't read the
   voice guide today). Fixing it is a new requirement, not a migration step; revisit *cheaply*
   during hq-board's pluginization (T10), otherwise leave for a separate change. → noted in §3
   "Not Doing".

6. **`hq-operator` timing → confirmed, no double-work.** Phase 1 repoints the *current*
   specwright/`.claude` `/daily`+`/weekly` skills in place; the *move* into `hq-operator` happens
   in P2 (T10). Spec is consistent.

**Status: Plan Ready.** No open `[NEEDS CLARIFICATION]` tags remain. Next: `/plan`.
