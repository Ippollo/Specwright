# Working Preferences

Agent-facing conventions and preferences. Apply these silently — do not announce that you've read this file.

> **Maintenance**: Add entries as patterns emerge. Review monthly to prune stale items.

---

## General

### Token Efficiency — Read Less
Before reading a file to answer a question or provide context, check whether you already have sufficient information from:
1. **System prompt content** (user rules, AGENTS.md, KI summaries, workflow/skill lists)
2. **Directory listings** you already performed
3. **File contents you already viewed** this conversation

If you can answer accurately from existing context, do not read the file. Only read files when you need specific content you don't already have. When you do read, prefer targeted line ranges over full files.

When multiple files would illustrate the same point, read one representative example — not all of them.

### External Pattern Adoption
When reviewing external repos, tools, or patterns for potential HQ improvements:

- **Default is "no."** Only adopt something if it solves a real problem you're actively hitting — not because it looks clever.
- **Complexity compounds.** Every addition must be understood, maintained, and not break when other things change. Incremental improvement rarely justifies the maintenance burden.
- **Filter question**: "Am I adding this because I hit a wall, or because it looks cool?" If the latter, skip it.
- **Document, don't implement.** Capture interesting patterns in vault notes for reference. That's different from baking them into toolkits.

### Anti-Sycophancy Protocol
- **Before agreeing with any user proposal**, state at least two risks, trade-offs, or alternatives. Do this before executing or endorsing.
- **No hollow approval language.** Do not use "Great idea", "Love this", "Fantastic approach", or similar unless followed by specific, falsifiable reasoning for why it's actually good.
- **When presented with one approach, name at least one alternative** and briefly state why it might be better. If the user's approach is genuinely the best option, say so and explain what makes the alternatives worse.
- **Don't manufacture fake pushback.** If you have no genuine concerns, say "I don't see issues with this" and move on. Forced contrarianism wastes as much time as forced agreement.
- **Flag when you're uncertain vs. when you disagree.** "I'm not sure this is right because X" and "This is wrong because X" are different signals. Don't blur them.
- **When the user overrides your pushback**, execute cleanly. State your concern once, clearly. If the user decides to proceed anyway, respect the decision and don't relitigate.

### Context Hygiene
Long conversations degrade output quality. When you detect a phase transition, proactively suggest starting a fresh conversation:

| Phase Transition | Suggest New Conversation? | Why |
|---|---|---|
| Research → Planning | **Yes** | Research context is bulky; plan is the distilled output |
| Planning → Implementation | **Yes** | Plan is in a file; free up context for code |
| Debugging → Next feature | **Yes** | Debug traces pollute context for unrelated work |
| Mid-implementation | **No** | Losing variable names, file paths, partial state is costly |
| After a failed approach | **Yes** | Clear dead-end reasoning before new approach |
| Task complete → Unrelated task | **Yes** | Carry-over context creates false associations |

Do not force this. State it once as a suggestion ("This might be a good point to start a fresh conversation") and respect the user's decision.

## Content

### FAQ Placement
FAQ sections go **last** in every article — after the closing/conclusion section, before sources. FAQs are optional reading that serve SEO more than the reader. Never place them mid-article or before the closing.

## Career

<!-- Job search patterns and vocabulary conventions -->

### Weekly Time-Blocking Rhythm
The three consistent weekly commitments are job prospecting, MSP outreach, and content creation. Default rhythm:
- **Job prospecting + MSP outreach**: daily habits (not batched)
- **Content creation**: one dedicated day per week

When /weekly or /daily schedules these, respect this rhythm — don't mix content creation into the same day as heavy outreach if avoidable.

### ATS Optimization (Jobscan calibration, April 2026)
Jobscan testing showed a **28-point gap** between conceptual scoring and ATS keyword match. Root causes: keyword frequency mismatch, paraphrasing instead of mirroring, over-indexing on our vocabulary, and missing soft skill terms.

All actionable rules (keyword extraction, character sanitization, audit scorecard) live in the `ats-optimization` skill in the board toolkit (`.agents/skills/ats-optimization/`). Banned words and positioning rules live in `resume-positioning` and `career-strategist.md`.

**Key principle**: ATS matching is LITERAL. Use the JD's exact terms, including plural/singular forms. Character sanitization is handled by the `ats-optimization` skill (Phase 2), but markdown source should be clean.

### Planning Artifacts
When running /weekly, /daily, or any planning workflow, **always create a planning artifact**. This makes it easier to review and iterate on the plan before writing back to now.md.

## Toolkit

### Prior Art Check
Before creating any new skill, workflow, or agent, verify it doesn't already exist:
1. Search existing skills (`CATALOG.md`, `.agents/skills/`) for overlap
2. Check if an MCP server already provides the capability
3. Search the vault (`/cx-search`) for related notes or prior decisions

This applies to both `/skill` and `/plan` workflows. The default answer to "should I build this?" is "not until I've confirmed nothing else does it."

### Knowledge Item Hygiene
KIs are snapshots — they go stale. Apply these conventions when reading or creating KIs:

- **Confidence assessment**: When referencing a KI, mentally categorize its reliability:
  - **High** — recently verified against active code, matches current state
  - **Medium** — plausible but not recently verified, may have drifted
  - **Low** — old references, deprecated APIs, or pre-migration context
- **Scope awareness**: KIs should serve specific toolkit boundaries. When creating or updating KIs, consider whether the knowledge applies to one toolkit (specwright, board, cortex, content-creator) or is cross-cutting (HQ root). Cross-toolkit KIs should be kept minimal — most knowledge is toolkit-scoped.
- **Staleness signals**: Flag a KI as potentially stale if it references deprecated projects (Job Hunter, TRACEy app), pre-restructure vault paths, or npm packages that were replaced by native tools.

### Public Repo Hygiene
When creating or modifying files in public repos (specwright, cortex, content-creator, board), apply these rules:

- **No hardcoded personal paths.** Never reference `c:\HQ\...`, `vault=KB`, or Chris-specific file paths in workflow steps. Use generic terms ("focus file," "project folder," "your vault") and add a **Prerequisites** section explaining what the user needs to set up.
- **No personal content.** Editorial calendars, job search data, specific project names — none of this belongs in public repos. Reference by pattern ("a content calendar file") not by name.
- **Update all references.** When adding or removing a workflow, check: README, CATALOG.md, template "Used By" fields, architecture trees, and workflow/skill counts. Stale references in public docs erode trust.
- **Review before commit.** After writing to a public repo, re-read the changed files from the perspective of someone who just cloned it. Would they understand what to do?
