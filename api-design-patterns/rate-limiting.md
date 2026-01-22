# Rate Limiting Patterns

Protect your downstream services and prevent abuse.

## Headers (RFC 6585)

Communicate limits clearly to clients.

```http
HTTP/1.1 200 OK
X-RateLimit-Limit: 1000        # Hits allowed per window
X-RateLimit-Remaining: 995     # Hits left
X-RateLimit-Reset: 1700000000  # Unix timestamp when window resets
```

## Exceeding Limits

Return `429 Too Many Requests`.

```http
HTTP/1.1 429 Too Many Requests
Retry-After: 30                # Seconds to wait

{
  "error": {
    "code": "RATE_LIMIT_EXCEEDED",
    "message": "You have exceeded your request limit.",
    "links": { "upgrade": "..." }
  }
}
```

## Algorithms

1. **Fixed Window**: 1000 requests / hour.
   - _Issue_: Spikes at the window boundary (e.g. at XX:59 and XX:01).
2. **Sliding Window**: Smoother. Counts requests in the last X seconds relative to now.
3. **Token Bucket**: "Burst" capacity. You have 100 tokens, refill 10 per second. Good for allowing short usage spikes.

## Scopes

- **User-ID based**: Limits per signed-in user (harder to bypass).
- **IP-based**: Fallback for anonymous usage (can block NATs/offices).
- **Global**: Circuit-breaking level (protect DB).
