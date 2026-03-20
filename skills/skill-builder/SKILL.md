---
schema_version: 1.0
name: skill-builder
description: "Comprehensive tool for creating, modifying, and validating Agent Skills. Includes wizard-based generation, audit checklists, and best practice templates. Use this skill when building new SKILL.md files, enhancing existing skills, or when a project needs custom skills for its domain patterns."
metadata:
  pattern: inversion
---

# Skill Builder

Master tool for the Agent Skills lifecycle. Use this to create new skills, enhance existing ones, or audit skill quality.

## Design Principles

These principles are distilled from the best-performing skills in this toolkit. Apply them when creating or reviewing any skill.

### 1. Lead with Why, Not What

A skill that opens with "This skill does X" is weaker than one that opens with "You are a [role] that achieves [outcome]." Framing the **purpose** before the mechanics helps the agent adopt the right mindset.

- _Weak_: "This skill generates commit messages."
- _Strong_: "You are a version control specialist. You craft commit messages that communicate intent to future maintainers."

### 2. Write Trigger-Rich Descriptions

The `description` field is how the agent decides whether to load a skill. It must answer **what** it does and **when** to use it, using the user's natural vocabulary.

- Include concrete trigger phrases: "Use this skill when...", "Use when the user asks to..."
- List example scenarios: "building web components, pages, dashboards..."
- Differentiate from similar skills: "For React patterns, see `react-best-practices`."
- Max 1024 chars. Every word must earn its place.

> [!CAUTION]
> **The Description Trap**: Never summarize the skill's workflow in the description. If the description contains step-by-step process instructions (e.g., "asks questions, then proposes approaches, then writes docs"), agents use the description as a shortcut and **skip reading the SKILL.md body entirely**. Descriptions should only contain **trigger conditions** — when to use the skill — never how it works.

### 3. Encode Anti-Patterns

Great skills don't just say what to do — they say what **NOT** to do. Anti-patterns prevent common mistakes and are often more valuable than the positive instructions.

- _Example from `frontend-design`_: "NEVER use generic AI-generated aesthetics like overused font families (Inter, Roboto, Arial)..."
- _Example from `prompt-engineering`_: "**Prompt Stuffing**: Adding irrelevant context 'just in case.' This dilutes attention and increases costs."

### 4. Progressive Disclosure

Keep `SKILL.md` lean (target 2-5KB). Move heavy content to supporting files:

| Content Type             | Location                                      |
| ------------------------ | --------------------------------------------- |
| Core logic & workflow    | `SKILL.md` (Level 2)                          |
| Reference data, catalogs | `docs/reference.md` or `resources/` (Level 3) |
| Executable automation    | `scripts/` (Level 3)                          |
| Code templates           | `resources/templates/` (Level 3)              |
| Good examples            | `resources/examples/good/` (Level 3)          |
| Bad examples             | `resources/examples/bad/` (Level 3)           |
| Eval checklist           | `eval/checklist.md` (Level 3)                 |
| Review personas          | `eval/review-personas.md` (Level 3)           |

The agent reads `SKILL.md` first. It only reads Level 3 files when `SKILL.md` tells it to.

### 5. Be Immediately Actionable

Every skill should get the agent **doing something useful** as fast as possible. Include:

- A "Quick Start" or entry-point step
- Concrete code snippets or commands (not just theory)
- A clear output format so the agent knows what "done" looks like

### 6. Define Relationships

Skills don't exist in isolation. State how this skill relates to others:

- _Complements_: "Use with `backend-performance` when optimizing API responses."
- _Conflicts_: "Do not mix with `frontend-design` in the same component."
- _Delegates_: "For ADR format, defer to `documentation-standards`."

### 7. Classify the Pattern

Every skill follows one of five structural patterns. Identifying the pattern early shapes the content design, template selection, and directory structure.

| Pattern | Core Question | Key Trait |
|---|---|---|
| `tool-wrapper` | "How should I use this library/convention?" | Loads references on demand, no templates or scripts required |
| `generator` | "What should the output look like?" | Uses templates (`assets/`) and style guides (`references/`) to produce structured output |
| `reviewer` | "Is this good enough?" | Scores input against a checklist (`references/review-checklist.md`), produces findings |
| `inversion` | "What do I need to know before I start?" | Interviews the user through phased questions before generating |
| `pipeline` | "What's the correct sequence?" | Enforces ordered steps with gate conditions between phases |

**Decision Tree** — Use this to pick the right pattern:

```
Does the skill produce output?
├── YES → From a template?
│   ├── YES → generator
│   └── NO → Does it evaluate existing input?
│       ├── YES → reviewer
│       └── NO → Does it need user input first?
│           ├── YES → inversion
│           └── NO → Has ordered steps?
│               ├── YES → pipeline
│               └── NO → tool-wrapper
└── NO → tool-wrapper
```

**Patterns compose.** A Pipeline can include a Reviewer step. A Generator can use Inversion at the beginning to gather variables. Tag the _dominant_ pattern in `metadata.pattern`.

### 8. Script the Load Order

Don't just list prerequisites at the top and hope the agent reads them at the right time. Each workflow step should specify **which file to read at that step**.

- _Weak_: "Prerequisites: Read voice-guide.md, strategy.md, and algorithm.md before starting."
- _Strong_: "Step 1: Read `voice-guide.md` for tone and patterns. Step 3: Read `examples/good/` for structural reference. Step 5: Read `eval/checklist.md` for pass/fail criteria."

This prevents context competition — the agent only loads what it needs, when it needs it. Each step gets fresh, focused context instead of a front-loaded pile of documents.

> [!IMPORTANT]
> **Only applies to Intermediate and Advanced skills.** Basic skills (tool-wrapper, simple reviewer) are short enough that front-loading is fine.

---

## Workflow Entry Point

### Step 0: Gap Detection & Routing

Before starting, analyze the user request to determine the correct mode.

1.  **Analyze Request**:
    - Is the user asking to _create_ a new capability?
    - Is the user asking to _improve_, _fix_, or _audit_ an existing skill?

2.  **Check Catalog**:
    - Read `c:\Projects\specwright\CATALOG.md`.
    - Also check `.agents/skills/` in the current project for local skills.
    - **No Match** → Go to **[CREATE Mode](#create-mode)**.
    - **Partial/Full Match** → Go to **[MODIFY Mode](#modify-mode)**.

---

## CREATE Mode

Use when building a new skill from scratch.

### Step 1: Scope Selection

Ask the user:

> _"Should this be a **global** skill (useful across any project) or a **local** skill (specific to this project)?"_

- **Global** → Creates in `c:\Projects\specwright\skills\<skill-name>\`
- **Local** → Creates in `.agents/skills/<skill-name>\` within the current project

If invoked from `/discover` gap-filling, default to **local**.

### Step 2: Validation

- **Name**: 1-64 lowercase alphanumeric chars + hyphens (`a-z-`). No consecutive hyphens.
- **Conflict Check**: Verify name doesn't collide with an existing skill in the target location.

### Step 3: Description Crafting

Write the `description` field using the **Trigger-Rich Descriptions** principle:

1. Start with the capability: "What does this skill enable?"
2. Add trigger phrases: "Use this skill when [scenario 1], [scenario 2], or [scenario 3]."
3. Add disambiguation (if overlapping with another skill): "For [adjacent domain], see `other-skill`."
4. Verify: Would a user searching for this capability find it? Would adjacent searches correctly **not** find it?

### Step 4: Content Design

Before selecting a template, design the skill's substance using the Design Principles:

1. **Define the role**: What persona should the agent adopt? (Principle 1)
2. **List 3-5 anti-patterns**: What are the most common mistakes in this domain? (Principle 3)
3. **Identify output shape**: What does "done" look like? (Principle 5)
4. **Map relationships**: What other skills does this one complement, conflict with, or delegate to? (Principle 6)
5. **Assess content volume**: Will the skill need reference data, scripts, or templates? (Principle 4)
6. **Classify the pattern**: Use the decision tree in Principle 7 to determine the dominant pattern (`tool-wrapper`, `generator`, `reviewer`, `inversion`, `pipeline`). This directly informs template selection in the next step.

### Step 5: Select Template

Choose a template based on the content design assessment and the classified pattern:

- **Basic**: Single file, simple logic. Best for encoded preferences or checklists. ([View Template](references/templates/basic.md))
  - _Common patterns_: `tool-wrapper`, `reviewer` (simple checklist)
- **Intermediate**: Includes `scripts/` for automation. Best for workflow-driven skills. ([View Template](references/templates/intermediate.md))
  - _Common patterns_: `pipeline`, `inversion`, `reviewer` (multi-phase)
- **Advanced**: Full structure with `docs/`, `resources/`, and progressive disclosure. Best for capability-heavy skills with reference data. ([View Template](references/templates/advanced.md))
  - _Common patterns_: `generator` (needs `assets/` + `references/`), `pipeline` (complex multi-step with reference data)

### Step 6: Generation

**If Global:**

1.  **Create Directory**: `c:\Projects\specwright\skills\<skill-name>\`
2.  **Write SKILL.md**: Use the selected template, populated with content from Steps 3-4.
3.  **Create Subdirectories**: `scripts/`, `resources/`, `docs/` (if Intermediate/Advanced).

**If Local:**

1.  **Create Directory**: `.agents/skills/<skill-name>\` (create `.agents/skills/` if it doesn't exist).
2.  **Write SKILL.md**: Same format as global skills.
3.  **Create Subdirectories**: Same as global (if Intermediate/Advanced).

### Step 7: Registration

**If Global:**

- Append the new skill to `c:\Projects\specwright\CATALOG.md` in the appropriate category section.
- Format: `- [skill-name](./skills/skill-name/SKILL.md): <description>`

**If Local:**

- Update the project's `.agents/project-profile.md` "Local Skills" section (if the file exists).
- Format: `- \`skill-name\` — description`

---

## MODIFY Mode

Use when enhancing, fixing, or refactoring an existing skill.

### Step 1: Full Audit

Read the target skill's `SKILL.md` and evaluate against **both** the Structural Checklist and the Design Quality Checklist below. Verify that `metadata.pattern` is set and accurately reflects the skill's dominant pattern (see Principle 7).

### Step 2: Gap Analysis

Compare audit results against the checklists. Categorize gaps:

- **Critical**: Missing description triggers, no anti-patterns, vague instructions
- **Improvement**: Could add examples, better progressive disclosure, relationship mapping
- **Polish**: Formatting, ordering, frontmatter completeness

### Step 3: Enhancement

Apply fixes in priority order:

1. **Description** — Rewrite to be trigger-rich if it isn't already.
2. **Anti-Patterns** — Add a section if missing. Even 2-3 bullets add significant value.
3. **Progressive Disclosure** — Extract heavy content to supporting files if `SKILL.md` exceeds ~5KB.
4. **Examples** — Add concrete examples for key instructions.
5. **Relationships** — Add cross-references to complementary or conflicting skills.

### Step 4: Update

- Apply changes to `SKILL.md`.
- Update `CATALOG.md` if the description changed.

---

## Validation Checklists

### Structural Checklist

Certify the skill is well-formed:

- [ ] Starts/ends with `---` frontmatter
- [ ] `name`: Max 64 chars, kebab-case format
- [ ] `description`: Max 1024 chars
- [ ] `metadata.pattern`: One of `tool-wrapper`, `generator`, `reviewer`, `inversion`, `pipeline`
- [ ] Located at `skills/<skill-name>/` (no nesting)
- [ ] `SKILL.md` is the main entry point
- [ ] Large content moved to `docs/` or `resources/` (if applicable)

### Design Quality Checklist

Certify the skill is **effective**:

- [ ] **Trigger-Rich Description**: Answers "what" + "when", includes example scenarios
- [ ] **No Workflow Summary in Description**: Description contains trigger conditions only, not step-by-step process instructions (see "The Description Trap" in Design Principles)
- [ ] **Clear Persona or Role**: Opens with purpose framing, not just mechanics
- [ ] **Anti-Patterns Included**: At least 2-3 "don't do this" items
- [ ] **Actionable Content**: Includes concrete steps, commands, or code — not just theory
- [ ] **Output Shape Defined**: Agent knows what "done" looks like
- [ ] **Relationships Mapped**: Cross-references to complementary skills (if applicable)
- [ ] **Progressive Disclosure**: SKILL.md ≤ ~5KB, heavy content in supporting files
- [ ] **Load Order Scripted** (if intermediate/advanced): Each workflow step specifies which files to read
- [ ] **Eval Layer Defined** (if produces user-facing output): `eval/checklist.md` with pass/fail criteria exists

---

## Directory Structure

```
skills/<skill-name>/
├── SKILL.md                 # CORE: Logic & Instructions (~2-5KB)
├── README.md                # OPTIONAL: Human-readable docs
├── scripts/                 # OPTIONAL: Executable tools (setup.sh, run.py)
├── resources/               # OPTIONAL: Static assets
│   ├── templates/           # Code templates
│   └── examples/
│       ├── good/            # Annotated examples of excellent output
│       └── bad/             # Annotated anti-pattern samples
├── eval/                    # OPTIONAL: Self-evaluation layer
│   ├── checklist.md         # Pass/fail criteria for skill output
│   └── review-personas.md   # Perspective-based reviewer personas
└── docs/                    # OPTIONAL: Deep-dive documentation
    ├── reference.md         # Reference catalogs, data tables
    └── TROUBLESHOOTING.md   # Common issues and fixes
```

## Exemplars

Study these existing skills as models of excellence — see [references/examples/README.md](references/examples/README.md) for a curated guide to what makes each one effective.
