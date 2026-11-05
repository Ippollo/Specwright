# Tasks: HQ → Plugins Migration

> Dependency-ordered. Each task tagged with its executing workflow. P1 (T1–T13) = the first
> milestone (KB data layer + hq-cortex reference plugin), detailed. P2/P3 (T14–T16) coarse —
> break down after the reference pattern is proven.
>
> **Golden rule (every move task):** edit canonical `<toolkit>/workflows/*.md`, run
> `build-skills.ps1`, verify — never hand-edit `.claude/skills/`. Delete old file only after
> readers verify on KB.

## Phase 0 — Prep

### T1: Confirm command-vs-skill mapping for cortex `/design` — ✅ DONE
**Depends:** —
**What:** Lock the primitive map: 9 `cx-*` → commands; `obsidian-conventions` + `pkm-methodology`
→ skills; add `cx-search` as a distinct-named model-invocable skill (`vault-search`) alongside
the `cx-search` command. Primitives already in spec §8.
**Files:** notes / spec confirmation
**Verify:** Manual: every cortex primitive mapped; no command/skill name collision.
**Result:** `cortex-primitive-map.md` — 9 commands + 3 skills mapped; collision check passed
(skill named `vault-search`, no overlap with `cx-*` commands). ✅

### T2: Design & write the KB access contract `/backend` — ✅ DONE
**Depends:** T1
**What:** Generalize `cortex/config.md` into the contract (vault_root, logical folders,
`read_only: [20_Journal, 50_Finance]`, `access_method: filesystem`). Define the logical-location
convention skills will use.
**Files:** `cortex/config.md`, a short contract README
**Verify:** Manual: a skill can resolve `{knowledge}/jobs/pipeline` → real path from config;
read-only list present.
**Result:** `kb-access-contract.md` (reusable schema + logical-location table + Option-B
forward-compat) and `cortex/config.md` generalized (additive, backward-compatible — kept the
Vault/Inbox/Daily fields cx-capture & cx-inbox reference). `read_only` list present. ✅

## Phase 1 — KB as the data layer (move + repoint in lockstep)

### T2.5: Repoint build-skills.ps1 at canonical toolkits `/backend` — ✅ DONE
**Depends:** T2 | **Added:** 2026-07-16, mid-`/work` — **unplanned blocker discovered at T3.**
**Why it exists:** T3–T8's repoint mechanic assumed `global_workflows` symlinked to canonical.
It doesn't — 29 symlinks, **31 copies** (all specwright, incl. T3's targets `daily`/`weekly`/
`work`). Editing canonical + rebuilding would have read the stale copy and **silently discarded
every Phase-1 edit.** Hard blocker; T3 could not proceed until fixed.
**What:** Rewrote `.claude/build-skills.ps1` to read canonical `<toolkit>/workflows/` directly
(handles flat + directory-style layouts; precedence board/content-creator/cortex > specwright;
collisions reported). `global_workflows` untouched → Antigravity unaffected.
**Files:** `.claude/build-skills.ps1`
**Verify:** ✅ 60/60 skills regenerated, skill set **identical** (none vanished/appeared);
55 byte-identical; collision `analyze-job → board` matches the old symlink; backup taken.
**Result — fixed 5 latent bugs the drift had hidden:**
- `/daily` — the **Jun-16 canonical logic finally live** (conditional filtering, trust `status:
  done`, alternate pipeline display). Had been dormant ~2 months.
- `deploy`, `discover`, `enhance` — dropped refs to **7 deleted skills** (`backend-performance`,
  `deployment-pipeline`, `data-modeling`, `react-best-practices`, `vue-svelte-patterns`,
  `api-design-patterns`, `unit-testing-strategy`); all verified nonexistent.
- `ledger` — updated to Obsidian Bases (`Budget.base`) from `50_Finance/accounts/`.

### T3: Move now.md → KB + repoint `/backend` — ✅ DONE
**Depends:** T2
**What:** Copy `now.md` → `KB/99_System/now.md`; edit `daily`, `weekly`, `work` canonical
workflows to read it there; rebuild; delete root `now.md`.
**Files:** `now.md`, `specwright/workflows/{daily,weekly,work}.md`, rebuilt skills
**Verify:** `/daily` reads `KB/99_System/now.md`; `grep -ri "c:\\HQ\\now\.md" */workflows` → 0.

### T4: Move pipeline → KB + repoint `/backend` — ✅ DONE
**Depends:** T2
**What:** Move `board/pipeline.md` + `pipeline-archive.md` → `KB/40_Knowledge/jobs/`; repoint the
real readers (`daily`, `job-status`, `analyze-job`, `career-chat`, `consult`, `generate-resume`,
`content-status`). Do **not** touch the specwright dev-"pipeline" workflows (false matches).
**Files:** 2 pipeline files, board + content workflows, rebuilt skills
**Verify:** `/job-status` reads pipeline from KB; `grep -ri "board.pipeline" */workflows` → 0.

### T5: Move voice-guide → KB + repoint `/backend` — ✅ DONE
**Depends:** T2
**What:** Move voice guide → `KB/40_Knowledge/voice-guide.md`; repoint `atomize`,
`review-content`, `scout`, `write-article`, `write-case-study`.
**Files:** voice guide, 5 content workflows, rebuilt skills
**Verify:** A content workflow reads the voice guide from KB; run `/write-article` dry check.

### T6: Move decisions.md → KB + repoint `/backend` — ✅ DONE
**Depends:** T2
**What:** Move `decisions.md` → `KB/99_System/`; repoint `archive`, `weekly`, `work`, and confirm
`cx-inbox` (is it a write or a mention?). Handle write-repoint if `/weekly` writes decisions.
**Files:** `decisions.md`, 4 workflows, rebuilt skills
**Verify:** `/weekly` housekeeping writes to `KB/99_System/decisions.md`; grep → 0 stale readers.

### T7: Move working-preferences + mistakes → KB + repoint `/backend` — ✅ DONE
**Depends:** T2
**What:** Move both → `KB/99_System/`; repoint the specwright dev set
(`backend,debug,design,enhance,finish,plan,review,security,test,work`) + `weekly`.
**Files:** 2 files, ~11 workflows, rebuilt skills
**Verify:** A dev workflow (e.g. `/backend`) reads house rules from KB; `/weekly` writes
mistakes to KB; grep → 0 stale readers.

### T8: Move me.md + author house-style note + repoint router `/backend` — ✅ DONE
**Depends:** T2
**What:** Move `me.md` → `KB/40_Knowledge/Personal/`; author `KB/99_System/house-style.md`
(AGENTS rules 4–8); update `AGENTS.md`/`CLAUDE.md` shared-context refs to KB paths.
**Files:** `me.md`, new house-style note, `AGENTS.md`, `CLAUDE.md`
**Verify:** No skill reads a root `me.md` (already none); house-style note holds the voice /
no-corporate-speak / links-in-comments / `$`-escape rules.

### T9: Enforce read-only zones `/security` — ✅ DONE
**Depends:** T2
**What:** Ensure the contract refuses writes to `20_Journal`/`50_Finance`; document the guard so
every skill honors it (code-level enforcement deferred to the KB MCP).
**Files:** contract README, config
**Verify:** ✅ Audited all 29 protected-zone refs across cortex/board/content/specwright; all 6
write-paths now guarded; guard reached the generated skills. **(Traces: SC-002)**
**Rule (corrected, Chris-confirmed):** **explicit-instruction**, not absolute ban. The spec's
§2/§7 "must never be written by AI" was **stricter than the real operating rule** —
`vault-manual.md:25` + `CLAUDE.md` both allow writes on explicit user instruction. FR-005/SC-002
and the T2 contract were corrected to match.
**Violation found + fixed:** `cx-file-artifact` auto-routed "Reflections, lessons learned" →
`20_Journal/` with only a *conditional* ("when uncertain") ask — a clear-cut reflection would have
been written to a protected zone **unprompted**. Now requires explicit approval.
**Guards added (🔒 marker — read-only destinations can't be rubber-stamped in a batch):**
`cx-inbox`, `cx-file-artifact`, `librarian` agent, `pkm-methodology`, `obsidian-conventions`,
`cortex/config.md`. `cx-inbox` was already compliant (batch table + explicit approval).

### T10: Phase-1 regression sweep `/test` — ✅ DONE
**Depends:** T3–T9
**What:** Full grep audit for stray `c:\HQ\` root-file readers; run `/daily`, `/weekly`,
`/status`, `/job-status` end-to-end.
**Files:** —
**Verify:** ✅ **SC-001 GREEN** — zero live readers on any of the 8 moved files (whole-repo
fixed-string sweep, pattern self-tested against known-present content first). ✅ **SC-002 GREEN**
— no skill writes a protected zone unprompted. ✅ All four workflows resolve every declared
source. ✅ **Every KB path referenced by all 60 generated skills resolves on disk.**
**(Traces: SC-001, SC-002)**

> **Verification lesson (cost 4 false results this phase).** Three greps and one "self-test"
> silently lied: escaped-BRE backslash patterns, PowerShell `-SimpleMatch` with a `|` pattern,
> `[char]0x1F512` (astral codepoint), and a **tautological self-test** that matched a variable
> against itself. Each reported CLEAN/MISSING on content that provably existed. **Rule: every
> audit pattern must first be proven against a known-present string before its "clean" is
> believed.** Applied for the rest of this migration.

> **Phase 1 execution note (2026-07-16).** Two corrections surfaced mid-flight:
> 1. **T2.5 inserted** — the repoint mechanic was invalid (see T2.5); `global_workflows` was
>    29 symlinks + 31 stale copies, not symlinks. Fixed before T3 could run.
> 2. **Reader surface was wider than planned.** T3–T6's first pass swept only `*/workflows/` and
>    missed live readers in **`<toolkit>/agents/`** and **`<toolkit>/skills/`** (board agents ×3,
>    board/skills/career-data, content-creator/skills/{page-cro,seo-audit},
>    cortex/{config.md,skills/obsidian-conventions}). All 8 found and fixed via a whole-repo
>    fixed-string sweep. `research.md`'s reader table had the same blind spot.
> 3. **`vault-manual.md` added to T8** — spec §3.1 sends it to `99_System/`; the FR-001 table had
>    wrongly recorded it as "stays vault-scoped" (it was at HQ root, not in the vault).
>
> **Deferred / open:**
> - `KB/40_Knowledge/people/Luke (…).md` and a `jobs/_archive/` note still cite the old
>   `board\pipeline.md` path — vault *content*, not live readers. Left for user approval.
> - Hardcoded `c:\HQ\KB\...` paths written into workflows conflict with
>   `working-preferences.md:157` ("no hardcoded personal paths"). Deliberate + temporary —
>   de-hardcoded per plugin in T12/T14.

## Phase 1 — remaining

(T9 read-only enforcement, T10 regression sweep still open.)

## Phase 2 — hq-cortex reference plugin

### T11: Pluginize cortex — manifest + command/skill split `/backend` — ✅ DONE
**Depends:** T10
**What:** Add `.claude-plugin/plugin.json`; `cortex/workflows/` → `cortex/commands/`; keep 2
capability skills; add `skills/vault-search/` (model-invocable). Normalize frontmatter.
**Files:** `cortex/**`
**Verify:** `plugin.json` validates; commands namespace as `/hq-cortex:*`.
**Result:** `cortex/.claude-plugin/plugin.json` (name `hq-cortex` v0.1.0, valid JSON).
`workflows/ → commands/` via `git mv` (history preserved; 9 cx-* commands). Skills normalized
to kebab-case names, dropped non-standard `version`/`triggers`/`metadata` (model-invocation is
description-driven), trigger keywords folded into descriptions. Added `skills/vault-search/` —
the model-invocable NL entry point (distinct name; no collision with the `cx-search` command).
`build-skills.ps1` taught to read a toolkit's `workflows/` **or** `commands/` (general, not a
cortex special-case), so the live cx-* skills keep generating during transition. Rebuild verified:
all 9 cx-* present, 60 skills intact. **Command frontmatter still carries harmless Antigravity
fields (`quick_summary`, `requires_mcp`) — cleaned in T12's normalization pass.**

### T12: De-hardcode cortex paths → config `/enhance` — ✅ DONE
**Depends:** T11
**What:** Replace all ~60 `c:\HQ\` refs in cortex with config-resolved logical locations.
**Files:** `cortex/**`
**Verify:** ✅ SC-003 (corrected) — cortex has **exactly 1** `c:\HQ` ref (config.md `vault_root`,
the one machine-specific value by design); all 9 generated skills `c:\HQ`-free. **(Traces: SC-003)**
**Result:** 50 vault-path refs → `{vault_root}` token (resolved from config.md); 3 plugin-script
refs → `{plugin_root}` (`${CLAUDE_PLUGIN_ROOT}` at install — verify var name at T13); config.md
defines both tokens + holds the single `vault_root` value; 5 commands gained a resolution pointer.
Also cleaned Antigravity frontmatter (`quick_summary`/`requires_mcp`/`recommends_mcp`) from all 9
commands. **SC-003 reworded:** "zero c:\HQ" was impossible — Option A keeps the one path in config.

### T13: Cross-surface install-test + write the checklist `/test` — 🟡 CODE ✅ / COWORK blocked-by-design
**Depends:** T12
**What:** Install `hq-cortex` in Code and Cowork; exercise a command + the vault-search skill on
each; verify the collision/manifest assumptions from spec §8; write the repeatable checklist.
**Files:** `specwright/changes/hq-plugin-migration/pluginization-checklist.md`
**Verify (Code surface — DONE, verified against Claude Code v2.1.81):**
- ✅ `claude plugin validate ./cortex` → "Validation passed" (manifest + structure correct).
- ✅ `claude --plugin-dir ./cortex -p "/hq-cortex:cx-search onboarding"` → ran end-to-end,
  resolved `{vault_root}` from config.md, searched the **live vault**, returned a real note.
- ✅ 3 skills registered namespaced + model-invocable (`hq-cortex:obsidian-conventions`,
  `:pkm-methodology`, `:vault-search`).
- ✅ `${CLAUDE_PLUGIN_ROOT}` confirmed = our `{plugin_root}` token.
- ✅ `pluginization-checklist.md` written (SC-005). **(Traces: SC-004 [Code], SC-005)**

**Verify (Cowork surface — BLOCKED BY DESIGN under Option A):**
- ❌ Cowork = sandboxed Linux VM, no local Windows filesystem (memory `cowork-skills-scope`,
  claude-code-guide 2026-07-14). hq-cortex reads `c:\HQ\KB` → path absent in the sandbox →
  commands cannot function. Packaging fixes visibility, not function.
- **Only Option B (KB MCP) makes the vault reachable from Cowork** (spec §3.3). Deferred to the
  parked KB MCP project. **SC-004's "both surfaces" is Option-A-limited — see the DoD decision.**

**Findings that corrected the build (from verifying against real docs, not assumptions):**
1. commands/ are model-invocable by DEFAULT → added `disable-model-invocation: true` to all 9
   cx-* so they stay explicit-only (matching intent; the original HQ behavior).
2. `${CLAUDE_PLUGIN_ROOT}` / `license` / `keywords` all confirmed valid.
3. Namespacing `/hq-cortex:*` confirmed working live.
**→ FIRST MILESTONE COMPLETE.**

## Phase 3 — Remaining plugins (coarse)

### T14: Pluginize content / board / specwright / operator `/backend` — 🟡 IN PROGRESS

**Progress (Code-verified per the checklist):**
- ✅ **hq-content** — plugin.json + config.md; workflows→commands (git mv, 9); +disable-model-invocation; de-hardcoded 8→{vault_root}, 31→{plugin_root}; `claude plugin validate` passed; live `/hq-content:content-status` ran end-to-end; 13 skills registered namespaced. (1 leftover c:\HQ in a gitignored editorial-calendar content note — not machinery.)
- ✅ **hq-board** — plugin.json + config.md; workflows→commands (git mv, 10); +disable-model-invocation; de-hardcoded 58→{vault_root}, 42→{plugin_root}, **4 cross-toolkit sibling refs → optional `related_toolkits`** (independence-rule fix — the agents referenced content-creator/specwright/cortex directly; spec §2 "~zero coupling" audit had missed `agents/`). Added frontmatter to 3 agents (validate warned). Fixed 1 markdown-escaped double-backslash ref the single-\ scan missed. `claude plugin validate` clean; live `/hq-board:job-status` read pipeline from KB + asked write permission.
- ⬜ hq-specwright (~28) · hq-operator (net-new; daily/weekly/status move here from specwright)

**Cross-plugin re-scan:** verified cortex + content-creator have NO missed double-backslash refs (board's was isolated).

**Depends:** T13
**What:** Apply the T11–T13 checklist to each (content ~37, board ~113, specwright ~28,
operator = daily/weekly/status reading KB only + optional sources). `/weekly` moves into
operator here.
**Verify:** SC-006 — each installs standalone (siblings absent) and passes on both surfaces;
operator degrades cleanly without pipeline/working-prefs/mistakes. **(Traces: SC-006)**

## Phase 4 — Decommission HQ (coarse)

### T15: Marketplace + own-repo split `/backend` — ✅ DONE (2026-07-18)
**Depends:** T14
**What:** Each plugin to its own repo; register a personal marketplace.
**Verify:** Each plugin installs from the marketplace.
**Done:** 5 repos moved to `C:\Projects\hq-plugins\`; local marketplace `hq-plugins`
(`.claude-plugin/marketplace.json`, own git repo) registered via `claude plugin marketplace add`;
all 5 installed at user scope + enabled; live-verified `/hq-specwright:status`,
`/hq-cortex:cx-search`, `/hq-operator:daily` via the INSTALLED plugins. Install = version-pinned
copy in `~/.claude/plugins/cache/` (source of truth = `C:\Projects\hq-plugins\<plugin>\`; edit →
commit → `marketplace update` to refresh). Local chosen over GitHub (owner); nothing pushed.

### T16: Retire HQ root `/backend` — ✅ DONE (2026-07-18)
**Depends:** T15
**What:** Remove routing, symlink registry, `build-skills.ps1`, `AGENTS.md`; retire `c:\HQ\`.
**Verify:** SC-007 — root removed + plugins from marketplace; all workflows still run. **(Traces: SC-007)**
**Done:** KB moved `c:\HQ\KB` → `C:\Projects\KB`; `vault_root` repointed in all 5 configs (+ board
`related_toolkits`), committed, reinstalled so cached installs read the new path (reinstall, not
`plugin update` — update compares version not commit). `c:\HQ\.claude\build-skills.ps1` +
transitional `.claude\skills\` (60) removed; `AGENTS.md`/`CLAUDE.md`/`project-context.md` →
tombstones. **SC-007 verified:** installed `/hq-cortex:cx-search` (6 notes from `C:\Projects\KB`),
`/hq-content:content-status`, `/hq-specwright:status`, `/hq-board:job-status` all run with `c:\HQ`
retired. Left as follow-ups (owner): GitHub publish (nothing pushed), un-migrated
`analyze-job.md`/`ledger.md`, inert settings.json KB deny-rules, dangling Antigravity symlinks.

---

## 🎉 hq-plugin-migration COMPLETE (T1–T16, 2026-07-18)
HQ dissolved into 5 independent Claude Code plugins (`C:\Projects\hq-plugins`) + KB vault
(`C:\Projects\KB`), installed from the local `hq-plugins` marketplace. `c:\HQ` retired to tombstones
(+ unrelated `ledger/`, `altimeter/`). Nothing pushed to GitHub — that's a separate owner decision.

---

## Dependency Graph (P1 milestone)

```
T1 → T2 → [T3 → T4 → T5 → T6 → T7 → T8]  (serial — see below) → T9 → T10
     → T11 → T12 → T13 (milestone)
```

**T3–T8 are NOT parallel — run them serially.** They edit overlapping workflow files:

| Shared file | Edited by |
|---|---|
| `weekly.md` | T3 (now), T6 (decisions), T7 (working-prefs/mistakes) |
| `work.md` | T3, T6, T7 |
| `daily.md` | T3 (now), T4 (pipeline) |

Parallel edits would clobber each other. Two safe options: (a) run T3→T8 serially, one
`build-skills.ps1` rebuild at the end; or (b) batch all edits to `daily.md`/`weekly.md`/`work.md`
into a single pass, then rebuild once. Either way the rebuild is a single serialization point —
never rebuild mid-task with a half-repointed file. T9 (read-only guard) is independent and may run
any time after T2; T10 (regression sweep) gates on T3–T9 all being done.
