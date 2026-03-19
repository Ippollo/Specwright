---
description: Structured idea exploration before planning. Explores multiple options with trade-offs.
quick_summary: "Explore 3+ options with pros/cons before committing. Output: recommendations with tradeoffs."
requires_mcp: []
recommends_mcp: [sequential-thinking, firecrawl-mcp, context7]
---

# /brainstorm - Structured Idea Exploration

**Goal**: Turn vague ideas into concrete options before committing to implementation.

## When to Use

- You have a problem but aren't sure of the best approach
- You want to explore trade-offs before planning
- You need to compare multiple solutions

> **See also**: For non-technical decisions — career moves, consulting strategy, income prioritization — use `/consult` (Board of Advisors) instead.

## Behavior

When `/brainstorm` is triggered, I will:

1. **Understand the goal**
   - What problem are we solving?
   - Who is the user?
   - What constraints exist?

2. **Generate options**
   - Provide at least 3 different approaches
   - Each with pros and cons
   - Consider unconventional solutions

3. **Compare and recommend**
   - Summarize tradeoffs
   - Give a recommendation with reasoning

## Output Format

```markdown
## 🧠 Brainstorm: [Topic]

### Context

[Brief problem statement]

---

### Option A: [Name]

[Description]

✅ **Pros:**

- [benefit 1]
- [benefit 2]

❌ **Cons:**

- [drawback 1]

📊 **Effort:** Low | Medium | High

---

### Option B: [Name]

[Description]

✅ **Pros:**

- [benefit 1]

❌ **Cons:**

- [drawback 1]
- [drawback 2]

📊 **Effort:** Low | Medium | High

---

### Option C: [Name]

[Description]

✅ **Pros:**

- [benefit 1]

❌ **Cons:**

- [drawback 1]

📊 **Effort:** Low | Medium | High

---

## 💡 Recommendation

**Option [X]** because [reasoning].

What direction would you like to explore?
```

## Examples

```
/brainstorm authentication system
/brainstorm state management for complex form
/brainstorm database schema for social app
/brainstorm caching strategy
```

## Recommended MCP Servers

- **Sequential Thinking**: Structure complex ideation processes.
- **Firecrawl**: Extract content from competitor sites or documentation for inspiration.

## Key Principles

- **No code** - this is about ideas, not implementation
- **Visual when helpful** - use diagrams for architecture
- **Honest tradeoffs** - don't hide complexity
- **Next Steps** - suggest `/investigate` for technical analysis or `/new` to start planning

## Next Steps

When direction is clear:

- Use `/investigate` for technical deep-dives into existing code
- Use `/new [name]` to initialize a change folder
