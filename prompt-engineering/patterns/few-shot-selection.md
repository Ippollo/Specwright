# Pattern: Few-Shot with Dynamic Example Selection

**Use when**: You have a large library of potential examples (few-shot) but can only fit a few relevant ones in the context window.

This pattern uses semantic similarity to retrieve the most relevant examples for the current query.

```python
from langchain_chroma import Chroma
from langchain_core.example_selectors import SemanticSimilarityExampleSelector
from langchain_voyageai import VoyageAIEmbeddings

# 1. Define Your Example Library
# A diverse set of good input-output pairs
examples = [
    {"input": "How do I reset my password?", "output": "Go to Settings > Security > Reset Password"},
    {"input": "Where can I see my order history?", "output": "Navigate to Account > Orders"},
    {"input": "How do I contact support?", "output": "Click Help > Contact Us or email support@example.com"},
    {"input": "Can I change my username?", "output": "Yes, go to Profile > Edit Profile > Username"},
    {"input": "What is the return policy?", "output": "Returns are accepted within 30 days of purchase."},
]

# 2. Initialize Example Selector
# Uses a vector store to find examples semantically similar to the input
example_selector = SemanticSimilarityExampleSelector.from_examples(
    examples=examples,
    embeddings=VoyageAIEmbeddings(model="voyage-3-large"),
    vectorstore_cls=Chroma,
    k=2  # Select top 2 most relevant examples
)

async def get_dynamic_prompt(user_query: str) -> str:
    """Build a prompt with dynamically selected examples."""

    # 3. Select Relevant Examples
    selected_examples = await example_selector.aselect_examples({"input": user_query})

    # 4. Format Examples for the Prompt
    examples_text = "\n".join(
        f"User: {ex['input']}\nAssistant: {ex['output']}"
        for ex in selected_examples
    )

    # 5. Construct Final Prompt
    prompt = f"""You are a helpful customer support assistant.

Here are some example interactions similar to the current request:
{examples_text}

Now respond to this query:
User: {user_query}
Assistant:"""

    return prompt
```
