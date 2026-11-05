# Specwright Configuration

> Conforms to the **KB Access Contract** (Option A), same as the other HQ plugins. See the
> migration's `changes/hq-plugin-migration/kb-access-contract.md` for the full schema.

- **Vault Path** (`vault_root`): C:\Projects\KB
- **Access Method** (`access_method`): filesystem  <!-- future: kb-mcp (Option B) -->

> **`{vault_root}` token.** Commands, agents, and skills refer to the vault as `{vault_root}` (e.g.
> `{vault_root}\99_System\decisions.md`) and never hardcode an absolute path. Resolve it to the
> Vault Path above — the single place the machine-specific vault path lives.
>
> **`{plugin_root}` token.** This plugin's own bundled files (`commands/`, `agents/`, `skills/`,
> `templates/`, `CATALOG.md`, and the plugin-local `changes/` working area) relative to its install
> directory. Claude Code exposes it as `${CLAUDE_PLUGIN_ROOT}`. Pre-install it resolves to
> `specwright/`.

## What this plugin reads from / writes to the vault

Specwright is a development toolkit; most of its state lives in the plugin-local `changes/` folder,
not the vault. It touches the KB vault only to record cross-cutting knowledge (each target is
**optional** — if absent, skip that capture cleanly):

- `{vault_root}\99_System\decisions.md` — `/archive` appends architectural decisions from a change.
- `{vault_root}\99_System\mistakes.md` — the retro step in most dev workflows appends reusable
  lessons.
- `{vault_root}\99_System\now.md` (+ `decisions.md`) — `/work` reads for ambient context.

## Plugin-local working area (NOT the vault)

- `{plugin_root}\changes\<slug>\` — proposal / spec / design / tasks for each change. Managed by
  `/new`, `/specify`, `/plan`, `/work`, `/status`, `/finish`, `/archive`. Stays with the plugin.
- `{plugin_root}\skills\` and `{plugin_root}\CATALOG.md` — the skill library (`/skill`,
  `skill-builder`).

## Read-Only Zones

Inherits the contract: `20_Journal`, `50_Finance` are **read-only**. Reads always allowed; writes
to these zones only on explicit user instruction, with the destination surfaced and approved first
(mark read-only destinations with `🔒`). Specwright's vault writes target `99_System` (writable).
