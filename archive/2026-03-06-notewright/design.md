# Plan: Cortex — Knowledge & Productivity Toolkit

## Architecture

Cortex is a standalone toolkit at `C:\Projects\cortex` that provides AI-powered knowledge management workflows operating on an Obsidian vault (`C:\Projects\Notepad`).

```
C:\Projects\cortex\
├── config.md                # Vault path + user preferences
├── workflows/
│   ├── capture.md           # Quick capture to inbox
│   ├── inbox.md             # Process inbox items
│   ├── connect.md           # AI-suggested wikilinks
│   ├── synthesize.md        # Combine notes into insights
│   ├── review.md            # Spaced repetition surfacing
│   ├── map.md               # Generate Maps of Content
│   ├── daily.md             # Daily note with prompts
│   └── search.md            # Semantic vault search
├── agents/
│   ├── librarian.md         # Files, organizes, connects notes
│   └── synthesizer.md       # Combines notes into insights
├── skills/
│   ├── pkm-methodology/     # Zettelkasten, Progressive Summarization
│   │   └── SKILL.md
│   └── obsidian-conventions/# Wikilinks, tags, file naming, vault structure
│       └── SKILL.md
├── templates/
│   ├── fleeting.md          # Quick capture template
│   ├── permanent.md         # Refined note template
│   ├── literature.md        # Source/reading notes template
│   ├── synthesis.md         # Synthesis note template
│   ├── moc.md               # Map of Content template
│   └── daily.md             # Daily note template
├── README.md
└── CATALOG.md
```

### Component Design

#### Config (`config.md`)

Simple markdown file storing vault path and preferences:

```markdown
# Cortex Configuration

- **Vault Path**: C:\Projects\Notepad
- **Inbox Folder**: 00_Inbox
- **Daily Notes Folder**: 10_Reflection
- **Default Tags**: (none)
```

Workflows read this file to know where the vault is. On first run, if config doesn't exist, prompt the user and create it.

#### Workflows

Each workflow follows Specwright conventions:

- YAML frontmatter (`description`, `quick_summary`, `requires_mcp`, `recommends_mcp`)
- Sections: Goal, When to Use, Steps, Usage, Next Steps
- `// turbo-all` annotation where safe for auto-run

**P1 Workflows (Foundation):**

1. **`/capture`** — Reads the user's input, creates a timestamped markdown file in the inbox folder. No AI reasoning needed — pure file creation. This must be fast and frictionless.

2. **`/inbox`** — Reads all files in the inbox folder. For each: show content, suggest a target folder, offer to expand/connect/discard. Uses the Librarian agent. Interactive — one note at a time.

**P2 Workflows (Connections):**

3. **`/connect`** — Scans vault for notes related to the current note (by title matching, tag overlap, and AI semantic similarity). Suggests `[[wikilinks]]` to add. User approves each.

4. **`/synthesize`** — Takes a topic, finds all related notes, reads them, produces a new synthesis note linking back to sources. Uses the Synthesizer agent.

5. **`/review`** — Finds notes not modified recently, prioritizes by link count (well-connected notes are higher value). Surfaces 3-5 notes with prompts to update, connect, or mark as reviewed.

**P3 Workflows (Navigation):**

6. **`/map`** — Generates or updates a Map of Content for a topic. Scans vault for related notes, groups by subtopic, creates a structured note with `[[wikilinks]]`.

7. **`/daily`** — Creates a dated note (`YYYY-MM-DD.md`) in the configured daily folder with templated prompts and links to recent captures.

8. **`/search`** — Uses grep/file search across the vault, enhanced with AI to find semantically related notes even without exact keyword matches.

#### Agents

**Librarian** — The primary agent. Thinks like a knowledge curator:

- Understands the vault's folder structure and what belongs where
- Suggests filing locations based on content analysis
- Suggests `[[wikilinks]]` based on semantic similarity
- Can propose vault restructuring (new folders, reorganization) with user confirmation
- References `pkm-methodology` and `obsidian-conventions` skills

**Synthesizer** — The insight builder:

- Reads multiple notes on a topic and finds patterns
- Produces a coherent synthesis that isn't just a concatenation
- Attributes ideas to source notes with `[[wikilinks]]`
- References `pkm-methodology` skill

#### Skills

**`pkm-methodology`** — Covers:

- Zettelkasten principles (atomic notes, fleeting → permanent pipeline)
- Progressive summarization (distillation on review)
- MOC patterns (when to create, how to structure)
- Note quality indicators (a good permanent note is atomic, linked, in your own words)

**`obsidian-conventions`** — Covers:

- Wikilink syntax (`[[Title]]`, `[[Title|Alias]]`)
- Tag syntax (`#tag`, `#parent/child`)
- Frontmatter (when to use, when to skip — current vault skips it)
- File naming conventions
- Folder structure patterns
- Link management when moving files
- Compatibility considerations (what works when Obsidian isn't running)

#### Templates

All templates are markdown files the workflows use when creating notes:

- **`fleeting.md`** — Minimal: timestamp, content, optional tags. Used by `/capture`.
- **`permanent.md`** — Title, content, related links section, tags. Used when refining notes during `/inbox`.
- **`literature.md`** — Source info, key takeaways, own thoughts. For notes from reading/watching/listening.
- **`synthesis.md`** — Topic, synthesized insight, source links. Used by `/synthesize`.
- **`moc.md`** — Topic title, grouped wikilinks by subtopic. Used by `/map`.
- **`daily.md`** — Date, reflection prompts, links to recent captures. Used by `/daily`.

## Checklist

### Phase 1: Project Setup

- [ ] Create `C:\Projects\cortex/` directory structure
- [ ] Create `config.md` with vault path configuration
- [ ] Create `README.md` with project overview and quick start
- [ ] Create `CATALOG.md` indexing all components
- **CHECKPOINT**: Directory structure exists, README is readable

### Phase 2: Templates (Dependency for workflows)

- [ ] Create `templates/fleeting.md`
- [ ] Create `templates/permanent.md`
- [ ] Create `templates/literature.md`
- [ ] Create `templates/synthesis.md`
- [ ] Create `templates/moc.md`
- [ ] Create `templates/daily.md`
- **CHECKPOINT**: All 6 templates exist and follow Obsidian conventions

### Phase 3: Skills (Dependency for agents)

- [ ] Create `skills/pkm-methodology/SKILL.md`
- [ ] Create `skills/obsidian-conventions/SKILL.md`
- **CHECKPOINT**: Skills are readable and cover the conventions needed by agents

### Phase 4: Agents (Dependency for workflows)

- [ ] Create `agents/librarian.md`
- [ ] Create `agents/synthesizer.md`
- **CHECKPOINT**: Agents reference correct skills and have clear capabilities

### Phase 5: P1 Workflows (Foundation)

- [ ] Create `workflows/capture.md`
- [ ] Create `workflows/inbox.md`
- **CHECKPOINT**: Can `/capture` a note and see it in Obsidian. Can `/inbox` to process and file it.

### Phase 6: P2 Workflows (Connections)

- [ ] Create `workflows/connect.md`
- [ ] Create `workflows/synthesize.md`
- [ ] Create `workflows/review.md`
- **CHECKPOINT**: Can `/connect` a note and see wikilinks in Obsidian. Can `/synthesize` a topic.

### Phase 7: P3 Workflows (Navigation)

- [ ] Create `workflows/map.md`
- [ ] Create `workflows/daily.md`
- [ ] Create `workflows/search.md`
- **CHECKPOINT**: All 8 workflows functional

### Phase 8: Polish

- [ ] Initialize git repo
- [ ] Final README polish
- [ ] CATALOG completeness check
- **CHECKPOINT**: Ready for GitHub

## Verification

### Manual Testing (per phase)

- **Phase 5**: Run `/capture "Test note"` → verify file appears in `C:\Projects\Notepad\00_Inbox\` → open Obsidian → confirm note is visible
- **Phase 5**: Run `/inbox` → process the test note → verify it moves to the correct folder
- **Phase 6**: Run `/connect` on a note with related content → verify `[[wikilinks]]` are valid in Obsidian
- **Phase 6**: Run `/synthesize "productivity"` → verify synthesis note links back to sources
- **Phase 7**: Run `/map "career"` → verify MOC has correct wikilinks
- **Phase 7**: Run `/daily` → verify dated note appears in configured folder

### Acceptance Criteria Validation

- SC-001: Time `/capture` — should complete in < 3 seconds
- SC-002: Process 5 test inbox notes in one `/inbox` session
- SC-003: Check Obsidian graph view after creating Cortex notes
- SC-004: Click `[[wikilinks]]` in Obsidian to verify they resolve
- SC-005: Read any Cortex-created note in a plain text editor
- SC-006: Clone repo fresh, configure vault path, run `/capture`
