---
schema_version: 1.0
name: documentation-standards
description: "Comprehensive protocols for maintaining pristine project documentation, including decision trees, templates, and quality checks."
---

# Documentation Standards

This skill ensures that "The Job Isn't Done Until It's Documented". It provides a decision framework and execution-ready patterns for all technical documentation needs.

## 1. Decision Tree: What do I need?

Use this flow to determine the right documentation type:

```text
User needs: [Documentation Task]
    ├─ New project or repository?
    │   └─ **README.md** (use Protocol 3)
    │
    ├─ Made important technical decision?
    │   ├─ Architecture choice? → **ADR** (use Protocol 5)
    │   └─ Framework/Tool choice? → **ADR** with alternatives
    │
    ├─ Building or documenting API?
    │   ├─ REST/GraphQL? → **API Docs** (use Protocol 4)
    │   └─ Public Functions? → **Code Comments** (use Protocol 7)
    │
    ├─ Releasing new version?
    │   └─ **CHANGELOG.md** (use Protocol 2)
    │
    └─ Found a nasty bug/trap?
        └─ **Production Gotcha** (use Protocol 6)
```

## Quick Reference

| Doc Type      | Template                                 | Key Sections                    | Protocol |
| ------------- | ---------------------------------------- | ------------------------------- | -------- |
| **README**    | [readme.md](./templates/readme.md)       | Features, Install, Config       | #3       |
| **Changelog** | [changelog.md](./templates/changelog.md) | Added, Fixed, Breaking          | #2       |
| **ADR**       | [adr.md](./templates/adr.md)             | Context, Decision, Consequences | #5       |
| **Gotcha**    | [gotcha.md](./templates/gotcha.md)       | Trap, Symptom, Fix              | #6       |

---

## 2. Changelog Protocol

**Use when**: "Update the changelog", "What changed in this version?", "Prepare release".

> **Instruction**:
>
> 1.  **Read**: `CHANGELOG.md` to identify current version and format.
> 2.  **Draft**:
>     - **Header**: Use today's date and Semantic Version (`Major.Minor.Patch`).
>     - **Sections**: Group by `Added`, `Changed`, `Deprecated`, `Removed`, `Fixed`, `Security`.
> 3.  **Insert**: Prepend new entry to the top (below Unreleased).
> 4.  **Verify**: Ensure link to diff is correct (if applicable).

## 3. README Protocol

**Use when**: "New project", "Add installation steps", "Update config docs".

> **Instruction**:
>
> 1.  **Scan**: Does the change introduce new env vars or build steps?
> 2.  **Locate**: Relevant section (`Configuration`, `Getting Started`).
> 3.  **Update**:
>     - If **New Env Var**: Update `.env.example` AND README config table.
>     - If **New Command**: Add to `Makefile` or `package.json` scripts first, then document.
> 4.  **Validate**: "Fresh Eyes" test - could a junior dev follow this?

## 4. API Documentation Protocol

**Use when**: "Document this endpoint", "Create API reference".

> **Instruction**:
>
> 1.  **Identify**: HTTP Method, Endpoint URL, Auth requirements.
> 2.  **Schema**: Define Request Body and Response Model.
> 3.  **Examples**: Provide strict JSON examples for _Success_ (200) and _Error_ (4xx/5xx) cases.
> 4.  **Format**:
>     - If using OpenAPI: Update YAML/JSON spec.
>     - If Markdown: Use a clear request/response code block pair.

## 5. ADR Protocol (Architecture Decision Record)

**Use when**: "Why did we choose X?", "Deciding on database", "Major refactor".

> **Instruction**:
>
> 1.  **Create**: New file `doc/adr/XXXX-title.md` using [adr.md](./templates/adr.md).
> 2.  **Context**: Explain the _problem_ and constraints, not just the solution.
> 3.  **Consequences**: List both **Positive** (Benefits) and **Negative** (Trade-offs).
> 4.  **Status**: Mark as `Accepted` or `Proposed`.

## 6. Production Gotchas Protocol

**Use when**: "This bug took hours to debug", "Obscure platform issue", "Silent failure".

> **Instruction**:
>
> 1.  **Target**: `docs/gotchas.md` or dedicated `TROUBLESHOOTING.md`.
> 2.  **Structure**:
>     - **The Trap**: What looks right but fails?
>     - **Symptom**: Exact error message or behavior.
>     - **Fix**: The solution.
>     - **Prevention**: How to stop it happening again.
> 3.  **Share**: Mention this in relevant code comments near the fix.

## 7. Code Comments Protocol

**Use when**: "Explain this logic", "Add JSDoc".

> **Instruction**:
>
> 1.  **Public API**: Use JSDoc/Docstring. Focus on **Inputs**, **Outputs**, and **Exceptions**.
> 2.  **Complex Logic**: Comment **WHY**, not **WHAT**.
>     - ❌ `// Increment i by 1`
>     - ✅ `// Offset required because external API is 1-indexed`
> 3.  **Format**:
>     ```typescript
>     /**
>      * Short description of what it does.
>      *
>      * @param {Type} name - Description
>      * @returns {Type} Description
>      * @throws {ErrorType} When condition is met
>      */
>     ```

---

## Quality Checklist

Before completing any documentation task:

- [ ] **Links**: Do all internal/external links work?
- [ ] **Copy-Paste**: Do code examples actually run?
- [ ] **Secrets**: Are any real API keys accidentally included? (Use `sk_test_...`)
- [ ] **Spelling**: Run spellcheck.
- [ ] **Versioning**: Is the version number consistent across files?
