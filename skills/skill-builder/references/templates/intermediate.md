<!-- INTERMEDIATE TEMPLATE
     Best for: Workflow-driven skills with automation scripts.
     Size target: ~2-4KB for SKILL.md
     Examples in toolkit: design-system (script-driven), git-wizard
     When to upgrade to Advanced: when you need docs/, resources/templates/, or reference data.
-->

---

name: "skill-name"
description: "What this skill does + when to use it. Include trigger phrases and example scenarios (max 1024 chars)."

---

# Skill Name

<!-- Lead with purpose framing: what role + what outcome. -->

[1-2 sentences: What role does the agent adopt? What outcome does this skill achieve?]

## When to Use

<!-- Concrete trigger scenarios. Also state when NOT to use if there's a sibling skill. -->

- When [scenario 1]
- When [scenario 2]
- **Not for**: [scenario that belongs to a different skill] — use `other-skill` instead.

## Prerequisites

<!-- Tools, dependencies, or setup needed before the skill can run. -->

- [Requirement 1]
- [Requirement 2]

## Quick Start

<!-- Get the agent doing something useful immediately. A single command or 2-3 step sequence. -->

```bash
./scripts/setup.sh
```

## Workflow

<!-- The core logic of the skill, broken into clear phases.
     Each step should be actionable — tell the agent what to DO, not just what to consider. -->

### Phase 1: [Name]

1. [Concrete action]
2. [Concrete action]

### Phase 2: [Name]

1. [Concrete action]
2. [Concrete action]

### Phase 3: [Name]

1. [Concrete action]
2. [Concrete action]

## Anti-Patterns

<!-- What NOT to do. Include at least 2-3 common mistakes in this domain. -->

- **[Bad Pattern]**: [Description]. Instead, [correct approach].
- **[Bad Pattern]**: [Description]. Instead, [correct approach].

## Output Format

<!-- Define what the agent's output should look like when using this skill. -->

```
[Expected output structure or example]
```

## Scripts

<!-- Document what each script does. The agent reads this to decide which to run. -->

- `setup.sh`: [What it initializes]
- `run.py`: [What it executes and what output to expect]

## Related Skills

<!-- Map relationships to help the agent compose skills effectively. -->

- **Complements**: `other-skill` — [how they work together]
- **See also**: `another-skill` — [for adjacent domain]
