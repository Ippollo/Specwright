# API Versioning Strategies

Plan for evolution from Day 1. Changing an API contract breaks clients.

## Strategies

### 1. URI Path Versioning (Recommended)

Put the version explicitly in the URL.

```http
GET /api/v1/users
```

- **Pros**: Explicit, visible in browser history/logs, easy for clients to debug.
- **Cons**: "Pollutes" the resource identifier.
- **Best For**: Public APIs, mobile apps where forcing updates is hard.

### 2. Header Versioning (Content Negotiation)

Use the `Accept` header.

```http
GET /api/users
Accept: application/vnd.company.v1+json
```

- **Pros**: URLs remain clean ("resources don't change, their representation does").
- **Cons**: Harder to test in browser, hidden from logs often.
- **Best For**: Internal microservices, purist REST APIs.

### 3. Query Parameter

```http
GET /api/users?v=1
```

- **Pros**: Easy to implement.
- **Cons**: Mixes protocol concerns with resource filters. **Avoid if possible**.

## Breaking vs. Non-Breaking

A version bump is required **ONLY** for breaking changes.

**Non-Breaking (Don't Version):**

- Adding a new field to a response.
- Adding a new optional parameter.
- Adding a new endpoint.

**Breaking (MUST Version):**

- Renaming or removing a field.
- Changing a data type (string -> int).
- Making an optional parameter required.
- Changing validation rules to be stricter.

## Deprecation Policy

1. Mark old version/endpoint `Deprecated` in documentation + OpenAPI.
2. Add `Warning` header in responses: `Warning: 299 - "This endpoint is deprecated and will be removed on 2026-01-01"`.
3. Support old version for X months (e.g. 6-12 months).
4. Sunset (turn off).
