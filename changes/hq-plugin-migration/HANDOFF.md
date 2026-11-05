# HANDOFF — HQ → Plugins Migration

> **For the next Code session.** Read this to resume without re-deriving. Full record:
> `proposal.md`, `specs/spec.md`, `research.md`, `design.md`, `tasks.md`,
> `pluginization-checklist.md`, `kb-access-contract.md`, `cortex-primitive-map.md` (this folder).

> **📍 LOCATION CHANGED (T15).** The 5 plugin repos moved OUT of `c:\HQ` to
> **`C:\Projects\hq-plugins\{cortex,content-creator,board,operator,specwright}\`**. This file now
> lives at `C:\Projects\hq-plugins\specwright\changes\hq-plugin-migration\HANDOFF.md`. `c:\HQ` still
> holds **KB** (the vault, not yet moved), `ledger/`, `altimeter/`, and the retiring aggregator
> files (`AGENTS.md`, `CLAUDE.md`, `project-context.md`, `.claude/`). See T16.

## Where we are (2026-07-18)

Running a specwright change (`/new`→`/specify`→`/clarify`→`/plan`→`/analyze`→`/work`). Executing
`tasks.md`.

- **Phase 0–1 (T1–T10): DONE + committed.** KB is the data layer; all root context moved into the
  vault; every reader repointed; read-only guards in place. `/daily` reads KB only.
- **First milestone (T11–T13): MET on Code + committed.** hq-cortex packaged, de-hardcoded,
  and **verified live** (`claude plugin validate` + `/hq-cortex:cx-search` against the real vault).
- **T14 (pluginize all 5): DONE + committed** — **hq-cortex, hq-content, hq-board, hq-operator,
  hq-specwright**. All 5 plugins built, validated, and live-verified.
- **T15 (own-repos + marketplace): DONE.** 5 repos moved to `C:\Projects\hq-plugins\`; personal
  local marketplace `hq-plugins` created + registered; **all 5 installed from it (user scope,
  enabled)** and live-verified (`/hq-specwright:status`, `/hq-cortex:cx-search`, `/hq-operator:daily`
  resolve via the INSTALLED plugins, no `--plugin-dir`).
- **T16 (retire HQ root): DONE.** KB → `C:\Projects\KB`; `vault_root` repointed in all 5 configs +
  reinstalled; HQ `build-skills.ps1` + transitional `.claude/skills/` removed; `AGENTS.md`/`CLAUDE.md`/
  `project-context.md` → tombstones. **SC-007 verified** (installed plugins run with `c:\HQ` gone,
  reading `C:\Projects\KB`).
- **🎉 MIGRATION COMPLETE (T1–T16).** Only owner follow-ups remain (below) — none blocking.

### T16 details (2026-07-18)
- **Reinstall, not `plugin update`, to refresh a cached install:** `claude plugin update` compares
  the **version** (still 0.1.0) not the git commit, so it reported "already latest" and did NOT pull
  the new `vault_root`. `uninstall` + `install` re-pins to current HEAD and refreshes the cache.
  (If you want `update` to work later, bump the plugin `version` on each change.)
- Only `config.md`'s `vault_root` needed repointing — all `commands/skills/agents` use `{vault_root}`
  (verified 0 literal `c:\HQ` across runtime surfaces). Non-runtime stragglers left as-is:
  board `project-profile.md`, specwright `telemetry/` + `.agents/` + un-migrated `workflows/`.

### T15 details (2026-07-18)
- **Marketplace** `C:\Projects\hq-plugins\.claude-plugin\marketplace.json` (own git repo, sources
  `./cortex` … `./specwright`; the 5 plugin subdirs are gitignored — each stays its own repo).
  Registered with `claude plugin marketplace add C:\Projects\hq-plugins`.
- **Install = version-pinned COPY**, not a live link. Each installs to
  `~/.claude/plugins/cache/hq-plugins/<plugin>/0.1.0` pinned to a `gitCommitSha`. So: **source of
  truth = `C:\Projects\hq-plugins\<plugin>\`**; after editing a plugin, `git commit` it then
  `claude plugin marketplace update hq-plugins` (or reinstall) to refresh the cache. Installed
  plugins are durable — they survive `c:\HQ` retirement.
- **Local marketplace chosen over GitHub** (owner decision). GitHub publish deferred: the 4 repos
  keep their `github.com/Ippollo` remotes but **nothing is pushed**; a push still needs the privacy
  sweep + operator-visibility call + explicit approval.
- **Moving the repos out already dismantled part of the HQ aggregator:** `c:\HQ\.claude\build-skills.ps1`
  can no longer find the toolkits, so the HQ-root `.claude/skills/` are now frozen/stale (harmless;
  removed in T16). The namespaced installed plugins (`/hq-*:cmd`) don't collide with the old
  unnamespaced root skills (`/cmd`).

### T14 final two (2026-07-17)
- **hq-operator** — NET-NEW plugin, its own repo at top-level `operator/` (branch
  `hq-plugin-migration`, committed). Owns `/daily` + `/weekly` (extracted from specwright).
  config.md: now.md + 10_Projects/ required; pipeline / decisions / working-preferences / mistakes
  OPTIONAL (degrade cleanly). `/daily`'s `/comment` call made optional (only if hq-content
  installed) — independence rule. `claude plugin validate` clean. **No read-only command exists**
  (both daily/weekly write now.md), so live-verify is validate-only — consistent with the
  "never run a side-effectful command to verify" rule.
- **hq-specwright** — pluginized as pure dev tooling. **DECISION (owner-confirmed): `/status`
  STAYS in specwright** (it's change-lifecycle tooling that scans `changes/`, reads no KB — the
  spec/earlier-handoff had mis-listed it for operator). Only `/daily`+`/weekly` moved.
- **`analyze-job.md` + `ledger.md` left un-migrated** in `specwright/workflows/` (not shipped as
  plugin commands): board owns analyze-job (wins the build collision); ledger is finance, deferred.
  They still generate as HQ-root skills during transition. Decide their fate at T15/T16.

### ⚠️ CRITICAL GOTCHA (cost ~an hour to find — don't relearn)
**A plugin command named `skill` silently breaks command loading for the ENTIRE plugin.** Every
command resolves as `Unknown skill: <plugin>:<cmd>` — including unrelated ones — because `skill`
collides with Claude Code's built-in skill system. `claude plugin validate` does NOT catch it.
Found by bisecting specwright's 29 commands. **Fix: renamed `/skill` → `/build-skill`.** When
pluginizing, avoid reserved command names (`skill`); if commands mysteriously don't load, bisect
for a reserved name before suspecting frontmatter. Plugin SKILLS load fine even when commands are
broken — a useful discriminator.

## Git state

Branch **`hq-plugin-migration`** in each toolkit repo (KB, cortex, board, content-creator,
specwright, **operator** [new repo]); **HQ root** is on **`claude-code-setup`**. **Nothing pushed.**
All committed except a few of your own uncommitted `KB/10_Projects/` notes — pre-existing personal
work, **not ours, leave them**.

3 repos are **PUBLIC**: Cortex, content-creator, Specwright → **privacy-sweep before any push**
(no personal circumstances / employer names in tracked files or history).

**hq-operator is a PRIVATE repo** (`github.com/Ippollo/operator`): its `/daily` carries personal
planning logic, so it is not published publicly.

## The proven plugin recipe (worked 3×; full version in `pluginization-checklist.md`)

1. `.claude-plugin/plugin.json` — `name` (kebab, = namespace), `version`, `description`, `author`.
2. `config.md` — `vault_root` (the ONE machine path) + define `{vault_root}` / `{plugin_root}`
   tokens + `read_only` zones. Each plugin carries its own (Option A).
3. `workflows/` → `commands/` via **`git mv`**. Add **`disable-model-invocation: true`** to every
   command (commands are model-invocable BY DEFAULT — without the flag they auto-fire). Drop
   Antigravity frontmatter (`quick_summary`/`requires_mcp`/`recommends_mcp`).
4. Skills stay model-invocable (no flag); one NL entry point gets a **distinct name** (cortex used
   `vault-search`, not `cx-search`, to avoid command/skill collision).
5. De-hardcode: `c:\HQ\KB` → `{vault_root}`; `c:\HQ\<self>` → `{plugin_root}`; **sibling-toolkit
   refs → optional config** (independence rule — see board's `related_toolkits`).
6. Plugin **agents** need `name`+`description` frontmatter; **quote the description** (a `:` in it
   breaks YAML).
7. Rebuild (`pwsh -File .\.claude\build-skills.ps1` — it reads `workflows/` OR `commands/`).
8. Verify: `claude plugin validate ./<dir>` then
   `claude --plugin-dir ./<dir> -p "/<plugin>:<read-only-cmd>"` (never a side-effectful cmd).

## Gotchas that bit us (don't relearn)

- **`global_workflows` was 29 symlinks + 31 stale copies**, not symlinks. `build-skills.ps1` now
  reads canonical `<toolkit>/` dirs directly (T2.5). Don't reintroduce the middle layer.
- **Reader surface includes `agents/` and `skills/`, not just `workflows/`.** Sweep all three.
- **Markdown-escaped double-backslash paths** (`c:\\HQ\\KB\\`) evade single-`\` greps. Scan with a
  backslash-agnostic check.
- **`pwsh` via a bash pipe sometimes doesn't run** — run builds in a direct PowerShell call.
- **Verify the verifier**: several greps/checks gave false "clean" (escaped-BRE, `-SimpleMatch`
  with `|`, `[char]0x1F512`, a tautological self-test). Prove every audit pattern against a
  known-present string first.
- **Commit HQ's regenerated `.claude/skills/` from `/c/HQ`**, not from inside a toolkit repo (the
  `cd` in a `&&` chain persists — slipped twice).

## Decisions locked

- **Read-only zones = explicit-instruction rule** (not absolute ban): reads always OK; writes to
  `20_Journal`/`50_Finance` only on explicit user approval, destination surfaced with `🔒`.
- **DoD amended (spec §0): KB-reading plugins are Code-verified.** Cowork can't reach a local vault
  (sandboxed VM, no local FS — memory `cowork-skills-scope`); its verification is deferred to
  **Option B (KB MCP)**, the parked project. Not a per-plugin gap.
- **hq-operator is standalone**; `/weekly` moves there; treats pipeline/working-prefs/mistakes as
  OPTIONAL sources.
- **NL allowlist = cx-search only** (per toolkit, add sparingly).

## Migration complete — remaining OWNER follow-ups (none blocking)

**All 16 tasks done.** HQ is dissolved into 5 installed plugins + the `C:\Projects\KB` vault.
What's left is discretionary:

1. ✅ **GitHub publish (done 2026-11-05).** All 5 repos pushed after a privacy sweep; operator
   created as a private repo. A GitHub-based marketplace could now replace the local one.
2. ✅ **Un-migrated specwright workflows (done).** `analyze-job.md` removed (board owns it);
   `ledger.md` deleted.
3. **Read-only vault guards:** the old `c:\HQ\.claude\settings.json` `Write(KB/20_Journal|50_Finance)`
   deny rules are now inert (KB left). Read-only is enforced by each plugin's `config.md` contract;
   add settings-level guards at `C:\Projects\KB` if you open it as its own workspace.
4. **Antigravity symlink registry** (`c:\HQ\.agents\workflows\`, `~/.gemini/…/global_workflows\`) now
   dangles at the moved toolkit paths. Left in place (external to Claude Code) — clean up if unused.
5. **Version bumps:** plugins are all `0.1.0`. Bump `version` (plugin.json + marketplace.json entry)
   on future edits so `claude plugin update` can refresh installs without a full reinstall.

## Verify nothing regressed on resume

`pwsh -File .\.claude\build-skills.ps1` should print "Generated 60 skill(s)" with sources
`board, content-creator, cortex, operator, specwright` (only expected collision: board wins
`analyze-job`). HQ-root skills `/daily`, `/weekly` (now sourced from operator), `/status`,
`/build-skill` (renamed from `/skill`) should exist. Live plugin checks (clean cwd):
`claude --plugin-dir ./<dir> -p "/<plugin>:<read-only-cmd>"` — cortex `cx-search`, content
`content-status`, board `job-status`, specwright `status` all resolve. Operator has no read-only
command (validate-only).
