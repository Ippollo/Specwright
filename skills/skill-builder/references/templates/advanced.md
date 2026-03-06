<!-- ADVANCED TEMPLATE
     Best for: Capability-heavy skills with reference data, multiple scripts, and deep documentation.
     Size target: ~3-5KB for SKILL.md; heavy content lives in docs/ and resources/
     Examples in toolkit: frontend-design (aesthetic guidelines), gemini-api-dev (SDK reference),
                          design-system (searchable database with scripts)
     Key principle: SKILL.md is the routing layer. It tells the agent WHAT to do and WHERE to find details.
-->

---

name: "skill-name"
description: "Comprehensive description including functionality and trigger conditions (max 1024 chars). Use when [scenario list]. For [adjacent domain], see `other-skill`."

---

# Skill Name

<!-- Lead with role framing + core principle. Sets the agent's mindset before any instructions. -->

You are a [role]. [Core principle or philosophy in one sentence].

## When to Apply

<!-- Explicit trigger list. Include both positive triggers and negative exclusions. -->

- Designing [specific thing]
- Building [specific thing]
- Debugging [specific thing]
- **Not for**: [thing that belongs to another skill] — see `other-skill`

## Prerequisites

- [System requirement]
- [Tool requirement]

## Quick Start

<!-- Immediate value: a single command or 2-3 steps that demonstrate the skill working. -->

```bash
# Verify readiness
./scripts/doctor.sh

# Run default flow
./scripts/start.sh
```

## Core Instructions

<!-- The essential workflow. Keep this section lean and actionable.
     If a phase needs more than ~10 lines of detail, move it to docs/. -->

### Phase 1: [Name]

[Concise instructions. Link to deep-dive if needed.]

See [Configuration Guide](docs/CONFIGURATION.md) for detailed options.

### Phase 2: [Name]

[Concise instructions with concrete actions.]

### Phase 3: [Name]

[Verification steps. How to confirm the work is correct.]

## Anti-Patterns

<!-- Critical "don't do this" guidance. These prevent the most common mistakes.
     Great anti-patterns are specific and include the correct alternative. -->

> [!CAUTION]
> **[Anti-Pattern Name]**: [Specific bad behavior]. Instead, [specific correct behavior].

- **[Pattern Name]**: [Why it's bad]. _Do this instead_: [alternative].
- **[Pattern Name]**: [Why it's bad]. _Do this instead_: [alternative].

## Output Format

<!-- What the agent's deliverable should look like. -->

```
[Expected output structure]
```

## Resources

<!-- Progressive disclosure: point to Level 3 content the agent reads on demand. -->

- **Reference**: See [reference.md](docs/reference.md) for [catalogs, data tables, etc.]
- **Templates**: See `resources/templates/` for [scaffolding files]
- **Examples**: See `resources/examples/` for [sample implementations]

## Related Skills

<!-- Help the agent compose skills and avoid conflicts. -->

- **Complements**: `skill-a` — [how they work together]
- **Conflicts**: `skill-b` — [when NOT to use both; pick one based on context]
- **Delegates to**: `skill-c` — [specific subtask this skill defers to another]

## Troubleshooting

See [Troubleshooting Guide](docs/TROUBLESHOOTING.md) for common issues.
