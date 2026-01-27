# Scenario: Building a New Feature

This guide demonstrates the full "Meticulous Workflow"—recommended for complex features where quality and architecture are paramount.

## The Goal

Add a "Dark Mode" toggle to an existing dashboard.

---

### Step 1: Exploration

Before coding, explore the existing codebase to see how styling is handled.

```bash
/investigate "How are colors and themes currently managed in the dashboard?"
```

### Step 2: Initialization

Start the formal change process.

```bash
/new dark-mode-support
```

### Step 3: Requirements (Specification)

Define exactly what the feature should do.

```bash
/specify "Dashboard theme toggle in navbar, persistent across sessions, uses CSS variables."
```

_Creates: `changes/dark-mode-support/specs/theme.md`_

### Step 4: Refinement

Find gaps in the plan.

```bash
/clarify
```

_The agent might ask: "Should current system preference (OS Dark Mode) be respected?"_

### Step 5: Planning & Design

Generate the technical plan.

```bash
/plan
```

_Creates: `changes/dark-mode-support/design.md` and `tasks.md`._

### Step 6: Targeted Execution

Implement the UI with the Frontend Specialist.

```bash
/design "Create ThemeProvider and Toggle component with smooth transitions"
```

### Step 7: Verification

Run tests to ensure it works as expected.

```bash
/test "Theme toggle persistence and style application"
```

### Step 8: Archive

Clean up and finalize.

```bash
/archive dark-mode-support
```

---

## Why this workflow?

1. **Consistency**: `/specify` ensures you don't forget edge cases.
2. **Isolation**: `/new` keeps changes separate from other work.
3. **Audit Trail**: `/archive` preserves the "Why" (specs) even after the code is merged.
