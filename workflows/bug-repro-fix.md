---
description: Autonomous Test-Driven Debugging
---

# Bug Repro & Fix Workflow

> **Skill Reference**: Uses [unit-testing-strategy](../skills/unit-testing-strategy/SKILL.md) patterns.

1. **Repro**: Write a failing test that triggers the bug.
2. **Analyze**: Use `code-quality-sentinel` to examine the failure.
3. **Fix**: Apply the minimal safe fix.
4. **Verify**: Run the test to confirm the fix works.
5. **Clean**: Remove temporary test artifacts if needed.
