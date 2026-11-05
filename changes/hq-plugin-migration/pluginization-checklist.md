# Pluginization Checklist (from doing hq-cortex once)

The repeatable procedure for turning an HQ toolkit into a Claude Code plugin, derived from T11–T13
on `cortex` and **verified against Claude Code v2.1.81**. Apply to hq-content, hq-board,
hq-specwright, hq-operator (T14).

> **Verified facts (not assumptions).** These were confirmed against the live docs
> (`code.claude.com/docs/en/plugins`, `/plugins-reference`) and by actually loading the plugin:
> - Manifest: `.claude-plugin/plugin.json`; **required `name`**, optional `version`/`description`/
>   `author`/`homepage`/`repository`/`license`/`keywords`. `claude plugin validate ./<dir>` checks it.
> - Components at plugin **root** (never inside `.claude-plugin/`): `skills/<name>/SKILL.md`,
>   `commands/*.md` (flat; "Skills as flat Markdown files" — docs prefer `skills/` for new plugins),
>   `agents/`, `hooks/`, `.mcp.json`.
> - **Everything is invoked namespaced**: `/<plugin-name>:<name>` (e.g. `/hq-cortex:cx-search`).
> - **Both commands and skills are model-invocable by default.** To make one explicit-only, set
>   `disable-model-invocation: true` in its frontmatter. *(This is the step that's easy to miss —
>   without it, every command auto-loads into context and can auto-fire.)*
> - Plugin's own files resolve via **`${CLAUDE_PLUGIN_ROOT}`** (our `{plugin_root}` token).
> - Local testing: **`claude --plugin-dir ./<dir>`** — no marketplace needed. `/reload-plugins`
>   picks up edits.

## Steps

1. **Manifest** — `.claude-plugin/plugin.json` with `name` (kebab-case; becomes the namespace),
   `version`, `description`, `author`. Nothing else goes in `.claude-plugin/`.

2. **Commands** — put explicit slash procedures in `commands/*.md`. **Add
   `disable-model-invocation: true`** to each (else it becomes model-invocable). Strip Antigravity
   frontmatter (`quick_summary`, `requires_mcp`, `recommends_mcp`); keep `description`.

3. **Skills** — capability/knowledge skills in `skills/<name>/SKILL.md`, `name` kebab-case,
   strong `description` (drives model-invocation), **no** `disable-model-invocation` if you want it
   auto-invoked. Drop non-standard `version`/`triggers`/`metadata`.

4. **Natural-language entry point** — for the one skill that should trigger from plain English,
   give it a **distinct name** from any command (a skill and a command with the same name collide;
   we named the search skill `vault-search`, not `cx-search`).

5. **De-hardcode paths** — replace `c:\HQ\KB` with the `{vault_root}` token (resolved from
   `config.md`) and plugin-own-file paths with `{plugin_root}` / `${CLAUDE_PLUGIN_ROOT}`. Leave
   exactly **one** real path: `config.md`'s `vault_root`. Add a resolution pointer in each command.

6. **Config** — `config.md` carries `vault_root`, the logical folder map, `read_only` zones, and
   defines the `{vault_root}`/`{plugin_root}` tokens. It's the only place the machine-specific path
   lives.

7. **Read-only guards** — mark any write path into `20_Journal`/`50_Finance` with `🔒`;
   explicit-approval rule (never auto-file). See `kb-access-contract.md` §5.

8. **Transition** — keep the toolkit generating into `.claude/skills/` via `build-skills.ps1`
   (which reads `workflows/` OR `commands/`) until the plugin is installed; then drop the toolkit
   from the generator's `$toolkits` list so commands aren't double-served.

9. **Validate + test**
   - `claude plugin validate ./<dir>` → must print "Validation passed".
   - `claude --plugin-dir ./<dir> -p "/<plugin>:<a-read-only-command> <arg>"` → confirm it runs and
     resolves `{vault_root}` against the live vault. (Use a **read-only** command; never a
     side-effectful one like `cx-harvest` in a smoke test.)
   - `claude --plugin-dir ./<dir> -p "list the plugin's model-invocable skills"` → confirm the
     skills register namespaced. *(Note: in headless `-p` mode the model cannot enumerate slash
     commands — that's a print-mode visibility limit, not a failure; invoke one to confirm.)*

## ⚠️ The two-surface reality (Option A)

The spec/kickoff require "verified in both Cowork **and** Code." **Under Option A this is not
achievable for a filesystem-vault plugin.** Cowork runs in a sandboxed Linux VM with **no access to
the local Windows filesystem** (confirmed via claude-code-guide, 2026-07-14; see memory
`cowork-skills-scope`). hq-cortex reads `c:\HQ\KB` — that path doesn't exist in Cowork's sandbox,
so its commands cannot function there. Packaging fixes **visibility**, not **function**.

- **Code surface**: ✅ fully verifiable (and verified for hq-cortex).
- **Cowork surface**: ❌ blocked by design for any filesystem-vault plugin. Only **Option B
  (KB MCP)** makes the vault reachable from Cowork's sandbox — this is precisely the benefit the
  spec attributes to Option B (§3.3). Until then, KB-reading plugins are Code-only.

**Implication for the milestone's "both surfaces" DoD:** met on Code; the Cowork half is deferred
to the parked KB MCP project, not a gap in the plugin build. Plugins with **no** local-file
dependency (pure drafting/brainstorming) would be the exception and could be Cowork-verified.
