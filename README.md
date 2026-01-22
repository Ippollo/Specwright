# Agent Skills Library

This repository contains a collection of reusable skills and protocols designed to extend the capabilities of AI agents.

## Structure

The library uses a **flat structure** for efficiency. All skills are located in the root directory:

```
c:/Projects/skills/
├── CATALOG.md          # Complete index of all skills by category
├── [skill-name]/       # Individual skill folders
│   ├── SKILL.md        # Main instruction file
│   └── scripts/        # Supporting Python/JS scripts
└── ...
```

## Getting Started

1.  **Read the Catalog**: Start with [CATALOG.md](CATALOG.md) to see what's available.
2.  **Load a Skill**: Use `view_file` on `[skill-name]/SKILL.md` to read the instructions.
3.  **Execute**: Follow the protocol or run the scripts as defined in the skill file.

## Governance

- **Adding Skills**: Follow the [Skill Builder](./skill-builder/SKILL.md) protocol.
- **Managing Library**: Refer to [Skill Management](./skill-management/SKILL.md).
