# Proposal: HQ → Plugins Migration

## Intent

Dissolve the HQ monorepo into a collection of **independent** Claude plugins backed by a
single **Obsidian (KB) database**. Today HQ is a root container (`AGENTS.md` router +
symlink registry + `build-skills.ps1`) tying together per-toolkit repos whose skills
hard-code `c:\HQ\` paths (~229 refs) and silently share root context (`me.md`, `now.md`,
`decisions.md`, voice guide). That coupling makes the toolkits un-shareable and un-installable
on their own, and ties every workflow to this one machine's layout.

End state = **two layers only**: plugins (pure logic, independently installable) + KB (the
system of record). No HQ root, no `AGENTS.md`, no symlink registry.

**Independence rule (hard line):** a plugin may depend on *itself*, on *KB*, and on *user
config* — **never on another plugin**. Shared needs (identity, voice, house style, focus)
are read from KB, not by reaching into a sibling plugin.

Full design: `hq-plugin-migration-spec.md` (root). Companion context:
`cowork-operating-layer.md`, `cortex/config.md` (the Option A path precedent).

## Scope

**In scope:**

- **Phase 1 — KB as the data layer.** Move root context into KB (`me.md`, `now.md`,
  `decisions.md`, voice guide, working-preferences, mistakes, a new house-style note; move
  `board/pipeline.md` + archive into `KB/40_Knowledge/jobs/`). Stand up the Option A
  config-path contract. Repoint every live reader *in lockstep* so `/daily`, `/weekly`, etc.
  never break mid-migration. Verify read-only zones (`KB/20_Journal/`, `KB/50_Finance/`)
  stay unwritable.
- **Phase 2 — pluginize `hq-cortex`** as the reference pattern (2 skills, 9 `cx-*`
  workflows, owns KB, has the `config.md` precedent). Add `plugin.json`; normalize
  frontmatter; workflows → commands, capabilities → skills; de-hardcode its ~60 `c:\HQ\`
  refs → config. Install-test in **both Cowork and Code**. Capture a repeatable checklist.
- **Phase 3 — repeat the pattern** for `hq-content` (~37), `hq-board` (~113, heaviest),
  `hq-specwright` (~28, `changes/` stays plugin-local), `hq-operator` (reads KB only;
  `/daily` + `/weekly` + `/status` + multiscale planning).
- **Phase 4 — decommission HQ.** Remove routing, symlink registry, `build-skills.ps1`,
  `AGENTS.md`; each plugin to its own repo; register a personal marketplace; retire `c:\HQ\`.

**Out of scope:**

- **`altimeter/`** — an Antigravity IDE token-monitor extension, not a workflow toolkit.
  Left untouched.
- **`ledger/`** — a standalone Node finance app + `/ledger` skill. Deferred: **decide later**
  (6th plugin vs. standalone vs. fold into KB finance) after the reference plugin proves out.
  Not part of the 5-plugin set for this change.
- **Option B (KB MCP server).** Parked as a future KB project; Option A (config paths) ships
  first. Revisit once plugins are live.
- Connector setup (Todoist/Gmail/Calendar) and scheduled tasks — Cowork app-side, not code.

## Approach

Dogfood specwright: `/specify` → `/plan` → `/work`, phased per the spec's §6.

1. **Phase 0 (this change's prep):** classify each workflow as command vs. model-invocable
   skill (default: workflows → commands, capabilities → skills, plus a short allowlist of
   natural-language entry points — likely daily brief, `/status`, `cx-search`). Confirm
   current Claude Code command/skill/plugin primitives (namespacing, skill-wins-on-collision)
   before building.
2. **Guardrail-first sequencing:** Phase 1 restructures files the running skills read — move
   data *and* repoint readers together, never one without the other. Test each phase on both
   surfaces (Cowork + Code).
3. **KB access = Option A:** generalize `cortex/config.md` into a per-plugin config carrying
   the vault root + access method; skills read paths from config, not literals.
4. Prove the whole model end-to-end with Phase 1 + `hq-cortex`; everything after is repetition
   of a known-good, written-down checklist.
