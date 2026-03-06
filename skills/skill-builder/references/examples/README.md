# Exemplar Skills

Study these existing skills to understand what makes a great SKILL.md. Each entry highlights the specific quality to learn from.

---

## Best-in-Class Examples

### `frontend-design` — Opinionated Stance + Anti-Patterns

**Path**: `c:\Projects\agentic-toolkit\skills\frontend-design\SKILL.md`

**What makes it great**:

- Opens with a clear role: "distinctive, production-grade frontend interfaces"
- Takes a bold aesthetic stance — tells the agent to be UNFORGETTABLE
- Comprehensive anti-patterns section: "NEVER use generic AI-generated aesthetics like overused font families..."
- Domain-specific guidelines (typography, color, motion, composition) are immediately actionable

**Learn from it**: How to write a skill that takes a clear position and encodes strong opinions.

---

### `prompt-engineering` — Named Protocols with Triggers

**Path**: `c:\Projects\agentic-toolkit\skills\prompt-engineering\SKILL.md`

**What makes it great**:

- Each protocol has a "Use when" trigger — the agent can self-select the right technique
- Includes both instructions AND examples for each protocol
- Anti-patterns section with specific bad/good comparisons
- Designed to be **referenced by other skills**, not just used standalone

**Learn from it**: How to structure reusable patterns with clear activation conditions.

---

### `design-system` — Script-Driven Progressive Disclosure

**Path**: `c:\Projects\agentic-toolkit\skills\design-system\SKILL.md`

**What makes it great**:

- SKILL.md is only ~110 lines despite covering 50+ styles, 97 palettes, and 57 font pairings
- Heavy data lives in searchable scripts (`scripts/search.py`) and reference files
- Priority table makes decision-making fast
- Quick Start command gets immediate value

**Learn from it**: How to keep SKILL.md lean while providing massive depth through progressive disclosure.

---

### `gemini-api-dev` — Immediately Actionable with SDK Examples

**Path**: `c:\Projects\agentic-toolkit\skills\gemini-api-dev\SKILL.md`

**What makes it great**:

- Trigger-rich description listing specific scenarios AND SDK names
- Quick Start with working code in 4 languages
- Uses `[!IMPORTANT]` and `[!WARNING]` alerts to override stale training data
- Points to authoritative external docs (`llms.txt`) for self-updating knowledge

**Learn from it**: How to write a skill that corrects outdated knowledge and provides code-first guidance.

---

### `code-quality-sentinel` — Phased Safety Workflow

**Path**: `c:\Projects\agentic-toolkit\skills\code-quality-sentinel\SKILL.md`

**What makes it great**:

- Opens with a core principle (behavior preservation is mandatory)
- 5-phase workflow with safety gates between each phase
- Error Recovery protocol: STOP → REVERT → INVESTIGATE → DECIDE
- Defines exact output format so the agent knows what to produce

**Learn from it**: How to encode safety-critical workflows with explicit checkpoints and rollback.

---

## How to Use These Exemplars

When creating a new skill, pick the exemplar closest to your use case:

| Your skill type                  | Study this exemplar     |
| -------------------------------- | ----------------------- |
| Aesthetic / creative preferences | `frontend-design`       |
| Reusable protocols or patterns   | `prompt-engineering`    |
| Data-heavy with search/scripts   | `design-system`         |
| API/SDK integration              | `gemini-api-dev`        |
| Safety-critical workflows        | `code-quality-sentinel` |
