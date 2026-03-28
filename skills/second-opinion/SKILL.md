---
name: second-opinion
description: "Use when you want a critical review of a plan, proposal, strategy, design doc, decision, or implementation approach. Adopts expert personas to find weaknesses, blind spots, and unexamined assumptions."
metadata:
  pattern: reviewer
---

# Second Opinion (Expert Critique)

This skill adopts an **Expert Persona** to critique an artifact or decision, generates a structured report, and optionally rebuts false positives.

## Resources

- **Personas**: [personas/](personas/) — Pre-defined expert perspectives
  - **Technical**: security, performance, ux-design, systems-arch, maintainability
  - **Strategic**: strategy, market-fit, pragmatist
- **Templates**:
  - [review-report.md](templates/review-report.md) — For code and implementation artifacts
  - [decision-challenge.md](templates/decision-challenge.md) — For plans, proposals, strategies, and decisions
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
3.  **Synthesize Context**: Summarize the goal, proposed changes, and key decisions.
4.  **Classify Target**: Determine if the target is:
    - **Code/Implementation** → use technical personas and `review-report.md` template
    - **Plan/Proposal/Strategy/Decision** → use strategic personas and `decision-challenge.md` template
    - **Mixed** → run one persona from each category

### 2. Select Persona

1.  Determine the most critical domain for review.
    - **Technical targets**: Security, Performance, UX, Architecture, Maintainability
    - **Strategic targets**: Strategy (assumptions/opportunity cost), Market Fit (demand/evidence), Pragmatist (complexity/simplicity)
2.  Load the matching persona file from `personas/`.
3.  If no pre-defined persona fits, create one following the format in existing files.

### 3. Load Resources

Read:

- The selected persona file from `personas/`
- The appropriate output template from `templates/`

### 4. Execute Review

**INSTRUCTION**: You are now `[Persona Title]`. You are NOT a helpful assistant; you are a critical, high-standards expert.

- **Mindset**: "I am reading this looking for _failures_. What is missing? What is weak? What is dangerous? What assumptions are unexamined?"
- Apply the persona's Mental Model and Key Questions
- **For code artifacts**: Reference specific files and line numbers where applicable. Assign severity (Blocker > Critical > Major > Minor) and effort (Low/Med/High)
- **For decision artifacts**: Challenge assumptions, name risks, identify alternatives not considered, and flag gaps. Assign severity (🔴 Critical > 🟠 Major > 🟡 Minor)

### 5. Optional Rebuttal

Before finalizing, briefly switch back to a neutral perspective and ask:

> "Are any of these findings false positives given the full context?"

Remove or downgrade any findings that don't hold up under scrutiny.

### 6. Generate Report

Fill in the appropriate template with your findings:
- Code/implementation → `templates/review-report.md`
- Plan/proposal/strategy/decision → `templates/decision-challenge.md`

### 7. Reset

**INSTRUCTION**: After generating the report, you MUST drop the persona.

Append this footer to the message:

> _Critique complete. Returning to default agent mode._
