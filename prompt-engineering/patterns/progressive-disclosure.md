# Pattern: Progressive Disclosure

**Use when**: You want to optimize for cost and latency by starting with simple prompts and only increasing complexity (and token count) when necessary.

This defines a hierarchy of prompt templates for the same task.

```python
PROMPT_LEVELS = {
    # Level 1: Direct instruction (Fastest, Cheapest)
    "simple": "Summarize this article: {text}",

    # Level 2: Add constraints (Better formatting/structure)
    "constrained": """Summarize this article in 3 bullet points, focusing on:
- Key findings
- Main conclusions
- Practical implications

Article: {text}""",

    # Level 3: Add reasoning (Better logic/analysis)
    "reasoning": """Read this article carefully.
1. First, identify the main topic and thesis
2. Then, extract the key supporting points
3. Finally, summarize in 3 bullet points

Article: {text}

Summary:""",

    # Level 4: Add examples (Highest quality, Most tokens)
    "few_shot": """Read articles and provide concise summaries.

Example:
Article: "New research shows that regular exercise can reduce anxiety by up to 40%..."
Summary:
• Regular exercise reduces anxiety by up to 40%
• 30 minutes of moderate activity 3x/week is sufficient
• Benefits appear within 2 weeks of starting

Now summarize this article:
Article: {text}

Summary:"""
}

def get_prompt_for_complexity(text: str, complexity: str = "simple") -> str:
    """Retrieve the prompt template for the desired complexity level."""
    template = PROMPT_LEVELS.get(complexity, PROMPT_LEVELS["simple"])
    return template.format(text=text)
```
