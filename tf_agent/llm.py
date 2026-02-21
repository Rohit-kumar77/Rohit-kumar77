import os
from typing import Optional

try:
    import openai
except Exception:
    openai = None


def call_llm(prompt: str, max_tokens: int = 512) -> str:
    """Call an LLM (OpenAI) if available, otherwise return a placeholder string.

    This helper keeps the dependency optional so the agent can still be used
    when an API key or the package is not present.
    """
    api_key = os.getenv("OPENAI_API_KEY")
    if openai and api_key:
        openai.api_key = api_key
        resp = openai.Completion.create(engine="text-davinci-003", prompt=prompt, max_tokens=max_tokens)
        return resp.choices[0].text.strip()

    return f"[LLM unavailable] Prompt:\n\n{prompt}"
