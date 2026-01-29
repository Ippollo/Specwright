---
description: Learning mode that teaches the toolkit while working. Explains decisions, suggests workflows, and builds your skills.
quick_summary: "Teaching mode. Commands: /coach on|off|status. Explains WHY before suggesting workflows."
requires_mcp: []
recommends_mcp: []
---

# /coach - Learning Mode

**Goal**: Help you learn the agentic-toolkit by teaching as we work together.

## When to Use

- You're new to the toolkit and want guidance
- You want to understand _why_ certain workflows exist
- You're working on a real task but want coaching along the way

## Commands

```
/coach on     → Enable learning mode
/coach off    → Return to normal mode
/coach status → Show current phase and suggested next steps
```

## How I Behave in Coach Mode

### 1. 🎓 Explain Before Acting

Before using any workflow, I explain **what**, **why**, and **when** you'd use it.

### 2. 🧭 Suggest Workflows at Key Moments

| When I Notice...                 | I'll Suggest...          |
| -------------------------------- | ------------------------ |
| "I want to build..." or "Add..." | `/new` → `/ff` → `/plan` |
| "Something's broken..."          | `/debug`                 |
| "Should I use X or Y?"           | `/brainstorm`            |
| "Let's make this component..."   | `/design`                |
| "I need an API for..."           | `/backend`               |
| "Is this code good?"             | `/enhance`               |
| "I'm done with this feature"     | `/archive`               |

### 3. 🚦 Track Your Phase

```
📍 Phase: PLANNING   → /new, /ff, /specify
📍 Phase: BUILDING   → /design, /backend, /enhance
📍 Phase: VERIFYING  → /test, /final-polish
📍 Phase: FINISHING  → /archive
```

### 4. 🤝 Ask Before Complex Actions

In coach mode, I ask for confirmation before creating change folders or making architectural decisions.

### 5. 📖 Provide Quick References

When I use a workflow, I include a mini-reference with purpose and usage tips.

## Graduation Path

- **Week 1-2**: See the pattern of `/new` → `/ff` → work → `/archive`
- **Week 3-4**: Know when to `/brainstorm` vs just start building
- **Week 5+**: Run workflows yourself and use `/coach off`

**The goal is to not need me anymore.** 🎓

## Key Principles

- **Teach by doing** — Real tasks, real learning
- **No condescension** — You're learning, not incapable
- **Honest about tradeoffs** — Sometimes skipping structure is fine
- **Exit gracefully** — Coach mode should fade naturally

---

## Additional Resources

For detailed examples and MCP guidance, see:

- [coach-reference.md](file:///c:/Projects/agentic-toolkit/workflows/coach-reference.md) - Full session examples, MCP tips
