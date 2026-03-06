---
name: prompt-engineering
description: Use when crafting prompts for LLMs, implementing chain-of-thought reasoning, structured output generation, or debugging unreliable AI outputs. Meta-protocols that other skills should reference for reasoning and self-correction patterns.
---

# Prompt Engineering Standards

This skill provides **meta-protocols** that other skills should import or emulate to ensure intelligence and reliability.

## 1. The "Chain-of-Thought" Protocol

**Use when**: Solving complex logic, debugging, or planning architecture.

> **Instruction**: "Think step-by-step. First, analyze the constraints and dependencies. Then, outline your approach. Finally, generate the solution."

## 2. The "Self-Correction" Protocol

**Use when**: Generating critical code, security configs, or valid JSON.

> **Instruction**: "After generating the code, review it against the user's requirements. If you find errors or missing edge cases, correct them _before_ outputting the final block."

## 3. The "Persona" Protocol

**Use when**: You need deep domain expertise (e.g., Security, Legal, DevOps).

> **Instruction**: "Act as a [Role Name]. You are an expert in [Domain]. You prioritize [Value X] over [Value Y]."
> _Example_: "Act as a Principal Site Reliability Engineer. Prioritize system stability and observability over feature velocity."

## 4. The "Structured Output" Protocol

**Use when**: The output must be parsed by a script or tool. See `patterns/structured-output.md` for implementation details.

> **Instruction**: "Output ONLY valid JSON. Do not include markdown formatting (```json) or conversational text. The schema must be: { key: 'value' }."

## 5. The "Progressive Disclosure" Protocol

**Use when**: Orchestrating complex tasks where simple prompts fail but full context is expensive.

> **Instruction**: "Start with the simplest prompt. If the output fails validation or lacks depth, escalate to a constrained prompt, then a reasoning prompt, and finally a few-shot prompt with examples."
> _Reference_: `patterns/progressive-disclosure.md`

## 6. The "Verification & Validation" Protocol

**Use when**: Reliability is paramount and you need to ensure specific criteria are met.

> **Instruction**: "After generating the response, verify it meets ALL these criteria:
>
> - Directly addresses the original request
> - Contains no factual errors
> - Uses proper formatting
>   If verification fails, revise before outputting."

## 7. The "Error Recovery" Protocol

**Use when**: Handling potentially malformed outputs or ambiguous requests.

> **Instruction**: "If the output is invalid (e.g., malformed JSON), catch the error and retry with a simplified prompt or an explicit correction instruction citing the error."

---

## Anti-Patterns (What NOT To Do)

- **Prompt Stuffing**: Adding irrelevant context "just in case." This dilutes attention and increases costs.
- **Vague Instructions**: "Fix the code" (Bad) vs. "Fix the syntax error on line 42 caused by the missing semicolon" (Good).
- **Context Overflow**: Trying to cram too many few-shot examples into one prompt. Use dynamic selection (`patterns/few-shot-selection.md`) instead.
- **Ignoring Edge Cases**: Assuming the happy path. Always test with empty inputs, maximum values, or malformed data.
- **Over-Engineering**: Starting with a complex chain-of-thought prompt for a simple task like "capitalize this string."

## Best Practices Checklist

- [ ] **Be Specific**: ambiguous prompts yield ambiguous results.
- [ ] **Show, Don't Tell**: Use examples (few-shot) whenever possible.
- [ ] **Enforce Schemas**: Use Pydantic or similar tools for structured data.
- [ ] **Iterate**: Test prompt variations (A/B testing) to find the local optimum.
- [ ] **Document Intent**: Explain _why_ a prompt is structured a certain way in comments.

## Usage in Other Skills

When building new skills (like `git-wizard` or `system-design-architect`), **explicitly reference these protocols** in their instructions.

- _Bad_: "Generate a commit message."
- _Good_: "Using the **Chain-of-Thought Protocol**, analyze the diff to understand the intent. Then, acting as a **Senior Tech Lead**, generate a Conventional Commit message."
