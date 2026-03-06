---
name: skill-builder
description: Use when creating a new agent skill, auditing an existing skill, or scaffolding skill file structure. Includes wizard-based generation, validation checklists, and best practice templates. For skill library organization and lifecycle, see skill-management.
---

# Skill Builder

Master tool for managing the Agent Skills lifecycle. Use this to create new skills or enhance existing ones following the [Agent Skills Specification](https://agentskills.io/specification).

## Workflow Entry Point

### Step 0: Gap Detection & Routing

Before starting, analyze the user request to determine the correct mode.

1.  **Analyze Request**:
    - Is the user asking to _create_ a new capability?
    - Is the user asking to _improve_, _fix_, or _audit_ an existing skill?

2.  **Check Catalog**:
    - Read `c:\Projects\agentic-toolkit\CATALOG.md`.
    - Also check `.agents/skills/` in the current project for local skills.
    - **No Match** → Go to **[CREATE Mode](#create-mode)**.
    - **Partial/Full Match** → Go to **[MODIFY Mode](#modify-mode)**.

---

## CREATE Mode

Use when building a new skill from scratch.

### Step 0.5: Scope Selection

Ask the user:

> _"Should this be a **global** skill (useful across any project) or a **local** skill (specific to this project)?"_

- **Global** → Creates in `c:\Projects\agentic-toolkit\skills\<skill-name>\`
- **Local** → Creates in `.agents/skills/<skill-name>\` within the current project

If invoked from `/discover` gap-filling, default to **local**.

### Step 1: Validation

- **Name**: 1-64 lowercase alphanumeric chars + hyphens (`a-z-`). No consecutive hyphens.
- **Conflict Check**: Verify `c:\Projects\agentic-toolkit\<skill-name>` does not exist.

### Step 2: Description

- **Content**: 1-1024 chars. Must state **WHAT** it does and **WHEN** to use it.
- **Example**: "Generates React components. Use when scaffolding UI elements."

### Step 3: Select Template

Ask user to choose a template based on complexity:

- **Basic**: Single file, simple logic. ([View Template](references/templates/basic.md))
- **Intermediate**: Includes `scripts/` for automation. ([View Template](references/templates/intermediate.md))
- **Advanced**: Full structure with `docs/`, `resources/`, and progressive disclosure. ([View Template](references/templates/advanced.md))

### Step 4: Generation

**If Global:**

1.  **Create Directory**: `c:\Projects\agentic-toolkit\skills\<skill-name>\`
2.  **Write SKILL.md**: Use the selected template, populated with user's name/description and custom instructions.
3.  **Create Subdirectories**: `scripts/`, `resources/`, `docs/` (if Intermediate/Advanced).

**If Local:**

1.  **Create Directory**: `.agents/skills/<skill-name>\` (create `.agents/skills/` if it doesn't exist).
2.  **Write SKILL.md**: Same format as global skills.
3.  **Create Subdirectories**: Same as global (if Intermediate/Advanced).

### Step 5: Registration

**If Global:**

- Append the new skill to `c:\Projects\agentic-toolkit\CATALOG.md`.
- Format: `- [skill-name]: <description>`

**If Local:**

- Update the project's `.agents/project-profile.md` "Local Skills" section (if the file exists).
- Format: `- \`skill-name\` — description`

---

## MODIFY Mode

Use when enhancing, fixing, or refactoring an existing skill.

### Step 1: Audit

Read the target skill's `SKILL.md` and check against the **Validation Checklist** below.

### Step 2: Gap Analysis

Identify missing components:

- [ ] Is the frontmatter valid?
- [ ] Does it have clear "What" and "When"?
- [ ] Are complex instructions broken into `scripts/` or `docs/`?
- [ ] Are there examples in `resources/`?

### Step 3: Enhancement

- **Refactor**: Move inline code to `scripts/`.
- **Expand**: Add `resources/templates` or `docs/TROUBLESHOOTING.md`.
- **Clarify**: Rewrite ambiguous instructions.

### Step 4: Update

- Apply changes to `SKILL.md`.
- Update `CATALOG.md` if the description warrants a change.

---

## Reference & Best Practices

### Validation Checklist

Use this to certify a skill as "Production Ready":

**YAML Frontmatter**:

- [ ] Starts/ends with `---`
- [ ] `name`: Max 64 chars, valid format
- [ ] `description`: Max 1024 chars, includes "what" + "when"

**Structure**:

- [ ] Located at `c:\Projects\agentic-toolkit\<skill-name>\` (No nested skills)
- [ ] `SKILL.md` is the main entry point

**Progressive Disclosure**:

- [ ] **Level 1 (Metadata)**: Accurate name/description for routing.
- [ ] **Level 2 (SKILL.md)**: Lean (~2-5KB). Focus on logic and flow.
- [ ] **Level 3 (Files)**: Large content moved to `docs/` or `resources/`.

### Directory Structure

```
c:\Projects\agentic-toolkit\<skill-name>\
├── SKILL.md                 # CORE: Logic & Instructions
├── README.md                # OPTIONAL: Human-readable docs
├── scripts/                 # OPTIONAL: Executable tools (setup.sh, run.py)
├── resources/               # OPTIONAL: Static assets
│   ├── templates/           # Code templates
│   └── examples/            # Usage examples
└── docs/                    # OPTIONAL: Deep-dive documentation
```
