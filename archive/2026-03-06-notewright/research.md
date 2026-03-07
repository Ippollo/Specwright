# Research: Cortex

## PKM Methodology Survey

### Zettelkasten (Slip-Box Method)

- Originated by Niklas Luhmann — sociologist who produced 70+ books using a system of ~90,000 interconnected index cards
- **Core principles**: Atomic notes (one idea per note), connections between notes matter more than categories, permanent notes are written in your own words
- **Note types**:
  - **Fleeting notes**: Quick captures, raw thoughts — temporary, processed later
  - **Literature notes**: Key takeaways from a source, in your own words
  - **Permanent notes**: Refined, atomic ideas that stand on their own — the "real" knowledge base
- **Relevance to Cortex**: Maps directly to `00_Inbox` (fleeting) → processing → filed notes (permanent). The `/capture` → `/inbox` pipeline IS the Zettelkasten workflow.

### Progressive Summarization (Tiago Forte / Building a Second Brain)

- **Core idea**: Don't organize upfront — capture generously, then progressively distill notes each time you revisit them
- **Layers**: Layer 0 (original), Layer 1 (bold key passages), Layer 2 (highlight within bold), Layer 3 (executive summary), Layer 4 (remix into your own work)
- **PARA organization**: Projects, Areas, Resources, Archive
- **Relevance to Cortex**: The `/review` workflow naturally enables progressive summarization — each review pass is an opportunity to distill further. The existing folder structure (Inbox, Reflection, Ideas, Reference) loosely maps to PARA.

### Maps of Content (Nick Milo / Linking Your Thinking)

- **Core idea**: MOCs are navigational notes that link to related notes on a topic — like a table of contents you create yourself
- **When to create**: When a topic accumulates enough notes (>5) that browsing becomes unwieldy
- **Structure**: A MOC is just a note with curated `[[wikilinks]]` organized by subtopic
- **Relevance to Cortex**: The `/map` workflow automates MOC creation with AI-assisted topic detection

## Obsidian Conventions

### File Format

- Plain markdown with optional YAML frontmatter
- **Current vault uses**: No frontmatter, `#tags` in note body (not frontmatter), free-form prose
- **Wikilinks**: `[[Note Title]]` or `[[Note Title|Display Text]]` — Obsidian resolves by filename, not path
- **Tags**: `#tag` or `#nested/tag` — inline in the note body

### File Naming

- Obsidian allows spaces in filenames
- Current vault uses descriptive titles with spaces (e.g., `Building Agentic apps.md`)
- No date prefixes in current notes
- For Cortex captures, a timestamp-slugified approach works: `2026-03-06 My thought.md`

### Folder Structure

- Current vault uses numbered prefixes (`00_`, `10_`, etc.) for sort order
- Obsidian treats folders as organizational only — wikilinks work across folders without path specification
- Moving files does NOT break `[[wikilinks]]` — Obsidian auto-updates links on rename/move (when Obsidian is running)
- **Important**: When Cortex moves files, Obsidian may not auto-update links if it's not running. Cortex should handle link updates itself.

### Syncthing Integration

- Vault has `.stfolder` and `.stignore` — Syncthing is configured for sync
- Syncthing syncs the raw files — any changes Cortex makes will sync automatically
- No special handling needed; just write markdown to the vault directory

## Specwright Architecture Patterns

### Workflow File Convention

```yaml
---
description: One-line description for catalog/discovery
quick_summary: "Brief action summary for quick reference"
requires_mcp: []
recommends_mcp: [server1, server2]
---
```

Followed by: `# /name - Title`, `**Goal**:`, `## When to Use`, `## Steps`, `## Usage`, `## Next Steps`

### Agent File Convention

```yaml
---
description: Role description
requires_mcp: []
recommends_mcp: []
---
```

Followed by: Role description, Capabilities, Primary Skills, Recommended MCP Servers, Process

### Skill Convention

- `SKILL.md` file with frontmatter (name, description, version, trigger phrases)
- Reference materials in subdirectories
- Loaded conditionally based on description match

## Key Design Decisions

1. **No frontmatter for captured notes**: Existing vault notes don't use frontmatter. Cortex should follow suit and use `#tags` inline.
2. **Filename format for captures**: `YYYY-MM-DD Title.md` — sortable, human-readable, compatible with Obsidian daily notes plugin if used later.
3. **Link management**: Cortex must update `[[wikilinks]]` when moving files, since Obsidian won't auto-update if it's not running at the time.
4. **Agent design**: Cortex needs fewer agents than Specwright. A single "Librarian" agent covers most knowledge tasks (filing, connecting, organizing). A "Synthesizer" handles combining notes.
5. **Vault path configuration**: Store in a `config.md` file in the Cortex toolkit root, not in the vault itself. This keeps the toolkit portable.
