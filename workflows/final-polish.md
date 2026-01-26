---
description: Pre-submission cleanup and verification checklist
---

# Final Polish Workflow

> **Skill References**:
>
> - [code-quality-sentinel](../skills/code-quality-sentinel/SKILL.md)
> - [documentation-standards](../skills/documentation-standards/SKILL.md)

1. **Code Cleanup**:
   - Remove debug logs, dead code, and TODOs (`code-quality-sentinel`)
   - Verify lint checks pass

2. **Documentation**:
   - Update README if public API changed (`documentation-standards`)
   - Add Changelog entry if user-facing
   - Verify inline comments match code

3. **Verification**:
   - Run relevant tests
   - Confirm code is ready for commit
