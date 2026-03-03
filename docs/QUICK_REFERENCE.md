# Quick Reference: Agentic Toolkit

One-page cheat sheet for common commands and agent flows.

## 🚀 The Three Phases

1. **Ideate**: Brainstorm and research. Use `/brainstorm` and `/investigate`.
2. **Plan**: Define specs and tasks. Use `/new`, `/specify`, `/clarify`, and `/plan`.
3. **Execute**: Build and verify. Use `/work` to auto-run the pipeline, or `/backend`, `/design`, etc. individually.

---

## 🛠 Workflows

| Command           | Objective         | Use Case                                                                   |
| :---------------- | :---------------- | :------------------------------------------------------------------------- |
| `/brainstorm`     | Explore options   | Comparing different technical approaches.                                  |
| `/investigate`    | Deep-dive code    | Understanding existing logic before changing it.                           |
| `/new`            | Start change      | **Required** starting point for any feature/fix.                           |
| `/specify`        | Create specs      | Defining user stories and requirements.                                    |
| `/clarify`        | Fix gaps          | Identifying missing info in specifications.                                |
| `/plan`           | Create tasks      | Generating `design.md` and `tasks.md`.                                     |
| `/work`           | **Pipeline**      | Auto-executes tasks by tag: backend → design → security → enhance → test.  |
| `/design`         | Frontend work     | Building UI components and styles.                                         |
| `/backend`        | Server logic      | Designing APIs and backend architecture.                                   |
| `/test`           | Verification      | Running unit, integration, and E2E tests.                                  |
| `/debug`          | Fix bugs          | Investigating and resolving issues.                                        |
| `/enhance`        | Refactor          | Improving existing code quality/speed.                                     |
| `/security`       | Audit             | Hardening code against vulnerabilities.                                    |
| `/final-polish`   | Cleanup           | Pre-submission checklist, verification, and acceptance traceability audit. |
| `/commit`         | Save & push       | Stage, conventional commit, and push. Always pushes.                       |
| `/archive`        | Close change      | Snapshot specs, merge to `specs/`, and archive folder.                     |
| `/serve`          | Dev server        | Manage local server for previewing changes.                                |
| `/review`         | Quality audit     | Specialist review pipeline for agent auto-proceeded work.                  |
| `/second-opinion` | Review            | Stress-testing plans with an expert persona.                               |
| `/constitution`   | Rules             | Setting project-wide guardrails.                                           |
| `/deploy`         | Release           | Deploying changes to production.                                           |
| `/build`          | **Full pipeline** | Chains specify → plan → work → review → final-polish in one command.       |
| `/finish`         | **Ship & close**  | Chains commit → deploy → archive. The final step after testing.            |
| `/coach`          | Learning mode     | Teaches the toolkit while you work. Toggle with `/coach on/off`.           |

---

## 🤖 Agents

| Agent                   | Purpose                                                                  |
| :---------------------- | :----------------------------------------------------------------------- |
| **Project Planner**     | Planning only. Does NOT write code. Creates research, design, and tasks. |
| **Frontend Specialist** | UI/UX expert. Focuses on aesthetics, React patterns, and CSS.            |
| **Backend Architect**   | API and database design. Server-side logic and performance.              |
| **Debugger**            | Solving complex bugs and performance issues.                             |
| **QA Engineer**         | Writing tests and verifying acceptance criteria.                         |
| **Sec-DevOps**          | Infrastructure, security hardening, and deployment.                      |
| **Code Custodian**      | Refactoring, code quality, and library maintenance.                      |

---

## ⚙️ MCP Settings

Keep exactly **50 tools enabled** across 8 servers to cover all workflows without manual toggling.
See [MCP_SETTINGS.md](./MCP_SETTINGS.md) for the full enable/disable list per server.

| Server              | Enabled |
| ------------------- | :-----: |
| context7            |   2/2   |
| firebase            |  18/31  |
| gcloud              |   1/1   |
| github              |  8/26   |
| playwright          |  10/22  |
| sequential-thinking |   1/1   |
| firecrawl-mcp       |  4/12   |
| observability       |  6/13   |

---

## 💡 Quick Tips

- **Start with `/constitution`**: Set project rules before any coding begins.
- **Trust but verify**: After the agent auto-proceeds, run `/review` to spot-check quality.
- **Always `/new`**: Never work directly in the main branch. Isolated folders prevent chaos.
- **Spec First**: Use `/specify` before `/plan`. Clear requirements = better code.
- **Measure Twice**: Use `Project Planner` for complex changes.
- **Use `/build`**: The fastest path from idea to reviewed code. One command does it all.
- **Use `/finish`**: After testing, one command to commit, deploy, and archive.
- **Use `/work`**: After planning, let `/work` drive execution through the pipeline automatically.
- **Global linking**: Run `./scripts/make-global.ps1` to use these commands in any project.
