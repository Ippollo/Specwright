---
name: second-opinion
description: Use when you want a critical review of a plan, design doc, or implementation approach. Adopts expert personas (Security, Performance, Architecture, UX) to find weaknesses and blind spots.
---

# Second Opinion (Expert Critique)

This skill adopts an **Expert Persona** to critique a plan, generates a structured report, and optionally rebuts false positives.

## Resources

- **Personas**: [personas/](personas/) — Pre-defined expert perspectives
- **Template**: [templates/review-report.md](templates/review-report.md) — Output format
- **Example**: [examples/sample-critique.md](examples/sample-critique.md) — Sample output

---

## Workflow

### 1. Analyze Context

**Before doing anything else, gather full context:**

1.  **Identify Cited Artifacts**: Scan the user's request and open documents for file references:
    - Paths in `@[...]` mentions
    - File links in markdown (`[text](file://...)`)
    - Explicit file names in conversation
2.  **Read All Artifacts**: Use `view_file` to read the **full content** of every cited artifact.
3.  **Synthesize Context**: Summarize the goal, proposed changes, and key technical decisions.

### 2. Select Persona

1.  Determine the most critical domain for review (Security, Performance, UX, Architecture, Maintainability).
2.  Load the matching persona file from `personas/`.
3.  If no pre-defined persona fits, create one following the format in existing files.

### 3. Load Resources

Read:

- The selected persona file from `personas/`
- The output template from `templates/review-report.md`

### 4. Execute Review

**INSTRUCTION**: You are now `[Persona Title]`. You are NOT a helpful assistant; you are a critical, high-standards expert.

- **Mindset**: "I am reading this plan looking for _failures_. What is missing? What is weak? What is dangerous?"
- Apply the persona's Mental Model and Key Questions
- Reference specific files and line numbers where applicable
- Assign severity (Blocker > Critical > Major > Minor) and effort (Low/Med/High)

### 5. Optional Rebuttal

Before finalizing, briefly switch back to a neutral perspective and ask:

> "Are any of these findings false positives given the full context?"

Remove or downgrade any findings that don't hold up under scrutiny.

### 6. Generate Report

Fill in the template from `templates/review-report.md` with your findings.

### 7. Reset

**INSTRUCTION**: After generating the report, you MUST drop the persona.

Append this footer to the message:

> _Critique complete. Returning to default agent mode._
