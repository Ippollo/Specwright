# 📋 Feature Spec: Cortex — Knowledge & Productivity Toolkit

**Created**: 2026-03-06
**Status**: Draft
**Spec Level**: SDD (Spec-Driven Development)

---

## 1. Goal & Context

- **Problem**: Knowledge is trapped in AI chat histories, scattered across apps, and lost when switching tools. Capturing ideas requires context-switching away from the primary workspace (Antigravity), which kills the habit. The existing Obsidian vault is underutilized because the input friction is too high.
- **User**: Solo developer/builder who lives in Antigravity IDE and wants a unified knowledge system.
- **Value**: Externalizes the second brain into portable, AI-agnostic markdown. Eliminates context-switch friction for capture. Makes Obsidian useful again by separating input (Antigravity) from consumption (Obsidian).

## 2. User Scenarios (Prioritized)

> [!TIP]
> Each scenario should be an independently testable slice of functionality.

### Story 1: Quick Capture (Priority: P1)

- **Journey**: User is working in Antigravity, has an idea or learning. They run `/capture "thought about X"` and the note is instantly saved to the Obsidian vault's `00_Inbox` with a timestamp. No context switch, no friction.
- **Value**: P1 because this is the atomic habit — if capture doesn't work, nothing else matters. Solves the #1 stated pain point (context-switching to Obsidian).
- **Acceptance Scenarios**:
  - **Given** the user is in Antigravity, **When** they run `/capture "My observation about Y"`, **Then** a new markdown file is created in `C:\Projects\Notepad\00_Inbox\` with the content, a timestamp, and a unique filename
  - **Given** the user runs `/capture` with a `#tag`, **When** the note is created, **Then** the tag is preserved in the note body (Obsidian-compatible `#tag` format)
  - **Given** no vault path is configured, **When** `/capture` is run, **Then** the workflow prompts for the vault path and saves it for future use

### Story 2: Process Inbox (Priority: P1)

- **Journey**: User runs `/inbox` to process accumulated captures. The AI presents each inbox item and helps decide: file it to the right folder, expand it, connect it to existing notes, or discard it. One by one, the inbox empties.
- **Value**: P1 because capture without processing creates a junk drawer. This is the second half of the habit loop.
- **Acceptance Scenarios**:
  - **Given** there are 5 notes in `00_Inbox`, **When** the user runs `/inbox`, **Then** each note is presented with AI-suggested actions (move to folder, expand, connect, discard)
  - **Given** the user chooses to file a note to `20_Ideas`, **When** confirmed, **Then** the file is moved from `00_Inbox` to `20_Ideas`
  - **Given** the user chooses to expand a note, **When** confirmed, **Then** the AI helps flesh out the note with prompts and structure before filing

### Story 3: Connect Notes (Priority: P2)

- **Journey**: User runs `/connect` on a note or after filing from inbox. The AI scans the vault for related notes and suggests `[[wikilinks]]` to add. User approves or rejects each suggestion.
- **Value**: P2 because connections are what make a knowledge base compound over time, but the system works without them initially.
- **Acceptance Scenarios**:
  - **Given** a note about "Agentic Apps", **When** `/connect` is run, **Then** the AI suggests links to existing notes like `Building Agentic apps.md` and `My Productivity Workflow.md`
  - **Given** the user approves a connection, **When** confirmed, **Then** a `[[wikilink]]` is added to the note body in Obsidian-compatible format
  - **Given** no related notes are found, **When** `/connect` is run, **Then** the AI reports no connections and suggests creating a seed note

### Story 4: Synthesize Notes (Priority: P2)

- **Journey**: User has several notes on a topic and wants to combine them into a higher-level insight. They run `/synthesize "topic"` and the AI reads related notes, produces a synthesis note, and links back to the sources.
- **Value**: P2 because synthesis is the knowledge payoff — turning fragments into understanding.
- **Acceptance Scenarios**:
  - **Given** 4 notes tagged `#Productivity`, **When** the user runs `/synthesize "productivity"`, **Then** a new synthesis note is created that combines insights from the 4 source notes
  - **Given** a synthesis is created, **When** saved, **Then** the note includes `[[wikilinks]]` back to each source note

### Story 5: Review for Retention (Priority: P2)

- **Journey**: User runs `/review` and the AI surfaces notes they haven't seen in a while, prioritizing high-value or frequently-connected notes. A lightweight spaced-repetition prompt.
- **Value**: P2 because review prevents knowledge decay, but it's a habit built on top of an existing base.
- **Acceptance Scenarios**:
  - **Given** 50 notes in the vault, **When** `/review` is run, **Then** 3–5 notes are surfaced based on recency (least recently modified) and connectivity (most linked)
  - **Given** a note is surfaced, **When** the user reads it, **Then** they can choose to update it, connect it, or mark it as reviewed

### Story 6: Map of Content (Priority: P3)

- **Journey**: User runs `/map "topic"` and the AI generates or updates a Map of Content (MOC) — a note that serves as a table of contents for all notes on that topic.
- **Value**: P3 because MOCs are powerful for navigation but require a critical mass of notes first.
- **Acceptance Scenarios**:
  - **Given** 8 notes related to "Career", **When** `/map "career"` is run, **Then** a MOC note is created in the vault with `[[wikilinks]]` to all related notes, grouped by subtopic
  - **Given** a MOC already exists, **When** `/map` is run again, **Then** the MOC is updated with any new notes since last generation

### Story 7: Daily Note (Priority: P3)

- **Journey**: User runs `/daily` and a daily note is created with today's date, prompts for reflection, and links to recent captures or in-progress ideas.
- **Value**: P3 because daily notes are a journaling habit that builds on the system, not a prerequisite.
- **Acceptance Scenarios**:
  - **Given** today is 2026-03-06, **When** `/daily` is run, **Then** a note named `2026-03-06.md` is created with a template including prompts and links to recent inbox items
  - **Given** a daily note for today already exists, **When** `/daily` is run again, **Then** the existing note is opened/displayed rather than creating a duplicate

### Story 8: Search (Priority: P3)

- **Journey**: User runs `/search "topic"` and the AI performs a semantic search across the vault, returning the most relevant notes even if the exact words don't match.
- **Value**: P3 because the vault is small enough to browse manually right now, but this becomes essential at scale.
- **Acceptance Scenarios**:
  - **Given** a vault with 50+ notes, **When** `/search "how I manage my time"` is run, **Then** notes like `My Productivity Workflow.md` and `The Perfect Work Day.md` are returned
  - **Given** a search returns results, **When** the user selects a note, **Then** the note content is displayed inline

## 3. Constraints

### Must

- All notes are plain markdown — readable without any AI tool
- Use Obsidian-compatible conventions: `[[wikilinks]]`, `#tags` (not YAML frontmatter tags, since existing notes use `#tag` format)
- Respect the existing vault folder structure by default, but can suggest restructuring with user confirmation
- Toolkit architecture matches Specwright pattern: `workflows/`, `agents/`, `skills/`, `templates/`
- Cortex lives in its own project folder (`C:\Projects\cortex`), fully independent from other toolkits
- Vault path is configurable (not hardcoded to `C:\Projects\Notepad`)

### Must Not

- Must not modify Obsidian's `.obsidian/` configuration directory
- Must not require Obsidian to be running for any workflow to work
- Must not introduce YAML frontmatter into existing notes that don't have it
- Must not create coupling to Specwright or any other toolkit
- Must not use proprietary formats — everything stays portable markdown

### Out of Scope

- Obsidian plugin development
- Multi-vault support
- Cloud sync (handled by Obsidian Sync, Syncthing, or Git — user's choice)
- Mobile input (handled by Obsidian mobile app)

---

## 4. Functional Requirements

- **FR-001**: Vault configuration — workflows must know where the vault is. Store path in a config file within the toolkit (e.g., `cortex/config.md` or similar).
- **FR-002**: Note creation — `/capture` creates a new `.md` file with a generated filename (timestamp-based or slugified title), content body, and optional `#tags`.
- **FR-003**: Note filing — `/inbox` moves files between vault folders, preserving content and updating any `[[wikilinks]]` that reference the moved file.
- **FR-004**: Link suggestion — `/connect` scans vault note titles and content to suggest `[[wikilinks]]`, using AI for semantic similarity not just keyword matching.
- **FR-005**: Synthesis — `/synthesize` reads multiple notes and produces a new note that combines insights, with source attribution via `[[wikilinks]]`.
- **FR-006**: Review surfacing — `/review` uses file modification dates and link counts to prioritize which notes to surface.
- **FR-007**: MOC generation — `/map` creates a structured index note by scanning vault content for topic relevance.
- **FR-008**: Daily note — `/daily` uses a template to create a dated note in a consistent location.
- **FR-009**: Search — `/search` uses grep/semantic matching to find relevant notes and display results.

### Edge Cases

- Filename collisions during capture (append incrementing suffix)
- Notes with identical titles in different folders (use full path in wikilinks)
- Empty inbox when `/inbox` is run (report "inbox clear" and exit gracefully)
- Very large vaults (performance — scope for now is < 500 notes)

## 5. Current State

> [!NOTE]
> This is a greenfield project — no existing toolkit code. The vault already exists.

- **Relevant files**: `C:\Projects\Notepad/` (existing Obsidian vault)
- **Existing patterns to follow**: Specwright architecture (`c:\Projects\specwright/` — workflows, agents, skills, templates pattern)
- **Related systems**: Obsidian (desktop + mobile), Syncthing (`.stfolder` and `.stignore` present in vault, suggesting Syncthing sync is configured)

---

## 6. Tasks

> [!TIP]
> Tasks to be detailed during `/plan` phase. High-level breakdown below.

### Phase 1: Foundation (P1 Stories)

- T1: Create `cortex/` project structure (workflows, agents, skills, templates dirs, README, CATALOG)
- T2: Create vault configuration mechanism
- T3: Build `/capture` workflow
- T4: Build `/inbox` workflow
- T5: Create note templates (fleeting, permanent)

### Phase 2: Connections (P2 Stories)

- T6: Build `/connect` workflow
- T7: Build `/synthesize` workflow
- T8: Build `/review` workflow

### Phase 3: Navigation (P3 Stories)

- T9: Build `/map` workflow
- T10: Build `/daily` workflow
- T11: Build `/search` workflow

---

## 7. Success Criteria

- **SC-001**: `/capture` creates a note in `00_Inbox` in under 3 seconds with no context switch required
- **SC-002**: `/inbox` can process and file 5 notes in a single session
- **SC-003**: Notes created by Cortex are visible in Obsidian immediately (graph view, search, mobile) with no manual intervention
- **SC-004**: `[[wikilinks]]` created by `/connect` resolve correctly in Obsidian
- **SC-005**: The entire toolkit works if you delete the AI and just read the markdown files — nothing is locked in
- **SC-006**: A new user could clone the repo, point it at their vault, and be capturing in < 5 minutes

---

## 8. Technical Context (Optional for Specify Phase)

_To be filled during /plan phase._

- **Tech Stack**: Plain markdown workflows + Antigravity-compatible SKILL.md / workflow.md files
- **Dependencies**: None beyond Antigravity and a markdown editor

---

## 9. Acceptance Traceability

> [!TIP]
> Initially blank during `/specify`. Populated during `/plan` (verification method) and `/work` (status updates). Audited during `/final-polish`.

| ID     | Criterion                                | Verification | Status |
| ------ | ---------------------------------------- | ------------ | ------ |
| SC-001 | Capture with no context switch (< 3s)    |              | ⏳     |
| SC-002 | Process 5 inbox notes in one session     |              | ⏳     |
| SC-003 | Notes visible in Obsidian immediately    |              | ⏳     |
| SC-004 | Wikilinks resolve in Obsidian            |              | ⏳     |
| SC-005 | Toolkit works without AI (portable md)   |              | ⏳     |
| SC-006 | New user capturing in < 5 min from clone |              | ⏳     |
