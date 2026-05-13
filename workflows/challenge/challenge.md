---
description: Lightweight, domain-agnostic red team. Challenge any artifact or decision in ~2 minutes before shipping.
quick_summary: "Fast adversarial review for any work product — content, emails, decisions, plans. Max 3 findings, conversational output."
requires_mcp: []
recommends_mcp: []
---

# /challenge — Lightweight Red Team

**Goal**: Stress-test any work product or decision in ~2 minutes. Find the fatal flaw before it ships.

> [!IMPORTANT]
> This is a fast sparring round, not a formal audit. Max 3 findings. Conversational output. No templates, no severity ratings. If the user wants a deeper review, escalate to the `second-opinion` skill.

## When to Use

- Before sending an email or outreach message
- Before publishing a content draft
- Before committing to a business decision or strategy
- Before submitting a job application or cover letter
- Before shipping a technical plan
- Anytime you think "this feels done" — that's the signal

## Usage

```
/challenge                            → challenges the active document or last artifact
/challenge "Should I pursue this role?" → challenges a stated decision
/challenge @[path/to/file.md]         → challenges a specific file
```

## Steps

### 1. Identify the Target

Determine what's being challenged:

- If a file or artifact is referenced, read it in full
- If a decision statement is given, frame it as the target
- If nothing is specified, use the active document from the user's editor state
- If still ambiguous, ask: "What should I challenge?"

### 2. Classify the Domain

Auto-classify based on content. Do not ask the user to choose — infer from context:

| Signal | Domain | Lens |
|---|---|---|
| Post draft, article, hook, CTA, LinkedIn | Content | `content-draft` |
| Email, DM, outreach, follow-up, cold message | Email / Outreach | `email-outreach` |
| "Should I...", strategy, pricing, partnership, investment | Business Decision | `business-decision` |
| Job application, resume, cover letter, role evaluation | Career Move | `career-move` |
| Architecture, implementation plan, technical spec, code | Technical Plan | `technical-plan` |

If the target spans multiple domains, pick the primary one. Don't run multiple lenses — keep it fast.

### 3. Load the Lens

Read the matching lens file from the `lenses/` directory relative to this workflow:

```
lenses/content-draft.md
lenses/email-outreach.md
lenses/business-decision.md
lenses/career-move.md
lenses/technical-plan.md
```

If no lens matches, create an ad-hoc one using the same format: a framing statement + 3 key questions + a tone.

### 4. Run the Challenge

Adopt the lens framing. Read the target through that lens. Apply the key questions.

**Rules:**
- **Max 3 findings.** If you find more, prioritize by impact. Drop the rest.
- **Be specific.** "The hook is weak" is useless. "The hook promises a framework but the post delivers a story — the reader who clicked for tactics will bounce" is useful.
- **No line-editing.** Don't rewrite their work. Identify what's wrong and why.
- **Name what's working.** If something is genuinely strong, say so in one sentence. Don't manufacture praise — but don't be adversarial for sport either.
- **Stay in character.** You are the persona in the lens framing, not a helpful assistant.

### 5. Output

Deliver findings conversationally. No templates, no markdown headers, no severity ratings. Format:

```
[One sentence on what's working, if anything genuinely is]

Three things I'd fix before shipping:

1. [Finding] — [Why it matters]
2. [Finding] — [Why it matters]
3. [Finding] — [Why it matters]
```

### 6. User Response

| User says | Do this |
|---|---|
| Fixes or asks for help with a finding | Help them fix it |
| "Go deeper" | Escalate to full `second-opinion` skill — load the appropriate persona and run the full review workflow |
| "Ship it" / acknowledges and moves on | Done. Don't relitigate. |

## Adding New Lenses

To add a lens, create a markdown file in `lenses/` following this format:

```markdown
# Lens Name

**Domain**: [What types of work this lens applies to]
**Framing**: "[The persona statement — who you are when using this lens]"

## Key Questions
1. [Question that exposes the most common failure mode]
2. [Question that challenges assumptions]
3. [Question that tests whether this achieves its goal]

## Tone
[One sentence describing the persona's attitude and style]
```

## Key Principles

- **Speed over depth.** If it takes more than 2 minutes, you're doing it wrong.
- **3 findings max.** Constraint forces prioritization. The user can escalate if they want more.
- **No auto-trigger.** This is invoked manually. The goal is to be fast enough that the user *wants* to use it.
- **Domain-agnostic.** This is not a dev tool. It works on anything.
- **Honest, not adversarial.** The goal is to catch real problems, not to perform skepticism.
