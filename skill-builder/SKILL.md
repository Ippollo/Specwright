---
schema_version: 1.0
name: skill-builder
description: "Comprehensive tool for creating, modifying, and validating Agent Skills. Includes wizard-based generation, audit checklists, and best practice templates."
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
    - Read `c:/Projects/skills/CATALOG.md`.
    - **No Match** → Go to **[CREATE Mode](#create-mode)**.
    - **Partial/Full Match** → Go to **[MODIFY Mode](#modify-mode)**.

---

## CREATE Mode

Use when building a new skill from scratch.

### Step 1: Validation

- **Name**: 1-64 lowercase alphanumeric chars + hyphens (`a-z-`). No consecutive hyphens.
- **Conflict Check**: Verify `c:/Projects/skills/<skill-name>` does not exist.

### Step 2: Description

- **Content**: 1-1024 chars. Must state **WHAT** it does and **WHEN** to use it.
- **Example**: "Generates React components. Use when scaffolding UI elements."

### Step 3: Select Template

Ask user to choose a template based on complexity:

- **Basic**: Single file, simple logic. ([View Template](references/templates/basic.md))
- **Intermediate**: Includes `scripts/` for automation. ([View Template](references/templates/intermediate.md))
- **Advanced**: Full structure with `docs/`, `resources/`, and progressive disclosure. ([View Template](references/templates/advanced.md))

### Step 4: Generation

1.  **Create Directory**: `c:/Projects/skills/<skill-name>/`
2.  **Write SKILL.md**: Use the selected template, populated with user's name/description and custom instructions.
3.  **Create Subdirectories**: `scripts/`, `resources/`, `docs/` (if Intermediate/Advanced).

### Step 5: Catalog Update

- Append the new skill to `c:/Projects/skills/CATALOG.md`.
- Format: `- [skill-name]: <description>`

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

- [ ] Located at `c:/Projects/skills/<skill-name>/` (No nested skills)
- [ ] `SKILL.md` is the main entry point

**Progressive Disclosure**:

- [ ] **Level 1 (Metadata)**: Accurate name/description for routing.
- [ ] **Level 2 (SKILL.md)**: Lean (~2-5KB). Focus on logic and flow.
- [ ] **Level 3 (Files)**: Large content moved to `docs/` or `resources/`.

### Directory Structure

```
c:/Projects/skills/<skill-name>/
├── SKILL.md                 # CORE: Logic & Instructions
├── README.md                # OPTIONAL: Human-readable docs
├── scripts/                 # OPTIONAL: Executable tools (setup.sh, run.py)
├── resources/               # OPTIONAL: Static assets
│   ├── templates/           # Code templates
│   └── examples/            # Usage examples
└── docs/                    # OPTIONAL: Deep-dive documentation
```
