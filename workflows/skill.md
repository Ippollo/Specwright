---
description: Create or enhance Agent Skills using the skill-builder.
quick_summary: "Detect scope → design content → scaffold skill using templates and design principles."
requires_mcp: []
recommends_mcp: []
---

# /skill - Build or Enhance a Skill

**Goal**: Create a new skill or improve an existing one, guided by the skill-builder's design principles.

> **Skill Reference**:
>
> - [skill-builder](../skills/skill-builder/SKILL.md) — Design principles, templates, and validation checklists
> - [skill-management](../skills/skill-management/SKILL.md) — Governance rules for the skills library

## When to Use

- After `/discover` flags a skill gap you want to fill
- When a project needs a custom local skill for its domain patterns
- When you want to create a new global skill for the toolkit
- When an existing skill needs enhancement or audit

## Steps

### Step 1: Load Skill Builder

Read the [skill-builder](../skills/skill-builder/SKILL.md) skill. The rest of this workflow follows its instructions.

### Step 2: Gap Detection & Routing

Follow the skill-builder's **Step 0: Gap Detection & Routing**:

1. Analyze the user's request — are they creating or modifying?
2. Check `CATALOG.md` and `.agents/skills/` for existing matches.
3. **No Match** → proceed to **Step 3** (CREATE).
4. **Match Found** → proceed to **Step 5** (MODIFY).

### Step 3: CREATE — Scope & Content Design

Follow the skill-builder's CREATE Mode:

1. **Scope Selection** — Ask: global or local?
2. **Validation** — Verify name and check for conflicts.
3. **Description Crafting** — Write a trigger-rich description.
4. **Content Design** — Define persona, anti-patterns, output shape, and relationships using the Design Principles.

### Step 4: CREATE — Generate & Register

1. **Select Template** — Basic, Intermediate, or Advanced based on content complexity.
2. **Generate Files** — Scaffold the skill directory and `SKILL.md`.
3. **Register** — Add to `CATALOG.md` (global) or `.agents/project-profile.md` (local).
4. **Verify** — Run through both validation checklists (Structural + Design Quality).

Skip to **Step 6**.

### Step 5: MODIFY — Audit & Enhance

Follow the skill-builder's MODIFY Mode:

1. **Full Audit** — Evaluate against both Structural and Design Quality checklists.
2. **Gap Analysis** — Categorize findings as Critical, Improvement, or Polish.
3. **Enhancement** — Apply fixes in priority order (description → anti-patterns → progressive disclosure → examples → relationships).
4. **Update** — Apply changes and update `CATALOG.md` if the description changed.

### Step 6: Summary

Present the result:

```
🛠️ Skill: <skill-name>
📍 Location: <path to SKILL.md>
📋 Mode: CREATE | MODIFY
🔖 Scope: Global | Local

✅ Structural Checklist: Passed
✅ Design Quality Checklist: Passed

Next: /commit to save changes
```

## Usage

```bash
# Create a new skill (interactive)
/skill

# Enhance an existing skill
/skill enhance security-hardening

# Create a local skill for the current project
/skill create --local
```

## Next Steps

After building or enhancing a skill:

- Use `/commit` to save changes
- Use `/discover` to verify the skill appears in project recommendations
