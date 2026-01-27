# Quick Reference: Agentic Toolkit

One-page cheat sheet for common commands and agent flows.

## 🚀 The Three Phases

1. **Ideate**: Brainstorm and research. Use `/brainstorm` and `/investigate`.
2. **Plan**: Define specs and tasks. Use `/new`, `/specify`, `/clarify`, `/plan`, or `/ff`.
3. **Execute**: Build and verify. Use `/design`, `/backend`, `/test`, `/archive`.

---

## 🛠 Workflows

| Command           | Objective       | Use Case                                             |
| :---------------- | :-------------- | :--------------------------------------------------- |
| `/brainstorm`     | Explore options | Comparing different technical approaches.            |
| `/investigate`    | Deep-dive code  | Understanding existing logic before changing it.     |
| `/new`            | Start change    | **Required** starting point for any feature/fix.     |
| `/specify`        | Create specs    | Defining user stories and requirements.              |
| `/clarify`        | Fix gaps        | Identifying missing info in specifications.          |
| `/plan`           | Create tasks    | Generating `design.md` and `tasks.md`.               |
| `/ff`             | Fast-Forward    | Generates spec, design, and tasks in one pass.       |
| `/design`         | Frontend work   | Building UI components and styles.                   |
| `/backend`        | Server logic    | Designing APIs and backend architecture.             |
| `/test`           | Verification    | Running unit, integration, and E2E tests.            |
| `/debug`          | Fix bugs        | Investigating and resolving issues.                  |
| `/enhance`        | Refactor        | Improving existing code quality/speed.               |
| `/security`       | Audit           | Hardening code against vulnerabilities.              |
| `/final-polish`   | Cleanup         | Pre-submission checklist and verification.           |
| `/archive`        | Close change    | Moving delta specs to `specs/` and archiving folder. |
| `/preview`        | Dev server      | Manage local server for previewing changes.          |
| `/second-opinion` | Review          | Stress-testing plans with an expert persona.         |
| `/constitution`   | Rules           | Setting project-wide guardrails.                     |
| `/deploy`         | Release         | Deploying changes to production.                     |

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

## 💡 Quick Tips

- **Start with `/constitution`**: Set project rules before any coding begins.
- **Always `/new`**: Never work directly in the main branch. Isolated folders prevent chaos.
- **Spec First**: Use `/specify` before `/plan`. Clear requirements = better code.
- **Measure Twice**: Use `Project Planner` for complex changes.
- **Global linking**: Run `./scripts/make-global.ps1` to use these commands in any project.
