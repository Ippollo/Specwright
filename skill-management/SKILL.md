---
schema_version: 1.0
name: skill-management
description: Guidelines for managing, organizing, and expanding the Agent Skills library.
---

# Skill Management & Organization

This skill defines the protocols for maintaining the `c:/Projects/Skills` library.

## Organization Structure

The library uses a **categorical structure** to organize skills. All skills must reside in one of the following category folders:

### 1. Categories

- **`design/`**: UI/UX, visual design, stylesheets, and frontend patterns.
- **`development/`**: Coding standards, languages, frameworks, architecture, and git.
- **`meta/`**: Agent processes, instruction writing, skill governance, and documentation.
- **`testing/`**: QA procedures, testing frameworks (unit, E2E), and verification steps.

### 2. The Master Catalog

A `CATALOG.md` file MUST be maintained in the root (`c:/Projects/Skills/`).

- **Purpose**: Provides a single index for the Agent to discover available skills.
- **Maintenance**:
  - When adding a new skill, you MUST add an entry to `CATALOG.md`.
  - Entries should be alphabetized within their category.
  - **Format**:
    ```markdown
    - [skill-name](./category/skill-name/SKILL.md): Brief description of what this skill does.
    ```

## Creating New Skills

- **Location**: Place the new skill folder inside the most appropriate category directory.
- **Naming**: Use kebab-case (e.g., `my-new-skill`) for directory names.
- **Format**: Always include a `SKILL.md` file with frontmatter in the skill root.

## Skill Lifecycle

Skills pass through defined stages to ensure the library remains high-quality and relevant.

1.  **Draft**: being researched or built. Not yet in `CATALOG.md`.
2.  **Active**: Fully documented, tested, and listed in `CATALOG.md`.
3.  **Deprecated**: marked for removal or replacement.

## Quality Assurance Checklist

Before marking a skill as **Active**, ensure it meets these criteria:

- [ ] **Valid Frontmatter**: `SKILL.md` must have `schema_version`, `name` (kebab-case), and `description`.
- [ ] **Clear Scope**: The description is concise (under 100 chars) and actionable.
- [ ] **Categorization**: The skill is placed in the correct `design`, `development`, `meta`, or `testing` folder.
- [ ] **Cataloged**: An entry exists in `c:/Projects/skills/CATALOG.md` in the correct alphabetical position.
- [ ] **No Overlaps**: The skill does not duplicate functionality of an existing skill. If it does, follow the "Handling Overlaps" protocol.

## Handling Overlaps

If a new skill overlaps with an existing one:

1.  **Merge**: If the new skill is an enhancement, merge it into the existing skill folder and update the `SKILL.md`.
2.  **Split**: If the existing skill is too broad, split it into two focused skills (e.g., `testing` -> `unit-testing`, `e2e-testing`).
3.  **Replace**: If the new skill is a complete superior replacement, Deprecate the old one.

## Deprecation & Retirement

When a skill is no longer needed or has been superseded:

1.  **Update Frontmatter**: Add `status: deprecated` to the YAML frontmatter of the skill's `SKILL.md`.
2.  **Add Warning**: Add a `> [!WARNING]` alert at the top of the `SKILL.md` explaining why it is deprecated and what replaces it.
3.  **Update Catalog**: Move the entry in `CATALOG.md` to a "Deprecated" section at the bottom of the file (create one if it doesn't exist).

## Resources & Templates

- **[Skill Builder](../skill-builder/SKILL.md)**: Use this skill to interactively create new skills.
- **[Documentation Standards](../documentation-standards/SKILL.md)**: Refer to this for writing guides.
- **Templates**: See the [`templates/`](./templates/) directory for a `new-skill-template.md`.
