# Proposal: Cortex — Knowledge & Productivity Toolkit

## Intent

Knowledge is locked inside AI chat histories. When you switch providers, you rebuild from scratch. Specwright solved this for _workflows_ — your dev process is portable markdown. But your _knowledge_ (context, decisions, learnings, ideas) is still trapped in conversation logs and provider-specific memory systems.

**Cortex** externalizes your second brain into plain markdown files with AI-powered workflows for capturing, connecting, reviewing, and synthesizing knowledge. It becomes the **foundation layer** that all other toolkits (Specwright, Publishwright, etc.) read from and write to.

Inspired by [this X post from Tom Solid](https://x.com/TomSolidPM): _"The real play is building a system where your context, decisions, and workflows live outside any single AI tool. Then switching providers is just swapping the engine, not rebuilding the car."_

### Architecture: Obsidian + Antigravity

Cortex doesn't replace Obsidian — it **complements** it. Two tools, one vault, different jobs:

| Layer            | Tool                                       | What it does                                                              |
| ---------------- | ------------------------------------------ | ------------------------------------------------------------------------- |
| **AI Workflows** | **Cortex (Antigravity)**                   | Capture without context-switching, auto-link, synthesize, review, surface |
| **Storage & UI** | **Obsidian**                               | Graph view, mobile access, sync, visual browsing, community plugins       |
| **Files**        | **Obsidian vault (`C:\Projects\Notepad`)** | Plain markdown, shared by both tools simultaneously                       |

The existing vault already has a solid structure:

- `00_Inbox` — Capture zone
- `10_Reflection` — Personal reflections (22 notes)
- `20_Ideas` — Ideas and concepts (10 notes)
- `30_People` — People notes
- `40_Reference` — Reference material
- `99_System` — System config and scripts

Cortex workflows will read from and write to this vault, respecting the folder conventions already in place.

## Scope

**In scope:**

- Toolkit architecture (workflows, agents, skills, templates) — same pattern as Specwright
- Core workflows: `/capture`, `/connect`, `/review`, `/synthesize`, `/map`, `/inbox`, `/daily`, `/search`
- Direct read/write integration with the existing Obsidian vault
- AI-assisted `[[wikilink]]` creation compatible with Obsidian's link format
- Spaced repetition / review system for knowledge retention
- Optimized for Antigravity IDE

**Out of scope:**

- Obsidian plugin development (pure markdown + workflow approach)
- Multi-vault support (single vault for now)

## Approach

Build a standalone project at `C:\Projects\cortex` following the same architecture as Specwright:

```
C:\Projects\
├── specwright/     # Specwright (dev workflows) — existing
├── cortex/              # Cortex (knowledge & productivity workflows) — NEW
│   ├── workflows/       # /capture, /connect, /review, etc.
│   ├── agents/          # Librarian, Synthesizer, Reviewer
│   ├── skills/          # Zettelkasten, PKM patterns, note taxonomies
│   ├── templates/       # Note templates (fleeting, literature, permanent, MOC)
│   ├── README.md
│   └── CATALOG.md
└── Notepad/             # Obsidian vault (the data) — existing
```

All three are added as workspace folders in Antigravity. Cortex is the toolkit (processes); Notepad is the vault (data). Cortex operates on the vault's markdown files using Obsidian-compatible conventions (`[[wikilinks]]`, `#tags`, existing folder structure). Cortex can suggest vault restructuring (e.g., new folders, reorganization) but always requires user confirmation before making structural changes.

**Key design principle:** AI-agnostic by default. Every note, link, and structure is plain markdown. The AI enhances the experience but is never required to read or use the notes.

### Why this solves the Obsidian habit problem

The struggle was never Obsidian itself — it was the **context switch**. Cortex lets you capture and process knowledge from Antigravity (where you already live). Obsidian becomes the _consumption and browsing_ layer, not the primary input layer. That's a much easier habit to sustain.
