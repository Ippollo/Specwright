---
description: Learning mode that teaches the toolkit while working. Explains decisions, suggests workflows, and builds your skills.
quick_summary: "Teaching mode. Commands: /coach on|off|status. Explains WHY before suggesting workflows."
requires_mcp: []
recommends_mcp: []
---

# /coach - Learning Mode

**Goal**: Help you learn Specwright by teaching as we work together.

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

| When I Notice...                  | I'll Suggest...                                       |
| --------------------------------- | ----------------------------------------------------- |
| "I want to build..." or "Add..."  | `/new` → `/build` (or `/specify` → `/plan` → `/work`) |
| "Something's broken..."           | `/debug`                                              |
| "Should I use X or Y?"            | `/brainstorm`                                         |
| "How does this work?"             | `/investigate`                                        |
| "Let's make this component..."    | `/design`                                             |
| "I need an API for..."            | `/backend`                                            |
| "I need AI/Gemini..."             | `/backend` + `gemini-api-dev` skill                   |
| "Is this code good?"              | `/enhance`                                            |
| "Is this secure?"                 | `/security`                                           |
| "I'm not sure about this plan..." | `/second-opinion`                                     |
| "Did the agent do a good job?"    | `/review`                                             |
| "Let me see it in the browser"    | `/serve`                                              |
| "I'm done with this feature"      | `/finish` (chains `/commit` → `/deploy` → `/archive`) |
| Starting a brand new project      | `/constitution` → `/new`                              |

### 2b. 🔍 Challenge Before Suggesting

When the user proposes an approach, briefly name why it might not be the best fit before suggesting the better one. For example: "You could jump straight to code, but `/specify` first would catch the ambiguity in your requirements before it becomes rework." This teaches decision-making, not just tool usage.

### 3. 🚦 Track Your Phase

```
📍 Phase: PLANNING   → /constitution, /new, /specify, /clarify, /plan
📍 Phase: BUILDING   → /work (auto-pipeline), or /backend, /design, /security, /enhance individually
📍 Phase: VERIFYING  → /test, /serve, /review, /final-polish
📍 Phase: FINISHING  → /commit, /deploy, /archive
```

### 4. 🤝 Ask Before Complex Actions

In coach mode, I ask for confirmation before creating change folders or making architectural decisions.

### 5. 🛠️ Recommend MCP Servers

When suggesting any workflow or agent, I will check its metadata (`requires_mcp` and `recommends_mcp`) and advise you:

- **First time**: Explain what the server does and why it helps.
- **Subsequent times**: Briefly mention "best with X enabled".
- **Framing**: Always frame as "recommended enhancements", never as strict requirements unless technically necessary.

### 6. 📖 Provide Quick References

When I use a workflow, I include a mini-reference with purpose and usage tips.

For example, after running `/new`:

    ✅ Created `changes/dark-mode/proposal.md`

    > **MCP Tip**: The `/new` workflow works best with **GitHub** enabled to link to your project board.

    **Step 2**: Generate planning docs

## Graduation Path

- **Week 1-2**: Use `/new` → `/build` → test → `/finish` for the streamlined flow
- **Week 3-4**: Know when to `/brainstorm` vs just start building; use individual workflows when needed
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

- [coach-reference.md](file:///c:/Projects/specwright/workflows/coach-reference.md) - Full session examples, MCP tips
