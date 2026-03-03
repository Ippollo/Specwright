# Specwright

A spec-driven development framework for AI coding assistants. Define requirements, plan the architecture, build with specialist agents, and ship with confidence — all through simple slash commands.

> [!NOTE]
> This toolkit was built for [Antigravity](https://github.com/Ippollo/Specwright), Google's AI-powered IDE, but the methodology works with any AI coding assistant that supports custom instructions.

## The Problem

AI coding assistants are powerful, but without structure they encourage **vibe coding** — ad-hoc prompts, no requirements, no review, and no traceability. The result is fast but fragile: code that works until it doesn't, and no record of _why_ it was built that way.

## The Solution

This toolkit wraps your AI assistant in a **Spec-Driven Development (SDD)** lifecycle:

```
/new → /specify → /plan → /work → /review → /final-polish → /commit → /archive
```

Every feature starts with a **specification**, gets a **plan**, is built by **specialist agents**, passes a **multi-stage review**, and is **archived with full traceability** back to the original requirements.

### What You Get

- 🎯 **Spec-first workflow** — Define _what_ and _why_ before writing any code
- 🧠 **7 specialist agents** — Backend Architect, Frontend Specialist, Debugger, QA Engineer, Security Engineer, Code Custodian, and Project Planner
- ⚡ **26 slash commands** — From `/brainstorm` to `/archive`, every phase has a workflow
- 🔒 **Quality gates** — Human approval at spec and plan stages; automated review after
- 📋 **Full traceability** — Requirements → tasks → code → tests → versioned spec snapshots
- 📚 **17+ skills** — Deep knowledge in API design, testing, security, performance, and more

## Quick Start

### 1. Clone & Add to Workspace

```bash
git clone https://github.com/Ippollo/Specwright.git specwright
```

In VS Code: **File → Add Folder to Workspace...** → select the `specwright` folder → Save.

> [!TIP]
> Adding as a workspace folder is the recommended method — no permission prompts, always up to date, and your AI assistant sees everything immediately.

<details>
<summary>Alternative: Global or Per-Project Install</summary>

**Global** (available in every project):

```powershell
./scripts/make-global.ps1
```

**Per-Project** (isolated copy):

```bash
# Windows
iwr -useb https://raw.githubusercontent.com/Ippollo/Specwright/main/install.ps1 | iex

# macOS / Linux
curl -fsSL https://raw.githubusercontent.com/Ippollo/Specwright/main/install.sh | bash
```

Per-project installs create a local copy. Re-run to update.

</details>

### 2. Set Your Project Rules

```
/constitution
```

This creates `docs/CONSTITUTION.md` — your project's guardrails (tech stack, conventions, preferences). All agents reference it.

### 3. Build Something

The fastest path from idea to shipped code:

```
/new my-feature          # Initialize a change folder
/build                   # Chains: specify → plan → work → review → final-polish
                         # You approve the spec and plan; everything else auto-proceeds
/finish                  # Chains: commit → deploy → archive
```

Or run each phase yourself:

| Phase      | Commands                      | What Happens                                               |
| ---------- | ----------------------------- | ---------------------------------------------------------- |
| **Ideate** | `/brainstorm`, `/investigate` | Explore options, research the codebase                     |
| **Plan**   | `/new` → `/specify` → `/plan` | Define requirements, generate tasks                        |
| **Build**  | `/work`                       | Auto-execute: backend → design → security → enhance → test |
| **Verify** | `/review`, `/final-polish`    | Specialist review, cleanup, acceptance verification        |
| **Ship**   | `/commit` → `/archive`        | Conventional commit, spec snapshot, archive                |

## 🎓 New to Agentic Development?

The toolkit can feel overwhelming at first. **Start with Coach mode:**

```
/coach on
```

- 🎓 Explains _why_ workflows exist before suggesting them
- 🧭 Suggests the right workflow at the right time
- 🚦 Tracks your progress (Planning → Building → Verifying → Done)
- 🤝 Asks before taking complex actions

Turn it off anytime with `/coach off`.

## What's Inside

| Component                     | Count | Purpose                                                                               |
| ----------------------------- | ----- | ------------------------------------------------------------------------------------- |
| **[Workflows](./workflows/)** | 26    | Slash commands for every phase of development                                         |
| **[Agents](./agents/)**       | 7     | Specialist personas (planner, architect, designer, debugger, QA, security, custodian) |
| **[Skills](./skills/)**       | 17+   | Deep knowledge bases (API patterns, testing, security, performance, Gemini API, etc.) |
| **[Templates](./templates/)** | 4     | Spec, task, proposal, and delta-spec templates                                        |

See [CATALOG.md](./CATALOG.md) for the full index.

## Documentation

| Doc                                                  | Purpose                               |
| ---------------------------------------------------- | ------------------------------------- |
| [Getting Started](./docs/GETTING_STARTED.md)         | Detailed setup walkthrough            |
| [Quick Reference](./docs/QUICK_REFERENCE.md)         | One-page cheat sheet for all commands |
| [Project Lifecycle](./docs/PROJECT_LIFECYCLE.md)     | Visual map of the complete workflow   |
| [MCP Recommendations](./docs/MCP_RECOMMENDATIONS.md) | Recommended MCP server configuration  |

### Scenario Guides

| Scenario                    | Guide                                                                   |
| --------------------------- | ----------------------------------------------------------------------- |
| Building a new feature      | [new-feature.md](./docs/scenarios/new-feature.md)                       |
| Starting a new project      | [new-project.md](./docs/scenarios/new-project.md)                       |
| Joining an existing project | [existing-project.md](./docs/scenarios/existing-project.md)             |
| Debugging a bug             | [debugging.md](./docs/scenarios/debugging.md)                           |
| Quick fix / hotfix          | [quick-fix.md](./docs/scenarios/quick-fix.md)                           |
| Large refactoring           | [large-refactoring.md](./docs/scenarios/large-refactoring.md)           |
| Resuming after a break      | [resuming-work.md](./docs/scenarios/resuming-work.md)                   |
| Onboarding a contributor    | [onboarding-contributor.md](./docs/scenarios/onboarding-contributor.md) |

## License

[MIT](./LICENSE) — fork it, adapt it, make it yours.
