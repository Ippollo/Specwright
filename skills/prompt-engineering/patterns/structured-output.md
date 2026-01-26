# Pattern: Structured Output with Pydantic

**Use when**: You need to guarantee that the LLM's output conforms to a strict schema for downstream processing.

This pattern uses Pydantic models to define the expected structure and includes error handling for malformed JSON.

````python
from anthropic import Anthropic
from pydantic import BaseModel, Field, ValidationError
from typing import Literal, List
import json

# 1. Define the Schema
class SentimentAnalysis(BaseModel):
    sentiment: Literal["positive", "negative", "neutral"]
    confidence: float = Field(ge=0, le=1, description="Confidence score between 0.0 and 1.0")
    key_phrases: List[str]
    reasoning: str

async def analyze_sentiment(text: str) -> SentimentAnalysis:
    """Analyze sentiment with structured output."""
    client = Anthropic()

    # 2. Construct the Prompt
    # Explicitly requesting JSON and guarding against common formatting issues
    system_prompt = """
    You are a sentiment analysis engine.
    Output ONLY valid JSON matching the specified schema.
    Do not include markdown formatting (like ```json ... ```) or conversational text.
    """

    user_prompt = f"""
    Analyze the sentiment of this text:

    Text: {text}

    Respond with JSON matching this schema:
    {{
        "sentiment": "positive" | "negative" | "neutral",
        "confidence": 0.0-1.0,
        "key_phrases": ["phrase1", "phrase2"],
        "reasoning": "brief explanation"
    }}
    """

    try:
        message = client.messages.create(
            model="claude-3-5-sonnet-20241022",
            max_tokens=1024,
            system=system_prompt,
            messages=[{"role": "user", "content": user_prompt}]
        )

        # 3. Parse and Validate
        raw_content = message.content[0].text
        data = json.loads(raw_content)
        return SentimentAnalysis(**data)

    except (json.JSONDecodeError, ValidationError) as e:
        # 4. Error Handling / Retry Logic
        print(f"Validation failed: {e}")
        # In production, you might retry the request with the error message appended to the prompt
        # to ask the LLM to self-correct.
        raise
````
