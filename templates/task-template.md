# Task Breakdown Template

> **Note**: This file is used as a template for actionable task lists.

## 🛠️ Tasks: [Feature Name]

**Reference Plan**: [PLAN-slug.md]
**Reference Spec**: [SPEC-slug.md]

---

## Phase 1: Foundation (User Story: [P1 Title])

- [ ] `/backend` — 1.1 [Task Description] (File: [path])
- [ ] `/backend` — 1.2 [P] [Task Description] (File: [path])
- [ ] `/design` — 1.3 [P] [Task Description] (File: [path])
- [ ] **CHECKPOINT**: [How to verify Phase 1]

## Phase 2: Core Feature (User Story: [P2 Title])

- [ ] `/backend` — 2.1 [Task Description] (File: [path])
- [ ] `/design` — 2.2 [P] [Task Description] (File: [path])
- [ ] **CHECKPOINT**: [How to verify Phase 2]

## Phase 3: Hardening

- [ ] `/security` — 3.1 [Task Description]
- [ ] `/enhance` — 3.2 [Task Description]
- [ ] `/test` — 3.3 [Task Description]
- [ ] **CHECKPOINT**: [How to verify Phase 3]

---

## Legend

- `[P]`: Can be executed in **parallel**.
- `[!]`: High-risk or complex task.
- `[T]`: Testing task (TDD required).

## Workflow Tags

Every task MUST be prefixed with its executing workflow tag:

| Tag         | Use When                                                   |
| ----------- | ---------------------------------------------------------- |
| `/backend`  | APIs, database schema, services, hooks, server logic       |
| `/design`   | UI components, pages, layouts, styling, responsiveness     |
| `/enhance`  | Refactoring, optimization, code smell removal, performance |
| `/test`     | Writing or updating unit, integration, or E2E tests        |
| `/debug`    | Investigating and fixing bugs                              |
| `/security` | Security audits, rule hardening, auth changes              |

## Pipeline Execution Order

When executing via `/work`, tasks are processed in this order:

1. `/backend` — Foundation (data models, APIs, hooks)
2. `/design` — UI built on backend contracts
3. `/security` — Audit the complete implementation
4. `/enhance` — Optimize and clean up
5. `/test` — End-to-end verification

## Verification Strategy

- [ ] Unit Test Suite
- [ ] Integration Flow
- [ ] Final Manual Review
