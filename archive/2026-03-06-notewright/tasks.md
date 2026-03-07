# Tasks: Cortex

> All tasks create markdown files — no code in the traditional sense. Workflow labels indicate which Specwright workflow _pattern_ the task follows for structure and review.

## Phase 1: Project Setup

- [ ] `/backend` — Create `C:\Projects\cortex\` directory with subdirectories: `workflows/`, `agents/`, `skills/`, `templates/`
- [ ] `/backend` — Create `cortex/config.md` with vault path configuration (default: `C:\Projects\Notepad`)

## Phase 2: Templates

- [ ] `/design` — [P] Create `templates/fleeting.md` (quick capture template)
- [ ] `/design` — [P] Create `templates/permanent.md` (refined note template)
- [ ] `/design` — [P] Create `templates/literature.md` (source notes template)
- [ ] `/design` — [P] Create `templates/synthesis.md` (synthesis note template)
- [ ] `/design` — [P] Create `templates/moc.md` (Map of Content template)
- [ ] `/design` — [P] Create `templates/daily.md` (daily note template)
- **CHECKPOINT**: All 6 templates exist and follow Obsidian conventions (#tags, [[wikilinks]])

## Phase 3: Skills

- [ ] `/backend` — Create `skills/pkm-methodology/SKILL.md` (Zettelkasten, Progressive Summarization, MOCs)
- [ ] `/backend` — [P] Create `skills/obsidian-conventions/SKILL.md` (wikilinks, tags, file naming, link management)
- **CHECKPOINT**: Skills are complete and reference current vault conventions

## Phase 4: Agents

- [ ] `/backend` — Create `agents/librarian.md` (files, organizes, connects, suggests restructuring)
- [ ] `/backend` — [P] Create `agents/synthesizer.md` (combines notes, finds patterns, attributes sources)
- **CHECKPOINT**: Agents reference correct skills and have clear capabilities

## Phase 5: P1 Workflows (Foundation)

- [ ] `/backend` — Create `workflows/capture.md` (quick capture to inbox)
- [ ] `/backend` — Create `workflows/inbox.md` (process inbox with Librarian agent)
- **CHECKPOINT**: `/capture` creates a note visible in Obsidian. `/inbox` processes and files notes.

## Phase 6: P2 Workflows (Connections)

- [ ] `/backend` — Create `workflows/connect.md` (AI-suggested wikilinks)
- [ ] `/backend` — Create `workflows/synthesize.md` (combine notes into insights)
- [ ] `/backend` — Create `workflows/review.md` (spaced repetition surfacing)
- **CHECKPOINT**: `/connect` adds valid wikilinks. `/synthesize` produces linked synthesis notes.

## Phase 7: P3 Workflows (Navigation)

- [ ] `/backend` — Create `workflows/map.md` (generate Maps of Content)
- [ ] `/backend` — Create `workflows/daily.md` (daily note creation)
- [ ] `/backend` — Create `workflows/search.md` (semantic vault search)
- **CHECKPOINT**: All 8 workflows functional end-to-end

## Phase 8: Documentation & Polish

- [ ] `/enhance` — Create `README.md` with project overview, quick start, and architecture diagram
- [ ] `/enhance` — Create `CATALOG.md` indexing all workflows, agents, skills, and templates
- [ ] `/enhance` — Initialize git repo and create `.gitignore`
- **CHECKPOINT**: Ready for GitHub — clone, configure, capture in < 5 minutes
