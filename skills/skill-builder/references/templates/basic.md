<!-- BASIC TEMPLATE
     Best for: Encoded preferences, checklists, simple conventions.
     Size target: ~1-2KB for SKILL.md
     Examples in toolkit: prompt-engineering, code-quality-sentinel
     Common patterns: tool-wrapper, reviewer (simple checklist)
-->

---

name: "skill-name"
description: "What this skill does + when to use it. Include trigger phrases and example scenarios (max 1024 chars)."
metadata:
  pattern: tool-wrapper  # One of: tool-wrapper, generator, reviewer, inversion, pipeline

---

# Skill Name

<!-- Lead with purpose, not mechanics. Frame the role the agent should adopt. -->

[1-2 sentences: What outcome does this skill achieve? What role does the agent play?]

## When to Use

<!-- List concrete trigger scenarios so the agent can self-select this skill. -->

- When [scenario 1]
- When [scenario 2]
- When [scenario 3]

## Instructions

<!-- Step-by-step workflow. Be specific and actionable. -->

1. **Step 1**: [What to do and why]
2. **Step 2**: [What to do and why]
3. **Step 3**: [What to do and why]

## Anti-Patterns

<!-- What NOT to do. These are often more valuable than the positive instructions. -->

- **[Bad Pattern Name]**: [Why it's bad and what to do instead]
- **[Bad Pattern Name]**: [Why it's bad and what to do instead]

## Output

<!-- Define what "done" looks like so the agent knows the expected shape. -->

```
[Example output format or structure]
```
