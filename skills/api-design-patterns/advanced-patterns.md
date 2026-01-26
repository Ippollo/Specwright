# Advanced API Patterns

## HATEOAS (Hypermedia)

_Hypertext As The Engine Of Application State_

Include navigation links in responses. Allows clients to discover actions without hardcoding URLs.

```json
{
  "id": 123,
  "status": "pending_payment",
  "_links": {
    "self": { "href": "/orders/123", "method": "GET" },
    "pay": { "href": "/orders/123/pay", "method": "POST" },
    "cancel": { "href": "/orders/123", "method": "DELETE" }
  }
}
```

_Note: Optional for most pragmatic APIs, but helpful for state-machine driven UIs._

## Bulk Operations

Reduce network round-trips.

**Best Practice**: Use specialized endpoints, don't overload standard POST.

- `POST /users/bulk-create`
- `PATCH /users/bulk-update`

**Response**:
Return granular status for each item.

```json
{
  "results": [
    { "id": 1, "status": "success" },
    { "id": null, "status": "error", "error": "Invalid email" }
  ]
}
```

## Standard Media Types

Be explicit about content.

- `application/json`: Standard.
- `application/problem+json` (RFC 7807): Standard for error details.
- `application/merge-patch+json` (RFC 7396): For PATCH semantics where `null` means "delete field".

## Circuit Breakers

Protect your system from cascading failures.

If a downstream service (e.g. Payment Gateway) fails 50% of requests:

1. **Open** the circuit (stop sending requests immediately).
2. Fail fast with `503 Service Unavailable`.
3. After timeout, **Half-Open** (let 1 request through to test).
4. **Close** if successful.
