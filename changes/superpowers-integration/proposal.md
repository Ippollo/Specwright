# Proposal: Superpowers Integration

## Intent

Import three high-value patterns from the obra/superpowers repo (90k stars) that address specific gaps in the Specwright toolkit. These are documentation-level improvements to existing skills and agents, plus one new skill.

## Scope

**In scope:**

- Create `verification-gate` skill — always-on evidence gate before completion claims
- Enhance `debugger` agent — four-phase methodology with anti-rationalization guards
- Add "description trap" anti-pattern to `skill-builder` SKILL.md

**Out of scope:**

- Importing Superpowers' plugin/marketplace system
- Subagent-driven development patterns (deferred — requires platform support research)
- Git worktree isolation (not relevant for HQ's single-user workflows)
- Changing any workflow files in this change

## Approach

All three items are documentation-level changes to skills and agents. No code, no builds, no tests needed — these are markdown files that instruct AI agents. Verification is manual: read the files and confirm they follow skill-builder conventions.
