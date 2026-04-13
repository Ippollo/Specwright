# Feature Specification Template

> **Note**: This file is used as a template for new feature specifications.

## 📋 Feature Spec: [Feature Name]

**Created**: [Date]
**Status**: Draft
**Spec Level**: SDD (Spec-Driven Development)

---

## 1. Goal & Context

- **Problem**: What problem are we solving?
- **User**: Who is it for?
- **Value**: Why is this feature necessary?

## 2. User Scenarios (Prioritized)

> [!TIP]
> Each scenario should be an independently testable slice of functionality.

### Story 1: [Brief Title] (Priority: P1)

- **Journey**: [Describe the user flow]
- **Value**: [Why P1?]
- **Acceptance Scenarios**:
  - **Given** [initial state], **When** [action], **Then** [expected outcome]

### Story 2: [Brief Title] (Priority: P2)

- **Journey**: [Describe the user flow]
- **Acceptance Scenarios**:
  - **Given** [state], **When** [action], **Then** [outcome]

## 3. Constraints

### Must

- [Required patterns, libraries, conventions to follow]

### Must Not

- [Explicit prohibitions — frameworks to avoid, code not to modify, patterns to skip]
- Don't modify unrelated code

### Not Doing (and Why)

- [Adjacent feature explicitly not being built] — [why it's excluded from this change]

---

## 4. Functional Requirements

- **FR-001**: [Requirement]
- **FR-002**: [Requirement]
- **FR-003**: [NEEDS CLARIFICATION] - [Unclear point]

### Edge Cases

- [e.g., Network failure during checkout]
- [e.g., Invalid input validation]

## 5. Current State

> [!NOTE]
> Fill this in before handing the spec to an agent. Saves the agent from exploring the codebase.

- **Relevant files**: `path/to/file.ts`, `path/to/other.ts`
- **Existing patterns to follow**: [e.g., "Use the existing middleware pattern in `src/middleware/`"]
- **Related systems**: [APIs, services, or data models this touches]

---

## 6. Tasks

> [!TIP]
> Each task should touch ≤3 files and be completable in one agent session. Run tasks in fresh context windows.

### T1: [Title]

**What:** [Concrete deliverable for this task]
**Files:** `path/to/file`, `path/to/test`
**Verify:** `command to run` or "Manual: [what to check]"

### T2: [Title]

**What:** ...
**Files:** ...
**Verify:** ...

---

## 7. Success Criteria

- **SC-001**: [Measurable metric, e.g., "Passes login in < 2s"]
- **SC-002**: [User verification step]

---

## 8. Technical Context (Optional for Specify Phase)

_To be filled during /plan phase._

- **Tech Stack**: [Draft choices]
- **Dependencies**: [Draft choices]

---

## 9. Acceptance Traceability

> [!TIP]
> Initially blank during `/specify`. Populated during `/plan` (verification method) and `/work` (status updates). Audited during `/final-polish`.

| ID     | Criterion                  | Verification                                  | Status |
| ------ | -------------------------- | --------------------------------------------- | ------ |
| SC-001 | [From §7 Success Criteria] | [test file:function or "Manual: description"] | ⏳     |
| SC-002 | [From §7 Success Criteria] | [test file:function or "Manual: description"] | ⏳     |
