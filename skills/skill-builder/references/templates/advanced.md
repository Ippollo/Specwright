<!-- ADVANCED TEMPLATE
     Best for: Capability-heavy skills with reference data, multiple scripts, and deep documentation.
     Size target: ~3-5KB for SKILL.md; heavy content lives in docs/ and resources/
     Examples in toolkit: frontend-design (aesthetic guidelines), gemini-api-dev (SDK reference),
                           design-system (searchable database with scripts)
     Key principle: SKILL.md is the routing layer. It tells the agent WHAT to do and WHERE to find details.
                    Each workflow phase should specify exactly which files to read at that step.
     Common patterns: generator (needs assets/ + references/), pipeline (complex multi-step)
-->

---

name: "skill-name"
description: "Comprehensive description including functionality and trigger conditions (max 1024 chars). Use when [scenario list]. For [adjacent domain], see `other-skill`."
metadata:
  pattern: generator  # One of: tool-wrapper, generator, reviewer, inversion, pipeline

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
     If a phase needs more than ~10 lines of detail, move it to docs/.
     LOAD ORDER: Each phase should specify which files to read at that step.
     This prevents context competition — the agent only loads what it needs, when it needs it. -->

### Phase 1: [Name]

<!-- Read at this step: docs/CONFIGURATION.md -->

[Concise instructions. Link to deep-dive if needed.]

See [Configuration Guide](docs/CONFIGURATION.md) for detailed options.

### Phase 2: [Name]

<!-- Read at this step: resources/examples/good/[relevant-example].md -->

[Concise instructions with concrete actions.]

### Phase 3: [Name]

<!-- Read at this step: eval/checklist.md (if eval layer is used) -->

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

## Eval Layer (Optional)

<!-- For skills that produce user-facing output, define a quality gate that runs after generation.
     The checklist catches mechanical / rule-based failures.
     Review personas provide perspective-based evaluation from different reader viewpoints.
     Both are read on demand at the verification step — not loaded upfront. -->

- **Checklist**: See [checklist.md](eval/checklist.md) for pass/fail criteria
- **Review Personas**: See [review-personas.md](eval/review-personas.md) for perspective-based evaluation

## Resources

<!-- Progressive disclosure: point to Level 3 content the agent reads on demand. -->

- **Reference**: See [reference.md](docs/reference.md) for [catalogs, data tables, etc.]
- **Templates**: See `resources/templates/` for [scaffolding files]
- **Good Examples**: See `resources/examples/good/` for [annotated examples of excellent output]
- **Bad Examples**: See `resources/examples/bad/` for [annotated anti-pattern samples to avoid]

## Related Skills

<!-- Help the agent compose skills and avoid conflicts. -->

- **Complements**: `skill-a` — [how they work together]
- **Conflicts**: `skill-b` — [when NOT to use both; pick one based on context]
- **Delegates to**: `skill-c` — [specific subtask this skill defers to another]

## Troubleshooting

See [Troubleshooting Guide](docs/TROUBLESHOOTING.md) for common issues.
